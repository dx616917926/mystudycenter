//
//  HXLearnReportDetailCell.h
//  HXMinedu
//
//  Created by mac on 2022/3/24.
//

#import <UIKit/UIKit.h>
#import "HXLearnReportCell.h"
#import "HXLearnItemDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HXLearnReportDetailCell : UITableViewCell

@property(nonatomic,assign) HXLearnReportCellType cellType;
@property(nonatomic,strong) HXLearnItemDetailModel *learnItemDetailModel;

@end

NS_ASSUME_NONNULL_END
