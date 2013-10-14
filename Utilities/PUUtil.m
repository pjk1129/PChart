//
//  PUUtil.m
//  PChart
//
//  Created by JK.Peng on 13-10-13.
//  Copyright (c) 2013年 NJUT. All rights reserved.
//

#import "PUUtil.h"

@implementation PUUtil

+ (BOOL)stringIsNullOrEmpty:(NSString *)str;
{
    if (!str || [str length]<=0) {
        return YES;
    }
    return NO;
}

+ (BOOL)dictionaryIsNullOrEmpty:(NSDictionary *)dic
{
    if (!dic || [dic count]<=0) {
        return YES;
    }
    return NO;
}

+ (BOOL)arrayIsNullOrEmpty:(NSArray *)array;
{
    if (!array || [array count]<=0) {
        return YES;
    }
    return NO;
}


@end
