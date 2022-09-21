//
//  HXSignInShowView.h
//  HXMinedu
//
//  Created by mac on 2022/9/20.
//

#import <UIKit/UIKit.h>
#import "HXQRCodeSignInModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^SignInBlock)(void);

@interface HXSignInShowView : UIView

@property(nonatomic,strong) HXQRCodeSignInModel *qRCodeSignInModel;

@property(nonatomic,copy) SignInBlock signInBlock;

-(void)show;



@end

NS_ASSUME_NONNULL_END
