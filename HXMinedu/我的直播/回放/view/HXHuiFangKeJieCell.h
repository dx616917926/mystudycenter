//
//  HXHuiFangKeJieCell.h
//  HXMinedu
//
//  Created by mac on 2022/8/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@protocol HXHuiFangKeJieCellDelegate <NSObject>

/// 点评
- (void)dianPingWithModel;

/// 查看点评
- (void)checkDianPingWithModel;

@end

@interface HXHuiFangKeJieCell : UITableViewCell

@property(nonatomic, weak) id<HXHuiFangKeJieCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
