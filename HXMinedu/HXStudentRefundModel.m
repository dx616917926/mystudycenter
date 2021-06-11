//
//  HXStudentRefundModel.m
//  HXMinedu
//
//  Created by mac on 2021/6/9.
//

#import "HXStudentRefundModel.h"

@implementation HXStudentRefundModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
        @"refundId" : @"id"
    };
}
@end
