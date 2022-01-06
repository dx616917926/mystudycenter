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
///报考类型ID
@property(nonatomic,copy) NSString *version_id;
///报考专业
@property(nonatomic,copy) NSString *majorName;
///报考专业ID
@property(nonatomic,copy) NSString *major_id;
///
@property(nonatomic,copy) NSString *text;
///
@property(nonatomic,copy) NSString *value;
///内容
@property(nonatomic,copy) NSString *content;
///是否选中
@property(nonatomic,assign) BOOL isSelected;

@end

NS_ASSUME_NONNULL_END
