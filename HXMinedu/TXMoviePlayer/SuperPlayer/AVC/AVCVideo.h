//
//  AVCVideo.h
//  AliyunVideoClient_Entrance
//
//  Created by Zejian Cai on 2018/4/18.
//  Copyright © 2018年 Alibaba. All rights reserved.
//  AVCVideoConfig的组合类

#import <Foundation/Foundation.h>

/*
 * 参数： AliyunPlayMedthod 播放方式
 * 说明：
 */
typedef NS_ENUM(NSInteger,AliyunPlayMedthod){
    AliyunPlayMedthodPlayAuth = 0,  //vid+playauth
    AliyunPlayMedthodSTS,           //vid+sts
    AliyunPlayMedthodMPS,           //vid+mps
    AliyunPlayMedthodURL,           //url
    AliyunPlayMedthodLocal,         //本地视频
};

NS_ASSUME_NONNULL_BEGIN

@interface AVCVideo : NSObject

@property (nonatomic, strong, readonly, nullable) NSString *title;

@property (nonatomic, strong) NSURL *videoUrl;

@property (nonatomic, copy) NSString *videoId;

@property (nonatomic, copy) NSString *videoTitle;

@property (nonatomic, strong) NSNumber *video_quality;//视频的质量
@property (nonatomic, strong) NSString *video_format;//视频格式

@property (nonatomic, assign) AliyunPlayMedthod playMethod;

@property (nonatomic, copy) NSString * stsAccessKeyId;
@property (nonatomic, copy) NSString * stsAccessSecret;
@property (nonatomic, copy) NSString * stsSecurityToken;

@property (nonatomic, copy) NSString * playAuth;

@property (nonatomic, copy) NSString * mtsAccessKey;
@property (nonatomic, copy) NSString * mtsAccessSecret;
@property (nonatomic, copy) NSString * mtsStstoken;
@property (nonatomic, copy) NSString * mtsAuthon;
@property (nonatomic, copy) NSString * mtsRegion;
@property (nonatomic, copy) NSString * mtsPlayDomain;
@property (nonatomic, copy) NSString * mtsHlsUriToken;

@end
NS_ASSUME_NONNULL_END
