//
//  HXVideoLearnCell.h
//  HXMinedu
//
//  Created by mac on 2022/3/24.
//

#import <UIKit/UIKit.h>
#import "HXLearnCourseItemModel.h"
typedef enum : NSUInteger {
    HXKeJianXueXiReportType = 1,
    HXPingShiZuoYeReportType = 2,
    HXQiMoKaoShiReportType = 3,
    HXLiNianZhenTiReportType = 4
} HXLearnReportCellType;

NS_ASSUME_NONNULL_BEGIN

@interface HXLearnReportCell : UITableViewCell

@property(nonatomic,assign) HXLearnReportCellType cellType;
@property(nonatomic,strong) HXLearnCourseItemModel *learnCourseItemModel;

@end

NS_ASSUME_NONNULL_END
