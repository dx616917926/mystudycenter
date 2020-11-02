//
//  NSString+md5.h
//  HXCloudClass
//
//  Created by Mac on 2020/7/23.
//  Copyright © 2020 华夏大地教育网. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (md5)

/**
*  将当前字符串进行md5编码
*/
- (NSString *)md5String;


@end

NS_ASSUME_NONNULL_END
