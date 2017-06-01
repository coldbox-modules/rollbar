/**
* Copyright Since 2005 Ortus Solutions, Corp
* www.ortussolutions.com | www.gocontentbox.org
**************************************************************************************
*/
component{
	this.name = "A TestBox Runner Suite " & hash( getCurrentTemplatePath() );
	// any other application.cfc stuff goes below:
	this.sessionManagement = true;

	// Turn on/off white space management
	this.whiteSpaceManagement = "smart";
	
	// any mappings go here, we create one that points to the root called test.
	this.mappings[ "/tests" ] 		= getDirectoryFromPath( getCurrentTemplatePath() );
	rootPath 						= REReplaceNoCase( this.mappings[ "/tests" ], "tests(\\|/)", "" );
	
	this.mappings[ "/root" ]   		= rootPath;
	this.mappings[ "/testbox" ]   	= rootPath & "/testbox";
	this.mappings[ "/coldbox" ]   	= rootPath & "/coldbox";

	// any orm definitions go here.

	// request start
	public boolean function onRequestStart( String targetPage ){
		return true;
	}
}