#import "SuperPlayerView.h"
#import <AVFoundation/AVFoundation.h>
#import "SuperPlayer.h"
#import "SuperPlayerControlViewDelegate.h"
#import "SuperPlayerView+Private.h"
#import "StrUtils.h"
#import "UIView+Fade.h"
#import "TXBitrateItemHelper.h"
#import "UIView+MMLayout.h"
#import "SPDefaultControlView.h"
#import "SuperPlayerGuideView.h"

static UISlider * _volumeSlider;

//忽略编译器的警告
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"


@interface SuperPlayerView ()<AVPDelegate>

@property (nonatomic, weak) NSTimer *timer;         //计时器
@property (nonatomic, strong) UIView *playerView;
@property (nonatomic, strong) SuperPlayerGuideView *guideView;   //引导页
@property (nonatomic, assign) AVPSeekMode seekMode;
@property (nonatomic, assign) AVPStatus currentPlayStatus;       //记录播放器的状态

@end

@implementation SuperPlayerView {
    UIView *_fullScreenBlackView;
    SuperPlayerControlView *_controlView;
}

#pragma mark - life Cycle

/**
 *  代码初始化调用此方法
 */
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) { [self initializeThePlayer]; }
    return self;
}

/**
 *  storyboard、xib加载playerView会调用此方法
 */
- (void)awakeFromNib {
    [super awakeFromNib];
    [self initializeThePlayer];
}

/**
 *  初始化player
 */
- (void)initializeThePlayer {
    LOG_ME;
    self.netWatcher = [[NetWatcher alloc] init];
    
    CGRect frame = CGRectMake(0, -100, 10, 0);
    self.volumeView = [[MPVolumeView alloc] initWithFrame:frame];
    [self.volumeView sizeToFit];
    for (UIWindow *window in [[UIApplication sharedApplication] windows]) {
        if (!window.isHidden) {
            [window addSubview:self.volumeView];
            break;
        }
    }
    
    _fullScreenBlackView = [UIView new];
    _fullScreenBlackView.backgroundColor = [UIColor blackColor];
    
    // 单例slider
    _volumeSlider = nil;
    for (UIView *view in [self.volumeView subviews]){
        if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
            _volumeSlider = (UISlider *)view;
            break;
        }
    }
    
    _playerConfig = [[SuperPlayerViewConfig alloc] init];
    // 添加通知
    [self addNotifications];
    // 添加手势
    [self createGesture];
    
    self.autoPlay = YES;
    
    [self addSubview:self.playerView];
}

- (void)dealloc {
    LOG_ME;
    // 移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];

    [self.netWatcher stopWatch];
    [self.volumeView removeFromSuperview];
    
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    if (_aliPlayer) {
        [_aliPlayer destroy];
        _aliPlayer = nil;
    }
    //开启休眠
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
}

- (UIView *)playerView {
    if (!_playerView) {
        _playerView = [[UIView alloc]init];
    }
    return _playerView;
}

- (SuperPlayerGuideView *)guideView {
    if (!_guideView) {
        _guideView = [[SuperPlayerGuideView alloc] init];
    }
    return _guideView;
}

- (AVPSeekMode)seekMode {
    if (self.aliPlayer.duration < 300000) {
        return AVP_SEEKMODE_ACCURATE;
    }
    return AVP_SEEKMODE_INACCURATE;
}

#pragma mark - 观察者、通知

/**
 *  添加观察者、通知
 */
- (void)addNotifications {
    // app退到后台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackground:) name:UIApplicationWillResignActiveNotification object:nil];
    // app进入前台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterPlayground:) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    // 监测设备方向
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onDeviceOrientationChange)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
}

#pragma mark - layoutSubviews

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.playerView.frame = self.bounds;
}

#pragma mark - Public Method

- (void)playWithModel:(SuperPlayerModel *)playerModel {
    LOG_ME;
    self.isShiftPlayback = NO;
    [self _playWithModel:playerModel];
    self.coverImageView.alpha = 1;
    self.repeatBtn.hidden = YES;
    self.startPlayBtn.hidden = YES;
}

- (void)reloadModel {
    
    //准备重新请求数据
    [self.aliPlayer reset];
    self.aliPlayer.playerView = self.playerView;
    self.state = StateStopped;
    
    if ([self.delegate respondsToSelector:@selector(superPlayerRetryPlayAction:)]) {
        [self.delegate superPlayerRetryPlayAction:self];
    }
}

- (void)_playWithModel:(SuperPlayerModel *)playerModel {
    _playerModel = playerModel;
    
    [self pause];
    
    [self configTXPlayer];
}

/**
 *  player添加到fatherView上
 */
- (void)addPlayerToFatherView:(UIView *)view {
    [self removeFromSuperview];
    if (view) {
        [view addSubview:self];
        [self mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_offset(UIEdgeInsetsZero);
        }];
    }
}

- (void)setFatherView:(UIView *)fatherView {
    if (fatherView != _fatherView) {
        [self addPlayerToFatherView:fatherView];
    }
    _fatherView = fatherView;
}

/**
 *  重置player
 */
- (void)resetPlayer {
    LOG_ME;
    // 移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    // 暂停
    [self pause];
    
    [self.aliPlayer reset];
    
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    
    self.state = StateStopped;
}

/**
 *  播放
 */
- (void)resume {
    LOG_ME;
    [self.controlView setPlayState:YES];
    self.isPauseByUser = NO;
    self.state = StatePlaying;
    [self.aliPlayer start];
}

/**
 * 暂停
 */
