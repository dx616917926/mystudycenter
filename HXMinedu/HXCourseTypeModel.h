//
//  HXCourseTypeModel.h
//  HXMinedu
//
//  Created by mac on 2021/4/1.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
#import "HXTeachCourseModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HXCourseTypeModel : NSObject

@property(nonatomic,copy) NSString *courseTypeName;
@property(nonatomic,assign) NSInteger count;

@property(nonatomic, strong) NSArray<HXTeachCourseModel *> *courseList;
//是否展开，默认 否
@property(nonatomic,assign) BOOL isExpand;

@end

NS_ASSUME_NONNULL_END
