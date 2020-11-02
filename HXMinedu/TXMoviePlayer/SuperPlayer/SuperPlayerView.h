#import <UIKit/UIKit.h>
#import "SuperPlayer.h"
#import "SuperPlayerModel.h"
#import "SuperPlayerViewConfig.h"
#import <AliyunPlayer/AliyunPlayer.h>

@class SuperPlayerControlView;
@class SuperPlayerView;

@protocol SuperPlayerDelegate <NSObject>
@optional
/** 返回事件 */
- (void)superPlayerBackAction:(SuperPlayerView *)player;
/// 开始学习按钮点击通知
- (void)superPlayerStartPlayAction:(SuperPlayerView *)player;
/// 重试按钮点击通知
- (void)superPlayerRetryPlayAction:(SuperPlayerView *)player;
/// 全屏改变通知
- (void)superPlayerFullScreenChanged:(SuperPlayerView *)player;
/// 下载按钮点击通知
- (void)superPlayerDownloadAction:(SuperPlayerView *)player;
/// 播放开始通知
- (void)superPlayerDidStart:(SuperPlayerView *)player;
/// 播放结束通知
- (void)superPlayerDidEnd:(SuperPlayerView *)player;
/// 播放错误通知
- (void)superPlayerError:(SuperPlayerView *)player errCode:(int)code errMessage:(NSString *)why;
/// 播放进度通知
- (void)superPlayerPlaying:(SuperPlayerView *)player withTime:(NSInteger)currentTime;
@end

// 播放器的几种状态
typedef NS_ENUM(NSInteger, SuperPlayerState) {
    StateFailed,     // 播放失败
    StateBuffering,  // 缓冲中
    StatePlaying,    // 播放中
    StateStopped,    // 停止播放
    StatePause,      // 暂停播放
};


@interface SuperPlayerView : UIView

/** 点播播放器 */
@property (nonatomic, strong) AliPlayer *aliPlayer;

/** 设置代理 */
@property (nonatomic, weak) id<SuperPlayerDelegate>delegate;

/**
 * 设置播放器的父view。播放过程中调用可实现播放窗口转移
 */
@property (nonatomic, weak) UIView *fatherView;

/** 竖屏界面的返回按钮*/
@property (nonatomic, strong) UIButton *backBtnPortrait;

/** 播放器的状态 */
@property (nonatomic, assign) SuperPlayerState state;
/** 是否全屏 */
@property (nonatomic, assign, setter=setFullScreen:) BOOL isFullScreen;
/** 是否锁定旋转 */
@property (nonatomic, assign) BOOL isLockScreen;

/// 状态栏
@property (nonatomic) BOOL isStatusBarHidden;

/// 超级播放器控制层
@property (nonatomic) SuperPlayerControlView *controlView;
/// 是否允许竖屏手势
@property (nonatomic) BOOL disableGesture;
/// 是否在手势中
@property (readonly)  BOOL isDragging;
/// 是否加载成功
@property (readonly)  BOOL  isLoaded;
/**
 * 设置封面图片
 */
@property (nonatomic) UIImageView *coverImageView;
/// 重播按钮
@property (nonatomic, strong) UIButton *repeatBtn;
/// 开始学习按钮
@property (nonatomic, strong) UIButton *startPlayBtn;
/// 是否自动播放（在playWithModel前设置) 默认YES
@property BOOL autoPlay;
/// 是否显示开始学习按钮（在playWithModel前设置) 默认NO
@property (nonatomic) BOOL showStartPlayBtn;
/// 视频总时长
@property (nonatomic) CGFloat playDuration;
/// 视频当前播放时间
@property (nonatomic) CGFloat playCurrentTime;
/// 起始播放时间，用于从上次位置开播（在playWithModel前设置)
@property CGFloat startTime;
/// 播放的视频Model
@property (readonly) SuperPlayerModel *playerModel;
/// 播放器配置
@property SuperPlayerViewConfig *playerConfig;

/**
 * 视频雪碧图
 */
//@property TXImageSprite *imageSprite;
/**
 * 播放model
 */
- (void)playWithModel:(SuperPlayerModel *)playerModel;

/**
 * 重置player
 */
- (void)resetPlayer;

/**
 * 播放
 */
- (void)resume;

/**
 * 暂停
 * @warn isLoaded == NO 时暂停无效
 */
- (void)pause;

@end
