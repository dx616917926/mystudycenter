//
//  HXLearnReportDetailViewController.h
//  HXMinedu
//
//  Created by mac on 2022/3/24.
//

#import "HXBaseViewController.h"
#import "HXLearnReportCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface HXLearnReportDetailViewController : HXBaseViewController

@property(nonatomic,assign) BOOL isHistory;
@property(nonatomic,assign) HXLearnReportCellType cellType;
@end

NS_ASSUME_NONNULL_END
