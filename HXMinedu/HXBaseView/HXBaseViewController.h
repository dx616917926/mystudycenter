//
//  HXBaseViewController.h
//  HXMinedu
//
//  Created by Mac on 2020/10/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HXBaseViewController : UIViewController
@property (nonatomic, strong) HXBarButtonItem *leftBarItem;
@property(nonatomic,assign,readonly)BOOL isLogin;

@end

NS_ASSUME_NONNULL_END
