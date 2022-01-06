//
//  HXBannerLogoModel.h
//  HXMinedu
//
//  Created by mac on 2021/4/21.
//

#import <Foundation/Foundation.h>
#import "HXBannerModel.h"
#import "MJExtension.h"
NS_ASSUME_NONNULL_BEGIN

@interface HXBannerLogoModel : NSObject
///logoUrl
@property(nonatomic, copy) NSString *logoUrl;
///首页顶部logo
@property(nonatomic, copy) NSString *logoIndexUrl;
///课程资源URL
@property(nonatomic, copy) NSString *courseResourceUrl;
///t_BannerList_app
@property(nonatomic, strong) NSArray<HXBannerModel *> *bannerList;
@end

NS_ASSUME_NONNULL_END
