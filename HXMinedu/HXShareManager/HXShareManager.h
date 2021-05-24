//
//  HXShareManager.h
//  HXMinedu
//
//  Created by mac on 2021/5/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
///1 微信   2 朋友圈    3 QQ    4 微博
typedef NS_ENUM(NSInteger, kHXShareType) {
    kKPSharePathDefault    = 0,
    kKPShareToWechat       = 1,
    kKPShareToFriendShare  = 2,
    kKPShareToQQ           = 3,
    kKPShareToWeibo        = 4
};

@interface HXShareManager : NSObject

+ (HXShareManager *)manager;

/*
 只分享图片到微信
 imageData   图片数据
 scene       场景 0:聊天界面   1:朋友圈    2:收藏   3:指定联系人
 */
- (void)wechatShareImageData:(NSData *)imageData
                     wxScene:(int)scene;
/*
 微信分享（图片是url）
 title     消息标题
 content   描述内容
 imgUrl    图片url
 url       网页的url地址,微信打开分享跳转的H5页面地址
 scene       场景 0:聊天界面   1:朋友圈    2:收藏   3:指定联系人
 */
- (void)wechatShareWithTitle:(NSString *)title
                     content:(NSString *)content
                      imgUrl:(NSString *)imgUrl
                         url:(NSString *)url
                     wxScene:(int)scene
                  completion:(void (^)(BOOL success))completion;

/*
 微信分享（图片是NSData）
 title     消息标题
 content   描述内容
 imgUrl    图片url
 url       网页的url地址
 scene     场景 0:聊天界面   1:朋友圈    2:收藏   3:指定联系人
 */
- (void)wechatShareWithTitle:(NSString *)title
                     content:(NSString *)content
                   imageData:(NSData *)imageData
                         url:(NSString *)url
                     wxScene:(int)scene
                  completion:(void (^)(BOOL))completion;

    

@end

NS_ASSUME_NONNULL_END
