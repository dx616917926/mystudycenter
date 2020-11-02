//
//  HXDictionary.m
//  Hxdd_lms
//
//  Created by  MAC on 15/1/27.
//  Copyright (c) 2015年 华夏大地教育. All rights reserved.
//

#import "HXDictionary.h"

@implementation NSDictionary (HXDictionary)

-(NSString *)stringValueForKey:(NSString *)key
{
    return [self stringValueForKey:key WithHolder:@""];
}

-(NSString *)stringValueForKey:(NSString *)key WithHolder:(id)holder
{
    id obj = [self objectForKey:key];
    
    if (!obj || [obj isKindOfClass:[NSNull class]]) {
        return holder;
    }
    
    if (![obj isKindOfClass:[NSString class]]) {
        return [NSString stringWithFormat:@"%@",obj];
    }
    
    if ([obj length] == 0) {
        return holder;
    }
    
    return obj;
}

-(NSString *)numberStringValueForKey:(NSString *)key
{
    NSString * string = [self stringValueForKey:key WithHolder:@""];
    
    NSString * numberString = [NSString stringWithFormat:@"%lf",[string doubleValue]];
    
    NSDecimalNumber *decNumber = [NSDecimalNumber decimalNumberWithString:numberString];
    
    return [decNumber stringValue];
}

-(BOOL)boolValueForKey:(NSString *)key
{
    id obj = [self objectForKey:key];
    
    if (!obj || [obj isKindOfClass:[NSNull class]]) {
        return NO;
    }
    
    return [obj boolValue];
}

-(NSDictionary *)dictionaryValueForKey:(NSString *)key
{
    id obj = [self objectForKey:key];
    
    if (!obj || [obj isKindOfClass:[NSNull class]]) {
        return nil;
    }
    
    return obj;
}

@end