- (void)pause {
    LOG_ME;
    if (!self.isLoaded)
        return;
    [self.controlView setPlayState:NO];
    self.isPauseByUser = YES;
    self.state = StatePause;
    [self.aliPlayer pause];
}

/**
 是否显示开始学习按钮
 */
- (void)setShowStartPlayBtn:(BOOL)show {
    self.startPlayBtn.hidden = !show;
}

#pragma mark - Private Method
/**
 *  设置Player相关参数
 */
- (void)configTXPlayer {
    LOG_ME;
    self.backgroundColor = [UIColor blackColor];
    
    [self.aliPlayer stop];
    
    self.liveProgressTime = self.maxLiveProgressTime = 0;
    
    self.isLoaded = NO;
    
    self.netWatcher.playerModel = self.playerModel;
    if (self.playerModel.playingDefinition == nil) {
        self.playerModel.playingDefinition = self.netWatcher.adviseDefinition;
    }
    
    switch (self.playerModel.playMethod) {
        case AliyunPlayMedthodPlayAuth: //vid+playauth
        {
            AVPVidAuthSource *authSource = [[AVPVidAuthSource alloc]initWithVid:self.playerModel.videoId playAuth:self.playerModel.playAuth region:@""];
            [self.aliPlayer setAuthSource:authSource];
        }
            break;
        case AliyunPlayMedthodURL: //url
        {
            AVPUrlSource *urlSource = [[AVPUrlSource alloc]init];
            urlSource.playerUrl = self.playerModel.videoUrl;
            [self.aliPlayer setUrlSource:urlSource];
        }
            break;
        case AliyunPlayMedthodSTS: //vid+sts
        {
            AVPVidStsSource *stsSource = [[AVPVidStsSource alloc]initWithVid:self.playerModel.videoId accessKeyId:self.playerModel.stsAccessKeyId accessKeySecret:self.playerModel.stsAccessSecret securityToken:self.playerModel.stsSecurityToken region:@""];
            [self.aliPlayer setStsSource:stsSource];
        }
            break;
        case AliyunPlayMedthodMPS: //vid+mps
        {
            AVPVidMpsSource *mpsSource = [[AVPVidMpsSource alloc]initWithVid:self.playerModel.videoId accId:self.playerModel.mtsAccessKey accSecret:self.playerModel.mtsAccessSecret stsToken:self.playerModel.mtsStstoken authInfo:self.playerModel.mtsAuthon region:self.playerModel.mtsRegion playDomain:self.playerModel.mtsPlayDomain mtsHlsUriToken:self.playerModel.mtsHlsUriToken];
            [self.aliPlayer setMpsSource:mpsSource];
        }
            break;
        case AliyunPlayMedthodLocal: //本地视频
            {
                AVPUrlSource *urlSource = [[AVPUrlSource alloc]init];
                urlSource.playerUrl = self.playerModel.videoUrl;
                [self.aliPlayer setUrlSource:urlSource];
            }
            break;
        default:
            break;
    }
    
    [self.netWatcher startWatch];
    __weak SuperPlayerView *weakSelf = self;
    [self.netWatcher setNotifyTipsBlock:^(NSString *msg) {
        SuperPlayerView *strongSelf = weakSelf;
        if (strongSelf) {
            [strongSelf showMiddleBtnMsg:msg withAction:ActionSwitch];
            [strongSelf.middleBlackBtn fadeOut:2];
        }
    }];
    self.state = StateBuffering;
    self.isPauseByUser = NO;
    [self.controlView playerBegin:self.playerModel isLive:NO isTimeShifting:self.isShiftPlayback isAutoPlay:self.autoPlay];
    self.controlView.playerConfig = self.playerConfig;
    self.playDidEnd = NO;
    [self.middleBlackBtn fadeOut:0.1];
    
    [self.aliPlayer prepare];
    [self.aliPlayer start];
}

/**
 *  创建手势
 */
- (void)createGesture {
    // 单击
    self.singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTapAction:)];
    self.singleTap.delegate                = self;
    self.singleTap.numberOfTouchesRequired = 1; //手指数
    self.singleTap.numberOfTapsRequired    = 1;
    [self addGestureRecognizer:self.singleTap];
    
    // 双击(播放/暂停)
    self.doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTapAction:)];
    self.doubleTap.delegate                = self;
    self.doubleTap.numberOfTouchesRequired = 1; //手指数
    self.doubleTap.numberOfTapsRequired    = 2;
    [self addGestureRecognizer:self.doubleTap];

    // 解决点击当前view时候响应其他控件事件
    [self.singleTap setDelaysTouchesBegan:YES];
    [self.doubleTap setDelaysTouchesBegan:YES];
    // 双击失败响应单击事件
    [self.singleTap requireGestureRecognizerToFail:self.doubleTap];
    
    // 加载完成后，再添加平移手势
    // 添加平移手势，用来控制音量、亮度、快进快退
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panDirection:)];
    panRecognizer.delegate = self;
    [panRecognizer setMaximumNumberOfTouches:1];
    [panRecognizer setDelaysTouchesBegan:YES];
    [panRecognizer setDelaysTouchesEnded:YES];
    [panRecognizer setCancelsTouchesInView:YES];
    [self addGestureRecognizer:panRecognizer];
}

#pragma mark - KVO

/**
 *  设置横屏的约束
 */
- (void)setOrientationLandscapeConstraint:(UIInterfaceOrientation)orientation {
    _isFullScreen = YES;
    [self toOrientation:orientation];
}

/**
 *  设置竖屏的约束
 */
- (void)setOrientationPortraitConstraint {

    [self addPlayerToFatherView:self.fatherView];
    _isFullScreen = NO;
    [self toOrientation:UIInterfaceOrientationPortrait];
}

