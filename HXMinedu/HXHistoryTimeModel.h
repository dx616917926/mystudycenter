//
//  HXHistoryTimeModel.h
//  HXMinedu
//
//  Created by mac on 2021/7/29.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

@interface HXHistoryTimeModel : NSObject

//时间
@property(nonatomic, copy) NSString *createDate;

//是否选中 默认否
@property(nonatomic, assign) BOOL isSelected;

@end

NS_ASSUME_NONNULL_END
