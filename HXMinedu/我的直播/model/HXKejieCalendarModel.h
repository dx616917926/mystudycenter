//
//  HXKejieCalendarModel.h
//  HXMinedu
//
//  Created by mac on 2022/8/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HXKejieCalendarModel : NSObject

///日期
@property(nonatomic, strong) NSString *Date;
///数量
@property(nonatomic, assign) NSInteger Qty;
///是否本月 1是   0否
@property(nonatomic, assign) NSInteger IsMonth;
///是否选中
@property(nonatomic, assign) BOOL IsSelect;

@end

NS_ASSUME_NONNULL_END
