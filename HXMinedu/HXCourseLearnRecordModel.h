//
//  HXCourseLearnRecordModel.h
//  HXMinedu
//
//  Created by mac on 2021/5/10.
//

#import <Foundation/Foundation.h>
#import "HXCourseModel.h"
#import "HXKJCXXCourseListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HXCourseLearnRecordModel : NSObject

@property(nonatomic, strong) NSArray<HXCourseModel *> *courseInfoList;

@end

NS_ASSUME_NONNULL_END
