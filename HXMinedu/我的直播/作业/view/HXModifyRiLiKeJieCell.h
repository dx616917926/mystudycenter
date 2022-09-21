//
//  HXModifyRiLiKeJieCell.h
//  HXMinedu
//
//  Created by mac on 2022/9/20.
//

#import <UIKit/UIKit.h>
#import "HXKeJieModel.h"

NS_ASSUME_NONNULL_BEGIN

@class HXModifyRiLiKeJieCell;

@protocol HXModifyRiLiKeJieCellDelegate <NSObject>

-(void)zhanKaiCell:(HXModifyRiLiKeJieCell *)cell;

@end

@interface HXModifyRiLiKeJieCell : UITableViewCell

@property(nonatomic,weak) id<HXModifyRiLiKeJieCellDelegate> delegate;

@property(nonatomic,strong) HXKeJieModel *keJieModel;
//是否第一和最后
@property(nonatomic,assign) BOOL isFirst;
@property(nonatomic,assign) BOOL isLast;

@end

NS_ASSUME_NONNULL_END
