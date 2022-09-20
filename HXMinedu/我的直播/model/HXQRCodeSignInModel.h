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
///是否签到 0否  1是
@property(nonatomic, assign) NSInteger IsSign;


@end

NS_ASSUME_NONNULL_END
