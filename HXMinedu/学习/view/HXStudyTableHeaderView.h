//
//  HXStudyTableHeaderView.h
//  HXMinedu
//
//  Created by mac on 2021/4/6.
//

#import <UIKit/UIKit.h>
#import "SDCycleScrollView.h"

@protocol HXStudyTableHeaderViewDelegate <NSObject>
//flag:  0、学习报告    1、公告     2、课程库     3、签到   4、切换专业
-(void)handleEventWithFlag:(NSInteger)flag;

@end
NS_ASSUME_NONNULL_BEGIN

@interface HXStudyTableHeaderView : UIView
///banner广告条
@property (nonatomic,strong) SDCycleScrollView *bannerView;
@property (nonatomic,strong) UIButton *versionBtn;

@property(nonatomic,weak) id<HXStudyTableHeaderViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
