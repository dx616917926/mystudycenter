//
//  HXLearnRecordModel.h
//  HXMinedu
//
//  Created by mac on 2021/5/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HXLearnRecordModel : NSObject
//课程名称
@property(nonatomic, strong) NSString *courseName;
//标签
@property(nonatomic, strong) NSString *mark1;
//课程图片url
@property(nonatomic, strong) NSString *imgUrl;
//总时间
@property(nonatomic, assign) NSInteger learnTime;
//已学时间
@property(nonatomic, assign) NSInteger learnDuration;
//新课件系统的参数
@property(nonatomic, strong) NSDictionary *cws_param;
//慕课课件系统的参数
@property(nonatomic, strong) NSDictionary *mooc_param;
//MOOC为慕课课程
@property(nonatomic, strong) NSString *StemCode;
//课程包
@property(nonatomic, strong) NSString *Revision;
//章节
@property(nonatomic, strong) NSString *CatalogTitle;
//开课ID
@property(nonatomic, strong) NSString *studentCourseID;

@end

NS_ASSUME_NONNULL_END
