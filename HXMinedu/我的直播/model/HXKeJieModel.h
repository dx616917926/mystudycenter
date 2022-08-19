//
//  HXKeJieModel.h
//  HXMinedu
//
//  Created by mac on 2022/8/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HXKeJieModel : NSObject

///直播名称
@property(nonatomic, strong) NSString *ClassName;
///直播开始日期
@property(nonatomic, strong) NSString *ClassBeginDate;
///直播开始时间
@property(nonatomic, strong) NSString *ClassBeginTime;
///直播结束日期
@property(nonatomic, strong) NSString *ClassEndDate;
///直播类型 1ClassIn    2保利威
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
///0-6（0:周末  1周一.....6周六）
@property(nonatomic, assign) NSInteger Week;
///是否评价 0否 1是
@property(nonatomic, assign) NSInteger IsEvaluate;

@end

NS_ASSUME_NONNULL_END
