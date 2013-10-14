//
//  NSArray+Expand.m
//  PChart
//
//  Created by JK.PENG on 13-10-14.
//  Copyright (c) 2013年 NJUT. All rights reserved.
//

#import "NSArray+Expand.h"

@implementation NSArray (Expand)

- (NSArray *)mapWithBlock:(id (^)(id obj))block {
    NSMutableArray *result = [[NSMutableArray alloc] init];
	for(id val in self) {
        id mappedVal = block(val);
        if(mappedVal){
            [result addObject:mappedVal];
        }
	}
	return result;
}

@end
