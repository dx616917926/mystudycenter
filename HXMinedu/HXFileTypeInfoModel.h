//
//  HXFileTypeInfoModel.h
//  HXMinedu
//
//  Created by mac on 2021/12/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HXFileTypeInfoModel : NSObject
///资料名称
@property(nonatomic,copy) NSString *reserve;
////应上传条数
@property(nonatomic,assign) NSInteger count;
///已上传条数
@property(nonatomic,assign) NSInteger stuFileCount;
///待确认条数
@property(nonatomic,assign) NSInteger dqrCount;
///状态： 1待完善 2待确认 3已完善
@property(nonatomic,assign) NSInteger status;

@end

NS_ASSUME_NONNULL_END
