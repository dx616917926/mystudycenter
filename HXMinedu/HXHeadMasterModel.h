//
//  HXHeadMasterModel.h
//  HXMinedu
//
//  Created by mac on 2021/5/25.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
NS_ASSUME_NONNULL_BEGIN

@interface HXHeadMasterModel : NSObject
//班主任负责人
@property(nonatomic, copy) NSString *realName;
//手机
@property(nonatomic, copy) NSString *cellPhone;
//邮箱
@property(nonatomic, copy) NSString *email;
//机构二维码地址
@property(nonatomic, copy) NSString *imageUrl;
//标签数组
@property(nonatomic, strong) NSArray<NSDictionary *> *markList;

@end

NS_ASSUME_NONNULL_END
