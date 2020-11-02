//
//  HXVerificationCodeView.h
//  CloudClass
//
//  Created by Mac on 2018/4/12.
//  Copyright © 2018年 TheLittleBoy. All rights reserved.
//

#import <UIKit/UIKit.h>

//生成四位数验证码
@interface HXVerificationCodeView : UIView

/**
 刷新验证码
 */
-(void)changeCode;

/**
 核对验证码(不区分大小写）
 
 @param code 非空字符串
 @return 一致返回YES，否则返回NO
 */
- (BOOL)checkCode:(NSString *)code;

@end
