//
//  HXConfirmViewController.h
//  HXMinedu
//
//  Created by mac on 2021/4/9.
//

#import "HXBaseViewController.h"
#import "HXPictureInfoModel.h"
//flag 1:已上传 2:已确定
typedef void(^RefreshInforBlock)(NSInteger flag);

NS_ASSUME_NONNULL_BEGIN

@interface HXConfirmViewController : HXBaseViewController

@property(nonatomic,strong) HXPictureInfoModel *pictureInfoModel;
//刷新外部数据
@property(nonatomic,copy) RefreshInforBlock refreshInforBlock;

@end

NS_ASSUME_NONNULL_END