- (void)toOrientation:(UIInterfaceOrientation)orientation {
    
    // 根据要旋转的方向,使用Masonry重新修改限制
    if (orientation != UIInterfaceOrientationPortrait) {
        
        [self removeFromSuperview];
        
        UIView *examPopView;
        for (UIView *view in [UIApplication sharedApplication].keyWindow.subviews) {
            if (view.tag == 99) {
                examPopView = view;
            }
        }
        if (examPopView) {
            [[UIApplication sharedApplication].keyWindow insertSubview:_fullScreenBlackView belowSubview:examPopView];
        }else
        {
            [[UIApplication sharedApplication].keyWindow addSubview:_fullScreenBlackView];
        }
        [[UIApplication sharedApplication].keyWindow insertSubview:self aboveSubview:_fullScreenBlackView];
        
        [_fullScreenBlackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(ScreenWidth));
            make.height.equalTo(@(ScreenHeight));
            make.center.equalTo([UIApplication sharedApplication].keyWindow);
        }];
        
        [self mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (IS_iPhoneX) {
                make.width.equalTo(@(ScreenWidth-88));
            } else {
                make.width.equalTo(@(ScreenWidth));
            }
            
            make.height.equalTo(@(ScreenHeight));
            make.center.equalTo([UIApplication sharedApplication].keyWindow);
        }];
        
        self.backBtnPortrait.hidden = YES;
        
        //是否显示引导页
        BOOL showGuideView = [[NSUserDefaults standardUserDefaults] boolForKey:TXMoviePlayerShowGuideView];
        if (!showGuideView) {
            self.guideView.frame = CGRectMake(0, 0, IS_iPhoneX?ScreenWidth-88:ScreenWidth, ScreenHeight);
            [self addSubview:self.guideView];
        }
        
    } else {
        //竖屏的时候隐藏引导页
        [_fullScreenBlackView removeFromSuperview];
        [_guideView removeFromSuperview];
        _guideView = nil;
        self.backBtnPortrait.hidden = NO;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.fatherView.mm_viewController setNeedsStatusBarAppearanceUpdate];
    });
}

#pragma mark 屏幕转屏相关

/**
 *  屏幕转屏
 *
 *  @param orientation 屏幕方向
 */
- (void)interfaceOrientation:(UIInterfaceOrientation)orientation {
    if (orientation == UIInterfaceOrientationLandscapeRight || orientation == UIInterfaceOrientationLandscapeLeft) {
        // 设置横屏
        [self setOrientationLandscapeConstraint:orientation];
    } else if (orientation == UIInterfaceOrientationPortrait) {
        // 设置竖屏
        [self setOrientationPortraitConstraint];
    }
}

/**
 *  屏幕方向发生变化会调用这里
 */
- (void)onDeviceOrientationChange {
    if (self.isLockScreen) { return; }
    
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    UIInterfaceOrientation interfaceOrientation = (UIInterfaceOrientation)orientation;
    if (orientation == UIDeviceOrientationFaceUp || orientation == UIDeviceOrientationFaceDown || orientation == UIDeviceOrientationUnknown ) { return; }
    
    switch (interfaceOrientation) {
        case UIInterfaceOrientationPortraitUpsideDown:{
        }
            break;
        case UIInterfaceOrientationPortrait:{
            [self setOrientationPortraitConstraint];
        }
            break;
        case UIInterfaceOrientationLandscapeLeft:{
            [self setOrientationLandscapeConstraint:UIInterfaceOrientationLandscapeLeft];
        }
            break;
        case UIInterfaceOrientationLandscapeRight:{
            [self setOrientationLandscapeConstraint:UIInterfaceOrientationLandscapeRight];
        }
            break;
        default:
            break;
    }
}

#pragma mark - Action

/**
 *   轻拍方法
 *
 *  @param gesture UITapGestureRecognizer
 */
- (void)singleTapAction:(UIGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateRecognized) {
        
        if (self.controlView.alpha == 0) {
            [[self.controlView fadeShow] fadeOut:3];
        } else {
            [self.controlView fadeOut:0];
        }
    }
}

/**
 *  双击播放/暂停
 *
 *  @param gesture UITapGestureRecognizer
 */
- (void)doubleTapAction:(UIGestureRecognizer *)gesture {
    if (self.playDidEnd) { return;  }
    // 显示控制层
    [self.controlView fadeShow];
    if (self.isPauseByUser) {
        [self resume];
        [self.controlView fadeOut:3];
    } else {
        [self pause];
    }
}

/** 全屏 */
- (void)setFullScreen:(BOOL)fullScreen {
    _isFullScreen = fullScreen;
    if (fullScreen) {
        UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
        if (orientation == UIDeviceOrientationLandscapeRight) {
            [self interfaceOrientation:UIInterfaceOrientationLandscapeLeft];
        } else {
            [self interfaceOrientation:UIInterfaceOrientationLandscapeRight];
        }
    } else {
        [self interfaceOrientation:UIInterfaceOrientationPortrait];
    }
}

#pragma mark - NSNotification Action

/**
 *  播放完了
 *
 */
- (void)moviePlayDidEnd {
    self.state = StateStopped;
    self.playDidEnd = YES;

    [self.controlView fadeShow];
    [self fastViewUnavaliable];
    [self.netWatcher stopWatch];
    self.repeatBtn.hidden = NO;
    if ([self.delegate respondsToSelector:@selector(superPlayerDidEnd:)]) {
        [self.delegate superPlayerDidEnd:self];
    }
}

/**
 *  应用退到后台
 */
