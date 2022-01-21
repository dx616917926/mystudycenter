//
//  HXVoucherViewController.h
//  HXMinedu
//
//  Created by mac on 2021/4/30.
//

#import "HXBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface HXVoucherViewController : HXBaseViewController

@property (nonatomic, copy) NSString *downLoadUrl;
///查看凭证 PDFType: 1、已支付待确认,交易凭证     2、已完成,收款凭证    3、已完成,发票凭证
@property (nonatomic, assign) NSInteger PDFType;
@end

NS_ASSUME_NONNULL_END
