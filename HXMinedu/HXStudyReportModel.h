//
//  HXStudyReportModel.h
//  HXMinedu
//
//  Created by mac on 2021/4/12.
//

#import <Foundation/Foundation.h>
#import "HXCourseDetailModel.h"
#import "MJExtension.h"

NS_ASSUME_NONNULL_BEGIN

@interface HXStudyReportModel : NSObject
//姓名
@property(nonatomic, copy) NSString *name;
//生成时间
@property(nonatomic, copy) NSString *buildTime;
//关键词
@property(nonatomic, copy) NSString *keyWords;
//标签1
@property(nonatomic, copy) NSString *mark1;
//标签2
@property(nonatomic, copy) NSString *mark2;
//名言
@property(nonatomic, copy) NSString *remarks;
//课件学习 时间
@property(nonatomic, copy) NSString *kjxx;
//知识测评 最高分
@property(nonatomic, copy) NSString *zscp;
//平时作业 最高分
@property(nonatomic, copy) NSString *pszy;
//课件学习数组
@property(nonatomic, strong) NSArray<HXCourseDetailModel *> *kjxxCourseList;
//知识点测评数组
@property(nonatomic, strong) NSArray<HXCourseDetailModel *> *zscpCourseList;
//平时作业数组
@property(nonatomic, strong) NSArray<HXCourseDetailModel *> *pszyCourseList;

@end

NS_ASSUME_NONNULL_END