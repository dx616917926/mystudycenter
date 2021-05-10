//
//  HXKJCXXCourseListModel.h
//  HXMinedu
//
//  Created by mac on 2021/5/10.
//

#import <Foundation/Foundation.h>
#import "HXLearnRecordModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HXKJCXXCourseListModel : NSObject
@property(nonatomic, strong) NSArray<HXLearnRecordModel *> *nowadaysList;
@property(nonatomic, strong) NSArray<HXLearnRecordModel *> *yesterdayList;
@end

NS_ASSUME_NONNULL_END
