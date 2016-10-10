# saml-ios-app [![Build Status](https://travis-ci.org/feedhenry-templates/saml-ios-app.png)](https://travis-ci.org/feedhenry-templates/saml-ios-app)

> Swift version is available [here](https://github.com/feedhenry-templates/saml-ios-swift).

Author: Corinne Krych   
Level: Intermediate  
Technologies: Objective-C, iOS, RHMAP, CocoaPods.
Summary: A demonstration of how to authenticate with SAML IdP with RHMAP. 
Community Project : [Feed Henry](http://feedhenry.org)
Target Product: RHMAP  
Product Versions: RHMAP 3.7.0+   
Source: https://github.com/feedhenry-templates/saml-ios-app  
Prerequisites: fh-ios-sdk : 3.+, Xcode : 7.2+, iOS SDK : iOS7+, CocoaPods: 1.0.1+

## What is it?

Simple native iOS app to work with [```SAML Service``` connector service](https://github.com/feedhenry-templates/saml-service) in RHMAP. The user can login to the app using SAML authentication, user details available on SAML IdP are displayed once successfully logged in.To configure the service in your RHMAP platform read the [SAML notes](https://github.com/feedhenry-templates/saml-service/blob/master/NOTES.md).

If you do not have access to a RHMAP instance, you can sign up for a free instance at [https://openshift.feedhenry.com/](https://openshift.feedhenry.com/).

## How do I run it?  

### RHMAP Studio

This application and its cloud services are available as a project template in RHMAP as part of the "SAML Project" template.

### Local Clone (ideal for Open Source Development)
If you wish to contribute to this template, the following information may be helpful; otherwise, RHMAP and its build facilities are the preferred solution.

## Build instructions

1. Clone this project

2. Populate ```saml-ios-app/fhconfig.plist``` with your values as explained [here](http://docs.feedhenry.com/v3/dev_tools/sdks/ios.html#ios-configure).

3. Run ```pod install```

4. Open ```saml-ios-app.xcworkspace```

4. Run the project
 
## How does it work?

### Using FHCloudRequest
In this example we used ```FHCloudRequest``` to make request on the REST endpoint setup to deal with SAML authentication.

### iOS9 and non TLS1.2 backend

If your RHMAP is depoyed without TLS1.2 support, open as source  ```saml-ios-app/saml-ios-appr-Info.plist``` add the exception lines:

```
  <key>NSAppTransportSecurity</key>
  <dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
  </dict>
```