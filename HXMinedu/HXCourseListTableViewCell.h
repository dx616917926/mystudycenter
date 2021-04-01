//
//  HXCourseListTableViewCell.h
//  HXMinedu
//
//  Created by Mac on 2020/12/22.
//

#import "HXBaseTableViewCell.h"
#import "HXCourseModel.h"
#import "HXCourseListModelView.h"

@class HXCourseListTableViewCell;
@protocol HXCourseListTableViewCellDelegate <NSObject>
@required
/// 点击了模块按钮
- (void)didClickStudyButtonWithModel:(HXModelItem *)modelItem;

/// 点击了学习情况按钮
- (void)didClickReportButtonInCell:(HXCourseListTableViewCell *)cell;

@end

@interface HXCourseListTableViewCell : HXBaseTableViewCell<HXCourseListModelViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *mBackgroundView;
@property (weak, nonatomic) IBOutlet UILabel *mTitleLabel;
@property (weak, nonatomic) IBOutlet HXCourseListModelView *modelView;

@property(nonatomic, weak) id<HXCourseListTableViewCellDelegate> delegate;

@property(nonatomic, strong) HXCourseModel *model;

@end
