/**
*********************************************************************************
* Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
* www.ortussolutions.com
* ---
* Module Config.
*/
component {

	// Module Properties
	this.title 				= "rollbar";
	this.author 			= "Ortus Solutions";
	this.webURL 			= "https://www.ortussolutions.com";
	this.description 		= "A module to log and send bug reports to Rollbar";
	this.version			= "@build.version@+@build.number@";
	// If true, looks for views in the parent first, if not found, then in the module. Else vice-versa
	this.viewParentLookup 	= true;
	// If true, looks for layouts in the parent first, if not found, then in module. Else vice-versa
	this.layoutParentLookup = true;
	// Module Entry Point
	this.entryPoint			= "rollbar";

	// STATIC SCRUB FIELDS
	SCRUB_FIELDS 	= [ "passwd", "password", "password_confirmation", "secret", "confirm_password", "secret_token", "APIToken", "x-api-token" ];
	SCRUB_HEADERS 	= [ "x-api-token", "Authorization" ];

	/**
	* Configure
	*/
	function configure(){

		settings = {
			// Rollbar token
			"ServerSideToken" = "",
		    // Enable the Rollbar LogBox Appender Bridge
		    "enableLogBoxAppender" = true,
		    // Min/Max levels for appender
		    "levelMin" = "FATAL",
		    "levelMax" = "ERROR",
		    // Enable/disable error logging
		    "enableExceptionLogging" = true,
		    // Data sanitization, scrub fields and headers, replaced with * at runtime
		    "scrubFields" 	= [],
		    "scrubHeaders" 	= [] 
		};

		// SES Routes
		routes = [
			// Module Entry Point
			{ pattern="/", handler="test",action="index" },
			// Convention Route
			{ pattern="/:handler/:action?" }
		];
	}

	/**
	* Fired when the module is registered and activated.
	*/
	function onLoad(){
		// parse parent settings
		parseParentSettings();
		var settings = controller.getConfigSettings().rollbar;
		// Incorporate defaults into settings
		settings.scrubFields.addAll( SCRUB_FIELDS );
		settings.scrubHeaders.addAll( SCRUB_HEADERS );
		// Load the LogBox Appenders
		if( settings.enableLogBoxAppender ){
			loadAppenders();
		}
	}

	/**
	* Fired when the module is unregistered and unloaded
	*/
	function onUnload(){

	}

	/**
	* Trap exceptions and send them to Rollbar
	*/
	function onException( event, interceptData, buffer ){
		if( !settings.enableExceptionLogging ){
			return;
		}
		var rollbarService = wirebox.getInstance( "RollbarService@rollbar" );
		// create log body
		var logBody = rollbarService.exceptionToLogBody( interceptData.exception );
		rollbarService.sendToRollbar(
			logBody = logBody,
			level 	= "error"
		);
	}

	//**************************************** PRIVATE ************************************************//	

	// load LogBox appenders
	private function loadAppenders(){
		// Get config
		var logBoxConfig 	= controller.getLogBox().getConfig();
		var rootConfig 		= "";

		// Register tracer appender
		rootConfig = logBoxConfig.getRoot();
		logBoxConfig.appender( 
			name 		= "rollbar_appender", 
			class 		= "#moduleMapping#.models.RollbarAppender",
			levelMin 	= settings.levelMin,
			levelMax 	= settings.levelMax
		);
		logBoxConfig.root( 
			levelMin = rootConfig.levelMin,
			levelMax = rootConfig.levelMax,
			appenders= listAppend( rootConfig.appenders, "rollbar_appender") 
		);

		// Store back config
		controller.getLogBox().configure( logBoxConfig );
	}

	/**
	* parse parent settings
	*/
	private function parseParentSettings(){
		var oConfig 		= controller.getSetting( "ColdBoxConfig" );
		var configStruct 	= controller.getConfigSettings();
		var rollbarDSL 		= oConfig.getPropertyMixin( "rollbar", "variables", structnew() );

		// Defaults
		configStruct.rollbar = settings;

		// incorporate settings
		structAppend( configStruct.rollbar, rollbarDSL, true );
	}

}
