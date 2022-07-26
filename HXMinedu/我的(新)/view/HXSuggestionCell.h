//
//  HXSuggestionCell.h
//  HXMinedu
//
//  Created by mac on 2021/6/4.
//

#import <UIKit/UIKit.h>
#import "HXStudentRefundDetailsModel.h"
#import "HXYiDongInfoModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HXSuggestionCell : UITableViewCell

///退费用到
@property(nonatomic,strong) HXStudentRefundDetailsModel *studentRefundDetailsModel;
///异动用到
@property(nonatomic,strong) HXYiDongInfoModel *yiDongInfoModel;

@end

NS_ASSUME_NONNULL_END
