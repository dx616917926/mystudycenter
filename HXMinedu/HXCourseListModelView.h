//
//  HXCourseListModelView.h
//  HXMinedu
//
//  Created by Mac on 2021/1/20.
//

#import <UIKit/UIKit.h>
#import "HXModelItem.h"

@protocol HXCourseListModelViewDelegate <NSObject>
@required
/// 点击了按钮
- (void)didClickButtonWithModel:(HXModelItem *)modelItem;

@end

@interface HXCourseListModelView : UIView

@property(nonatomic, strong) NSArray<HXModelItem *> *listModel;

@property(nonatomic, weak) id<HXCourseListModelViewDelegate> delegate;

@end
