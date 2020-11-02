//
//  SuperPlayerViewConfig.h
//  SuperPlayer
//
//  Created by annidyfeng on 2018/10/18.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SuperPlayerViewConfig : NSObject
/// 播放速度，默认1.0
@property CGFloat playRate;
/// 是否静音，默认NO
@property BOOL mute;
/// 填充模式，默认铺满。
@property NSInteger renderMode;
/// http头，跟进情况自行设置
@property NSDictionary *headers;
/// 播放器最大缓存个数
@property (nonatomic) NSInteger maxCacheItem;
/// log打印，默认NO
@property BOOL enableLog;
/// 是否支持下载
@property BOOL canDownload;
/// 是否在进度条上显示打点信息，默认NO
@property BOOL showVideoPoint;

@end
