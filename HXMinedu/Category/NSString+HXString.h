//
//  NSString+HXString.h
//  HXMinedu
//
//  Created by Mac on 2021/1/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (HXString)

//验证电话号码
+(BOOL)isValidateTelNumber:(NSString *)number;

//验证email
+(BOOL)isValidateEmail:(NSString *)email;

//校验是否是纯数字字符串
+(BOOL)isOnlyNumString:(NSString *)num;

//校验是否是纯字母字符串
+(BOOL)isOnlyLetterString:(NSString *)letter;

//是否是有效的正则表达式
+(BOOL)isValidateRegularExpression:(NSString *)strDestination byExpression:(NSString *)strExpression;

@end

NS_ASSUME_NONNULL_END