- (void)appDidEnterBackground:(NSNotification *)notify {
    NSLog(@"appDidEnterBackground");
    self.didEnterBackground = YES;

    if (!self.isPauseByUser && (self.state != StateStopped && self.state != StateFailed)) {
        [self.aliPlayer pause];
        self.state = StatePause;
    }
}

/**
 *  应用进入前台
 */
- (void)appDidEnterPlayground:(NSNotification *)notify {
    NSLog(@"appDidEnterPlayground");
    self.didEnterBackground = NO;
    if (!self.isPauseByUser && (self.state != StateStopped && self.state != StateFailed)) {
        self.state = StatePlaying;
        [self.aliPlayer start];
    }
}

/**
 *  从xx秒开始播放视频跳转
 *
 *  @param dragedSeconds 视频跳转的秒数
 */
- (void)seekToTime:(NSInteger)dragedSeconds {
    if (!self.isLoaded || self.state == StateStopped) {
        return;
    }
    [self.aliPlayer start];
    [self.aliPlayer seekToTime:dragedSeconds*1000 seekMode:self.seekMode];
    [self.controlView setPlayState:YES];
}

#pragma mark - UIPanGestureRecognizer手势方法

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        return YES;
    }

    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        if (!self.isLoaded) { return NO; }
        if (self.isLockScreen) { return NO; }
        
        if (self.disableGesture) {
            if (!self.isFullScreen) {
                return NO;
            }
        }
        return YES;
    }
    
    return NO;
}

/**
 *  pan手势事件
 *
 *  @param pan UIPanGestureRecognizer
 */
- (void)panDirection:(UIPanGestureRecognizer *)pan {

    if (self.state == StateStopped)
        return;
    
    //根据在view上Pan的位置，确定是调音量还是亮度
    CGPoint locationPoint = [pan locationInView:self];
    
    // 我们要响应水平移动和垂直移动
    // 根据上次和本次移动的位置，算出一个速率的point
    CGPoint veloctyPoint = [pan velocityInView:self];
    
    // 判断是垂直移动还是水平移动
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:{ // 开始移动
            // 使用绝对值来判断移动的方向
            CGFloat x = fabs(veloctyPoint.x);
            CGFloat y = fabs(veloctyPoint.y);
            if (x > y) { // 水平移动
                // 取消隐藏
                self.panDirection = PanDirectionHorizontalMoved;
                self.sumTime      = [self playCurrentTime];
            }
            else if (x < y){ // 垂直移动
                self.panDirection = PanDirectionVerticalMoved;
                // 开始滑动的时候,状态改为正在控制音量
                if (locationPoint.x > self.bounds.size.width / 2) {
                    self.isVolume = YES;
                }else { // 状态改为显示亮度调节
                    self.isVolume = NO;
                }
            }
            self.isDragging = YES;
            [self.controlView fadeOut:0.1];
            break;
        }
        case UIGestureRecognizerStateChanged:{ // 正在移动
            switch (self.panDirection) {
                case PanDirectionHorizontalMoved:{
                    [self horizontalMoved:veloctyPoint.x]; // 水平移动的方法只要x方向的值
                    break;
                }
                case PanDirectionVerticalMoved:{
                    [self verticalMoved:veloctyPoint.y]; // 垂直移动方法只要y方向的值
                    break;
                }
                default:
                    break;
            }
            self.isDragging = YES;
            break;
        }
        case UIGestureRecognizerStateEnded:{ // 移动停止
            // 移动结束也需要判断垂直或者平移
            // 比如水平移动结束时，要快进到指定位置，如果这里没有判断，当我们调节音量完之后，会出现屏幕跳动的bug
            switch (self.panDirection) {
                case PanDirectionHorizontalMoved:{
                    self.isPauseByUser = NO;
                    [self seekToTime:self.sumTime];
                    // 把sumTime滞空，不然会越加越多
                    self.sumTime = 0;
                    break;
                }
                case PanDirectionVerticalMoved:{
                    // 垂直移动结束后，把状态改为不再控制音量
                    self.isVolume = NO;
                    break;
                }
                default:
                    break;
            }
            [self fastViewUnavaliable];
            self.isDragging = NO;
            break;
        }
        case UIGestureRecognizerStateCancelled: {
            self.sumTime = 0;
            self.isVolume = NO;
            [self fastViewUnavaliable];
            self.isDragging = NO;
        }
        default:
            break;
    }
}

/**
 *  pan垂直移动的方法
 *
 *  @param value void
 */
- (void)verticalMoved:(CGFloat)value {
   
    self.isVolume ? ([[self class] volumeViewSlider].value -= value / 10000) : ([UIScreen mainScreen].brightness -= value / 10000);

    if (self.isVolume) {
        [self fastViewImageAvaliable:SuperPlayerImage(@"sound_max") progress:[[self class] volumeViewSlider].value];
    } else {
        [self fastViewImageAvaliable:SuperPlayerImage(@"light_max") progress:[UIScreen mainScreen].brightness];
    }
}

/**
 *  pan水平移动的方法
 *
 *  @param value void
 */
- (void)horizontalMoved:(CGFloat)value {
    // 每次滑动需要叠加时间
    CGFloat totalMovieDuration = [self playDuration];
    self.sumTime += value / 100;
    
    if (self.sumTime > totalMovieDuration) { self.sumTime = totalMovieDuration;}
    if (self.sumTime < 0) { self.sumTime = 0; }
    
    [self fastViewProgressAvaliable:self.sumTime];
}

