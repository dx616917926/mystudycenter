//
//  HXDictionary.h
//  Hxdd_lms
//
//  Created by  MAC on 15/1/27.
//  Copyright (c) 2015年 华夏大地教育. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (HXDictionary)

/**
 *  从字典对象中获取string字符串，如果为nil，或者各种非字符串value 默认返回@""
 *
 *  @param key
 *
 *  @return 如果为nil，或者各种非字符串value 默认返回@""
 */
-(NSString *)stringValueForKey:(NSString *)key;

/**
 *  从字典对象中获取string字符串，如果为nil，或者各种非字符串value 默认返回 holder
 *
 *  @param key
 *  @param holder 占位字符串
 *
 *  @return 如果为nil，或者各种非字符串value 默认返回 holder
 */
-(NSString *)stringValueForKey:(NSString *)key WithHolder:(id)holder;

/**
 返回数字字符串

 @param key
 @return 如果为nil，或者各种非字符串value 默认返回@""
 */
-(NSString *)numberStringValueForKey:(NSString *)key;

/**
 *  从字典对象中获取bool值，如果为nil，或者各种非字符串value 默认返回NO
 *
 *  @param key
 *
 *  @return 如果为nil，或者各种非字符串value 默认返回NO
 */
-(BOOL)boolValueForKey:(NSString *)key;

/**
 *  从字典对象中获取dictionary值,如果为NSNull 返回nil
 *
 *  @param key
 *
 *  @return
 */
-(NSDictionary *)dictionaryValueForKey:(NSString *)key;

@end
