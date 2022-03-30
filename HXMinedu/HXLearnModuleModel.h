//
//  HXLearnModuleModel.h
//  HXMinedu
//
//  Created by mac on 2022/3/28.
//

#import <Foundation/Foundation.h>
#import "HXLearnCourseItemModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HXLearnModuleModel : NSObject
//1视频学习  2平时作业 3期末考试 4历年真题
@property(nonatomic, assign) NSInteger type;
///模块名称
@property(nonatomic, copy) NSString *ModuleName;
///模块里的课程数据
@property(nonatomic, strong) NSArray<HXLearnCourseItemModel *> *learnCourseItemList;

@end

NS_ASSUME_NONNULL_END
