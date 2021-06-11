//
//  HXStudentFileModel.h
//  HXMinedu
//
//  Created by mac on 2021/6/9.
//

#import <Foundation/Foundation.h>
#import "HXPictureInfoModel.h"
#import "MJExtension.h"
NS_ASSUME_NONNULL_BEGIN

@interface HXStudentFileModel : NSObject
///标题
@property(nonatomic, copy) NSString *title;
///t_BannerList_app
@property(nonatomic, strong) NSArray<HXPictureInfoModel *> *studentFileInfoList;
@end

NS_ASSUME_NONNULL_END
