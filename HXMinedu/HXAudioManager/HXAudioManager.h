//
//  HXAudioManager.h
//  eplatform-ebook
//
//  Created by  MAC on 15/7/1.
//  Copyright (c) 2015年 华夏大地教育. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXAudioManager : NSObject

+ (instancetype)sharedManager;

@property (nonatomic, copy) NSArray *tracks;

-(void)showWithAnimated:(BOOL)animated;

-(void)hiddenWithAnimated:(BOOL)animated;

@end
