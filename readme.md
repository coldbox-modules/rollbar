WELCOME TO THE BUGLOGHQ MODULE
==============================
BugLogHQ Created & copyright by Oscar Arevalo (www.bugloghq.com)

This module connects your ColdBox application to send bug reports and even
LogBox integration into BugLogHQ

##LICENSE
Apache License, Version 2.0.

##IMPORTANT LINKS
- http://www.bugloghq.com
- https://github.com/ColdBox/cbox-bugloghq

##SYSTEM REQUIREMENTS
- Railo 4+
- ColdFusion 9+
- BugLogHQ 1.8+
- ColdBox 4+

INSTRUCTIONS
============
Just drop into your modules folder or use the box-cli to install

`box install bugloghq`

## Settings
You can add configuration settings to your `ColdBox.cfc` under a structure called `bugloghq`:

```js
bugloghq = {
    // The location of the listener where to send the bug reports
    "bugLogListener" : "",
    // A comma-delimited list of email addresses to which send the bug reports in case
    "bugEmailRecipients" :  "",
    // The sender address to use when sending the emails mentioned above.
    "bugEmailSender" : "",
    // The api key in use to submit the reports, empty if none.
    "apikey" : "",
    // The hostname of the server you are on, leave empty for auto calculated
    "hostname" : "",
    // The aplication name
    "appName"   : "",
    // The max dump depth
    "maxDumpDepth" : 10,
    // Write out errors to CFLog
    "writeToCFLog" : true,
    // Enable the BugLogHQ LogBox Appender Bridge
    "enableLogBoxAppender" : false
};
```

********************************************************************************
Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
www.coldbox.org | www.luismajano.com | www.ortussolutions.com
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