//
//  OCNotesViewController.h
//  CloudNotes
//
//  Created by Peter Hedlund on 2/4/14.
//  Copyright (c) 2014 Peter Hedlund. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "OCDateTransformer.h"
#import "Note.h"

@interface OCNotesViewController : NSViewController <NSTextFieldDelegate>

@property (strong) IBOutlet NSTableView *tableView;
@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong) IBOutlet NSArrayController *notesArrayController;
@property (strong) IBOutlet NSSplitView *splitView;
@property (strong, readonly) NSArray *idSortDescriptor;
@property (strong) IBOutlet NSTextView *contentTextView;
@property (strong) IBOutlet NSTableCellView *tableCellView;

- (IBAction)doSync:(id)sender;
- (IBAction)doAdd:(id)sender;
- (IBAction)doDelete:(id)sender;



@end
