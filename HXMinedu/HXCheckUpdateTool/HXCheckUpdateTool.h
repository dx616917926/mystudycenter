//
//  HXCheckUpdateTool.h
//  HXMinedu
//
//  Created by Mac on 2020/11/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HXCheckUpdateTool : NSObject

+ (instancetype)sharedInstance;

@property(nonatomic, assign) BOOL hasNewVersion;  //是否有新版本

/**
 检查是否有新版本
 */
- (void)checkUpdate;

- (void)checkUpdateWithInController:(nullable UIViewController *)viewController;

/**
 打开新版本网页
 */
- (void)gotoUpdate;

@end

NS_ASSUME_NONNULL_END
