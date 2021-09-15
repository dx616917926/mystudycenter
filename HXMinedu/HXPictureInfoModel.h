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
//专业名称
@property(nonatomic, copy) NSString *majorName;
//状态 0:待上传 1:已上传  //0.待上传  1.待确认  2.待审核  3.审核不通过  4.审核通过 只有待确认和审核不通过时可以修改照片
@property(nonatomic, assign) NSInteger status;
///状态提示：未上传    待确认   待确认
@property(nonatomic, copy) NSString *statusText;
//学生确认状态 0:未确认  1：已确认
@property(nonatomic, assign) NSInteger studentstatus;
//备注
@property(nonatomic, copy) NSString *remark;
//等于2时不允许上传图片
@property(nonatomic, assign) NSInteger attr;
//专业ID
@property(nonatomic, copy) NSString *major_id;
//类别ID
@property(nonatomic, copy) NSString *version_id;

@end

NS_ASSUME_NONNULL_END
