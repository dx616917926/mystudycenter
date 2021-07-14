//
//  HXStudentYiDongModel.h
//  HXMinedu
//
//  Created by mac on 2021/7/8.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

NS_ASSUME_NONNULL_BEGIN

@interface HXStudentYiDongModel : NSObject
///异动ID
@property(nonatomic, copy) NSString *stopStudyId;
///异动时间
@property(nonatomic, copy) NSString *stopTypeTime;
///异动类型 ：8001-休学         8002-退学      8005-转专业      8006-转产品
@property(nonatomic, assign) NSInteger stopType_id;
///异动名称
@property(nonatomic, copy) NSString *stopTypeName;
///姓名
@property(nonatomic, copy) NSString *name;
///标题
@property(nonatomic, copy) NSString *title;
///0-待确认           1-已确认         2-审核中     3-待终审       4-已同意       5-已驳回
///0-时不显示任何标签   1-时显示审核中   4-时显示已通过       5-时不显示标签
@property(nonatomic, assign) NSInteger reviewStatus;
///状态
@property(nonatomic, copy) NSString *reviewStatusName;
///
@property(nonatomic, assign) NSInteger isConfirm;

@end

NS_ASSUME_NONNULL_END
