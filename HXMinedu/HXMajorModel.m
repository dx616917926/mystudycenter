//
//  HXMajorModel.m
//  HXMinedu
//
//  Created by Mac on 2020/12/22.
//

#import "HXMajorModel.h"

@implementation HXMajorModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
        @"versionId" : @"version_id",
        @"bkSchool" : @"BkSchool",
             
    };
}
@end
