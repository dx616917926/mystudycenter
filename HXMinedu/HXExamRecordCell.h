//
//  HXExamRecordCell.h
//  HXMinedu
//
//  Created by Mac on 2020/12/25.
//

#import "HXBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@class HXExamRecordCell;

@protocol HXExamRecordCellDelegate <NSObject>
@required
/// 点击了继续考试按钮
- (void)didClickContinueExamButtonInCell:(HXExamRecordCell *)cell;
/// 点击了查看答卷
- (void)didClickLookExamButtonInCell:(HXExamRecordCell *)cell;

@end

@interface HXExamRecordCell : HXBaseTableViewCell

@property (weak, nonatomic) IBOutlet UIView *mBackgroundView;
@property (weak, nonatomic) IBOutlet UILabel *mTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *mScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *mTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *mContinueExamButton;
@property (weak, nonatomic) IBOutlet UIButton *mLookExamButton;

@property(nonatomic, strong) NSDictionary *dataSource;

@property (nonatomic, weak) id<HXExamRecordCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
