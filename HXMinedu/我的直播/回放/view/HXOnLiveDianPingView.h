//
//  HXOnLiveDianPingView.h
//  HXMinedu
//
//  Created by mac on 2022/8/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


typedef NS_ENUM(NSUInteger, OnLiveDianPingViewType) {
    OnLiveDianPingViewTypeShow = 1,//展示
    OnLiveDianPingViewTypeeSelect = 2,//选择
};

typedef void(^DianPingCallBack)(NSInteger fenGeStarScore,NSInteger contentStarScore,NSInteger tiYanStarScore,NSString *jianYiContent);

@interface HXOnLiveDianPingView : UIView
//默认 选择
@property (nonatomic, assign) OnLiveDianPingViewType type;

//默认5
@property (nonatomic, assign) CGFloat fenGeStarScore;
@property (nonatomic, assign) CGFloat contentStarScore;
@property (nonatomic, assign) CGFloat tiYanStarScore;


@property(nonatomic, copy) DianPingCallBack dianPingCallBack;

-(void)show;

@end

NS_ASSUME_NONNULL_END
