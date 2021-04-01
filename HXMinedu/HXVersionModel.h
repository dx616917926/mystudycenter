//
//  HXVersionModel.h
//  HXMinedu
//
//  Created by 邓雄 on 2021/3/31.
//

#import <Foundation/Foundation.h>
#import "HXMajorModel.h"
#import "MJExtension.h"

NS_ASSUME_NONNULL_BEGIN

@interface HXVersionModel : NSObject
//报考类型ID
@property(nonatomic, copy) NSString *versionId;
//报考类型名称
@property(nonatomic, copy) NSString *versionName;
//分类 
@property(nonatomic, assign) NSInteger type;
//专业数组
@property(nonatomic, strong) NSArray<HXMajorModel *> *majorList;

//是否选中 默认否
@property(nonatomic, assign) BOOL isSelected;

@end

NS_ASSUME_NONNULL_END
