//
//  LoggedInViewController.m
//  saml-ios-app
//
//  Created by Corinne Krych on 02/09/15.
//  Copyright (c) 2015 FeedHenry. All rights reserved.
//

#import "LoggedInViewController.h"

#import "FHSAMLViewController.h"


@implementation LoggedInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (![[NSNull null] isEqual:self.nameModel]) {
        self.name.text = self.nameModel;
    }
    if (![[NSNull null] isEqual:self.emailModel]) {
        self.email.text = self.emailModel;
    }
    if (![[NSNull null] isEqual:self.sessionModel]) {
        self.session.text = self.sessionModel;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) viewWillAppear:(BOOL)animated {
    [self reloadInputViews];
}

- (IBAction)signInAgain:(id)sender {
        NSLog(@"Login to SAML Service again...");
        // Build a FHCloudRequest to get the SSO login URL
        NSString* deviceID = [[FHConfig getSharedInstance] uuid];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"token"] = deviceID;
        FHCloudRequest *cloudReq = [FH buildCloudRequest:@"sso/session/login_host" WithMethod:@"POST" AndHeaders:nil AndArgs: params];
        
        // Initiate the SSO call to the cloud
        [cloudReq execWithSuccess:^(FHResponse *success) {
            NSLog(@"EXEC SUCCESS LOGIN AGAIN=%@", success);

            NSDictionary* response = [success parsedResponse];
            NSString* urlString = response[@"sso"];
            NSURL* loginUrl = [[NSURL alloc] initWithString:urlString];
            // Display WebView
            FHSAMLViewController *controller = [[FHSAMLViewController alloc] initWithURL:loginUrl];
            [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:controller animated:YES completion:nil];
        } AndFailure:^(FHResponse *failed) {
            NSLog(@"EXEC FAILUE LOGIN AGAIN=%@", failed);
        }];


}
@end
