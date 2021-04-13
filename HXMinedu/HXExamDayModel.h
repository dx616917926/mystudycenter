//
//  HXExamDayModel.h
//  HXMinedu
//
//  Created by mac on 2021/4/10.
//

#import <Foundation/Foundation.h>
#import "HXExamDateSignInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HXExamDayModel : NSObject

//日期
@property(nonatomic, copy) NSString *examDayText;
//每日数组
@property(nonatomic, strong) NSArray<HXExamDateSignInfoModel *> *examDateSignInfoList;

@end

NS_ASSUME_NONNULL_END
