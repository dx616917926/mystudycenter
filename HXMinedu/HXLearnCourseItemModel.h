//
//  HXLearnCourseItemModel.h
//  HXMinedu
//
//  Created by mac on 2022/3/28.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

NS_ASSUME_NONNULL_BEGIN

@interface HXLearnCourseItemModel : NSObject
///课程ID
@property(nonatomic, copy) NSString *course_id;
///课程代码
@property(nonatomic, copy) NSString *courseCode;
///课程名
@property(nonatomic, copy) NSString *courseName;
///标题
@property(nonatomic, copy) NSString *studentCourseID;
///课程版本
@property(nonatomic, copy) NSString *revision;
///总章节
@property(nonatomic, assign) NSInteger generalChapter;
///学习次数
@property(nonatomic, assign) NSInteger studiesNumber;
///已完成章节数
@property(nonatomic, assign) NSInteger chaptersCompletedNumber;
///试卷总数
@property(nonatomic, assign) NSInteger testPaperNumber;
///练习次数
@property(nonatomic, assign) NSInteger exercisesNumber;
///试卷完成数
@property(nonatomic, assign) NSInteger testPaperCompletedNumber;
///1为视频学习 2为平时作业 3为期末考试 4为历年真题 为1时取generalChapter、studiesNumber、chaptersCompletedNumber
///其他取testPaperNumber、exercisesNumber、testPaperCompletedNumber 除此之外用以区分调用详情接口
@property(nonatomic, assign) NSInteger type;
///1为平时作业  2为期末考试  3为历年真题
@property(nonatomic, assign) NSInteger examType;

@end

NS_ASSUME_NONNULL_END
