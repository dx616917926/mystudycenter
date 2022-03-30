//
//  HXHistoryLearnReportDetailHeadView.h
//  HXMinedu
//
//  Created by mac on 2022/3/25.
//

#import <UIKit/UIKit.h>
#import "HXLearnReportCell.h"
#import "HXLearnReportCourseDetailModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HXHistoryLearnReportDetailHeadView : UIView

@property(nonatomic,strong) HXLearnReportCourseDetailModel *learnReportCourseDetailModel;
@property(nonatomic,assign) HXLearnReportCellType cellType;

@end

NS_ASSUME_NONNULL_END
