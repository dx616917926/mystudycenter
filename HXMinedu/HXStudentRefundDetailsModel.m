//
//  HXStudentRefundDetailsModel.m
//  HXMinedu
//
//  Created by mac on 2021/6/9.
//

#import "HXStudentRefundDetailsModel.h"

@implementation HXStudentRefundDetailsModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
        @"refundId" : @"id",
        @"studentRefundInfoList" : @"t_StudentRefundInfoList_app"
        
    };
}

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"studentRefundInfoList" : @"HXPaymentDetailModel"
             };
}


-(NSArray *)appendixList{
    NSMutableArray *appendixArray = [NSMutableArray array];
    if (![HXCommonUtil isNull:self.appendix1]) {
        [appendixArray addObject:self.appendix1];
    }
    if (![HXCommonUtil isNull:self.appendix2]) {
        [appendixArray addObject:self.appendix2];
    }
    if (![HXCommonUtil isNull:self.appendix3]) {
        [appendixArray addObject:self.appendix3];
    }
    if (![HXCommonUtil isNull:self.appendix4]) {
        [appendixArray addObject:self.appendix4];
    }
    return appendixArray;
}
@end
