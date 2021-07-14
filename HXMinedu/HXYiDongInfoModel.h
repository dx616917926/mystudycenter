//
//  HXYiDongInfoModel.h
//  HXMinedu
//
//  Created by mac on 2021/7/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HXYiDongInfoModel : NSObject
///异动ID
@property(nonatomic, copy) NSString *stopStudyId;
///异动时间
@property(nonatomic, copy) NSString *stopTypeTime;
///异动类型 ：8001-休学         8002-退学      8005-转专业      8006-转产品
@property(nonatomic, assign) NSInteger stopType_id;
///异动名称
@property(nonatomic, copy) NSString *stopTypeName;
///异动备注
@property(nonatomic, copy) NSString *remark;
///审核时间
@property(nonatomic, copy) NSString *reviewertime;
///审核备注
@property(nonatomic, copy) NSString *reviewerremark;
///确认时间
@property(nonatomic, copy) NSString *rejecttime;
///确认备注
@property(nonatomic, copy) NSString *rejectremark;
///结转备注
@property(nonatomic, copy) NSString *costRemark;
///reviewstatus=2时显示确认意见 reviewstatus=4和5时显示确认意见和审核意见
@property(nonatomic, assign) NSInteger reviewstatus;
///
@property(nonatomic, assign) NSInteger isConfirm;

@end

NS_ASSUME_NONNULL_END
