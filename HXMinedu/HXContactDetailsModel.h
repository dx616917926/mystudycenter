//
//  HXContactDetailsModel.h
//  HXMinedu
//
//  Created by mac on 2022/8/25.
//

#import <Foundation/Foundation.h>
#import "HXContactModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HXContactDetailsModel : NSObject

//联系方式数组
@property(nonatomic, strong) NSArray<HXContactModel *> *contactDetailsList;
//联系邮箱数组
@property(nonatomic, strong) NSArray<HXContactModel *> *contactEmailList;
//投诉电话数组
@property(nonatomic, strong) NSArray<HXContactModel *> *complaintNumberList;

@end

NS_ASSUME_NONNULL_END
