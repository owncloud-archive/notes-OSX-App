//
//  OCDateTransformer.m
//  CloudNotes
//
//  Created by Peter Hedlund on 2/8/14.
//  Copyright (c) 2014 Peter Hedlund. All rights reserved.
//

#import "OCDateTransformer.h"

@implementation OCDateTransformer

+(Class)transformedValueClass {
    return [NSString class];
}

-(id)transformedValue:(id)value {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[value doubleValue]];
    if (date) {
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        dateFormat.dateStyle = NSDateFormatterShortStyle;
        dateFormat.timeStyle = NSDateFormatterNoStyle;
        dateFormat.doesRelativeDateFormatting = YES;
        return [dateFormat stringFromDate:date];
    }
    return value;
}

@end
