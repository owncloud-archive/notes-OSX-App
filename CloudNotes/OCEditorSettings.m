//
//  OCEditorSettings.m
//  CloudNotes
//
//  Created by Peter Hedlund on 2/15/14.
//  Copyright (c) 2014 Peter Hedlund. All rights reserved.
//

#import "OCEditorSettings.h"

@implementation OCEditorSettings

@synthesize font;

- (id) init {
	if (self = [super init]) {
        
    }
	return self;
}

#pragma mark - NSCoding Protocol

- (id)initWithCoder:(NSCoder *)decoder {
	if ((self = [super init])) {
        font = [decoder decodeObjectForKey:@"font"];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:font forKey:@"font"];
}

@end
