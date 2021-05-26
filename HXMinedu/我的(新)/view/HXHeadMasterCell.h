//
//  HXHeadMasterCell.h
//  HXMinedu
//
//  Created by mac on 2021/5/25.
//

#import <UIKit/UIKit.h>
#import "HXHeadMasterModel.h"
NS_ASSUME_NONNULL_BEGIN
@class HXHeadMasterCell;

@protocol HXHeadMasterCellDelegate <NSObject>

-(void)headMasterCell:(HXHeadMasterCell *)cell tapJiGouQRCodeImageView:(UIImageView *)jiGouQRCodeImageView;

@end

@interface HXHeadMasterCell : UITableViewCell

@property(nonatomic,weak) id<HXHeadMasterCellDelegate> delegate;

@property(nonatomic,strong) HXHeadMasterModel *headMasterModel;

@end

NS_ASSUME_NONNULL_END
