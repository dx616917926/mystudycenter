//
//  HXExamDetailViewController.h
//  HXMinedu
//
//  Created by Mac on 2020/12/25.
//

#import "HXBaseViewController.h"
#import "HXExam.h"

NS_ASSUME_NONNULL_BEGIN

@interface HXExamDetailViewController : HXBaseViewController

@property(nonatomic, strong) HXExam *exam;

@property(nonatomic, strong) NSString *EndDate;
@property(nonatomic, strong) NSString *StartDate;

@end

NS_ASSUME_NONNULL_END
