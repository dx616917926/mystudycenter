//
//  NSString+HXString.m
//  HXMinedu
//
//  Created by Mac on 2021/1/6.
//

#import "NSString+HXString.h"

@implementation NSString (HXString)

//是否是有效的正则表达式
+(BOOL)isValidateRegularExpression:(NSString *)strDestination byExpression:(NSString *)strExpression
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", strExpression];
    
    return [predicate evaluateWithObject:strDestination];
    
}

//验证email
+(BOOL)isValidateEmail:(NSString *)email {
    
    NSString *strRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,5}";
    
    BOOL rt = [self isValidateRegularExpression:email byExpression:strRegex];
    
    return rt;
    
}

//验证电话号码
+(BOOL)isValidateTelNumber:(NSString *)number {
    
    NSString *strRegex = @"^1[0-9][0-9]{9}$";
    
    BOOL rt = [self isValidateRegularExpression:number byExpression:strRegex];
    
    return rt;
    
}
//校验是否是纯数字字符串
+(BOOL)isOnlyNumString:(NSString *)num {
    
    NSString *strRegex = @"[0-9]*";
    
    BOOL rt = [self isValidateRegularExpression:num byExpression:strRegex];
    
    return rt;
}

//校验是否是纯字母字符串
+(BOOL)isOnlyLetterString:(NSString *)letter {
    
    NSString *strRegex = @"[A-Za-z]*";
    
    BOOL rt = [self isValidateRegularExpression:letter byExpression:strRegex];
    
    return rt;
}

- (NSString *)trim {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

@end
