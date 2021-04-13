//
//  HXShowExamDateView.h
//  HXMinedu
//
//  Created by mac on 2021/4/8.
//

#import <UIKit/UIKit.h>
#import "HXExamDateModel.h"
NS_ASSUME_NONNULL_BEGIN
typedef void (^SelectExamDateCallBack)(BOOL isRefresh,HXExamDateModel *selectExamDateModel);
@interface HXShowExamDateView : UIView

@property(nonatomic,strong) NSArray *dataArray;

-(void)show;

@property(nonatomic,copy) SelectExamDateCallBack selectExamDateCallBack;

@end

NS_ASSUME_NONNULL_END
