//
//  HXColumnItemModel.h
//  HXMinedu
//
//  Created by mac on 2021/10/9.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
NS_ASSUME_NONNULL_BEGIN

@interface HXColumnItemModel : NSObject
///内容ID
@property(nonatomic, strong) NSString *itemId;
///H5地址URL
@property(nonatomic, strong) NSString *url;
///1图片 展示图片      2链接 跳转链接
@property(nonatomic, assign) NSInteger aType;
////父菜单名称
@property(nonatomic, strong) NSString *pName;
////子菜单名称
@property(nonatomic, strong) NSString *name;
///创建时间
@property(nonatomic, strong) NSString *createTime;
///备注 有备注则展示
@property(nonatomic, strong) NSString *remarks;
///预览图
@property(nonatomic, strong) NSString *imgUrl;


@end

NS_ASSUME_NONNULL_END
