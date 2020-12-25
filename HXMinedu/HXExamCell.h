//
//  HXExamCell.h
//  HXMinedu
//
//  Created by Mac on 2020/12/24.
//

#import "HXBaseTableViewCell.h"
#import "HXExamModel.h"

NS_ASSUME_NONNULL_BEGIN

@class HXExamCell;
@protocol HXExamCellDelegate <NSObject>
@required
/// 点击了进入考试按钮
- (void)didClickStartExamButtonInCell:(HXExamCell *)cell;

@end

@interface HXExamCell : HXBaseTableViewCell

@property (weak, nonatomic) IBOutlet UIView *mBackgroundView;
@property (weak, nonatomic) IBOutlet UILabel *mTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *mInfoLabel;
@property (weak, nonatomic) IBOutlet UIButton *mStartExamButton;

@property (nonatomic, weak) id<HXExamCellDelegate> delegate;

@property (nonatomic, strong) HXExamModel *model;

@end

NS_ASSUME_NONNULL_END
