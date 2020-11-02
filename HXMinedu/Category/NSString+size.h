//
//  NSString+size.h
//  HXCloudClass
//
//  Created by Mac on 2020/7/23.
//  Copyright © 2020 华夏大地教育网. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (size)

- (CGSize)sizeWithFont:(UIFont *)font maxW:(CGFloat)maxW;

- (CGSize)sizeWithFont:(UIFont *)font;

@end

NS_ASSUME_NONNULL_END
