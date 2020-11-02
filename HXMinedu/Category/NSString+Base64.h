//
//  NSString+Base64.h
//  b2b-edu
//
//  Created by iMac on 2017/6/2.
//  Copyright © 2017年 华夏大地教育网. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Base64)
/**
 *  转换为Base64编码
 */
- (NSString *)base64EncodedString;
/**
 *  将Base64编码还原
 */
- (NSString *)base64DecodedString;

@end
