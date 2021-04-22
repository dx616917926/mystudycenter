//
//  HXStudyReportCell.h
//  HXMinedu
//
//  Created by mac on 2021/4/7.
//

#import <UIKit/UIKit.h>
#import "HXCourseDetailModel.h"
typedef enum : NSUInteger {
    HXKeJianXueXiType = 1,
    HXZhiShiDianPingType = 2,
    HXPingShiZuoYeType = 3,
    HXQiMoKaoShiType = 4,
} HXStudyReportCellType;

typedef enum : NSUInteger {
    HXNoneCornerRadiusType = 0,
    HXTopCornerRadiusType = 1,
    HXBottomCornerRadiusType = 2,
    HXBothCornerRadiusType = 3,
} HXCornerRadiusType;

NS_ASSUME_NONNULL_BEGIN

@interface HXStudyReportCell : UITableViewCell

@property(nonatomic,assign)  HXCornerRadiusType cornerRadiusType;

@property(nonatomic,assign) HXStudyReportCellType cellType;

@property(nonatomic,strong) HXCourseDetailModel *courseDetailModel;

@end

NS_ASSUME_NONNULL_END
