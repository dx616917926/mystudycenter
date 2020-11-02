//
//  AVCVideo.m
//  AliyunVideoClient_Entrance
//
//  Created by Zejian Cai on 2018/4/18.
//  Copyright © 2018年 Alibaba. All rights reserved.
//

#import "AVCVideo.h"

@implementation AVCVideo

- (instancetype)init{
    self = [super init];
    if (self) {
        
        self.playMethod = AliyunPlayMedthodURL;
        
        self.videoUrl = @"";
        
        self.videoId = @"";
        
        
        self.playAuth = @"";
        
        self.stsAccessKeyId = @"";
        self.stsAccessSecret = @"";
        self.stsSecurityToken = @"";
        
        self.mtsAccessKey = @"";
        self.mtsAccessSecret = @"";
        self.mtsStstoken = @"";
        self.mtsAuthon = @"";
        self.mtsRegion = @"cn-hangzhou";
        
        
        self.stsAccessKeyId = @"";
        self.stsAccessSecret = @"";
        self.stsSecurityToken = @"";
        
    }
    return self;
}

@end
