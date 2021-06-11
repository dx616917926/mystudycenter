//
//  HXStudentFileModel.m
//  HXMinedu
//
//  Created by mac on 2021/6/9.
//

#import "HXStudentFileModel.h"

@implementation HXStudentFileModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
        @"studentFileInfoList" : @"t_StudentFileInfo_app"
        
    };
}

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"studentFileInfoList" : @"HXPictureInfoModel"
             };
}
@end
