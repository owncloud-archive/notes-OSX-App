//
//  OCAppDelegate.m
//  CloudNotes
//
//  Created by Peter Hedlund on 2/2/14.
//  Copyright (c) 2014 Peter Hedlund. All rights reserved.
//

#import "OCAppDelegate.h"
#import "OCNotesHelper.h"
#import "NSSplitView+SaveLayout.h"
#import "OCEditorSettings.h"

@implementation OCAppDelegate

@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize prefsWindowController;

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication*)sender
{
	return YES;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    self.notesViewController = [[OCNotesViewController alloc] initWithNibName:@"OCNotesViewController" bundle:nil];
    NSView *mySubview = self.notesViewController.view;
    [self.window.contentView addSubview:mySubview];
    [mySubview setTranslatesAutoresizingMaskIntoConstraints:NO];
    [[[self window] contentView] addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[mySubview]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(mySubview)]];
    [[[self window] contentView] addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[mySubview]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(mySubview)]];
    self.notesViewController.context = [[OCNotesHelper sharedHelper] context];
    [self.notesViewController.notesArrayController fetch:self.notesViewController];
    [self.notesViewController.tableView reloadData];
    [self.notesViewController.tableView setSelectionHighlightStyle:NSTableViewSelectionHighlightStyleSourceList];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"SyncOnStart"]) {
        [self.notesViewController doSync:nil];
    }
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"Server"].length == 0) {
        [self doPreferences:nil];
    }
    [[self window] setAutorecalculatesContentBorderThickness:YES forEdge:NSMinYEdge];
	[[self window] setContentBorderThickness:30 forEdge:NSMinYEdge];
    
    [NSFontManager sharedFontManager].action = @selector(changeEditorFont:);
}

// Returns the NSUndoManager for the application. In this case, the manager returned is that of the managed object context for the application.
- (NSUndoManager *)windowWillReturnUndoManager:(NSWindow *)window
{
    return [[self managedObjectContext] undoManager];
}

// Performs the save action for the application, which is to send the save: message to the application's managed object context. Any encountered errors are presented to the user.
- (IBAction)saveAction:(id)sender
{
    NSError *error = nil;
    
    if (![[self managedObjectContext] commitEditing]) {
        NSLog(@"%@:%@ unable to commit editing before saving", [self class], NSStringFromSelector(_cmd));
    }
    
    if (![[self managedObjectContext] save:&error]) {
        [[NSApplication sharedApplication] presentError:error];
    }
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

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender
{
    // Save changes in the application's managed object context before the application terminates.
    [self.notesViewController.splitView saveLayoutWithName:@"SplitViewLayout"];
    
    if (!_managedObjectContext) {
        return NSTerminateNow;
    }
    
    if (![[self managedObjectContext] commitEditing]) {
        NSLog(@"%@:%@ unable to commit editing to terminate", [self class], NSStringFromSelector(_cmd));
        return NSTerminateCancel;
    }
    
    if (![[self managedObjectContext] hasChanges]) {
        return NSTerminateNow;
    }
    
    NSError *error = nil;
    if (![[self managedObjectContext] save:&error]) {

        // Customize this code block to include application-specific recovery steps.              
        BOOL result = [sender presentError:error];
        if (result) {
            return NSTerminateCancel;
        }

        NSString *question = NSLocalizedString(@"Could not save changes while quitting. Quit anyway?", @"Quit without saves error question message");
        NSString *info = NSLocalizedString(@"Quitting now will lose any changes you have made since the last successful save", @"Quit without saves error question info");
        NSString *quitButton = NSLocalizedString(@"Quit anyway", @"Quit anyway button title");
        NSString *cancelButton = NSLocalizedString(@"Cancel", @"Cancel button title");
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:question];
        [alert setInformativeText:info];
        [alert addButtonWithTitle:quitButton];
        [alert addButtonWithTitle:cancelButton];

        NSInteger answer = [alert runModal];
        
        if (answer == NSAlertAlternateReturn) {
            return NSTerminateCancel;
        }
    }

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
    NSURL *saveUrl = [[OCNotesHelper sharedHelper] applicationFilesDirectory];
    
    saveUrl = [saveUrl URLByAppendingPathComponent:@"settings" isDirectory:NO];
    saveUrl = [saveUrl URLByAppendingPathExtension:@"plist"];
    [NSKeyedArchiver archiveRootObject:settings toFile:[saveUrl path]];
    
    self.notesViewController.contentTextView.textStorage.font = settings.font;    
}

@end
