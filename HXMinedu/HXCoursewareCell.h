//
//  HXCoursewareCell.h
//  HXMinedu
//
//  Created by Mac on 2020/12/24.
//

#import "HXBaseTableViewCell.h"
#import "HXCwsCourseware.h"

NS_ASSUME_NONNULL_BEGIN

@interface HXCoursewareCell : HXBaseTableViewCell

@property (weak, nonatomic) IBOutlet UIView *mBackgroundView;
@property (weak, nonatomic) IBOutlet UIView *mTypeLabel;
@property (weak, nonatomic) IBOutlet UIView *mTitleLabel;
@property (weak, nonatomic) IBOutlet UIView *mInfoLabel;
@property (weak, nonatomic) IBOutlet UIView *mProgressLabel;
@property (weak, nonatomic) IBOutlet UIView *mProgressView;

@property(nonatomic, strong) HXCwsCourseware *entity;

@end

NS_ASSUME_NONNULL_END
