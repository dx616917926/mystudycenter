//
//  TXMoviePlayerController.h
//  TXMoviePlayer
//
//  Created by Mac on 2019/5/17.
//  Copyright © 2019 华夏大地教育网. All rights reserved.
//

#import <UIKit/UIKit.h>

//
//  更新记录
//  v1.0 第一个上线版本，阿里云SDK v3.4.10
//  v2.0 更新阿里云SDK v4.7.0
//  v3.0 增加下载功能 阿里云SDK v4.7.2
//  v4.0 默认不显示进度条打点功能  showVideoPoint=NO
//  v4.1 新增加动态服务器域名参数  serverUrl
//  v4.2 更新阿里云SDK v4.7.5
//  v4.3 优化手势响应速度，适配iOS 14
//  v4.4 为iOS 11以上设备自定义状态栏，升级AFNetworking到v4.0.1
//  v4.5 组件化 阿里云SDK v5.3.0

NS_ASSUME_NONNULL_BEGIN

@interface TXMoviePlayerController : UIViewController

@property(nonatomic, strong) NSDictionary *cws_param;  //验证参数，必传

@property(nonatomic,assign) BOOL canDownload;         //是否支持下载功能，默认NO
@property(nonatomic,copy) NSString *coursewareTitle;  //课件大标题名称
@property(nonatomic,copy) NSString *coursewareId;     //ID
@property(nonatomic,copy) NSString *classID;          //班级ID

@end

NS_ASSUME_NONNULL_END
