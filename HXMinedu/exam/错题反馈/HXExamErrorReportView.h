//
//  HXExamErrorReportView.h
//  zikaoks
//
//  Created by Mac on 2021/12/10.
//  Copyright © 2021 华夏大地教育网. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//常量
UIKIT_EXTERN const int HXExamErrorReportViewTag;

//错题反馈弹框
@interface HXExamErrorReportView : UIView

@property(nonatomic, strong) NSString *examBasePath;
@property(nonatomic, strong) NSString *userExamId;
@property(nonatomic, strong) NSString *questionId;

//弹出
- (void)showInViewController:(UIViewController *)viewController;

@end

NS_ASSUME_NONNULL_END
