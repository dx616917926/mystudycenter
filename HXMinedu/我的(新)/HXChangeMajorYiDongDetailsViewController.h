//
//  HXChangeMajorYiDongDetailsViewController.h
//  HXMinedu
//
//  Created by mac on 2021/7/9.
//

#import "HXBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface HXChangeMajorYiDongDetailsViewController : HXBaseViewController

///异动id
@property(nonatomic, copy) NSString *stopStudyId;

@property(nonatomic,assign) BOOL isconfirm;//确认异动

@end

NS_ASSUME_NONNULL_END
