//
//  HXLianXiCell.h
//  HXMinedu
//
//  Created by mac on 2022/8/24.
//

#import <UIKit/UIKit.h>
#import "HXContactModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HXLianXiCell : UITableViewCell

@property(nonatomic,strong) HXContactModel *contactModel;
@property(nonatomic,strong) UILabel *titleLabel;
@property(nonatomic,strong) UILabel *detailLabel;

@end

NS_ASSUME_NONNULL_END
