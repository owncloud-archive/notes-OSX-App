//
//  NSSplitView+SaveLayout.h
//  CloudNotes
//
//  Created by Peter Hedlund on 2/7/14.
//  Copyright (c) 2014 Peter Hedlund. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSSplitView (SaveLayout)

- (void)saveLayoutWithName:(NSString *)defaultName;
- (void)loadLayoutWithName:(NSString *)defaultName;

@end
