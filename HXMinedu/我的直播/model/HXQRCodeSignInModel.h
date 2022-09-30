//
//  HXQRCodeSignInModel.h
//  HXMinedu
//
//  Created by mac on 2022/9/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HXQRCodeSignInModel : NSObject
///课程名称
@property(nonatomic, strong) NSString *MealName;
///课节名称
@property(nonatomic, strong) NSString *ClassName;
///授课教师
@property(nonatomic, strong) NSString *TeacherName;
///机构ID
@property(nonatomic, strong) NSString *Oz_ID;
///房间ID
@property(nonatomic, strong) NSString *ScheduleRoomID;
///课节ID
@property(nonatomic, strong) NSString *ClassGuid;
///开始日期
@property(nonatomic, strong) NSString *ClassBeginDate;
///结束日期
@property(nonatomic, strong) NSString *ClassEndDate;
///开始时间
@property(nonatomic, strong) NSString *ClassBeginTime;
///房间名
@property(nonatomic, strong) NSString *RoomName;
///班级ID
@property(nonatomic, strong) NSString *ScheduleClassID;
///请假班级
@property(nonatomic, strong) NSString *ScheduleClassName;
///备注
@property(nonatomic, strong) NSString *Remarks;
///是否签到 0否  1是
@property(nonatomic, assign) NSInteger IsSign;
///请假状态 0未提交请假申请 1事假 2病假 3其它
@property(nonatomic, assign) NSInteger QjStatus;
///审核状态 为0则是没有提交申请可编辑发起申请 1审核中 2已通过 3已驳回 请假状态1、2、3只可查看不能发起申请
@property(nonatomic, assign) NSInteger AuditState;

@end

NS_ASSUME_NONNULL_END
