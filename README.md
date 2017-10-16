# saml-ios-app
[![circle-ci](https://img.shields.io/circleci/project/github/feedhenry-templates/saml-ios-app/master.svg)](https://circleci.com/gh/feedhenry-templates/saml-ios-app)

> Swift version is available [here](https://github.com/feedhenry-templates/saml-ios-swift).

Author: Corinne Krych  
Level: Intermediate  
Technologies: Objective-C, iOS, RHMAP, CocoaPods.  
Summary: A demonstration of how to authenticate with SAML IdP with RHMAP.  
Community Project : [Feed Henry](http://feedhenry.org)  
Target Product: RHMAP  
Product Versions: RHMAP 3.7.0+  
Source: https://github.com/feedhenry-templates/saml-ios-app  
Prerequisites: fh-ios-sdk: 5.+, Xcode: 9+, iOS SDK: iOS 9+, CocoaPods: 1.3.0+

## What is it?

Simple native iOS app to work with [`SAML Service` connector service](https://github.com/feedhenry-templates/saml-service) in RHMAP. The user can login to the app using SAML authentication, user details available on SAML IdP are displayed once successfully logged in.To configure the service in your RHMAP platform read the [SAML notes](https://github.com/feedhenry-templates/saml-service/blob/master/NOTES.md).

If you do not have access to a RHMAP instance, you can sign up for a free instance at [https://openshift.feedhenry.com/](https://openshift.feedhenry.com/).

## How do I run it?  

### RHMAP Studio

This application and its cloud services are available as a project template in RHMAP as part of the "SAML Project" template.

### Local Clone (ideal for Open Source Development)
If you wish to contribute to this template, the following information may be helpful; otherwise, RHMAP and its build facilities are the preferred solution.

## Build instructions

1. Clone this project
1. Populate `saml-ios-app/fhconfig.plist` with your values as explained [on section 2.1.4. Setup](https://access.redhat.com/documentation/en/red-hat-mobile-application-platform-hosted/3/paged/client-sdk/chapter-2-native-ios-objective-c).
1. Run `pod install`
1. Open `saml-ios-app.xcworkspace`
1. Run the project

## How does it work?

### Using FHCloudRequest
In this example we used `FHCloudRequest` to make request on the REST endpoint setup to deal with SAML authentication.

### iOS9 and non TLS1.2 backend

If your RHMAP is deployed without TLS1.2 support, open as source  `saml-ios-app/saml-ios-app-Info.plist` add the exception lines:

```
  <key>NSAppTransportSecurity</key>
  <dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
  </dict>
```
