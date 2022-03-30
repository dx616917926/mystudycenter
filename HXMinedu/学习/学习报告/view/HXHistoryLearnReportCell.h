//
//  HXHistoryLearnReportCell.h
//  HXMinedu
//
//  Created by mac on 2022/3/24.
//

#import <UIKit/UIKit.h>
#import "HXLearnReportCell.h"
#import "HXLearnCourseItemModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HXHistoryLearnReportCell : UITableViewCell

@property(nonatomic,strong) HXLearnCourseItemModel *learnCourseItemModel;
@property(nonatomic,assign) HXLearnReportCellType cellType;

@end

NS_ASSUME_NONNULL_END