- (void)volumeChanged:(NSNotification *)notification
{
    if (self.isDragging)
        return; // 正在拖动，不响应音量事件
    
    if (![[[notification userInfo] objectForKey:@"AVSystemController_AudioVolumeChangeReasonNotificationParameter"] isEqualToString:@"ExplicitVolumeChange"]) {
        return;
    }
    float volume = [[[notification userInfo] objectForKey:@"AVSystemController_AudioVolumeNotificationParameter"] floatValue];
    [self fastViewImageAvaliable:SuperPlayerImage(@"sound_max") progress:volume];
    [self.fastView fadeOut:1];
}

- (SuperPlayerFastView *)fastView
{
    if (_fastView == nil) {
        _fastView = [[SuperPlayerFastView alloc] init];
        [self addSubview:_fastView];
        [_fastView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
    }
    return _fastView;
}

- (void)fastViewImageAvaliable:(UIImage *)image progress:(CGFloat)draggedValue {
    if (self.controlView.isShowSecondView)
        return;
    [self.fastView showImg:image withProgress:draggedValue];
    [self.fastView fadeShow];
}

- (void)fastViewProgressAvaliable:(NSInteger)draggedTime
{
    NSInteger totalTime = [self playDuration];
    NSString *currentTimeStr = [StrUtils timeFormat:draggedTime];
    NSString *totalTimeStr   = [StrUtils timeFormat:totalTime];
    NSString *timeStr        = [NSString stringWithFormat:@"%@ / %@", currentTimeStr, totalTimeStr];
    
    UIImage *thumbnail;
    if (self.isFullScreen) {
        //thumbnail = [self.imageSprite getThumbnail:draggedTime];
    }
    if (thumbnail) {
        self.fastView.videoRatio = self.videoRatio;
        [self.fastView showThumbnail:thumbnail withText:timeStr];
    } else {
        CGFloat sliderValue = 1;
        if (totalTime > 0) {
            sliderValue = (CGFloat)draggedTime/totalTime;
        }
        [self.fastView showText:timeStr withText:sliderValue];
    }
    [self.fastView fadeShow];
}

- (void)fastViewUnavaliable
{
    [self.fastView fadeOut:0.1];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    

    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        if (self.playDidEnd){
            return NO;
        }
    }

    if ([touch.view isKindOfClass:[UISlider class]] || [touch.view.superview isKindOfClass:[UISlider class]] || [touch.view isKindOfClass:[UIScrollView class]] || [touch.view isKindOfClass:[SuperPlayerGuideView class]]) {
        return NO;
    }

    return YES;
}

#pragma mark - Setter 


/**
 *  设置播放的状态
 *
 *  @param state SuperPlayerState
 */
- (void)setState:(SuperPlayerState)state {
        
    _state = state;
    // 控制菊花显示、隐藏
    if (state == StateBuffering) {
        [self.spinner startAnimating];
    } else {
        [self.spinner stopAnimating];
    }
    if (state == StatePlaying) {
        
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:@"AVSystemController_SystemVolumeDidChangeNotification"
                                                      object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(volumeChanged:)         name:@"AVSystemController_SystemVolumeDidChangeNotification"
                                                   object:nil];
        
        if (self.coverImageView.alpha == 1) {
            [UIView animateWithDuration:0.2 animations:^{
                self.coverImageView.alpha = 0;
            }];
        }
    } else if (state == StateFailed) {
        
    } else if (state == StateStopped) {
        
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:@"AVSystemController_SystemVolumeDidChangeNotification"
                                                      object:nil];
        
        self.coverImageView.alpha = 1;
        
    } else if (state == StatePause) {

    }
}

- (void)setControlView:(SuperPlayerControlView *)controlView {
    if (_controlView == controlView) {
        return;
    }
    [_controlView removeFromSuperview];

    controlView.delegate = self;
    [self addSubview:controlView];
    [controlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    [controlView playerBegin:self.playerModel isLive:NO isTimeShifting:self.isShiftPlayback isAutoPlay:self.autoPlay];
    [controlView setTitle:_controlView.title];
    [controlView setPointArray:_controlView.pointArray];
    
    _controlView = controlView;
    
    //添加返回按钮
    [self addSubview:self.backBtnPortrait];
    [self.backBtnPortrait mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.offset(5);
        make.top.offset(3);
        make.width.height.mas_equalTo(40);
    }];
}

- (SuperPlayerControlView *)controlView
{
    if (_controlView == nil) {
        self.controlView = [[SPDefaultControlView alloc] initWithFrame:CGRectZero];
    }
    return _controlView;
}

- (void)setDragging:(BOOL)dragging
{
    _isDragging = dragging;
    if (dragging) {
        [[NSNotificationCenter defaultCenter]
         removeObserver:self name:@"AVSystemController_SystemVolumeDidChangeNotification"
         object:nil];
    } else {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter]
             addObserver:self
             selector:@selector(volumeChanged:)
             name:@"AVSystemController_SystemVolumeDidChangeNotification"
             object:nil];
        });
    }
}

#pragma mark - Getter

- (CGFloat)playDuration {
    
    return self.aliPlayer.duration/1000;
}

- (CGFloat)playCurrentTime {
    return _playCurrentTime;
}

- (AliPlayer *)aliPlayer{
    if (!_aliPlayer) {
        _aliPlayer = [[AliPlayer alloc] init];
        _aliPlayer.delegate = self;
        _aliPlayer.autoPlay = YES;
        _aliPlayer.playerView = self.playerView;
    }
    return _aliPlayer;
}

+ (UISlider *)volumeViewSlider {
    return _volumeSlider;
}

#pragma mark - AVPDelegate

