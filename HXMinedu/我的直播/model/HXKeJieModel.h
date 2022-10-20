//
//  HXKeJieModel.h
//  HXMinedu
//
//  Created by mac on 2022/8/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HXKeJieModel : NSObject
///
@property(nonatomic, strong) NSString *ClassGuid;
///
@property(nonatomic, strong) NSString *EnrollId;
///直播名称
@property(nonatomic, strong) NSString *ClassName;
///直播开始日期
@property(nonatomic, strong) NSString *ClassBeginDate;
///直播结束日期
@property(nonatomic, strong) NSString *ClassEndDate;
///直播开始时间
@property(nonatomic, strong) NSString *ClassBeginTime;
///直播结束时间
@property(nonatomic, strong) NSString *ClassEndTime;
///直播类型 1ClassIn    2保利威    3面授课程    面授课程只展示不做任何操作
@property(nonatomic, assign) NSInteger LiveType;
///上课时长 LiveType等于1时展示    2时隐藏
@property(nonatomic, strong) NSString *ClassTimeSpan;
///直播地址
@property(nonatomic, strong) NSString *liveUrl;
///直播图片
@property(nonatomic, strong) NSString *imgUrl;
///直播状态 0待开始 1直播中 2已结束
@property(nonatomic, assign) NSInteger LiveState;
///直播老师
@property(nonatomic, strong) NSString *TeacherName;
///上课教室
@property(nonatomic, strong) NSString *RoomName;
///教室地址
@property(nonatomic, strong) NSString *RoomAddr;
///0-6（0:周末  1周一.....6周六）
@property(nonatomic, assign) NSInteger Week;
///是否评价 0否 1是
@property(nonatomic, assign) NSInteger IsEvaluate;
///审核状态   0未提交请假显示请假按钮       1待审核显示审核中            2已通过显示已请假          3已驳回显示已驳回不可再次申请
@property(nonatomic, assign) NSInteger AuditState;
///签到状态    -1未签到可提交请假申请       0提交请假申请审核中        1到课         2迟到        3请假        4未到
@property(nonatomic, assign) NSInteger Status;

///是否展开
@property(nonatomic, assign) BOOL IsZhanKai;

@end

NS_ASSUME_NONNULL_END
