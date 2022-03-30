//
//  HXLearnReportCourseDetailModel.h
//  HXMinedu
//
//  Created by mac on 2022/3/29.
//

#import <Foundation/Foundation.h>
#import "HXLearnItemDetailModel.h"
#import "MJExtension.h"
NS_ASSUME_NONNULL_BEGIN

@interface HXLearnReportCourseDetailModel : NSObject

///课程名
@property(nonatomic, copy) NSString *courseName;
///课件id
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
///
@property(nonatomic, strong) NSArray<HXLearnItemDetailModel *> *learnItemDetailList;
///
@property(nonatomic, strong) NSArray<HXLearnItemDetailModel *> *learnExamItemDetailList;

@end

NS_ASSUME_NONNULL_END
