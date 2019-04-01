[![Build Status](https://travis-ci.org/coldbox-modules/rollbar.svg?branch=development)](https://travis-ci.org/coldbox-modules/rollbar)

# Welcome to the Rollbar ColdBox Module
(https://rollbar.com)

This module connects your ColdBox application to send bug reports and even
LogBox integration into Rollbar (https://rollbar.com)

## LICENSE
Apache License, Version 2.0.

## IMPORTANT LINKS
- Source: https://github.com/coldbox-modules/rollbar
- Issues: https://github.com/coldbox-modules/rollbar/issues
- Account Setup: https://rollbar.com
- [Changelog](changelog.md)

## SYSTEM REQUIREMENTS
- ColdFusion 11+
- ColdBox 4+

## Instructions

Just drop into your modules folder or use the box-cli to install

`box install rollbar`

## Settings
You can add configuration settings to your `ColdBox.cfc` under a structure called `rollbar`:

```js
rollbar = {
    // Rollbar token
    "ServerSideToken" = "",
    // Enable the Rollbar LogBox Appender Bridge
    "enableLogBoxAppender" : true,
    // Min/Max levels for appender
    "levelMin" = "FATAL",
    "levelMax" = "INFO",
    // Enable/disable error logging
    "enableExceptionLogging" = true
};
```


## Usage

Just by activating the module any exceptions will be sent to Rollbar. The LogBox appender bridge is **activated** by default, and the Rollbar appender is added as an appender to your application.  You can fine tune it via your main ColdBox logbox configuration file.

### Exception Tracking

The module will automatically listen for exceptions in any part of your application and send the exceptions over to rollbar.

### Logging

You can use LogBox and any of its logging methods to send data to Rollbar automatically using the required logging levels for the appender in the configuration.



********************************************************************************
Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
www.ortussolutions.com
********************************************************************************
####HONOR GOES TO GOD ABOVE ALL
Because of His grace, this project exists. If you don't like this, then don't read it, its not for you.

>"Therefore being justified by faith, we have peace with God through our Lord Jesus Christ:
By whom also we have access by faith into this grace wherein we stand, and rejoice in hope of the glory of God.
And not only so, but we glory in tribulations also: knowing that tribulation worketh patience;
And patience, experience; and experience, hope:
And hope maketh not ashamed; because the love of God is shed abroad in our hearts by the 
Holy Ghost which is given unto us. ." Romans 5:5

###THE DAILY BREAD
 > "I am the way, and the truth, and the life; no one comes to the Father, but by me (JESUS)" Jn 14:1-12
