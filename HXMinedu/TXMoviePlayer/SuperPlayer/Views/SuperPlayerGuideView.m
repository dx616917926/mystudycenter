//
//  SuperPlayerGuideView.m
//  TXLiteAVDemo
//
//  Created by annidyfeng on 2018/8/16.
//  Copyright © 2018年 Tencent. All rights reserved.
//

#import "SuperPlayerGuideView.h"
#import "SuperPlayer.h"
#import "Masonry.h"

@interface SuperPlayerGuideView()

@property UIImageView *leftImg;
@property UIImageView *middleImg;
@property UIImageView *rightImg;

@property UILabel *leftLabel;
@property UILabel *middleLabel;
@property UILabel *rightLabel;

@end

@implementation SuperPlayerGuideView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGBA(0, 0, 0, 0.5);
        [self showGuide1];
    }
    return self;
}

- (void)showGuide1 {
    UIImageView *leftImg = [[UIImageView alloc] initWithImage:SuperPlayerImage(@"left_g")];
    [self addSubview:leftImg];
    UILabel *leftLabel = [UILabel new];
    [self addSubview:leftLabel];
    leftLabel.font = [UIFont systemFontOfSize:12];
    leftLabel.textColor = [UIColor whiteColor];
    leftLabel.text = @"上下滑动调节屏幕明暗";
    self.leftImg = leftImg;
    self.leftLabel = leftLabel;
    
    UIImageView *rightImg = [[UIImageView alloc] initWithImage:SuperPlayerImage(@"right_g")];
    [self addSubview:rightImg];
    UILabel *rightLabel = [UILabel new];
    [self addSubview:rightLabel];
    rightLabel.font = [UIFont systemFontOfSize:12];
    rightLabel.textColor = [UIColor whiteColor];
    rightLabel.text = @"上下滑动调节音量大小";
    self.rightImg = rightImg;
    self.rightLabel = rightLabel;
    
    UIImageView *middleImg = [[UIImageView alloc] initWithImage:SuperPlayerImage(@"middle_g")];
    [self addSubview:middleImg];
    UILabel *middleLabel = [UILabel new];
    [self addSubview:middleLabel];
    middleLabel.textColor = [UIColor whiteColor];
    middleLabel.font = [UIFont systemFontOfSize:12];
    middleLabel.text = @"左右滑动快进/倒退";
    self.middleImg = middleImg;
    self.middleLabel = middleLabel;

    int leftwidth = 100;
    
    [leftImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(leftwidth);
        make.centerY.mas_offset(0);
    }];
    
    [middleImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(leftImg);
    }];
    [rightImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).mas_offset(-leftwidth);
        make.centerY.equalTo(leftImg);
    }];
    [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(leftImg);
        make.top.equalTo(leftImg.mas_bottom).mas_offset(10);
    }];
    [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(rightImg);
        make.centerY.equalTo(leftLabel);
    }];
    [middleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(middleImg);
        make.centerY.equalTo(leftLabel);
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self dismiss];
}

- (void)dismiss {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:TXMoviePlayerShowGuideView];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self removeFromSuperview];
}

@end
