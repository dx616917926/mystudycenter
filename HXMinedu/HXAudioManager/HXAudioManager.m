//
//  HXAudioManager.m
//  eplatform-ebook
//
//  Created by  MAC on 15/7/1.
//  Copyright (c) 2015年 华夏大地教育. All rights reserved.
//

#import "HXAudioManager.h"
#import "DOUAudioStreamer.h"
#import "Track.h"

static void *kStatusKVOKey = &kStatusKVOKey;
static void *kDurationKVOKey = &kDurationKVOKey;
static void *kBufferingRatioKVOKey = &kBufferingRatioKVOKey;

@interface HXAudioManager ()
{
    DOUAudioStreamer    *_streamer;
    UIView              * managerView;
    UIButton            *_playPauseBtn; //播放和暂停按钮
    UIActivityIndicatorView *_playWaitActView; //滑块上的转圈圈
    UILabel             *_currentTimeLabel; //播放时间
    UILabel             *_durationLabel;  //总时间
    NSTimer             *_timer;
    NSInteger           waitingTime; //播放完成10秒后自动消失
}
@end

@implementation HXAudioManager


+ (instancetype)sharedManager
{
    static HXAudioManager *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[HXAudioManager alloc] init];
    });
    
    return _sharedClient;
}

-(instancetype)init
{
    if (self=[super init]) {
    }
    return self;
}


-(void)showWithAnimated:(BOOL)animated
{
    if (managerView == nil) {
        [self createManagerView];
    }
    [self _resetStreamer];
    
    if (_timer == nil) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(_timerAction:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop]addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    
    if (animated) {
        [UIView animateWithDuration:0.3 animations:^{
            
            managerView.alpha = 1;
        }];
    }else
    {
        managerView.alpha = 1;
    }
}

-(void)hiddenWithAnimated:(BOOL)animated
{
    [_timer invalidate];
    waitingTime = 0;
    _timer = nil;
    [_streamer stop];
    [self _cancelStreamer];
    
    if (animated) {
        [UIView animateWithDuration:0.5 animations:^{
            
            managerView.alpha = 0;
        }];
    }else
    {
        managerView.alpha = 0;
    }
}

- (void)dealloc
{
    [_timer invalidate];
    [_streamer stop];
    [self _cancelStreamer];
}

-(void)createManagerView
{
    if (!managerView) {
        managerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 130, 56)];
        managerView.backgroundColor = [[UIColor alloc] initWithWhite:0.2 alpha:0.8];
        managerView.layer.cornerRadius = 10;
        managerView.layer.masksToBounds = YES;
        managerView.translatesAutoresizingMaskIntoConstraints=NO;
        managerView.alpha = 0;
        
        NSEnumerator *frontToBackWindows = [[[UIApplication sharedApplication]windows]reverseObjectEnumerator];
        
        for (UIWindow *window in frontToBackWindows){
            if (window.windowLevel == UIWindowLevelNormal) {
                
                [window addSubview:managerView];
                
                NSArray *constraints1=[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[managerView(==195)]"
                                        options:0
                                        metrics:nil
                                          views:NSDictionaryOfVariableBindings(managerView)];
                
                NSArray *constraints2=[NSLayoutConstraint constraintsWithVisualFormat:@"V:[managerView(==56)]-44-|"
                                        options:0
                                        metrics:nil
                                          views:NSDictionaryOfVariableBindings(managerView)];
                
                [window addConstraints:constraints1];
                [window addConstraints:constraints2];
                
                break;
            }
        }
        
        [self createView];
    }
}

