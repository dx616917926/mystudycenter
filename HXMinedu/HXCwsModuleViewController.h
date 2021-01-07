//
//  HXCwsModuleViewController.h
//  HXMinedu
//
//  Created by Mac on 2020/12/23.
//

#import <UIKit/UIKit.h>
#import "HXPullRefreshViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface HXCwsModuleViewController : HXPullRefreshViewController

@property(nonatomic, strong) NSString *courseGUID;
@property(nonatomic, strong) NSString *courseCode;
@property(nonatomic, strong) NSString *stemCode;
@property(nonatomic, strong) NSString *examDate;
@property(nonatomic, strong) NSString *yxDM;
@property(nonatomic, strong) NSString *kcDM;

@end

NS_ASSUME_NONNULL_END
