//
//  HXExamModel.h
//  HXMinedu
//
//  Created by Mac on 2020/12/25.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

NS_ASSUME_NONNULL_BEGIN

@interface HXExamModel : NSObject

@property(nonatomic, strong) NSString *ButtonName;
@property(nonatomic, strong) NSString *EndDate;
@property(nonatomic, strong) NSString *StartDate;
@property(nonatomic, strong) NSString *examTimes;
@property(nonatomic, strong) NSString *ExamUrl;
@property(nonatomic, strong) NSString *Type;

@end

NS_ASSUME_NONNULL_END
