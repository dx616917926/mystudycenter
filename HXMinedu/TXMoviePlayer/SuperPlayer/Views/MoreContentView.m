//
//  SuperPlayerMoreView.m
//  TXLiteAVDemo
//
//  Created by annidyfeng on 2018/7/4.
//  Copyright © 2018年 Tencent. All rights reserved.
//

#import "MoreContentView.h"
#import "UIView+MMLayout.h"
#import "SuperPlayer.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "SuperPlayerControlView.h"
#import "SuperPlayerView+Private.h"

@interface MoreContentView()
@property (nonatomic) UIView *soundCell;
@property (nonatomic) UIView *ligthCell;
@property (nonatomic) UIView *speedCell;
@property BOOL isVolume;
@property NSDate *volumeEndTime;
@end

@implementation MoreContentView {
    NSInteger  _contentHeight;
    NSInteger  _speedTag;
    
    UISwitch *_mirrorSwitch;
    UISwitch *_hwSwitch;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    self.mm_h = ScreenHeight;
    self.mm_w = MoreViewWidth;
    
    UIScrollView *scrollview = [[UIScrollView alloc] initWithFrame:self.bounds];
    scrollview.alwaysBounceVertical = YES;
    [self addSubview:scrollview];
    
    [scrollview addSubview:[self speedCell]];
    [scrollview addSubview:[self soundCell]];
    [scrollview addSubview:[self lightCell]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(volumeChanged:)         name:@"AVSystemController_SystemVolumeDidChangeNotification"
                                               object:nil];
    
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)volumeChanged:(NSNotification *)notify
{
    if (!self.isVolume) {
        if (self.volumeEndTime != nil && -[self.volumeEndTime timeIntervalSinceNow] < 2.f)
            return;
        float volume = [[[notify userInfo] objectForKey:@"AVSystemController_AudioVolumeNotificationParameter"] floatValue];
        self.soundSlider.value = volume;
    }
}

- (void)sizeToFit
{
    _contentHeight = 20;
    
    if (IS_IPAD) {
        _contentHeight = 40;
    }
    _speedCell.mm_top(_contentHeight);
    _contentHeight += _speedCell.mm_h;
    
    _soundCell.mm_top(_contentHeight);
    _contentHeight += _soundCell.mm_h;
    
    _ligthCell.mm_top(_contentHeight);
    _contentHeight += _ligthCell.mm_h;
    
}

