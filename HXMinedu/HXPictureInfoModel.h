//
//  HXPictureInfoModel.h
//  HXMinedu
//
//  Created by 邓雄 on 2021/4/11.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
NS_ASSUME_NONNULL_BEGIN

@interface HXPictureInfoModel : NSObject
///类型id
@property(nonatomic, copy) NSString *fileId;
///上传类型id
@property(nonatomic, copy) NSString *fileTypeId;
///姓名
@property(nonatomic, copy) NSString *name;
//图片地址
@property(nonatomic, copy) NSString *imgurl;
//类型名称
@property(nonatomic, copy) NSString *fileTypeName;
//状态 0:待上传 1:已上传
@property(nonatomic, assign) NSInteger status;
///状态提示：未上传    待确认   待确认
@property(nonatomic, copy) NSString *statusText;
//学生确认状态 0:未确认  1：已确认
@property(nonatomic, assign) NSInteger studentstatus;
//备注
@property(nonatomic, copy) NSString *remark;

//考生号
@end

NS_ASSUME_NONNULL_END
