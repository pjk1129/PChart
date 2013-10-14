//
//  NSArray+Expand.h
//  PChart
//
//  Created by JK.PENG on 13-10-14.
//  Copyright (c) 2013年 NJUT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Expand)

/**
 Perform a block on each element of an array, and return an array of the results.
 If the block returns nil for an object, that object is not added to the block. This may change in the future to NSNull objects being added, you should not rely on this behavior.
 
 This method is somewhat similar to the makeObjectsPerformSelector: but uses a block and aggregates the return values.
 @param aSelector the selector to perform
 @return a new array with the results of performing the selector on each array element
 */
- (NSArray *)mapWithBlock:(id (^)(id obj))block;

@end
