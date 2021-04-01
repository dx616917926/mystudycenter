//
//  HXVersionModel.m
//  HXMinedu
//
//  Created by 邓雄 on 2021/3/31.
//

#import "HXVersionModel.h"

@implementation HXVersionModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
        @"versionId" : @"version_id",
        @"majorList" : @"t_MajorList_app"
        
    };
}

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"majorList" : @"HXMajorModel"
             };
}
@end
