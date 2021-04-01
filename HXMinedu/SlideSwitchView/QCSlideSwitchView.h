//
//  QCSlideSwitchView.h
//  QCSliderTableView
//
//  Created by “ 邵鹏 on 14-4-16.
//  Copyright (c) 2014年 Scasy. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "QCScrollView.h"

//
//  更新记录
//  v1.0 第一个上线版本
//  v2.0 适配iOS 14
//  v3.0 增加title颜色渐变动效  2020年12月28日
//  v4.0 完善参数  2020年12月29日

@protocol QCSlideSwitchViewDelegate;

@interface QCSlideSwitchView : UIView<UIScrollViewDelegate>
{
    BOOL _isLeftScroll;                             //是否左滑动
    BOOL _isRootScroll;                             //是否主视图滑动
    BOOL _isBuildUI;                                //是否建立了UI
}

@property(nonatomic, strong) IBOutlet QCScrollView *rootScrollView;  //主视图
@property(nonatomic, strong) IBOutlet UIScrollView *topScrollView;   //顶部页签视图
@property(nonatomic, assign) CGFloat userContentOffsetX;
@property(nonatomic, assign) NSInteger userSelectedChannelID;        //点击按钮选择名字ID
@property(nonatomic, assign) NSInteger scrollViewSelectedChannelID;
@property(nonatomic, weak) IBOutlet id<QCSlideSwitchViewDelegate> slideSwitchViewDelegate;
@property(nonatomic, strong) UIColor *tabItemNormalColor;            //正常时tab文字颜色
@property(nonatomic, strong) UIColor *tabItemSelectedColor;          //选中时tab文字颜色
@property(nonatomic, strong) UIImage *tabItemNormalBackgroundImage;  //正常时tab的背景
@property(nonatomic, strong) UIImage *tabItemSelectedBackgroundImage;//选中时tab的背景
@property(nonatomic, strong) UIImageView *shadowImageView;
@property(nonatomic, strong) UIImage *shadowImage;                  //滑块背景图
@property(nonatomic, strong) NSMutableArray *viewArray;             //主视图的子视图数组
@property(nonatomic, strong) IBOutlet UIButton *rigthSideButton;    //右侧按钮
@property(nonatomic, assign) BOOL bisection;                         //根据view大小平均分布button。默认yes。要不然就会从左往右顺序排列
@property(nonatomic, assign) CGFloat widthOfButton;                  //button的宽度 默认四个字宽度78像素
@property(nonatomic, assign) CGFloat widthOfButtonMargin;            //button的默认间距  默认56像素
@property(nonatomic, assign) CGFloat fontSizeOfTabButton;            //字体大小 默认17号字

/*!
 * @method 创建子视图UI
 */
- (void)buildUI;

@end

@protocol QCSlideSwitchViewDelegate <NSObject>

@required

/*!
 * @method 顶部tab个数
 */
- (NSUInteger)numberOfTab:(QCSlideSwitchView *)view;

/*!
 * @method 每个tab所属的viewController
 */
- (UIViewController *)slideSwitchView:(QCSlideSwitchView *)view viewOfTab:(NSUInteger)number;

@optional

/*!
 * @method 滑动左边界时传递手势
 */
- (void)slideSwitchView:(QCSlideSwitchView *)view panLeftEdge:(UIPanGestureRecognizer*) panParam;

/*!
 * @method 滑动右边界时传递手势
 */
- (void)slideSwitchView:(QCSlideSwitchView *)view panRightEdge:(UIPanGestureRecognizer*) panParam;

/*!
 * @method 点击tab
 */
- (void)slideSwitchView:(QCSlideSwitchView *)view didselectTab:(NSUInteger)number;

@end

