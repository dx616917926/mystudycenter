//
//  HXCourseModel.h
//  HXMinedu
//
//  Created by Mac on 2020/12/22.
//

#import <Foundation/Foundation.h>
#import "HXModelItem.h"
#import "MJExtension.h"

NS_ASSUME_NONNULL_BEGIN

@interface HXCourseModel : NSObject

@property(nonatomic, strong) NSString *studentCourseID;   //学生开课表的ID
@property(nonatomic, strong) NSString *course_id;
@property(nonatomic, strong) NSString *coursecode;        //课程代码
@property(nonatomic, strong) NSString *courseName;        //课程名称
@property(nonatomic, strong) NSString *revision;          //课程版本
@property(nonatomic, strong) NSString *major_id;             //专业ID
@property(nonatomic, strong) NSString *majorName;            //专业名称
@property(nonatomic, strong) NSString *jobCode;              //作业代码
@property(nonatomic, strong) NSString *ModleCode;            //期末代码
@property(nonatomic, strong) NSString *StemCode;             //课件来源
@property(nonatomic, strong) NSString *imageURL;             //课件图片
@property(nonatomic, strong) NSString *kcDM;                 //课程性质代码
@property(nonatomic, strong) NSString *yxDM;                 //主考院校代码
@property(nonatomic, strong) NSString *ExamDate;             //考期

@property(nonatomic, strong) NSArray<HXModelItem *> *modules;          //课件、考试等模块

@end

NS_ASSUME_NONNULL_END
