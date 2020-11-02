//
//  TXExamPopView.h
//  TXMoviePlayer
//
//  Created by Mac on 2019/5/27.
//  Copyright © 2019 华夏大地教育网. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXQuestion.h"

@protocol TXExamPopViewDelegate <NSObject>

@optional

/**
 继续播放
 */
- (void)continuePlay;

/**
 作答结果
 */
- (void)examQuestion:(TXQuestion *)question withResult:(BOOL)result;

@end

@interface TXExamPopView : UIView

@property(nonatomic, weak) id<TXExamPopViewDelegate>delegate;
@property(nonatomic, strong) TXQuestion *questionItem;

-(void)showInView:(UIView *)view;

@end

