//
//  HXLearnRecordModel.h
//  HXMinedu
//
//  Created by mac on 2021/5/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HXLearnRecordModel : NSObject
//课程名称
@property(nonatomic, strong) NSString *courseName;
//标签
@property(nonatomic, strong) NSString *mark1;
//课程图片url
@property(nonatomic, strong) NSString *imgUrl;
//总时间
@property(nonatomic, assign) NSInteger learnTime;
//已学时间
@property(nonatomic, assign) NSInteger learnDuration;

@end

NS_ASSUME_NONNULL_END
