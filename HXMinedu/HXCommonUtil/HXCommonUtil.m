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
 字符串编码
 */
+ (NSString *)stringEncoding:(NSString *)str{
    if ([HXCommonUtil isNull:str]) {
        return @"";
    }
    return  [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
}



/**
 字符串解码
 */
+ (NSString*)strDecodedString:(NSString*)str{
    if ([HXCommonUtil isNull:str]) {
        return @"";
    }
   NSString *decodedString=[str stringByRemovingPercentEncoding];
   return decodedString;
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

/**
 图片质量压缩到某一范围内，如果后面用到多，可以抽成分类或者工具类,这里压缩递减比二分的运行时间长，二分可以限制下限。
 */
+ (UIImage *)compressImageSize:(UIImage *)image toByte:(NSUInteger)maxLength{
    //首先判断原图大小是否在要求内，如果满足要求则不进行压缩，over
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(image, compression);
    NSLog(@"原图大小：%.2f M",(float)data.length/(1024*1024.0f));
    if (data.length < maxLength) return image;
    //原图大小超过范围，先进行“压处理”，这里 压缩比 采用二分法进行处理，6次二分后的最小压缩比是0.015625，已经够小了
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(image, compression);
        if (data.length < maxLength * 0.9) {
            min = compression;
        } else if (data.length > maxLength) {
            max = compression;
        } else {
            break;
        }
    }
    //判断“压处理”的结果是否符合要求，符合要求就over
    UIImage *resultImage = [UIImage imageWithData:data];
    if (data.length < maxLength) return resultImage;
    
    //缩处理，直接用大小的比例作为缩处理的比例进行处理，因为有取整处理，所以一般是需要两次处理
    NSUInteger lastDataLength = 0;
    while (data.length > maxLength && data.length != lastDataLength) {
        lastDataLength = data.length;
        //获取处理后的尺寸
        CGFloat ratio = (CGFloat)maxLength / data.length;
        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                 (NSUInteger)(resultImage.size.height * sqrtf(ratio)));
        //通过图片上下文进行处理图片
        UIGraphicsBeginImageContext(size);
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        //获取处理后图片的大小
        data = UIImageJPEGRepresentation(resultImage, compression);
    }
    
    return resultImage;
}
@end
