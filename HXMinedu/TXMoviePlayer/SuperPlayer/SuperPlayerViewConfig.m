//
//  SuperPlayerViewConfig.m
//  SuperPlayer
//
//  Created by annidyfeng on 2018/10/18.
//

#import "SuperPlayerViewConfig.h"
#import "SuperPlayer.h"

@implementation SuperPlayerViewConfig

- (instancetype)init {
    self = [super init];
    self.playRate = 1;
    self.renderMode = 0;
    self.maxCacheItem = 5;
    self.enableLog = NO;
    self.canDownload = NO;
        
#ifdef TXMoviePlayerTest
    self.showVideoPoint = YES;
#else
    self.showVideoPoint = NO;
#endif
    
    return self;
}

@end
