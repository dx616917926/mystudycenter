//
//  HXColumnItemModel.m
//  HXMinedu
//
//  Created by mac on 2021/10/9.
//

#import "HXColumnItemModel.h"

@implementation HXColumnItemModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
        @"itemId" : @"id"
    };
}
@end
