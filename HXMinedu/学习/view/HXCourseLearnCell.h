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
    HXKeJianXueXiClickType = 1,//课件学习
    HXPingShiZuoYeClickType = 2,//平时作业
    HXQiMoKaoShiClickType = 3,//期末考试
    HXLiNianZhenTiClickType = 4,//历年真题
    HXZiLiaoClickType = 5//电子资料
} HXClickType;



@protocol HXCourseLearnCellDelegate <NSObject>

-(void)handleType:(HXClickType)type withItem:(HXModelItem *)item;

@end


@interface HXCourseLearnCell : UITableViewCell

@property(nonatomic,weak) id<HXCourseLearnCellDelegate> delegate;

@property(nonatomic,strong) HXCourseModel *courseModel;

@end

NS_ASSUME_NONNULL_END
