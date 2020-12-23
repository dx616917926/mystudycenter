//
//  HXCourseModel.h
//  HXMinedu
//
//  Created by Mac on 2020/12/22.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

NS_ASSUME_NONNULL_BEGIN

@interface HXCourseModel : NSObject

@property(nonatomic, strong) NSString *studentCourseID;   //学生开课表的ID
@property(nonatomic, strong) NSString *student_id;
@property(nonatomic, strong) NSString *course_id;
@property(nonatomic, strong) NSString *coursecode;        //课程代码
@property(nonatomic, strong) NSString *courseName;        //课程名称
@property(nonatomic, strong) NSString *revision;          //课程版本
@property(nonatomic, assign) BOOL ShowKJ;                 //是否显示课件
@property(nonatomic, assign) BOOL ShowZY;                 //是否显示作业
@property(nonatomic, assign) BOOL ShowQM;                 //是否显示期末考试
@property(nonatomic, strong) NSString *StartDate;            //学习开始时间
@property(nonatomic, strong) NSString *EndDate;              //学习结束时间
@property(nonatomic, strong) NSString *KJButtonName;         //课件按钮名称   课件学习
@property(nonatomic, strong) NSString *ZYButtonName;         //作业按钮名称   平时作业
@property(nonatomic, strong) NSString *QMButtonName;         //期末按钮名称   期末考试
@property(nonatomic, strong) NSString *ExButtonName;         //考前练习按钮名称
@property(nonatomic, assign) BOOL canLearning;               //是否到时间可以学习和考试
@property(nonatomic, strong) NSString *major_id;             //专业ID
@property(nonatomic, strong) NSString *majorName;            //专业名称
@property(nonatomic, strong) NSString *jobCode;              //作业代码
@property(nonatomic, strong) NSString *ModleCode;            //期末代码
@property(nonatomic, strong) NSString *StemCode;             //课件来源
@property(nonatomic, strong) NSString *KjStartDate;          //课件学习开始时间
@property(nonatomic, strong) NSString *KjEndDate;            //课件学习结束时间
@property(nonatomic, assign) BOOL KjcanLearning;             //课件是否到时间可以学习和考试
@property(nonatomic, strong) NSString *ZyStartDate;          //作业学习开始时间
@property(nonatomic, strong) NSString *ZyEndDate;            //作业学习结束时间
@property(nonatomic, assign) BOOL ZycanLearning;             //作业是否到时间可以学习和考试
@property(nonatomic, strong) NSString *QmStartDate;          //期末学习开始时间
@property(nonatomic, strong) NSString *QmEndDate;            //期末学习结束时间
@property(nonatomic, assign) BOOL QmcanLearning;             //期末是否到时间可以学习和考试
@property(nonatomic, strong) NSString *imageURL;             //课件图片
@property(nonatomic, strong) NSString *courseGUID;           //课次GUID
@property(nonatomic, strong) NSString *ProceduralTypeURL;    //课程模式对应的图片
@property(nonatomic, strong) NSString *jobTimes;             //平时作业次数，默认2次，可根据设置来
@property(nonatomic, strong) NSString *examTimes;            //期末考试次数，默认1次，可根据设置来
@property(nonatomic, strong) NSString *kcDM;                 //课程性质代码
@property(nonatomic, strong) NSString *yxDM;                 //主考院校代码
@property(nonatomic, strong) NSString *ExamDate;

@end

NS_ASSUME_NONNULL_END
