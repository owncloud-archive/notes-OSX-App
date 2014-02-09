//
//  OCPrefsWindowController.m
//  CloudNotes
//
//  Created by Peter Hedlund on 2/8/14.
//  Copyright (c) 2014 Peter Hedlund. All rights reserved.
//

#import "OCPrefsWindowController.h"
#import "PDKeychainBindingsController.h"
#import "OCAPIClient.h"

static const NSString *rootPath = @"index.php/apps/notes/api/v0.2/";

@interface OCPrefsWindowController ()

@end

@implementation OCPrefsWindowController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    [self.usernameTextField bind:@"value"
                        toObject:[PDKeychainBindingsController sharedKeychainBindingsController]
                     withKeyPath:[NSString stringWithFormat:@"values.%@",@"Username"]
                         options:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES]
                                                    forKey:@"NSContinuouslyUpdatesValue"]];
    
    [self.passwordTextField bind:@"value"
                        toObject:[PDKeychainBindingsController sharedKeychainBindingsController]
                     withKeyPath:[NSString stringWithFormat:@"values.%@",@"Password"]
                         options:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES]
                                                             forKey:@"NSContinuouslyUpdatesValue"]];

    NSString *status;
    NSString *server = [[NSUserDefaults standardUserDefaults] stringForKey:@"Server"];
    if ([OCAPIClient sharedClient].reachabilityManager.isReachable) {
        status = [NSString stringWithFormat:@"Connected to an ownCloud Notes server at\n \"%@\".", server];
    } else {
        status = @"Currently not connected to an ownCloud Notes server";
    }
    
    self.statusLabel.stringValue = status;
    self.serverTextField.stringValue = server;
    if (!server || server.length == 0) {
        [self.tabView selectLastTabViewItem:nil];
    }
}

- (IBAction)doConnect:(id)sender {
    [self.connectionActivityIndicator startAnimation:nil];
    __block NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    PDKeychainBindings *keychain = [PDKeychainBindings sharedKeychainBindings];
    
    OCAPIClient *client = [[OCAPIClient alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", self.serverTextField.stringValue, rootPath]]];
    [client setRequestSerializer:[AFJSONRequestSerializer serializer]];
    [client.requestSerializer setAuthorizationHeaderFieldWithUsername:[keychain stringForKey:@"Username"] password:[keychain stringForKey:@"Password"]];
    
    BOOL allowInvalid = [prefs boolForKey:@"AllowInvalidSSLCertificate"];
    client.securityPolicy.allowInvalidCertificates = allowInvalid;
    NSDictionary *params = @{@"exclude": @"content"};
    
    [client GET:@"notes" parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"notes: %@", responseObject);
        [prefs setObject:self.serverTextField.stringValue forKey:@"Server"];
        [OCAPIClient setSharedClient:nil];
        int status = [[OCAPIClient sharedClient].reachabilityManager networkReachabilityStatus];
        NSLog(@"Server status: %i", status);
        self.statusLabel.stringValue = [NSString stringWithFormat:@"Connected to an ownCloud Notes server at\n \"%@\".", self.serverTextField.stringValue];
        
        [self.connectionActivityIndicator stopAnimation:nil];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        NSLog(@"Error: %@, response: %ld", [error localizedDescription], (long)[response statusCode]);
        self.statusLabel.stringValue = @"Failed to connect to a server. Check your settings.";
        [self.connectionActivityIndicator stopAnimation:nil];
    }];

}
@end
