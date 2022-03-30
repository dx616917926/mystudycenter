//
//  HXSelectTimeView.h
//  HXMinedu
//
//  Created by mac on 2022/3/25.
//

#import <UIKit/UIKit.h>
#import "HXHistoryTimeModel.h"
NS_ASSUME_NONNULL_BEGIN
typedef void (^SelectTimeCallBack)(BOOL isRefresh,HXHistoryTimeModel *selectExamDateModel);

@interface HXSelectTimeView : UIView

@property(nonatomic,strong) NSArray *dataArray;

-(void)show;

@property(nonatomic,copy) SelectTimeCallBack selectTimeCallBack;

@end

NS_ASSUME_NONNULL_END
