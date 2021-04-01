//
//  HXTeachPlanModel.h
//  HXMinedu
//
//  Created by mac on 2021/3/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HXTeachPlanModel : NSObject
@property(nonatomic,copy) NSString *title;
@property(nonatomic,assign) NSInteger num;
//是否展开，默认 否
@property(nonatomic,assign) BOOL isExpand;

@end

NS_ASSUME_NONNULL_END
