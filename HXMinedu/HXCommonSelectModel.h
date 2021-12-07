//
//  HXCommonSelectModel.h
//  HXXiaoGuan
//
//  Created by mac on 2021/6/28.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

NS_ASSUME_NONNULL_BEGIN

@interface HXCommonSelectModel : NSObject
///
@property(nonatomic,assign) NSInteger type;

@property(nonatomic,copy) NSString *name;
///报考类型ID
@property(nonatomic,copy) NSString *versionId;
///报考类型
@property(nonatomic,copy) NSString *versionName;
///学校归属地
@property(nonatomic,copy) NSString *province;
///年级/版本
@property(nonatomic,copy) NSString *enterDate;
///报考学校
@property(nonatomic,copy) NSString *BkSchool;
///报考学校ID
@property(nonatomic,copy) NSString *BkSchoolId;
///学习形式/报考层次
@property(nonatomic,copy) NSString *studyTypeName;
///学习形式/报考层次ID
@property(nonatomic,copy) NSString *studyTypeId;
///报考专业
@property(nonatomic,copy) NSString *majorLongName;
///报考专业ID
@property(nonatomic,copy) NSString *major_id;
///分校
@property(nonatomic,copy) NSString *orgName;
///分校ID
@property(nonatomic,copy) NSString *orgId;
///线索来源
@property(nonatomic,copy) NSString *sourceName;
///线索来源ID
@property(nonatomic,copy) NSString *sourceId;
///民族、学校归属地、政治面貌、学历
@property(nonatomic,copy) NSString *text;
///民族、学校归属地、政治面貌、学历ID
@property(nonatomic,copy) NSString *value;
///内容
@property(nonatomic,copy) NSString *content;
///是否选中
@property(nonatomic,assign) BOOL isSelected;

@end

NS_ASSUME_NONNULL_END
