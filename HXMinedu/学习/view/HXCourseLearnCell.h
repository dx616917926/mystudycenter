//
//  HXCourseLearnCell.h
//  HXMinedu
//
//  Created by mac on 2021/4/6.
//

#import <UIKit/UIKit.h>
#import "HXCourseModel.h"


NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    HXNoClickType = 0,
    HXKeJianXueXiClickType = 1,
    HXPingShiZuoYeClickType = 2,
    HXQiMoKaoShiClickType = 3
} HXClickType;



@protocol HXCourseLearnCellDelegate <NSObject>

-(void)handleType:(HXClickType)type withItem:(HXModelItem *)item;

@end


@interface HXCourseLearnCell : UITableViewCell

@property(nonatomic,weak) id<HXCourseLearnCellDelegate> delegate;

@property(nonatomic,strong) HXCourseModel *courseModel;

@end

NS_ASSUME_NONNULL_END
