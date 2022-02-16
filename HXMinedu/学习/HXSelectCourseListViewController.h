//
//  HXSelectListViewController.h
//  HXMinedu
//
//  Created by mac on 2022/2/15.
//

#import "HXBaseViewController.h"
#import "HXCourseLearnCell.h"

NS_ASSUME_NONNULL_BEGIN


@interface HXSelectCourseListViewController : HXBaseViewController

@property(nonatomic,assign) HXClickType type;
@property(nonatomic,strong) NSString *course_id;

@end

NS_ASSUME_NONNULL_END
