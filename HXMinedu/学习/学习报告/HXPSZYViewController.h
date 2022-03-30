//
//  HXPSZYViewController.h
//  HXMinedu
//
//  Created by mac on 2022/3/24.
//

#import "HXBaseViewController.h"

@class  HXLearnCourseItemModel;

NS_ASSUME_NONNULL_BEGIN

@interface HXPSZYViewController : HXBaseViewController

@property(nonatomic,assign) BOOL isHistory;
@property(nonatomic,strong) UITableView *mainTableView;
///模块名称
@property(nonatomic, copy) NSString *ModuleName;
///模块里的课程数据
@property(nonatomic, strong) NSArray<HXLearnCourseItemModel *> *learnCourseItemList;
@end

NS_ASSUME_NONNULL_END
