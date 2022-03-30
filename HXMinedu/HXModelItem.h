//
//  HXModelItem.h
//  HXMinedu
//
//  Created by Mac on 2021/1/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HXModelItem : NSObject

@property(nonatomic, strong) NSString *ModuleName;
@property(nonatomic, strong) NSString *EndDate;
@property(nonatomic, strong) NSString *StartDate;
@property(nonatomic, strong) NSString *examTimes;
@property(nonatomic, strong) NSString *ExamUrl;        //考试地址
@property(nonatomic, strong) NSString *Type;
@property(nonatomic, strong) NSDictionary *cws_param;  //新课件系统的参数
@property(nonatomic, strong) NSDictionary *mooc_param;  //慕课课件系统的参数
@property(nonatomic, strong) NSString *coursewareType;
@property(nonatomic, strong) NSString *learnDuration;  //学习总时长
@property(nonatomic, strong) NSString *learnTime;      //建议学时
@property(nonatomic, assign) BOOL showLanguageButton;
@property(nonatomic, strong) NSString *Message;
@property(nonatomic, strong) NSString *ImgUrl;
///类型
@property(nonatomic, strong) NSString *ExamCourseType;
//课件来源   MOOC：为慕课课程
@property(nonatomic, strong) NSString *StemCode;
//课程名称
@property(nonatomic, strong) NSString *courseName;

@property(nonatomic, strong) NSString *course_id;

//开课ID
@property(nonatomic, strong) NSString *studentCourseID;

//自己增加的，判断是否在时间范围内
@property(nonatomic, assign) BOOL isInTime;

@end

NS_ASSUME_NONNULL_END