-(void)createView
{
    // play hud
    _playPauseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_playPauseBtn setImage:[UIImage imageNamed:@"but_audio_pause"] forState:UIControlStateNormal];
    _playPauseBtn.frame = CGRectMake(10, 10.5, 35, 35);
    [_playPauseBtn addTarget:self action:@selector(_actionPlayPause:) forControlEvents:UIControlEventTouchUpInside];
    
    [managerView addSubview:_playPauseBtn];
    
    //转圈圈
    
    _playWaitActView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [_playWaitActView setHidesWhenStopped:YES];
    //[_playWaitActView setBackgroundColor:[UIColor colorWithWhite:0.886 alpha:1.000]];
    //[_playWaitActView setColor:[UIColor colorWithRed:0.275 green:0.796 blue:0.396 alpha:1.000]];
    [_playWaitActView startAnimating];
    _playWaitActView.opaque = YES;
    _playWaitActView.layer.cornerRadius = 10;
    _playWaitActView.layer.masksToBounds = YES;
    [_playWaitActView setCenter:CGPointMake(170, 56/2)];
    
    [managerView addSubview:_playWaitActView];
    
    //
    _currentTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 13, 50, 30)];
    _currentTimeLabel.backgroundColor = [UIColor clearColor];
    _currentTimeLabel.opaque = NO;
    _currentTimeLabel.adjustsFontSizeToFitWidth = NO;
    _currentTimeLabel.textAlignment = NSTextAlignmentRight;
    _currentTimeLabel.textColor = [UIColor whiteColor];
    _currentTimeLabel.text = @"00:00";
    _currentTimeLabel.font = [UIFont systemFontOfSize:17];
    [managerView addSubview:_currentTimeLabel];
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(101, 13, 7, 30)];
    label.backgroundColor = [UIColor clearColor];
    label.opaque = NO;
    label.adjustsFontSizeToFitWidth = NO;
    label.textAlignment = NSTextAlignmentRight;
    label.textColor = [UIColor whiteColor];
    label.text = @"/";
    label.font = [UIFont systemFontOfSize:17];
    [managerView addSubview:label];
    
    //
    _durationLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 13, 50, 30)];
    _durationLabel.backgroundColor = [UIColor clearColor];
    _durationLabel.opaque = NO;
    _durationLabel.adjustsFontSizeToFitWidth = NO;
    _durationLabel.textAlignment = NSTextAlignmentLeft;
    _durationLabel.textColor = [UIColor whiteColor];
    _durationLabel.text = @"00:00";
    _durationLabel.font = [UIFont systemFontOfSize:17];
    [managerView addSubview:_durationLabel];
}

- (void)_timerAction:(id)timer
{
    //if (_disableUpdateHUD)
    //    return;
    
    if ([_streamer duration] == 0.0) {
        //[_progressSlider setValue:0.0f animated:NO];
    }
    
    if (_streamer.status != DOUAudioStreamerPlaying &&
        _streamer.status != DOUAudioStreamerBuffering) {
        
        waitingTime ++;
        
        if (waitingTime>5) {
            [self hiddenWithAnimated:YES];
        }
        
        if (_streamer.status == DOUAudioStreamerFinished) {
            _currentTimeLabel.text = @"00:00";
        }
        
        return;
    }else
    {
        waitingTime = 0;
        const CGFloat duration = _streamer.duration;
        const CGFloat currentTime = _streamer.currentTime;
        
        _durationLabel.text = [self timeToHumanString:duration];
        
        _currentTimeLabel.text = [self timeToHumanString:MIN(currentTime, duration)];
    }
    
}

- (void)_cancelStreamer
{
    if (_streamer != nil) {
        [_streamer pause];
        [_streamer removeObserver:self forKeyPath:@"status"];
        [_streamer removeObserver:self forKeyPath:@"duration"];
        [_streamer removeObserver:self forKeyPath:@"bufferingRatio"];
        _streamer = nil;
    }
}

- (void)_resetStreamer
{
    [self _cancelStreamer];
    
    if (0 == [_tracks count])
    {
        NSLog(@"(No tracks available)");
    }
    else
    {
        _durationLabel.text = @"00:00";
        
        _currentTimeLabel.text = @"00:00";
        
        Track *track = [_tracks objectAtIndex:0];
        
        _streamer = [DOUAudioStreamer streamerWithAudioFile:track];
        [_streamer addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:kStatusKVOKey];
        [_streamer addObserver:self forKeyPath:@"duration" options:NSKeyValueObservingOptionNew context:kDurationKVOKey];
        [_streamer addObserver:self forKeyPath:@"bufferingRatio" options:NSKeyValueObservingOptionNew context:kBufferingRatioKVOKey];
        
        [_streamer play];
        
        [self _updateBufferingStatus];
        [self _setupHintForStreamer];
    }
}

- (void)_setupHintForStreamer
{
    [DOUAudioStreamer setHintWithAudioFile:[_tracks objectAtIndex:0]];
}

