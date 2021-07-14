//
//  HXMajorInfoModel.h
//  HXMinedu
//
//  Created by mac on 2021/7/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HXMajorInfoModel : NSObject

///标题
@property(nonatomic, copy) NSString *title;
///学校
@property(nonatomic, copy) NSString *BkSchool;
///专业
@property(nonatomic, copy) NSString *majorName;

///是否是新专业
@property(nonatomic, assign) BOOL isRecent;

@end

NS_ASSUME_NONNULL_END
