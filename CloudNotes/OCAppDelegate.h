//
//  OCAppDelegate.h
//  CloudNotes
//
//  Created by Peter Hedlund on 2/2/14.
//  Copyright (c) 2014 Peter Hedlund. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <CoreData/CoreData.h>
#import "OCNotesViewController.h"

@interface OCAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) OCNotesViewController *notesViewController;
//@property (nonatomic, retain) NSFetchedResultsController *notesFetchedResultsController;

- (IBAction)saveAction:(id)sender;

@end
