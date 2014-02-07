//
//  OCNotesViewController.h
//  CloudNotes
//
//  Created by Peter Hedlund on 2/4/14.
//  Copyright (c) 2014 Peter Hedlund. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface OCNotesViewController : NSViewController

@property (strong) IBOutlet NSTableView *tableView;
@property (strong) IBOutlet NSScrollView *contentTextView;
@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong) IBOutlet NSArrayController *notesArrayController;

- (IBAction)doSync:(id)sender;
- (IBAction)doAdd:(id)sender;
- (IBAction)doDelete:(id)sender;

@end
