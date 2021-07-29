//
//  HXStudyReportTableHeaderView.h
//  HXMinedu
//
//  Created by mac on 2021/4/7.
//

#import <UIKit/UIKit.h>
#import "HXStudyReportModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HXStudyReportTableHeaderView : UIView
//查看历史学习报告
@property(nonatomic,strong) UIButton *checkHistoryBtn;

@property(strong,nonatomic) HXStudyReportModel *studyReportModel;

@end

NS_ASSUME_NONNULL_END
