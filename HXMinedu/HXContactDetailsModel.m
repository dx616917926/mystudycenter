//
//  HXContactDetailsModel.m
//  HXMinedu
//
//  Created by mac on 2022/8/25.
//

#import "HXContactDetailsModel.h"

@implementation HXContactDetailsModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
        @"contactDetailsList" : @"t_ContactDetails",
        @"contactEmailList" : @"t_ContactEmail",
        @"complaintNumberList" : @"t_ComplaintNumber"
        
    };
}

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"contactDetailsList" : @"HXContactModel",
             @"contactEmailList" : @"HXContactModel",
             @"complaintNumberList" : @"HXContactModel"
             };
}

@end
