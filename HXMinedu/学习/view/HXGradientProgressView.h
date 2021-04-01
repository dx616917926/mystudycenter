//
//  HXGradientProgressView.h
//  HXMinedu
//
//  Created by mac on 2021/3/31.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HXGradientProgressView : UIView

@property(nonatomic,strong) UILabel *progressLabel;
@property(nonatomic,strong) UILabel *unFinishLabel;

//进度条背景颜色  默认是 （#dcdcdc）
@property (nonatomic, strong) UIColor *bgProgressColor;

//进度条渐变颜色数组，目前最多支持3种颜色
//默认是 @[(id)COLOR_WITH_ALPHA(0x4BA4FE, 1).CGColor , (id)COLOR_WITH_ALPHA(0x45EFCF, 1).CGColor]

@property (nonatomic, strong) NSArray<UIColor *> *colorArr;

//进度 默认是0.5
@property (nonatomic, assign) CGFloat progress;

//不管progress为多少，进度条上始终展示全部颜色 默认YES
@property (nonatomic, assign) BOOL alwaysShowAllColor;



@end

NS_ASSUME_NONNULL_END
