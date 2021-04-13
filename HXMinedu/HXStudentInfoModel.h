//
//  HXStudentInfoModel.h
//  HXMinedu
//
//  Created by mac on 2021/4/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HXStudentInfoModel : NSObject
///姓名
@property(nonatomic, copy) NSString *name;
//学号
@property(nonatomic, copy) NSString *studentNo;
//考生号
@property(nonatomic, copy) NSString *examineeNo;
//年级批次
@property(nonatomic, copy) NSString *enterDate;
//身份证号
@property(nonatomic, copy) NSString *personId;
//性别
@property(nonatomic, copy) NSString *sexName;
//政治面貌
@property(nonatomic, copy) NSString *politic;
//民族
@property(nonatomic, copy) NSString *nation;
//入学日期
@property(nonatomic, copy) NSString *rxrq;
//毕业日期
@property(nonatomic, copy) NSString *byrq;
//学生类型
@property(nonatomic, copy) NSString *studyTypeName;
//专业名称
@property(nonatomic, copy) NSString *majorName;
//层次
@property(nonatomic, copy) NSString *educationName;
//教学点名称
@property(nonatomic, copy) NSString *subSchoolName;
//报考类型
@property(nonatomic, copy) NSString *versionName;
//报考学校
@property(nonatomic, copy) NSString *BkSchool;
//手机号码
@property(nonatomic, copy) NSString *mobile;
//QQ
@property(nonatomic, copy) NSString *qq;
//联系地址
@property(nonatomic, copy) NSString *addr;
//最高学历
@property(nonatomic, copy) NSString *degree;
//学生状态
@property(nonatomic, copy) NSString *studentState_name;
//班级名称
@property(nonatomic, copy) NSString *className;

@end

NS_ASSUME_NONNULL_END