- (void)_updateBufferingStatus
{
    //[_miscLabel setText:];
    
    NSLog(@"%@",[NSString stringWithFormat:@"Received %.2f/%.2f MB (%.2f %%), Speed %.2f MB/s", (double)[_streamer receivedLength] / 1024 / 1024, (double)[_streamer expectedLength] / 1024 / 1024, [_streamer bufferingRatio] * 100.0, (double)[_streamer downloadSpeed] / 1024 / 1024]);
    
    if ([_streamer bufferingRatio] >= 1.0) {
        //NSLog(@"sha256: %@", [_streamer sha256]);
        
        if ([_streamer receivedLength] == [_streamer expectedLength]) {
            //NSLog(@"%@",_streamer.cachedPath);
            /*
            NSFileManager*fileManager =[NSFileManager defaultManager];
            NSError*error;
            
            NSString * filename = [Utilities MD5StringWithKey:_streamer.url.absoluteString];
            
            NSString * filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:filename];
            
            if([fileManager fileExistsAtPath:filePath]== NO){
                [fileManager copyItemAtPath:_streamer.cachedPath toPath:filePath error:&error];
            }
            */
        }
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == kStatusKVOKey) {
        [self performSelector:@selector(_updateStatus)
                     onThread:[NSThread mainThread]
                   withObject:nil
                waitUntilDone:NO];
    }
    else if (context == kDurationKVOKey) {
        [self performSelector:@selector(_timerAction:)
                     onThread:[NSThread mainThread]
                   withObject:nil
                waitUntilDone:NO];
    }
    else if (context == kBufferingRatioKVOKey) {
        [self performSelector:@selector(_updateBufferingStatus)
                     onThread:[NSThread mainThread]
                   withObject:nil
                waitUntilDone:NO];
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}


- (void)_updateStatus
{
    switch ([_streamer status]) {
        case DOUAudioStreamerPlaying:
            
            [_playWaitActView stopAnimating];
            NSLog(@"playing");
            [_playPauseBtn setImage:[UIImage imageNamed:@"but_audio_pause.png"] forState:UIControlStateNormal];
            break;
            
        case DOUAudioStreamerPaused:
            
            [_playWaitActView stopAnimating];
            NSLog(@"paused");
            [_playPauseBtn setImage:[UIImage imageNamed:@"but_audio_play.png"] forState:UIControlStateNormal];
            break;
            
        case DOUAudioStreamerIdle:

            [_playWaitActView stopAnimating];
            break;
            
        case DOUAudioStreamerFinished:
            
            [_playWaitActView stopAnimating];
            [_playPauseBtn setImage:[UIImage imageNamed:@"but_audio_play.png"] forState:UIControlStateNormal];
            
            break;
            
        case DOUAudioStreamerBuffering:

            [_playWaitActView startAnimating];
            NSLog(@"buffering");
            break;
            
        case DOUAudioStreamerError:
            //[_statusLabel setText:@"error"];
            [_playWaitActView stopAnimating];
            [[[UIApplication sharedApplication] keyWindow] showErrorWithMessage:@"播放失败！"];
            waitingTime = 2; //快点结束的好
            NSLog(@"error");
            break;
    }
}


- (void)_actionPlayPause:(id)sender
{
    if ([_streamer status] == DOUAudioStreamerPaused ||
        [_streamer status] == DOUAudioStreamerIdle) {
        [_streamer play];
    }
    else if([_streamer status] == DOUAudioStreamerFinished){
        [self _resetStreamer];
    }else if([_streamer status] == DOUAudioStreamerError){
        
        [[[UIApplication sharedApplication] keyWindow] showErrorWithMessage:@"播放失败！"];
    }else
    {
        [_streamer pause];
    }
}

- (void)_actionStop:(id)sender
{
    [_streamer stop];
}

- (void)_actionSliderVolume:(id)sender
{
    //[DOUAudioStreamer setVolume:[_volumeSlider value]];
}

- (NSString *)timeToHumanString:(NSInteger)seconds
{
    seconds = MAX(0, seconds);
    
    NSInteger s = seconds;
    NSInteger m = s / 60;
    //NSInteger h = m / 60;
    
    s = s % 60;
    m = m % 60;
    
    NSString *format = [NSString stringWithFormat:@"%02d:%02d",m,s];
    
    return format;
}



@end
