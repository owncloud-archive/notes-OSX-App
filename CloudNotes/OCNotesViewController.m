//
//  OCNotesViewController.m
//  CloudNotes
//
//  Created by Peter Hedlund on 2/4/14.
//  Copyright (c) 2014 Peter Hedlund. All rights reserved.
//

#import "OCNotesViewController.h"
#import "OCNotesHelper.h"
#import "Note.h"

@interface OCNotesViewController ()

@end

@implementation OCNotesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (IBAction)doSync:(id)sender {
    [[OCNotesHelper sharedHelper] sync];
}

- (IBAction)doAdd:(id)sender {
    [[OCNotesHelper sharedHelper] addNote];
}

- (IBAction)doDelete:(id)sender {
    Note *noteToDelete = nil;
    if ([[self.notesArrayController selectedObjects] count] > 0) {
        noteToDelete = (Note*)[[self.notesArrayController selectedObjects] objectAtIndex:0];
        [[OCNotesHelper sharedHelper] deleteNote:noteToDelete];
    }
}

- (BOOL)splitView:(NSSplitView *)splitView canCollapseSubview:(NSView *)subview {
    return NO;
}

- (CGFloat)splitView:(NSSplitView *)splitView constrainMinCoordinate:(CGFloat)proposedMin ofSubviewAt:(NSInteger)dividerIndex {
    return 200;
}

- (CGFloat)splitView:(NSSplitView *)splitView constrainMaxCoordinate:(CGFloat)proposedMax ofSubviewAt:(NSInteger)dividerIndex {
    return 500;
}

- (NSArray *)idSortDescriptor {
    return @[[NSSortDescriptor sortDescriptorWithKey:@"myId" ascending:NO]];
}

@end
