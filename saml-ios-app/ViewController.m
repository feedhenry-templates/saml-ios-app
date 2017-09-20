//
//  ViewController.m
//  saml-ios-app
//
//  Created by Corinne Krych on 31/08/15.
//  Copyright (c) 2015 FeedHenry. All rights reserved.
//

#import "ViewController.h"
#import <FH/FH.h>
#import "FHSAMLViewController.h"
#import "LoggedInViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize activityIndicator;

- (void)viewDidLoad {
    [super viewDidLoad];
    activityIndicator.hidden = true;
    // Do any additional setup after loading the view, typically from a nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(close) name:@"WebViewClosed" object:nil];

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"showLoggedIn"]) {
        NSDictionary *response = (NSDictionary *) sender;
        LoggedInViewController *controller = (LoggedInViewController *)segue.destinationViewController;
        controller.nameModel = response[@"first_name"];
        controller.emailModel = response[@"email"];
        controller.sessionModel = response[@"expires"];
    }
}

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
        [ self performSegueWithIdentifier: @"showLoggedIn" sender: response];
    } AndFailure:^(FHResponse *failed) {
        NSLog(@"Request name failure =%@", failed);
    }];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)login:(UIButton *)sender {
    activityIndicator.hidden = false;
    [activityIndicator startAnimating];
    
    [FH initWithSuccess:^(FHResponse *response) {
        NSLog(@"initialized OK");
        NSLog(@"Login to SAML Service...");
        // Build a FHCloudRequest to get the SSO login URL
        NSString* deviceID = [[FHConfig getSharedInstance] uuid];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"token"] = deviceID;
        FHCloudRequest *cloudReq = [FH buildCloudRequest:@"sso/session/login_host" WithMethod:@"POST" AndHeaders:nil AndArgs: params];
        
        // Initiate the SSO call to the cloud
        [cloudReq execWithSuccess:^(FHResponse *success) {
            NSLog(@"EXEC SUCCESS =%@", success);
            [activityIndicator stopAnimating];
            NSDictionary* response = [success parsedResponse];
            NSString* urlString = response[@"sso"];
            NSURL* loginUrl = [[NSURL alloc] initWithString:urlString];
            // Display WebView
            FHSAMLViewController *controller = [[FHSAMLViewController alloc] initWithURL:loginUrl];
            [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:controller animated:YES completion:nil];
        } AndFailure:^(FHResponse *failed) {
            NSLog(@"EXEC FAILUE =%@", failed.rawResponseAsString);
            NSString * message = [failed.parsedResponse objectForKey:@"msg"];
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Login fails" message:message preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:alertController animated:YES completion:nil];
        }];
    } AndFailure:^(FHResponse *response) {
        NSLog(@"initialize fail, %@", response.rawResponseAsString);
        NSString * message = @"Please fill in fhconfig.plist file.";
        if (response.parsedResponse) {
            message = [response.parsedResponse objectForKey:@"msg"];
        }
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"FH init fails" message:message preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
        [activityIndicator stopAnimating];
        activityIndicator.hidden = true;
    }];

}

@end
