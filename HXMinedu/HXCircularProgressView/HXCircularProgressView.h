//
//  HXCircularProgressView.h
//  CloudClass
//
//  Created by Mac on 2018/4/11.
//  Copyright © 2018年 TheLittleBoy. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 //使用简例
 HXCircularProgressView * myProgressView = [[HXCircularProgressView alloc] initWithFrame:CGRectMake(50, 50, 150, 150)
                                    backColor:[UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1.00]
                                    progressColor:[NSArray arrayWithObjects:(id)[UIColor colorWithRed:1.00 green:0.73 blue:0.03 alpha:1.00].CGColor,(id)[UIColor colorWithRed:0.67 green:0.02 blue:0.90 alpha:1.00].CGColor,(id)[UIColor colorWithRed:0.32 green:0.17 blue:0.96 alpha:1.00].CGColor, nil]
                                    lineWidth:14
                                    labelFontSize:40];
 
 [self.view addSubview:myProgressView];
 
 [myProgressView setProgress:1 animated:YES];
 */

//圆形渐变色进度条
@interface HXCircularProgressView : UIView

@property (nonatomic) float progress;  //0-1
@property (nonatomic) UIColor *backColor;  //背景圆圈的颜色
@property (nonatomic) NSArray *progressColor;  //前景渐变色的数组  默认是：红-黄-绿  CGColor
@property (assign, nonatomic) CGFloat lineWidth;  //线条宽度

- (id)initWithFrame:(CGRect)frame
          backColor:(UIColor *)backColor
      progressColor:(NSArray *)progressColor
          lineWidth:(CGFloat)lineWidth
      labelFontSize:(CGFloat)fontSize;

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated;

@end
