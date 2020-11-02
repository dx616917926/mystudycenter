//
//  TXBitrateItemHelper.h
//  SuperPlayer
//
//  Created by annidyfeng on 2018/9/28.
//

#import <Foundation/Foundation.h>
#import "SuperPlayerModel.h"
#import "SuperPlayer.h"

@interface TXBitrateItemHelper : NSObject

+ (NSArray *)sortWithBitrate:(NSArray*)tracks;

//获取所有已知清晰度
+ (NSArray<NSString *> *)allQualities;

+ (NSString *)qualityFromTrackDefinition:(NSString *)definitio;

@end
