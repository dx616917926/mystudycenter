//
//  HXElectronicDataModel.h
//  HXMinedu
//
//  Created by mac on 2022/4/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HXElectronicDataModel : NSObject
///时间
@property(nonatomic,copy) NSString *AddTime;
///文件名
@property(nonatomic,copy) NSString *FileName;
///文件大小B
@property(nonatomic,assign) float FileSize;
///文件地址
@property(nonatomic,copy) NSString *FileUrl;
///文件后缀名
@property(nonatomic,copy) NSString *Suffix;
///时间
@property(nonatomic,copy) NSString *AddTimeText;

@end

NS_ASSUME_NONNULL_END
