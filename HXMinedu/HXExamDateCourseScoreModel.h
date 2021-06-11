//
//  HXExamDateCourseScoreModel.h
//  HXMinedu
//
//  Created by mac on 2021/4/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HXExamDateCourseScoreModel : NSObject

///课程名
@property(nonatomic, copy) NSString *courseName;
///分数
@property(nonatomic, copy) NSString *finalScore;
///是否通过 1通过 0未通过
@property(nonatomic, assign) NSInteger IsPass;

@end

NS_ASSUME_NONNULL_END
