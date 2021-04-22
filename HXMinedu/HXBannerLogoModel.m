//
//  HXBannerLogoModel.m
//  HXMinedu
//
//  Created by mac on 2021/4/21.
//

#import "HXBannerLogoModel.h"

@implementation HXBannerLogoModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
        @"bannerList" : @"t_BannerList_app"
        
    };
}

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"bannerList" : @"HXBannerModel"
             };
}

@end
