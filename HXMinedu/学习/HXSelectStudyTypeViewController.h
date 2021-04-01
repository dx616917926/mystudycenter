//
//  HXSelectStudyTypeViewController.h
//  HXMinedu
//
//  Created by mac on 2021/3/31.
//

#import "HXBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
@class HXVersionModel,HXMajorModel;

typedef void (^SelectFinishCallBack)(NSArray *versionList,HXVersionModel *selectVersionModel,HXMajorModel *selectMajorModel);

@interface HXSelectStudyTypeViewController : HXBaseViewController
///数据源
@property (nonatomic, strong) NSArray *versionList;
///选择完成回调
@property (nonatomic, copy) SelectFinishCallBack selectFinishCallBack;

@end

NS_ASSUME_NONNULL_END
