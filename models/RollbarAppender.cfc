/**
*********************************************************************************
* Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
* www.ortussolutions.com
* ---
* Appender for Rollbar leveraging the RollBar service
*/
component extends="coldbox.system.logging.AbstractAppender" accessors=true{
	
	/**
	* Constructor
	*/
	function init( 
		required name,
		struct properties=structnew(),
		layout="",
		numeric levelMin=0,
		numeric levelMax=4
	){
		super.init( argumentCollection=arguments );
		
		// Get rollbar Service, wirebox must be in application scope.
		variables.rollbarService = application.wirebox.getInstance( "RollbarService@rollbar" );
		
		return this;
	}

	/**
	 * Log a message
	 */
	public void function logMessage( required coldbox.system.logging.LogEvent logEvent ){
		var extraInfo = arguments.logEvent.getExtraInfo();

		// Is this an exception or not?
		if( isStruct( extraInfo ) && structKeyExists( extraInfo, "StackTrace" ) ){
			var logBody = variables.rollbarService.exceptionToLogBody( extraInfo );
		} else {
			var logBody = {
				"message" : {
					"body" 		: arguments.logEvent.getMessage(),
					"extraInfo" : arguments.logEvent.getExtraInfo()
				}
			};
		}

		var threadStatus = variables.rollbarService.sendToRollbar( logBody=logBody, level=arguments.logEvent.getSeverity() );
	}

}