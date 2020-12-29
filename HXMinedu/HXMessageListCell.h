//
//  HXMessageListCell.h
//  HXMinedu
//
//  Created by Mac on 2020/12/29.
//

#import "HXBaseTableViewCell.h"
#import "HXMessageObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface HXMessageListCell : HXBaseTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *mTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *mTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *mStatusLabel;

@property(nonatomic, strong) HXMessageObject *model;

@end

NS_ASSUME_NONNULL_END
