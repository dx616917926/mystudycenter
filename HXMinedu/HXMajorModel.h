//
//  HXMajorModel.h
//  HXMinedu
//
//  Created by Mac on 2020/12/22.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

NS_ASSUME_NONNULL_BEGIN

@interface HXMajorModel : NSObject
//报考类型ID
@property(nonatomic, copy) NSString *versionId;
//分类
@property(nonatomic, assign) NSInteger type;
//专业ID
@property(nonatomic, strong) NSString *major_id;


//考生号
@property(nonatomic, copy) NSString *examineeNo;
//报考年级
@property(nonatomic, copy) NSString *enterDate;
//层次
@property(nonatomic, copy) NSString *educationName;
//报考学校
@property(nonatomic, copy) NSString *bkSchool;
//专业
@property(nonatomic, copy) NSString *majorName;
//学习形式
@property(nonatomic, copy) NSString *studyTypeName;
//档案标题
@property(nonatomic, copy) NSString *title;


//是否选中 默认否
@property(nonatomic, assign) BOOL isSelected;

@end

NS_ASSUME_NONNULL_END
