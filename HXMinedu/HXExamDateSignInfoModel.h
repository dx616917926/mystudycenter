//
//  HXExamDateSignInfoModel.h
//  HXMinedu
//
//  Created by mac on 2021/4/10.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

NS_ASSUME_NONNULL_BEGIN

@interface HXExamDateSignInfoModel : NSObject
///考试时间
@property(nonatomic, copy) NSString *examTime;
///课程名
@property(nonatomic, copy) NSString *courseName;

@end

NS_ASSUME_NONNULL_END
