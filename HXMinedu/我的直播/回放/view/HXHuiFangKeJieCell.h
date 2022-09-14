//
//  HXHuiFangKeJieCell.h
//  HXMinedu
//
//  Created by mac on 2022/8/11.
//

#import <UIKit/UIKit.h>
#import "HXKeJieModel.h"

NS_ASSUME_NONNULL_BEGIN


@protocol HXHuiFangKeJieCellDelegate <NSObject>

/// 点评/查看点评
- (void)dianPingWithModel:(HXKeJieModel *)keJieModel;


@end

@interface HXHuiFangKeJieCell : UITableViewCell

@property(nonatomic, weak) id<HXHuiFangKeJieCellDelegate> delegate;

@property(nonatomic,strong) HXKeJieModel *keJieModel;

@end

NS_ASSUME_NONNULL_END
