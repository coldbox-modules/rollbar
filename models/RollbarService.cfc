/**
*********************************************************************************
* Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
* www.ortussolutions.com
* ---
* Connector to Rollbar
*/
component accessors=true singleton{
	
	/**
	 * Module  Settings
	 */
	property name="settings" type="struct";
	/**
	 * Module Configuration struct
	 */
	property name="moduleConfig" type="struct";
	/**
	 * API Base URL
	 */	
	property name="APIBaseURL" default="https://api.rollbar.com/api/1/item/";

	/**
	 * Constructor
	 * @settings The module settings
	 * @settings.inject coldbox:setting:rollbar
	 * @coldbox.inject coldbox
	 */
	function init(
		required struct settings,
		required coldbox 
	){
		// module settings
		variables.settings 	= arguments.settings;
		// coldbox reference
		variables.coldbox 	= arguments.coldbox;
		// module config
		variables.moduleConfig = variables.coldbox.getSetting( "modules" ).rollbar;

		return this;
	}

	/**
	 * Send a message to rollbar
	 * @message A string message
	 * @metadata A struct of metadata to send alongside the message
	 * @level One of: "critical", "error", "warning", "info", "debug", defaults to "info"
	 *
	 * @return struct 
	 */
	function sendMessage( required string message, struct metadata={}, level="info" ){
		return sendToRollbar(
			logBody 	= {
				"message" : {
					"body" : arguments.message
				}
			},
			metadata 	= arguments.metadata,
			level  		= arguments.level
		);
	}

	/**
	 * Send a log body to rollbar
	 * @logBody The logBody struct to send as a message
	 * @metadata A struct of metadata to send alongside the message
	 * @level One of: "critical", "error", "warning", "info", "debug", defaults to "info"
	 *
	 * @return struct 
	 */
	function sendToRollbar( required struct logBody, struct metadata={}, level="info" ){
		var threadName 	= "rollbar-#createUUID()#";
		var event 		= variables.coldbox.getRequestService().getContext();
		var httpData 	= getHTTPRequestData();

		// ColdBox Environment
		var coldboxEnv = {
			"currentEvent"		: event.getCurrentEvent(),
			"currentRoute"		: event.getCurrentRoute(),
			"currentLayout"		: event.getCurrentLayout(),
			"currentView"		: event.getCurrentView(),
			"currentModule"		: event.getCurrentModule(),
			"currentRoutedURL"	: event.getCurrentRoutedURL()
		};
		// Append to custom metadata
		structAppend( arguments.metadata, coldboxEnv, true );
		// Create payload
		var payload = {
			"access_token" 	: variables.settings.serverSideToken,
			"data" 			: {
				// app environment
				"environment"	: variables.coldbox.getSetting( "environment" ),
				// The main data being sent
				"body" 			: arguments.logBody,
				// Severity level, defaults to "info" for messages
				"level" 		: arguments.level,
				// OS platform
				"platform"		: server.os.name,
				// language
				"language"		: "ColdFusion(CFML)",
				// Framework
				"framework"		: "ColdBox",
				// An identifier for which part of your application this event came from.
				"context" 		: event.getCurrentEvent(),
				// Data about the request this event occurred in.
				"request" 		: {
					// url: full URL where this event occurred
					"url": CGI.REQUEST_URL,
					// method: the request method
					"method": httpData.method,
					// query_string: the raw query string
		      		"query_string": CGI.QUERY_STRING,
					// Headers
					"headers" : httpData.headers,
					// Raw Body
					"body" 	: httpData.content,
					// POST: POST params
		      		"POST": FORM,
		      		// GET: query string params
		      		"GET": URL,
					// IP Address of request
					"user_ip" : getRealIP()
				},
				// Server information
				"server" : {
					"host" : getHostName(),
					"root" : CGI.cf_template_path
				},
				// Client Information
				"client" : {
					"browser" : CGI.http_user_agent
				},
				// Custom metadata
				"custom" : arguments.metadata,
				// Libary Used
				"notifier" 		: {
					"name" 		: "ColdBox Rollbar Module",
			  		"version"	: variables.moduleConfig.version
				},
			}
		};

		var APIBaseURL = getAPIBaseURL();
		// thread this
		thread 
			name="#threadName#" 
			action="run"
			payload=payload
		{
			var h = new HTTP( url=variables.APIBaseURL, method="POST" );
			h.addParam( type="BODY", value=serializeJSON( payload ) );
			thread.response = h.send().getPrefix();
		}
		// return thread information
		return cfthread[ threadName ];
	}

	/**
	 * Convert an exception to log body struct
	 * @exception The exception object
	 */
	public function exceptionToLogBody( required exception ){
		var logBody = {
	        // Option 1: "trace"
			"trace" : marshallStackTrace( arguments.exception )
		};
		return logBody;
	}

	/**
	 * Marshall a stack trace
	 * @exception The exception object
	 */
	private function marshallStackTrace( required exception ){

		/**
		 * Format Frame
		 */
		var formatFrame = function( required stackItem ){
			return {
				"filename" 	: arguments.stackItem.template,
				"lineno" 	: arguments.stackItem.line,
				"colno" 	: arguments.stackItem.column,
				"method" 	: arguments.stackItem.Raw_Trace,
				// The line of code
				"code" 		: arguments.stackItem.codePrintPlain ?: ''
			};
		}

		var trace = {
			"exception": {
				"class" 		: arguments.exception.Type,
				"message" 		: arguments.exception.Message,
				"description"	: arguments.exception.Detail
	        },
			"frames" 			: []
		};

		for( var stackItem in arguments.exception.TagContext ){
			arrayAppend( trace.frames, formatFrame( stackItem ) )
		}

		return trace;
	}

	/**
	 * Get the host name you are on
	 */
	private function getHostName(){
		try{
			return createObject( "java", "java.net.InetAddress").getLocalHost().getHostName();
		}
		catch(Any e ){
			return cgi.http_host;
		}
	}

	/**
	* Get Real IP, by looking at clustered, proxy headers and locally.
	*/
	private function getRealIP(){
		var headers = GetHttpRequestData().headers;

		// Very balanced headers
		if( structKeyExists( headers, 'x-cluster-client-ip' ) ){
			return headers[ 'x-cluster-client-ip' ];
		}
		if( structKeyExists( headers, 'X-Forwarded-For' ) ){
			return headers[ 'X-Forwarded-For' ];
		}

		return len( cgi.remote_addr ) ? cgi.remote_addr : '127.0.0.1';
	}
}