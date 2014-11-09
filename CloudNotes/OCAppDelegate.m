//
//  OCAppDelegate.m
//  CloudNotes
//
//  Created by Peter Hedlund on 2/2/14.
//  Copyright (c) 2014 Peter Hedlund. All rights reserved.
//

#import "OCAppDelegate.h"
#import "OCNotesWindowController.h"
#import "OCNotesHelper.h"
#import "NSSplitView+SaveLayout.h"
#import "OCEditorSettings.h"
#import "OCNote.h"
#import "OCAPIClient.h"

@interface OCAppDelegate ()

@property (strong) OCNotesWindowController *notesWindowController;

@end

@implementation OCAppDelegate

@synthesize prefsWindowController;

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication*)sender
{
	return YES;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    
    //Clear prefs for debug.
    //NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    //[[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    
    self.notesWindowController = [[OCNotesWindowController alloc] initWithWindowNibName:@"OCNotesWindowController"];
    self.notesViewController = [[OCNotesViewController alloc] initWithNibName:@"OCNotesViewController" bundle:nil];
    NSView *mySubview = self.notesViewController.view;
    [self.notesWindowController.window.contentView addSubview:mySubview];
    [mySubview setTranslatesAutoresizingMaskIntoConstraints:NO];
    [[self.notesWindowController.window contentView] addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[mySubview]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(mySubview)]];
    [[self.notesWindowController.window contentView] addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[mySubview]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(mySubview)]];
    //self.notesViewController.context = [[OCNotesHelper sharedHelper] context];
    [self.notesViewController.notesArrayController setContent:[OCNote allInstances]];
    [self.notesViewController.tableView reloadData];
    [self.notesViewController.tableView setSelectionHighlightStyle:NSTableViewSelectionHighlightStyleSourceList];
    NSLog(@"Server: %@", [[NSUserDefaults standardUserDefaults] stringForKey:@"Server"]);
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"Server"].length == 0) {
        [self doPreferences:nil];
    }    
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"SyncOnStart"]) {
        [self.notesViewController doSync:nil];
    }

    [self.notesWindowController.window setAutorecalculatesContentBorderThickness:YES forEdge:NSMinYEdge];
	[self.notesWindowController.window setContentBorderThickness:30 forEdge:NSMinYEdge];
    
    [OCAPIClient sharedClient];
    [OCNotesHelper sharedHelper];

    [NSFontManager sharedFontManager].action = @selector(changeEditorFont:);
    [self.notesWindowController showWindow:self];

}

- (IBAction)doPreferences:(id)sender {
    [self.prefsWindowController showWindow:nil];
}

- (IBAction)doNew:(id)sender {
    [self.notesViewController doAdd:sender];
}

- (IBAction)doDelete:(id)sender {
    [self.notesViewController doDelete:sender];
}

- (IBAction)doSync:(id)sender {
    [self.notesViewController doSync:sender];
}

- (IBAction)doImport:(id)sender {
    NSOpenPanel* openPanel = [NSOpenPanel openPanel];
    
    openPanel.title = @"Select text file(s) to import";
    openPanel.showsResizeIndicator = YES;
    openPanel.showsHiddenFiles = NO;
    openPanel.canChooseDirectories = NO;
    openPanel.canCreateDirectories = YES;
    openPanel.allowsMultipleSelection = YES;
    openPanel.allowedFileTypes = @[@"txt"];
    
    [openPanel beginSheetModalForWindow:self.window
                      completionHandler:^(NSInteger result) {
                          
                          if (result == NSFileHandlingPanelOKButton) {
                              
                              [openPanel.URLs enumerateObjectsUsingBlock:^(NSURL *url, NSUInteger idx, BOOL *stop) {
                                  NSString *fileText = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
                                  if (fileText) {
                                      NSLog(@"Content: %@", fileText);
                                      [[OCNotesHelper sharedHelper] addNote:fileText];
                                  }
                              }];
                          }
                      }];
}

- (IBAction)doExport:(id)sender {
    [self.notesViewController doExport:sender];
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender
{
    // Save changes in the application's managed object context before the application terminates.
    [self.notesViewController.splitView saveLayoutWithName:@"SplitViewLayout"];
    
    return NSTerminateNow;
}

- (OCPrefsWindowController*)prefsWindowController {
    if (!prefsWindowController) {
        prefsWindowController = [[OCPrefsWindowController alloc] initWithWindowNibName:@"OCPrefsWindowController"];
    }
    return prefsWindowController;
}

- (void)changeEditorFont:(id)sender {
    NSFont *newFont = [sender convertFont:[sender selectedFont]];
    OCEditorSettings *settings = [[OCEditorSettings alloc] init];
    settings.font = newFont;
    
    NSLog(@"Saving myself");
    NSURL *saveUrl = [[OCNotesHelper sharedHelper] documentsDirectoryURL];
    
    saveUrl = [saveUrl URLByAppendingPathComponent:@"settings" isDirectory:NO];
    saveUrl = [saveUrl URLByAppendingPathExtension:@"plist"];
    [NSKeyedArchiver archiveRootObject:settings toFile:[saveUrl path]];
    
    self.notesViewController.contentTextView.textStorage.font = settings.font;
    self.notesViewController.contentTextView.font = settings.font;
}

@end
