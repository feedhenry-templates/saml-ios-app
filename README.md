# SAML iOS Client

## What does the demo do?

This is an example SAML Client App, designed to be used in conjunction with our [SAML Service](https://github.com/feedhenry-templates/saml-service). 

The Cloud App proxies the login client call to a SAML Service (e.g. fetching a URL to display in the WebView for IdP login) through the use of a SAML service (See Configuration section).

The client app demoes the usage of the two SAML Service endpoints:
- `sso/session/login_host` to get the SAML login page URL. A WebView is used to display the SAML login page.
- `sso/session/valid` to get the user information once the login was successful. 

Before running the project you will need some configuration.

## Configuration

As a pre-requisite, you need:
- to have project created with SAML template
- to have created and configured a SAML service in your RHMAP platform.
All the pre-requisites steps are well described in the [SAML notes](https://github.com/feedhenry-templates/saml-service/blob/master/NOTES.md).

Here is the steps you will need to do on your client app in fh-ngui console:
- Go to your SAML Demo project, associate it with your new SAML Service (click the + in the MBaaS Services area)
- Pick your SAML Service, and click Associate
- Navigate into your service and grab its "Service ID" (e.g. qhgvcppenzcquhlipr3dldat)
- Go into your SAML Cloud app, choose Environment Variables icon on left hand side navigation
- Add a new environement variable
    - Name: SAML_SERVICE
    - Value: YOUR_SERVICE_ID (e.g. qhgvcppenzcquhlipr3dldat)
- Re-deploy your SAML Cloud app

You should be good to go.

## Build and deploy your app

Open Xcode project ```saml-ios-app.xcodeproj```.
Run it.

## Code snippets and SAML usage

### Login call
When the user clicks the `Sign In` button, `sso/session/login_host` end point is called. The resulting `sso` url is loaded in the WebView. 

In ```saml-ios-app\ViewController.m``` file, we define the ```login:``` method called once the user hits login button, as below:

```
- (IBAction)login:(UIButton *)sender {
    [FH initWithSuccess:^(FHResponse *response) {
        // Build a FHCloudRequest to get the SSO login URL
        NSString* deviceID = [[FHConfig getSharedInstance] uuid];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"token"] = deviceID;
        FHCloudRequest *cloudReq = [FH buildCloudRequest:@"sso/session/login_host" WithMethod:@"POST" AndHeaders:nil AndArgs: params];
        
        // Initiate the SSO call to the cloud
        [cloudReq execWithSuccess:^(FHResponse *success) {
            NSDictionary* response = [success parsedResponse];
            NSString* urlString = response[@"sso"];
            NSURL* loginUrl = [[NSURL alloc] initWithString:urlString];
            // Display WebView
            FHSAMLViewController *controller = [[FHSAMLViewController alloc] initWithURL:loginUrl];
            [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:controller animated:YES completion:nil];
        } AndFailure:^(FHResponse *failed) {
            NSLog(@"EXEC FAILUE =%@", failed);
        }];
    } AndFailure:^(FHResponse *response) {
        NSLog(@"initialize fail, %@", response.rawResponseAsString);
    }];
}

```

### User information call

Once the user is successfully logged in, we can call `sso/session/valid` to fetch the user details. 

In ```saml-ios-app\ViewController.m``` file, we define the ```close``` method called once the user is logged in and closes the WebView. In here we call the user information details.

```
- (void) close {
    // Get the User name claims
    NSString* deviceID = [[FHConfig getSharedInstance] uuid];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"token"] = deviceID;
    FHCloudRequest *cloudReq = [FH buildCloudRequest:@"sso/session/valid" WithMethod:@"POST" AndHeaders:nil AndArgs: params];
    
    // Initiate the SSO call to the cloud
    [cloudReq execWithSuccess:^(FHResponse *success) {
        NSDictionary* response = [success parsedResponse];
        // Manage next UI view controller
        [self performSegueWithIdentifier: @"showLoggedIn" sender: response];
    } AndFailure:^(FHResponse *failed) {
        NSLog(@"Request name failure =%@", failed);
    }];   
}
```