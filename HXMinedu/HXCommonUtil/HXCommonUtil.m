//
//  HXCommonUtil.m
//  HXMinedu
//
//  Created by mac on 2021/3/30.
//

#import "HXCommonUtil.h"

@implementation HXCommonUtil

/**
 *  判断对象是否为空，包括 nil、空字符串、NSNull
 *  @param obj 需要进行判断的对象
 *  @return 对象为空返回YES，否则返回NO
 */
+ (BOOL)isNull:(id)obj {
    if ([obj isKindOfClass:[NSNull class]] || !obj) {
        return YES;
    } else if ([obj isKindOfClass:[NSString class]] && [[obj stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        return YES;
    }
    return NO;
}
/**
 属性化文字
 @param needString             需要属性化的文字
 @param needAttributedDic      添加的属性
 @param content                所有文本
 @param defaultAttributedDic   默认的属性
 @return 属性化文字
 */
+ (NSMutableAttributedString *)getAttributedStringWith:(NSString *)needString needAttributed:(NSDictionary *)needAttributedDic content:(NSString *)content defaultAttributed:(NSDictionary *)defaultAttributedDic{
    if ([HXCommonUtil isNull:content]||[HXCommonUtil isNull:needString]) {
        return nil;
    }
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:content];
    ///添加默认属性
    if (defaultAttributedDic!=nil&&![HXCommonUtil isNull:content]) {
        [attributedString addAttributes:defaultAttributedDic range:NSMakeRange(0, content.length)];
    }
    if (needAttributedDic!=nil&&![HXCommonUtil isNull:needString]) {
        ///需要属性化的范围
        NSRange range =  [content rangeOfString:needString];
        ///添加属性
        [attributedString addAttributes:needAttributedDic range:range];
    }
    
    return attributedString;
}
@end
