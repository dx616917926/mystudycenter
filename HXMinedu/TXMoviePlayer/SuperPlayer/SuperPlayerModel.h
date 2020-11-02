#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AVCVideo.h"

@class SuperPlayerView;


@interface SuperPlayerModel : AVCVideo

/**
 * 正在播放的清晰度
 */
@property (nonatomic) NSString *playingDefinition;

/**
 * 正在播放的清晰度索引
 */
@property (readonly) int playingDefinitionIndex;

/**
 * 清晰度列表
 */
@property (nonatomic) NSArray *playDefinitions;

/**
 * 打点信息
 */
@property (nonatomic) NSArray<NSString *> *videoPointList;


@end
