//
//  HXLearnReportModel.h
//  HXMinedu
//
//  Created by mac on 2022/3/28.
//

#import <Foundation/Foundation.h>
#import "HXLearnModuleModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HXLearnReportModel : NSObject
///是否有历史学校报告 为历史学习报告时，不需要处理该值
@property(nonatomic, assign) NSInteger isHisVersion;
///
@property(nonatomic, copy) NSString *remarks;
///模块数据
@property(nonatomic, strong) NSArray<HXLearnModuleModel *> *learnModuleList;


@end

NS_ASSUME_NONNULL_END
