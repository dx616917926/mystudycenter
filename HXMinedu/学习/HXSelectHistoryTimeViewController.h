//
//  HXSelectHistoryTimeViewController.h
//  HXMinedu
//
//  Created by mac on 2021/7/29.
//

#import "HXBaseViewController.h"


NS_ASSUME_NONNULL_BEGIN
@class HXVersionModel,HXMajorModel;

typedef void (^SelectTimeFinishCallBack)(NSString *time);

@interface HXSelectHistoryTimeViewController : HXBaseViewController

//历史时间数组
@property(strong,nonatomic) NSArray *historyTimeList;
///选择完成回调
@property (nonatomic, copy) SelectTimeFinishCallBack selectFinishCallBack;

@end

NS_ASSUME_NONNULL_END

