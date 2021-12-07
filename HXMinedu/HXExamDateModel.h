//
//  HXExamDateModel.h
//  HXMinedu
//
//  Created by mac on 2021/4/10.
//

#import <Foundation/Foundation.h>
#import "HXExamDayModel.h"
#import "HXExamDateCourseScoreModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HXExamDateModel : NSObject

//成考录取状态 不为空则显示成考样式 自考成考互斥
@property(nonatomic, copy) NSString *AdmissionStatus;
//自考考期 不为空则显示自考样式
@property(nonatomic, copy) NSString *examDate;
//每日数组(报考课程用)
@property(nonatomic, strong) NSArray<HXExamDayModel *> *examDayList;
//每日数组(考试成绩用)
@property(nonatomic, strong) NSArray<HXExamDateCourseScoreModel *> *examDateCourseScoreInfoList;
//是否选中 默认否
@property(nonatomic, assign) BOOL isSelected;
@end

NS_ASSUME_NONNULL_END
