//
//  HXCourseDetailModel.h
//  HXMinedu
//
//  Created by mac on 2021/4/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HXCourseDetailModel : NSObject
///课程名称
@property(nonatomic, copy) NSString *courseName;
///学习总时间
@property(nonatomic, assign) NSInteger learnTime;
///已经学习时间
@property(nonatomic, assign) NSInteger learnDuration;


///学习总时间
@property(nonatomic, assign) NSInteger yzTopic;
///学习总时间
@property(nonatomic, assign) NSInteger wzTopic;
///得分
@property(nonatomic, copy) NSString *score;
///总分
@property(nonatomic, assign) NSInteger totalScore;

@end

NS_ASSUME_NONNULL_END
