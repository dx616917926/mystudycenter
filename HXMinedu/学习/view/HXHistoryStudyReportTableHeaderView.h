//
//  HXHistoryStudyReportTableHeaderView.h
//  HXMinedu
//
//  Created by mac on 2021/7/29.
//

#import <UIKit/UIKit.h>
#import "HXStudyReportModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HXHistoryStudyReportTableHeaderView : UIView

@property(nonatomic,strong) UIButton *backBtn;
@property(nonatomic,strong) UIControl *titleControl;

@property(strong,nonatomic) HXStudyReportModel *studyReportModel;

@end

NS_ASSUME_NONNULL_END
