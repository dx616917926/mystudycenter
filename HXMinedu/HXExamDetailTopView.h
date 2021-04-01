//
//  HXExamDetailTopView.h
//  HXMinedu
//
//  Created by Mac on 2020/12/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HXExamDetailTopView : UIView

@property (weak, nonatomic) IBOutlet UILabel *mExamTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *mExamTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *mExamStartTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *mExamEndTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *mExamAllowCountLabel;

@end

NS_ASSUME_NONNULL_END
