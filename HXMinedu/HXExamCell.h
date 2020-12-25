//
//  HXExamCell.h
//  HXMinedu
//
//  Created by Mac on 2020/12/24.
//

#import "HXBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface HXExamCell : HXBaseTableViewCell

@property (weak, nonatomic) IBOutlet UIView *mBackgroundView;
@property (weak, nonatomic) IBOutlet UILabel *mTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *mInfoLabel;
@property (weak, nonatomic) IBOutlet UIButton *mStartExamButton;

@end

NS_ASSUME_NONNULL_END
