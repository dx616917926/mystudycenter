//
//  HXLearnItemDetailModel.h
//  HXMinedu
//
//  Created by mac on 2022/3/29.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

NS_ASSUME_NONNULL_BEGIN

@interface HXLearnItemDetailModel : NSObject

///标题
@property(nonatomic, copy) NSString *catalogTitle;
///课件来源
@property(nonatomic, copy) NSString *stemCode;
///学习时长
@property(nonatomic, assign) NSInteger accumulativeTime;
///章节总时长
@property(nonatomic, assign) NSInteger videoTime;
///
@property(nonatomic, copy) NSDictionary *cws_param;
///
@property(nonatomic, copy) NSDictionary *mooc_param;

///标题
@property(nonatomic, copy) NSString *examName;
///分数
@property(nonatomic, copy) NSString *score;
///1已完成 0未完成
@property(nonatomic, assign) NSInteger state;

@end

NS_ASSUME_NONNULL_END
