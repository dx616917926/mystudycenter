//
//  HXConfirmViewController.h
//  HXMinedu
//
//  Created by mac on 2021/4/9.
//

#import "HXBaseViewController.h"
#import "HXPictureInfoModel.h"

typedef void(^RefreshInforBlock)(void);

NS_ASSUME_NONNULL_BEGIN

@interface HXConfirmViewController : HXBaseViewController

@property(nonatomic,strong) HXPictureInfoModel *pictureInfoModel;
//刷新外部数据
@property(nonatomic,copy) RefreshInforBlock refreshInforBlock;

@end

NS_ASSUME_NONNULL_END
