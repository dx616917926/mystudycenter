//
//  HXStudyTableHeaderView.h
//  HXMinedu
//
//  Created by mac on 2021/4/6.
//

#import <UIKit/UIKit.h>

@protocol HXStudyTableHeaderViewDelegate <NSObject>
//flag:  0、学习报告    1、公告     2、直播
-(void)handleEventWithFlag:(NSInteger)flag;

@end
NS_ASSUME_NONNULL_BEGIN

@interface HXStudyTableHeaderView : UIView

@property(nonatomic,weak) id<HXStudyTableHeaderViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
