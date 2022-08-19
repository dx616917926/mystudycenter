//
//  HXKeChengModel.h
//  HXMinedu
//
//  Created by mac on 2022/8/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HXKeChengModel : NSObject

///
@property(nonatomic, strong) NSString *MealGuid;
///课程名称
@property(nonatomic, strong) NSString *MealName;
///适用类型
@property(nonatomic, strong) NSString *MealApplyTypeName;
///
@property(nonatomic, strong) NSString *MealBeginDate;
///
@property(nonatomic, strong) NSString *MealBeginTime;
///
@property(nonatomic, strong) NSString *roomNumber;
///总课节数
@property(nonatomic, assign) NSInteger ClassNum;
///待完成课节数
@property(nonatomic, assign) NSInteger UndoneClassNum;
///直播类型 1ClassIn 2保利威 保利威直接跳转页面直播 ClassIn进入下一页面展示课节
@property(nonatomic, assign) NSInteger LiveType;
///地址
@property(nonatomic, strong) NSString *liveUrl;
///图片
@property(nonatomic, strong) NSString *imgUrl;
///0-6（0:周末  1周一.....6周六）
@property(nonatomic, assign) NSInteger Week;

@end

NS_ASSUME_NONNULL_END
