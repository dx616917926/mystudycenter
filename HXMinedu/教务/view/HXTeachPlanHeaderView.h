//
//  HXTeachPlanHeaderView.h
//  HXMinedu
//
//  Created by mac on 2021/3/29.
//

#import <UIKit/UIKit.h>
#import "HXCourseTypeModel.h"
NS_ASSUME_NONNULL_BEGIN

typedef void (^ExpandCallBack)(void);

@interface HXTeachPlanHeaderView : UITableViewHeaderFooterView

@property(nonatomic,strong) HXCourseTypeModel *model;

@property(nonatomic,copy) ExpandCallBack expandCallBack;



@end

NS_ASSUME_NONNULL_END