-(void)onPlayerEvent:(AliPlayer*)player eventType:(AVPEventType)eventType {
    
    switch (eventType) {
        case AVPEventPrepareDone:
        {
            // 防止暂停导致加载进度不消失
            if (self.isPauseByUser)
                [self.spinner stopAnimating];
            
            //清晰度，非阿里云视频就没有可以选择的清晰度
            AVPMediaInfo * info = [self.aliPlayer getMediaInfo];
            if (info && info.tracks.count > 0) {
                NSArray *titles = [TXBitrateItemHelper sortWithBitrate:info.tracks];
                if (titles.count > 0) {
                    _playerModel.playDefinitions = titles;
                    self.netWatcher.playerModel = _playerModel;
                    
                    AVPTrackInfo * track = [player getCurrentTrack:AVPTRACK_TYPE_SAAS_VOD];
                    _playerModel.playingDefinition = [TXBitrateItemHelper qualityFromTrackDefinition:track.trackDefinition];
                    [self.controlView playerBegin:_playerModel isLive:NO isTimeShifting:self.isShiftPlayback isAutoPlay:self.autoPlay];
                }
            }
            
            //打点信息
            NSMutableArray *array = @[].mutableCopy;
            for (NSString *point in self.playerModel.videoPointList) {
                SuperPlayerVideoPoint *p = [SuperPlayerVideoPoint new];
                p.time = [point integerValue]*1000;
                if (self.aliPlayer.duration > 0)
                    p.where = p.time/(float)self.aliPlayer.duration;
                [array addObject:p];
            }
            self.controlView.pointArray = array;
        }
            break;
        case AVPEventFirstRenderedStart:
        {
            if (!self.timer) {
                //sdk内部无计时器，需要获取currenttime；注意 NSRunLoopCommonModes
                NSTimer * tempTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerRun) userInfo:nil repeats:YES];
                [[NSRunLoop currentRunLoop] addTimer:tempTimer forMode:NSRunLoopCommonModes];
                self.timer = tempTimer;
            }
            
            //开启常亮状态
            [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
            
            self.isLoaded = YES;
            self.state = StatePlaying;  // 隐藏封面
            
            // 第一帧出来之后再暂停
            if (!self.autoPlay) {
                self.autoPlay = YES;    // 下次用户设置自动播放失效
                [self pause];
            }
            
            //直接跳转到需要播放的时间点
            if (self.startTime>0 && self.startTime*1000<player.duration) {
                [self.aliPlayer seekToTime:self.startTime*1000 seekMode:self.seekMode];
            }
            self.startTime = 0;
        }
            break;
        case AVPEventAutoPlayStart:
        {
            if ([self.delegate respondsToSelector:@selector(superPlayerDidStart:)]) {
                [self.delegate superPlayerDidStart:self];
            }
        }
            break;
        case AVPEventCompletion:{
            //播放完成回调
            [self.controlView setProgressTime:[self playDuration] totalTime:[self playDuration] progressValue:1.f playableValue:1.f];
            [self moviePlayDidEnd];
            
            //取消常亮状态
            [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
            //显示封面
            if (self.coverImageView) {
                self.coverImageView.hidden = NO;
                NSLog(@"播放器:播放停止封面显示");
            }
        }
            break;
        case AVPEventSeekEnd :{
            //
        }
            break;
        case AVPEventLoadingStart: {
            //展示loading动画
            self.state = StateBuffering;
        }
            break;
        case AVPEventLoadingEnd: {
            //关闭loading动画
            self.state = StatePlaying;
        }
            break;
        default:
            break;
    }
}

- (void)timerRun{
    
    //
}

/**
 * 功能：播放器播放时发生错误时，回调信息
 * 参数：errorModel 播放器报错时提供的错误信息对象
 */
- (void)onError:(AliPlayer*)player errorModel:(AVPErrorModel *)errorModel {
    NSLog(@"⚠️%@⚠️",errorModel.message);
    
    [self showMiddleBtnMsg:kStrLoadFaildRetry withAction:ActionRetry];
    [self.spinner stopAnimating];
    if ([self.delegate respondsToSelector:@selector(superPlayerError:errCode:errMessage:)]) {
        [self.delegate superPlayerError:self errCode:-1000 errMessage:@"网络请求失败"];
    }
    self.state = StateFailed;
}

/// 获取得到当前播放进度
/// @param player 播放器
/// @param position 位置--毫秒
- (void)onCurrentPositionUpdate:(AliPlayer*)player position:(int64_t)position {
    
    NSTimeInterval currentTime = position/1000;
    NSTimeInterval durationTime = self.aliPlayer.duration/1000;
    NSTimeInterval bufferedTime = self.aliPlayer.bufferedPosition/1000;
    
    if ((int)self.playCurrentTime != (int)currentTime) {
        
        self.playCurrentTime  = currentTime;
        CGFloat value         = currentTime / durationTime;
        float changeLoadTime = (durationTime == 0) ? 0 : (bufferedTime / durationTime);
        
        //更新进度条
        [self.controlView setProgressTime:self.playCurrentTime totalTime:durationTime progressValue:value playableValue:changeLoadTime];
        
        if (self.currentPlayStatus == AVPStatusStarted)
        {
            //回调
            if ([self.delegate respondsToSelector:@selector(superPlayerPlaying:withTime:)]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.delegate superPlayerPlaying:self withTime:self.playCurrentTime];
                });
            }
        }
    }
}

/**
@brief 视频缓存位置回调
@param player 播放器player指针
@param position 视频当前缓存位置
*/
- (void)onBufferedPositionUpdate:(AliPlayer*)player position:(int64_t)position {
    
}

/**
 @brief 播放器状态改变回调
 @param player 播放器player指针
 @param oldStatus 老的播放器状态 参考AVPStatus
 @param newStatus 新的播放器状态 参考AVPStatus
 @see AVPStatus
 */
