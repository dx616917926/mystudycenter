//
//  HXShareManager.m
//  HXMinedu
//
//  Created by mac on 2021/5/21.
//

#import "HXShareManager.h"
#import "WXApi.h"
#import "UIImage+Extension.h"

//分享文字内容最大长度
#define kHXShareContentMaxLen    100

@implementation HXShareManager

+ (HXShareManager *)manager{
    
    static HXShareManager *manager = nil;
    if (manager == nil) {
        manager = [[HXShareManager alloc] init];
    }
    return manager;
}


///只分享图片到微信
- (void)wechatShareImageData:(NSData *)imageData wxScene:(int)scene {
    if (![WXApi isWXAppInstalled]) {
        [[[UIApplication sharedApplication] keyWindow] showTostWithMessage:(NSLocalizedString(@"你的设备尚未安装微信", nil))];
    }
    
    NSData *data = [self compressScaleImageData:imageData isThumb:YES];
    imageData = [self compressScaleImageData:imageData isThumb:NO];
    
    WXMediaMessage *message = [WXMediaMessage message];
    ///切记缩略图大小不能超过64K，否则无法调起微信，而微信也没有返回错误信息，只是[WXApi sendReq:req]=NO
    [message setThumbImage:[UIImage imageWithData:data]];
    
    WXImageObject *imageObj = [WXImageObject object];
    imageObj.imageData = imageData;/// 大小不能超过25M    message.mediaObject = imageObj;
    message.mediaObject = imageObj;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene =  scene;
    
   [WXApi sendReq:req completion:^(BOOL success) {
         NSLog(@"%@", (success==NO)?@"图片不能微信分享,可能原因是图片太大了...":@"微信分享成功");
    }];
   
}

///*微信分享*/ (imageUrl)
- (void)wechatShareWithTitle:(NSString *)title content:(NSString *)content imgUrl:(NSString *)imgUrl url:(NSString *)url wxScene:(int)scene completion:(void (^)(BOOL))completion {
    if (![WXApi isWXAppInstalled]) {
        [[[UIApplication sharedApplication] keyWindow] showTostWithMessage:(NSLocalizedString(@"你的设备尚未安装微信", nil))];
        return;
    }
    
    if ([HXCommonUtil isNull: content]) {
        content = NSLocalizedString(@"来自学习中心的分享!", nil);
    }else if (content.length > kHXShareContentMaxLen) {
        content = [NSString stringWithFormat:@"%@…", [content substringToIndex:kHXShareContentMaxLen]];
    }
    
    NSString *shareTitle = title;
    if (shareTitle.length > 64) {
        shareTitle = [NSString stringWithFormat:@"%@…", [shareTitle substringToIndex:64]];
    }
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = shareTitle;
    message.description = content;
    
    NSData *data;
    if ([HXCommonUtil isNull:imgUrl]) {
        data = UIImagePNGRepresentation([UIImage imageNamed:@"version_logo"]);
    } else {
        data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrl]];
    }
    
    UIImage *image = [UIImage imageWithData:data];
    if (image) {
        message.thumbData = [self compressScaleImageData:data isThumb:YES];
    } else {
        message.thumbData = nil;
    }
    
    //多媒体数据对象，可以为WXImageObject，WXMusicObject，WXVideoObject，WXWebpageObject等
    WXWebpageObject *webpageObject = [WXWebpageObject object];
    webpageObject.webpageUrl = url;
    message.mediaObject = webpageObject;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = scene;
    
    [WXApi sendReq:req completion:^(BOOL success) {
        completion(success);
    }];
    
}




- (void)wechatShareWithTitle:(NSString *)title content:(NSString *)content imageData:(NSData *)imageData url:(NSString *)url wxScene:(int)scene completion:(void (^)(BOOL))completion{
    
    if (![WXApi isWXAppInstalled]) {
        [[[UIApplication sharedApplication] keyWindow] showTostWithMessage:(NSLocalizedString(@"你的设备尚未安装微信", nil))];
        return;
    }
    
    if ([HXCommonUtil isNull: content]) {
        content = NSLocalizedString(@"来自学习中心的分享!", nil);
    }else if (content.length > kHXShareContentMaxLen) {
        content = [NSString stringWithFormat:@"%@…", [content substringToIndex:kHXShareContentMaxLen]];
    }
    
    NSString *shareTitle = title;
    if (shareTitle.length > 64) {
        shareTitle = [NSString stringWithFormat:@"%@…", [shareTitle substringToIndex:64]];
    }
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = shareTitle;
    message.description = content;
    message.thumbData = [self compressScaleImageData:imageData isThumb:YES];;
    
    WXWebpageObject *webpageObject = [WXWebpageObject object];
    webpageObject.webpageUrl = url;
    message.mediaObject = webpageObject;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = scene;
    
   [WXApi sendReq:req completion:^(BOOL success) {
       completion(success);
    }];
    
}




#pragma mark - 图片处理
///分享图片限制 10M
- (NSData *)compressScaleImageData:(NSData *)imageData isThumb:(BOOL)isThumb {
    
    NSInteger byte = isThumb ? 64000 : 10000000;
    
    CGFloat originWidth = isThumb ? 125 : 1242;
    
    while (imageData.length > byte) {
        UIImage *tempImage = [UIImage imageWithData:imageData];
        CGFloat scale = tempImage.size.height/tempImage.size.width;
        tempImage = [self clipImage:tempImage toRect:CGSizeMake(originWidth, originWidth *scale)];
        imageData = UIImageJPEGRepresentation(tempImage, 0.3);
        
        originWidth = originWidth *0.8;
    }
    
    return imageData;
}

- (UIImage *)compressImage:(UIImage *)image toByte:(NSUInteger)maxLength {
    // Compress by quality
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(image, compression);
    if (data.length < maxLength) return image;
    
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
    UIImage *resultImage = [UIImage imageWithData:data];
    if (data.length < maxLength) return resultImage;
    
    // Compress by size
    NSUInteger lastDataLength = 0;
    while (data.length > maxLength && data.length != lastDataLength) {
        lastDataLength = data.length;
        CGFloat ratio = (CGFloat)maxLength / data.length;
        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                 (NSUInteger)(resultImage.size.height * sqrtf(ratio))); // Use NSUInteger to prevent white blank
        UIGraphicsBeginImageContext(size);
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        data = UIImageJPEGRepresentation(resultImage, compression);
    }
    
    return resultImage;
}


//裁剪图片
- (UIImage *)clipImage:(UIImage*)image toRect:(CGSize)size{
    @autoreleasepool {
        if (image.size.width < size.width || image.size.height < size.height) {
            return image;
        }
        UIGraphicsBeginImageContext(size);
        [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
        UIImage *newImg = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return newImg;
    }
}
@end
