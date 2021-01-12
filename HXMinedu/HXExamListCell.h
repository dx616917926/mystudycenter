//
//  HXExamListCell.h
//  HXMinedu
//
//  Created by Mac on 2021/1/12.
//

#import "HXBaseTableViewCell.h"
#import "HXExam.h"

NS_ASSUME_NONNULL_BEGIN

@interface HXExamListCell : HXBaseTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *mTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *mLastExamNumLabel;

@property (nonatomic, strong) HXExam *entity;

@end

NS_ASSUME_NONNULL_END
