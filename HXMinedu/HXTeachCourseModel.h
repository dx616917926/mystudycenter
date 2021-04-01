//
//  HXTeachCourseModel.h
//  HXMinedu
//
//  Created by mac on 2021/4/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HXTeachCourseModel : NSObject

@property(nonatomic, copy) NSString *courseName;        //课程名称
@property(nonatomic, assign) NSInteger isShowCourseCode;   //学生开课表的ID
@property(nonatomic, copy) NSString *courseCode;        //课程代码
@property(nonatomic, assign) NSInteger isShowIsNetCourse; //是否显示网学
@property(nonatomic, assign) BOOL isNetCourse; //是否是网学
@property(nonatomic, assign) NSInteger isShowIsPass; //是否显示通过
@property(nonatomic, assign) NSInteger IsPass; //是否通过
@property(nonatomic, assign) NSInteger isShowFinalScore; //是否显示成绩
@property(nonatomic, copy) NSString *finalScore;//成绩
@property(nonatomic, assign) NSInteger isShowCoursePoint; //是否显示学分
@property(nonatomic, copy) NSString *coursePoint; //学分
@property(nonatomic, assign) NSInteger isShowCheckLookName; //是否显示统考
@property(nonatomic, copy) NSString *checkLookName;//统考
@property(nonatomic, assign) NSInteger isShowCourseTypeName; //
@property(nonatomic, copy) NSString *courseTypeName;//

@end

NS_ASSUME_NONNULL_END
