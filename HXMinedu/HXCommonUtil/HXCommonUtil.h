//
//  HXCommonUtil.h
//  HXMinedu
//
//  Created by mac on 2021/3/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HXCommonUtil : NSObject

/**
 *  判断对象是否为空，包括 nil、空字符串、NSNull
 *  @param obj 需要进行判断的对象
 *  @return 对象为空返回YES，否则返回NO
 */
+ (BOOL)isNull:(id)obj;

/**
 字符串编码
 */
+ (NSString *)stringEncoding:(NSString *)str;
/**
 字符串解码
 */
+ (NSString*)strDecodedString:(NSString*)str;

/**
 属性化文字
 @param needString             需要属性化的文字
 @param needAttributedDic      添加的属性
 @param content                所有文本
 @param defaultAttributedDic   默认的属性
 @return 属性化文字
 */
+ (NSMutableAttributedString *)getAttributedStringWith:(NSString *)needString needAttributed:(NSDictionary *)needAttributedDic content:(NSString *)content defaultAttributed:(NSDictionary *)defaultAttributedDic;

/**
 图片质量压缩到某一范围内，如果后面用到多，可以抽成分类或者工具类,这里压缩递减比二分的运行时间长，二分可以限制下限。
 */
+(UIImage *)compressImageSize:(UIImage *)image toByte:(NSUInteger)maxLength;

@end

NS_ASSUME_NONNULL_END
