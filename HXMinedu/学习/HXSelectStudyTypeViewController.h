//
//  HXSelectStudyTypeViewController.h
//  HXMinedu
//
//  Created by mac on 2021/3/31.
//

#import "HXBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
@class HXVersionModel,HXMajorModel;

typedef void (^SelectFinishCallBack)(HXVersionModel *selectVersionModel,HXMajorModel *selectMajorModel);

@interface HXSelectStudyTypeViewController : HXBaseViewController
///选择完成回调
@property (nonatomic, copy) SelectFinishCallBack selectFinishCallBack;

@end

NS_ASSUME_NONNULL_END
