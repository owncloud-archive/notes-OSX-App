//
//  OCEditorSettings.h
//  CloudNotes
//
//  Created by Peter Hedlund on 2/15/14.
//  Copyright (c) 2014 Peter Hedlund. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OCEditorSettings : NSObject <NSCoding> {
    NSFont *font;
}

@property (nonatomic, copy) NSFont *font;

@end
