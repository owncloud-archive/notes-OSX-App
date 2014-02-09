//
//  OCPrefsWindowController.h
//  CloudNotes
//
//  Created by Peter Hedlund on 2/8/14.
//  Copyright (c) 2014 Peter Hedlund. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface OCPrefsWindowController : NSWindowController

@property (strong) IBOutlet NSTextField *usernameTextField;
@property (strong) IBOutlet NSSecureTextField *passwordTextField;
@property (strong) IBOutlet NSTextField *statusLabel;
@property (strong) IBOutlet NSTextField *serverTextField;
@property (strong) IBOutlet NSProgressIndicator *connectionActivityIndicator;
@property (strong) IBOutlet NSTabView *tabView;

- (IBAction)doConnect:(id)sender;

@end
