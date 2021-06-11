//
//  HXRegistFormModel.h
//  HXMinedu
//
//  Created by mac on 2021/6/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HXRegistFormModel : NSObject
///年级 2021秋
@property(nonatomic, copy) NSString *enterDate;
///层次  专升本
@property(nonatomic, copy) NSString *educationName;
///专业  金融学
@property(nonatomic, copy) NSString *majorName;
///报考类型  网络教育
@property(nonatomic, copy) NSString *versionName;
///报考学校  对外经济贸易大学
@property(nonatomic, copy) NSString *bkSchool;
///表单下载地址url  
@property(nonatomic, copy) NSString *url;
@end

NS_ASSUME_NONNULL_END