- (void)onPlayerStatusChanged:(AliPlayer*)player oldStatus:(AVPStatus)oldStatus newStatus:(AVPStatus)newStatus {
    
    self.currentPlayStatus = newStatus;
}

/**
 @brief track切换完成回调
 @param player 播放器player指针
 @param info 切换后的信息 参考AVPTrackInfo
 @see AVPTrackInfo
 */
- (void)onTrackChanged:(AliPlayer*)player info:(AVPTrackInfo*)info {
    
    [self.controlView fadeOut:0];
    [self showTostWithMessage:[@"已为您切换至" stringByAppendingString:self.playerModel.playingDefinition]];
}

#pragma mark - SuperPlayerControlViewDelegate

- (void)controlViewPlay:(SuperPlayerControlView *)controlView
{
    [self resume];
}

- (void)controlViewPause:(SuperPlayerControlView *)controlView
{
    [self pause];
}

- (void)controlViewDownload:(UIView *)controlView
{
    if ([self.delegate respondsToSelector:@selector(superPlayerDownloadAction:)]) {
        [self.delegate superPlayerDownloadAction:self];
    }
}

- (void)controlViewBack:(SuperPlayerControlView *)controlView {
    [self controlViewBackAction:controlView];
}

- (void)controlViewBackAction:(id)sender {
    if (self.isFullScreen) {
        self.isFullScreen = NO;
        return;
    }
    if ([self.delegate respondsToSelector:@selector(superPlayerBackAction:)]) {
        [self.delegate superPlayerBackAction:self];
    }
}

- (void)controlViewChangeScreen:(SuperPlayerControlView *)controlView withFullScreen:(BOOL)isFullScreen {
    
    //手动强制旋转
    if (!isFullScreen) {
        
        if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
            SEL selector = NSSelectorFromString(@"setOrientation:");
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
            [invocation setSelector:selector];
            [invocation setTarget:[UIDevice currentDevice]];
            int val = UIInterfaceOrientationPortrait;//这个方向即需要旋转到的那个方向,自行设置
            [invocation setArgument:&val atIndex:2];
            [invocation invoke];
        }
        [UIViewController attemptRotationToDeviceOrientation];
        
        [self interfaceOrientation:UIInterfaceOrientationPortrait];
        return;
    } else {
        if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
            SEL selector = NSSelectorFromString(@"setOrientation:");
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
            [invocation setSelector:selector];
            [invocation setTarget:[UIDevice currentDevice]];
            int val = UIInterfaceOrientationLandscapeLeft;//这个方向即需要旋转到的那个方向,自行设置
            [invocation setArgument:&val atIndex:2];
            [invocation invoke];
        }
        [UIViewController attemptRotationToDeviceOrientation];
        UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
        
        if (orientation == UIDeviceOrientationLandscapeRight) {
            [self interfaceOrientation:UIInterfaceOrientationLandscapeLeft];
        } else {
            [self interfaceOrientation:UIInterfaceOrientationLandscapeRight];
        }
    }
}

- (void)controlViewDidChangeScreen:(UIView *)controlView withInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    self.backBtnPortrait.hidden = (orientation!=UIInterfaceOrientationPortrait);
    
    if ([self.delegate respondsToSelector:@selector(superPlayerFullScreenChanged:)]) {
        [self.delegate superPlayerFullScreenChanged:self];
    }
}

- (void)controlViewLockScreen:(SuperPlayerControlView *)controlView withLock:(BOOL)isLock {
    self.isLockScreen = isLock;
}

- (void)controlViewSwitch:(SuperPlayerControlView *)controlView withDefinition:(NSString *)definition {
    if ([self.playerModel.playingDefinition isEqualToString:definition])
        return;
    
    self.playerModel.playingDefinition = definition;
    
    //暂停状态切换清晰度
    if(self.currentPlayStatus == AVPStatusPaused){
        [self resume];;
    }
    //切换清晰度
    [self.aliPlayer selectTrack:self.playerModel.playingDefinitionIndex];
}

- (void)controlViewConfigUpdate:(SuperPlayerView *)controlView withReload:(BOOL)reload {

    CGFloat rate = self.playerConfig.playRate;
    
    NSTimeInterval interval = 1;
    if (rate == 1.25) {
        interval = 0.8;
    }
    if (rate == 1.5) {
        interval = 0.6;
    }
    if (rate == 2.0) {
        interval = 0.5;
    }
    //重新设定计时器频率  这样倍速播放的时候进度条就可以正常更新啦！
    [self.timer invalidate];
    self.timer = nil;
    NSTimer * tempTimer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(timerRun) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:tempTimer forMode:NSRunLoopCommonModes];
    self.timer = tempTimer;
    
    //修改配置--倍速播放
    [self.aliPlayer setRate:rate];
    
    [self.controlView fadeOut:0];
    
    [self showTostWithMessage:[NSString stringWithFormat:@"已切换为%g倍速度播放",rate]];
}

- (void)controlViewReload:(UIView *)controlView {

    //重新播放
    [self.aliPlayer prepare];
    [self.aliPlayer start];
}

- (void)controlViewSnapshot:(SuperPlayerControlView *)controlView {
    
    //截屏事件
    //[self.aliPlayer snapShot];
}

- (CGFloat)sliderPosToTime:(CGFloat)pos
{
    // 视频总时间长度
    CGFloat totalTime = [self playDuration];
    //计算出拖动的当前秒数
    CGFloat dragedSeconds = floorf(totalTime * pos);
    
    return dragedSeconds;
}

