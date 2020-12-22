//
//  HXCourseListTableViewCell.h
//  HXMinedu
//
//  Created by Mac on 2020/12/22.
//

#import "HXBaseTableViewCell.h"
#import "HXCourseModel.h"

NS_ASSUME_NONNULL_BEGIN

@class HXCourseListTableViewCell;
@protocol HXCourseListTableViewCellDelegate <NSObject>
@required
/// 点击了开始学习按钮
- (void)didClickStudyButtonInCell:(HXCourseListTableViewCell *)cell;

@end

@interface HXCourseListTableViewCell : HXBaseTableViewCell

@property (weak, nonatomic) IBOutlet UIView *mBackgroundView;
@property (weak, nonatomic) IBOutlet UIImageView *mImageView;
@property (weak, nonatomic) IBOutlet UILabel *mTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *startStudyButton;

@property(nonatomic, weak) id<HXCourseListTableViewCellDelegate> delegate;

@property(nonatomic, strong) HXCourseModel *model;

@end

NS_ASSUME_NONNULL_END
