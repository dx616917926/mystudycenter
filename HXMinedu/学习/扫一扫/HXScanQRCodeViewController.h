//
//  HXScanQRCodeViewController.h
//  HXMinedu
//
//  Created by mac on 2021/10/19.
//

#import "HXBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^ScanResultBlock)(NSDictionary *dic);

@interface HXScanQRCodeViewController : HXBaseViewController

@property(nonatomic,copy) ScanResultBlock scanResultBlock;

@end

NS_ASSUME_NONNULL_END