- (void)controlViewSeek:(SuperPlayerControlView *)controlView where:(CGFloat)pos {
    
    if (self.state == StateStopped)
        return;
    
    CGFloat dragedSeconds = [self sliderPosToTime:pos];
    [self seekToTime:dragedSeconds];
    [self fastViewUnavaliable];
}

- (void)controlViewPreview:(SuperPlayerControlView *)controlView where:(CGFloat)pos {
    
    if (self.state == StateStopped)
        return;
    
    CGFloat dragedSeconds = [self sliderPosToTime:pos];
    if ([self playDuration] > 0) { // 当总时长 > 0时候才能拖动slider
        [self fastViewProgressAvaliable:dragedSeconds];
    }
}

- (void)controlView:(UIView *)controlView withStatusBarHidden:(BOOL)hidden {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.isStatusBarHidden = hidden;
        [self.fatherView.mm_viewController setNeedsStatusBarAppearanceUpdate];
    });
}

#pragma clang diagnostic pop
#pragma mark - 点播回调

// 日志回调
-(void)onLog:(NSString*)log LogLevel:(int)level WhichModule:(NSString*)module
{
    NSLog(@"%@:%@", module, log);
}

#pragma mark - Button

- (UIButton *)backBtnPortrait {
    if (!_backBtnPortrait) {
        _backBtnPortrait = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtnPortrait setImage:SuperPlayerImage(@"back_full") forState:UIControlStateNormal];
        [_backBtnPortrait addTarget:self action:@selector(controlViewBackAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtnPortrait;
}

- (UIButton *)middleBlackBtn
{
    if (_middleBlackBtn == nil) {
        _middleBlackBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_middleBlackBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _middleBlackBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        _middleBlackBtn.backgroundColor = RGBA(0, 0, 0, 0.7);
        [_middleBlackBtn addTarget:self action:@selector(middleBlackBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_middleBlackBtn];
        [_middleBlackBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.height.mas_equalTo(33);
        }];
    }
    return _middleBlackBtn;
}

- (void)showMiddleBtnMsg:(NSString *)msg withAction:(ButtonAction)action {
    [self.middleBlackBtn setTitle:msg forState:UIControlStateNormal];
    self.middleBlackBtn.titleLabel.text = msg;
    self.middleBlackBtnAction = action;
    CGFloat width = self.middleBlackBtn.titleLabel.attributedText.size.width;
    
    [self.middleBlackBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(width+12));
    }];
    [self.middleBlackBtn fadeShow];
}

- (void)middleBlackBtnClick:(UIButton *)btn
{
    switch (self.middleBlackBtnAction) {
        case ActionNone:
            break;
        case ActionContinueReplay: {
            [self configTXPlayer];
        }
            break;
        case ActionRetry:
            [self reloadModel];
            break;
        case ActionSwitch:
            [self controlViewSwitch:self.controlView withDefinition:self.netWatcher.adviseDefinition];
            [self.controlView playerBegin:self.playerModel isLive:NO isTimeShifting:self.isShiftPlayback isAutoPlay:YES];
            break;
        case ActionIgnore:
            return;
        default:
            break;
    }
    [btn fadeOut:0.1];
}

/**
 重播按钮
 */
- (UIButton *)repeatBtn {
    if (!_repeatBtn) {
        _repeatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_repeatBtn setImage:SuperPlayerImage(@"repeat_video") forState:UIControlStateNormal];
        [_repeatBtn addTarget:self action:@selector(repeatBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_repeatBtn];
        [_repeatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
        }];
    }
    return _repeatBtn;
}

/**
 开始学习按钮
 */
- (UIButton *)startPlayBtn {
    if (!_startPlayBtn) {
        _startPlayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_startPlayBtn setTitle:@"开始学习" forState:UIControlStateNormal];
        [_startPlayBtn setImage:SuperPlayerImage(@"play") forState:UIControlStateNormal];
        [_startPlayBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _startPlayBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_startPlayBtn addTarget:self action:@selector(startPlayBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _startPlayBtn.layer.cornerRadius = 20;
        _startPlayBtn.layer.borderWidth = 1;
        _startPlayBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        [self addSubview:_startPlayBtn];
        [_startPlayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(140, 40));
        }];
    }
    return _startPlayBtn;
}

- (void)repeatBtnClick:(UIButton *)sender {
    
    sender.hidden = YES;
    [self configTXPlayer];
}

- (void)startPlayBtnClick:(UIButton *)sender {
    
    sender.hidden = YES;
    if ([self.delegate respondsToSelector:@selector(superPlayerStartPlayAction:)]) {
        [self.delegate superPlayerStartPlayAction:self];
    }
}

- (MMMaterialDesignSpinner *)spinner {
    if (!_spinner) {
        _spinner = [[MMMaterialDesignSpinner alloc] init];
        _spinner.lineWidth = 1;
        _spinner.duration  = 1;
        _spinner.hidden    = YES;
        _spinner.hidesWhenStopped = YES;
        _spinner.tintColor = [[UIColor whiteColor] colorWithAlphaComponent:0.9];
        [self addSubview:_spinner];
        [_spinner mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.width.with.height.mas_equalTo(45);
        }];
    }
    return _spinner;
}

- (UIImageView *)coverImageView {
    if (!_coverImageView) {
        _coverImageView = [[UIImageView alloc] init];
        _coverImageView.userInteractionEnabled = YES;
        _coverImageView.contentMode = UIViewContentModeScaleAspectFit;
        _coverImageView.alpha = 1;
        [self insertSubview:_coverImageView belowSubview:self.controlView];
        [_coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
    }
    return _coverImageView;
}

@end