- (UIView *)soundCell
{
    if (_soundCell == nil) {
        _soundCell = [[UIView alloc] initWithFrame:CGRectZero];
        _soundCell.mm_width(MoreViewWidth).mm_height(50).mm_left(0);
        
        // 声音
        UILabel *sound = [UILabel new];
        sound.text = @"声音";
        sound.textColor = [UIColor whiteColor];
        [sound sizeToFit];
        [_soundCell addSubview:sound];
        sound.mm_left(20).mm__centerY(_soundCell.mm_h/2);

        
        UIImageView *soundImage1 = [[UIImageView alloc] initWithImage:SuperPlayerImage(@"sound_min")];
        [_soundCell addSubview:soundImage1];
        soundImage1.mm_left(sound.mm_maxX+10).mm__centerY(_soundCell.mm_h/2);

        UIImageView *soundImage2 = [[UIImageView alloc] initWithImage:SuperPlayerImage(@"sound_max")];
        [_soundCell addSubview:soundImage2];
        soundImage2.mm_right(50).mm__centerY(_soundCell.mm_h/2);
        
        
        UISlider *soundSlider                       = [[UISlider alloc] init];
        [soundSlider setThumbImage:SuperPlayerImage(@"slider_thumb") forState:UIControlStateNormal];
        
        soundSlider.maximumValue          = 1;
        soundSlider.minimumTrackTintColor = TintColor;
        soundSlider.maximumTrackTintColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5];
        
        // slider开始滑动事件
        [soundSlider addTarget:self action:@selector(soundSliderTouchBegan:) forControlEvents:UIControlEventTouchDown];
        // slider滑动中事件
        [soundSlider addTarget:self action:@selector(soundSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        // slider结束滑动事件
        [soundSlider addTarget:self action:@selector(soundSliderTouchEnded:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchCancel | UIControlEventTouchUpOutside];
        [_soundCell addSubview:soundSlider];
        soundSlider.mm__centerY(_soundCell.mm_centerY).mm_left(soundImage1.mm_maxX).mm_width(soundImage2.mm_minX-soundImage1.mm_maxX);
        
        self.soundSlider = soundSlider;
    }
    return _soundCell;
}

- (UIView *)lightCell
{
    if (_ligthCell == nil) {
        _ligthCell = [[UIView alloc] initWithFrame:CGRectZero];
        _ligthCell.mm_width(MoreViewWidth).mm_height(50).mm_left(0);
        
        // 亮度
        UILabel *ligth = [UILabel new];
        ligth.text = @"亮度";
        ligth.textColor = [UIColor whiteColor];
        [ligth sizeToFit];
        [_ligthCell addSubview:ligth];
        ligth.mm_left(20).mm__centerY(_ligthCell.mm_h/2);
        
        UIImageView *ligthImage1 = [[UIImageView alloc] initWithImage:SuperPlayerImage(@"light_min")];
        [_ligthCell addSubview:ligthImage1];
        ligthImage1.mm_left(ligth.mm_maxX+10).mm__centerY(_ligthCell.mm_h/2);
        
        UIImageView *ligthImage2 = [[UIImageView alloc] initWithImage:SuperPlayerImage(@"light_max")];
        [_ligthCell addSubview:ligthImage2];
        ligthImage2.mm_right(50).mm__centerY(_ligthCell.mm_h/2);
        
        
        UISlider *lightSlider                       = [[UISlider alloc] init];
        
        [lightSlider setThumbImage:SuperPlayerImage(@"slider_thumb") forState:UIControlStateNormal];
        
        lightSlider.maximumValue          = 1;
        lightSlider.minimumTrackTintColor = TintColor;
        lightSlider.maximumTrackTintColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5];
        
        // slider开始滑动事件
        [lightSlider addTarget:self action:@selector(lightSliderTouchBegan:) forControlEvents:UIControlEventTouchDown];
        // slider滑动中事件
        [lightSlider addTarget:self action:@selector(lightSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        // slider结束滑动事件
        [lightSlider addTarget:self action:@selector(lightSliderTouchEnded:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchCancel | UIControlEventTouchUpOutside];
        
        [_ligthCell addSubview:lightSlider];
        lightSlider.mm__centerY(_ligthCell.mm_h/2).mm_left(ligthImage1.mm_maxX).mm_width(ligthImage2.mm_minX-ligthImage1.mm_maxX);
        
        self.lightSlider = lightSlider;
    }

    
    return _ligthCell;
}

- (UIView *)speedCell {
    if (!_speedCell) {
        _speedCell = [UIView new];
        _speedCell.mm_width(MoreViewWidth).mm_height(90).mm_left(0);
        
        //顶线
        UIView *line1 = [[UIView alloc] init];
        line1.backgroundColor = [UIColor grayColor];
        [_speedCell addSubview:line1];
        line1.mm_height(1).mm_width(_speedCell.mm_w/2-40).mm__centerY(10);
        
        UIView *line2 = [[UIView alloc] init];
        line2.backgroundColor = [UIColor grayColor];
        [_speedCell addSubview:line2];
        line2.mm_height(1).mm_left(_speedCell.mm_w/2+40).mm_width(_speedCell.mm_w/2-40).mm__centerY(10);
        
        // 倍速
        UILabel *speed = [UILabel new];
        speed.text = @"倍速播放";
        speed.textAlignment = NSTextAlignmentCenter;
        speed.textColor = [UIColor whiteColor];
        [speed sizeToFit];
        [_speedCell addSubview:speed];
        speed.mm__centerX(_speedCell.mm_centerX).mm__centerY(10);
        
        UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"1.0X",@"1.25X",@"1.5X",@"2.0X"]];
        segmentedControl.backgroundColor = [UIColor clearColor];
        segmentedControl.selectedSegmentIndex = 0;
        segmentedControl.tintColor = [UIColor clearColor];
        NSDictionary* selectedTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:14],
                                                 NSForegroundColorAttributeName: TintColor};
        
        [segmentedControl setTitleTextAttributes:selectedTextAttributes forState:UIControlStateSelected];//设置文字属性
        
        NSDictionary* unselectedTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:14],
                                                   NSForegroundColorAttributeName: [UIColor whiteColor]};
        
        [segmentedControl setTitleTextAttributes:unselectedTextAttributes forState:UIControlStateNormal];
        [segmentedControl addTarget:self action:@selector(changeSpeed:) forControlEvents:UIControlEventValueChanged];
        [_speedCell addSubview:segmentedControl];
        segmentedControl.mm_width(_speedCell.mm_w-60).mm__centerY(45).mm__centerX(_speedCell.mm_centerX);
        
        //底线
        UIView *line3 = [[UIView alloc] init];
        line3.backgroundColor = [UIColor grayColor];
        [_speedCell addSubview:line3];
        line3.mm_height(1).mm_width(_speedCell.mm_w).mm__centerY(_speedCell.mm_h-10);
    }
    return _speedCell;
}

- (void)soundSliderTouchBegan:(UISlider *)sender {
    self.isVolume = YES;
}

- (void)soundSliderValueChanged:(UISlider *)sender {
    if (self.isVolume)
        [SuperPlayerView volumeViewSlider].value = sender.value;
}

- (void)soundSliderTouchEnded:(UISlider *)sender {
    self.isVolume = NO;
    self.volumeEndTime = [NSDate date];
}

- (void)lightSliderTouchBegan:(UISlider *)sender {
    
}

- (void)lightSliderValueChanged:(UISlider *)sender {
    [UIScreen mainScreen].brightness = sender.value;
}

- (void)lightSliderTouchEnded:(UISlider *)sender {
    
}

- (void)changeSpeed:(UISegmentedControl *)sender {
    
    float speedValue = sender.selectedSegmentIndex *0.25+1;
    if (sender.selectedSegmentIndex==3) {
        speedValue = 2.0;
    }
    
    self.playerConfig.playRate = speedValue;
    [self.controlView.delegate controlViewConfigUpdate:self.controlView withReload:NO];
}

- (void)update
{
    self.soundSlider.value = [SuperPlayerView volumeViewSlider].value;
    self.lightSlider.value = [UIScreen mainScreen].brightness;
    
    [self sizeToFit];
}


@end
