//
//  OCDateTransformer.h
//  CloudNotes
//
//  Created by Peter Hedlund on 2/8/14.
//  Copyright (c) 2014 Peter Hedlund. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OCDateTransformer : NSValueTransformer

+(Class)transformedValueClass;
-(id)transformedValue:(id)value;

@end
