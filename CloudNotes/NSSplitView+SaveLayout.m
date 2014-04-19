//
//  NSSplitView+SaveLayout.m
//  CloudNotes
//
//  Created by Peter Hedlund on 2/7/14.
//  Copyright (c) 2014 Peter Hedlund. All rights reserved.
//

#import "NSSplitView+SaveLayout.h"

@implementation NSSplitView (SaveLayout)

- (void)saveLayoutWithName:(NSString *)defaultName {
    NSMutableArray *rectStrings = [NSMutableArray array];
    [self.subviews enumerateObjectsUsingBlock:^(NSView *view, NSUInteger idx, BOOL *stop) {
        [rectStrings addObject: NSStringFromRect(view.frame)];
    }];
    [[NSUserDefaults standardUserDefaults] setObject:rectStrings forKey:defaultName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)loadLayoutWithName:(NSString *)defaultName {
    NSMutableArray *rectStrings = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:defaultName]];
    if (rectStrings.count) {
        [self.subviews enumerateObjectsUsingBlock:^(NSView *view, NSUInteger idx, BOOL *stop) {
            view.frame = NSRectFromString([rectStrings objectAtIndex:idx]);
        }];
    }
}

@end
