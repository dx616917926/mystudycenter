//
//  HXZiLiaoInfoViewController.h
//  HXMinedu
//
//  Created by mac on 2021/12/8.
//

#import "HXBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class HXCommonSelectModel;

@interface HXZiLiaoInfoViewController : HXBaseViewController

@property(nonatomic,strong)  NSArray<HXCommonSelectModel *> *majorList;
//选择的资料名称
@property(nonatomic,strong)  NSString *selectFileTypeName;
@end

NS_ASSUME_NONNULL_END
