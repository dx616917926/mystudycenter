//
//  HXStudentPaperModel.h
//  HXMinedu
//
//  Created by mac on 2022/1/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HXStudentPaperModel : NSObject
///是否可以上传 1可以  0不可以
@property(nonatomic,assign) NSInteger IsUpload;
///1001成考  1002自考  1003国开   1004网教    1005职业资格   1006全日制   version_id大于0代表着有数据显示数据，等于0代表没有数据显示上传
@property(nonatomic,copy) NSString *version_id;
///考期
@property(nonatomic,copy) NSString *enterDate;
///高升专
@property(nonatomic,copy) NSString *educationName;
///报考学校
@property(nonatomic,copy) NSString *BkSchool;
///专业
@property(nonatomic,copy) NSString *majorName;
///专业id
@property(nonatomic,copy) NSString *major_id;
///论文下载地址
@property(nonatomic,copy) NSString *paperUrl;
///1 我已答辩   0则用时间判断是否开始或结束
@property(nonatomic,assign) NSInteger defenseStatus;
///开始时间
@property(nonatomic,copy) NSString *defenseBDateText;
///结束时间
@property(nonatomic,copy) NSString *defenseEDateText;
///答辩地点
@property(nonatomic,copy) NSString *defenseAddr;
///答辩类型
@property(nonatomic,copy) NSString *defenseType;

@end

NS_ASSUME_NONNULL_END
