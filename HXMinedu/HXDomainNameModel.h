//
//  HXDomainNameModel.h
//  HXMinedu
//
//  Created by mac on 2022/3/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HXDomainNameModel : NSObject
//身份证ID
@property(nonatomic, copy) NSString *PersonId;
//域名
@property(nonatomic, copy) NSString *DomainName;
//机构名
@property(nonatomic, copy) NSString *OzName;
//机构logo
@property(nonatomic, copy) NSString *LogoUrl;

@end

NS_ASSUME_NONNULL_END
