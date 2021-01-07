//
//  HXCwsCourseware.h
//  HXMinedu
//
//  Created by Mac on 2021/1/7.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

NS_ASSUME_NONNULL_BEGIN

@interface HXCwsCourseware : NSObject

@property(nonatomic, strong) NSString *tenantCoursewareName;
@property(nonatomic, strong) NSString *coursewareType;
@property(nonatomic, strong) NSString *learnDuration; //学习总时长
@property(nonatomic, strong) NSString *learnTime;     //建议学时
@property(nonatomic, assign) BOOL showLanguageButton;
@property(nonatomic, strong) NSDictionary *cws_param;  //新课件系统的参数

@end

NS_ASSUME_NONNULL_END
