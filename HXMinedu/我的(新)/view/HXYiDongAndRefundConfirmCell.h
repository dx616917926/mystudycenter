//
//  HXYiDongAndRefundConfirmCell.h
//  HXMinedu
//
//  Created by mac on 2021/6/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    HXYiDongConfirmType = 1,//异动确认
    HXRefundConfirmType= 2//退费确认
} HXConfirmType;

@interface HXYiDongAndRefundConfirmCell : UITableViewCell

@property(nonatomic,assign) HXConfirmType confirmType;

@end

NS_ASSUME_NONNULL_END
