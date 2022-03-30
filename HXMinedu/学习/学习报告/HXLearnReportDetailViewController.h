//
//  HXLearnReportDetailViewController.h
//  HXMinedu
//
//  Created by mac on 2022/3/24.
//

#import "HXBaseViewController.h"
#import "HXLearnReportCell.h"
#import "HXLearnCourseItemModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HXLearnReportDetailViewController : HXBaseViewController

@property(nonatomic,assign) BOOL isHistory;
@property(nonatomic,assign) HXLearnReportCellType cellType;
///模块名称
@property(nonatomic, copy) NSString *ModuleName;
@property(nonatomic,strong) HXLearnCourseItemModel *learnCourseItemModel;

@end

NS_ASSUME_NONNULL_END
