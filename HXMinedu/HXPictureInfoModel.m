//
//  HXPictureInfoModel.m
//  HXMinedu
//
//  Created by 邓雄 on 2021/4/11.
//

#import "HXPictureInfoModel.h"

@implementation HXPictureInfoModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
        @"fileId" : @"id",
        @"fileTypeName" : @"fileType_name"        
    };
}

@end
