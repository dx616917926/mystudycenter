//
//  HXStudentRefundModel.h
//  HXMinedu
//
//  Created by mac on 2021/6/9.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

NS_ASSUME_NONNULL_BEGIN

@interface HXStudentRefundModel : NSObject
///退费id
@property(nonatomic, copy) NSString *refundId;
///时间
@property(nonatomic, copy) NSString *createtime;
///退学退费
@property(nonatomic, copy) NSString *refundTypeName;
///姓名
@property(nonatomic, copy) NSString *name;
///标题
@property(nonatomic, copy) NSString *title;

///0-待确认           1-确认无误      2和4-已退费            3和5-已驳回
///0-时不显示任何标签   1-时显示审核中   2和4-时显示已通过       3和5-时不显示标签
@property(nonatomic, assign) NSInteger reviewStatus;
///状态
@property(nonatomic, copy) NSString *reviewStatusName;

@end

NS_ASSUME_NONNULL_END
