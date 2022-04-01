//
//  HXExamSessionManager.h
//  HXCloudClass
//
//  Created by Mac on 2020/8/27.
//  Copyright © 2020 华夏大地教育网. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

NS_ASSUME_NONNULL_BEGIN

#define HXEXAM_MODULES_LIST @"/exam-admin/home/module/exams/mobile/code/%@"  //{moduleCode}  班级里已开通模块

#define HXEXAM_ANSWER  @"/student/exam/answer/"  //    下载正确答案   {basePath}+”/student/exam/answer/”+{userExamId}

#define HXEXAM_MYANSWER  @"/student/exam/myanswer/list/"  //    下载用户以前的答案 在设置题目导航面板时，可进行已做题目的标识    {basePath}+”/student/exam/myanswer/list/”+{userExamId}

#define HXEXAM_SUBMIT  @"/student/exam/submit/"  //    提交试卷（确保试卷提交成功，并通过下方的考试结束的接口来得到考试的结果信息）    {basePath}+“/student/exam/submit/”+userExamId

#define HXEXAM_FINISHED  @"/student/exam/finished/json/"  //考试结束，得到考试之后的试卷结果   {basePath}+“/student/exam/finished/json/”+{userExamId}

#define HXEXAM_MYANSWER_SAVE  @"/student/exam/myanswer/save/"  // 保存答案：在回答试卷的时候，每答一道题都会将该题的信息保存下来（题目的id，试卷和题目的关联id（paperSuitQuestionId），还有answer），在回答下一道题的时候会将这道题提交（并且当clientjudge为true时，要进行客户端判卷，用 考试试卷 中 下载正确答案 接口的数据 进行对比，得到分数）     {basePath}+“/student/exam/myanswer/save/”+{userExamId}+”/”+questionId

#define HXPOST_ANSWER_FILE  @"/student/exam/question/attaches/upload/filePath/form/"  //把问题附件上传到临时服务器，返回一个tempFIleName 路径值。

#define HXMODULE_EXAMS_LIST  @"/exam-admin/home/my/module/exams/list/"  //1.    获取模块考试数据   +page +”?”+ param +”&pageCount=”+ pageCount

#define HXMODULE_EXAMS_LIST_FREE  @"/exam-admin/home/free/module/exams/list/"  //1.    获取模块考试数据   +page +”?”+ param +”&pageCount=”+ pageCount

#define HXMY_EXAM_RESULT_JSON  @"/exam-admin/home/my/exam/view/result/json/"  //2.  用于查看考试记录时判断考试信息是否过期      +examId

#define HXEXAM_START_JSON  @"/exam-admin/home/my/exam/start/json/%@?credit=true&site_preference=mobile&ct=client"  //3.  用于考试数据的初始化，得到考试试卷和考试服务器的url      examId ---- 考试模块id

#define HXEXAM_RESTART  @"/exam-admin/home/my/exam/restart/json/%@?credit=true&site_preference=mobile&ct=client"  //1.继续考试,在考试记录中，要继续考试时，用这个接口判断是否可以继续考试 如果success为true时，则可以继续考试   +{examId}

#define HXEXAM_RESULT_JSON  @"/exam-admin/home/my/exam/view/result/json/"  //2.考试记录数据   +{examId}

#define HXEXAM_RESET_COOKIE @"/student/exam/resource/jsession"  //给wkwebview重置cookie

#define HXEXAM_ERROR_REPORT @"/exam-admin/feedback/addFeedbackForm"  //提交错题反馈

//EXAM
#define MY_EXAM_BUNDLE_NAME @"statics.bundle"
#define MY_EXAM_BUNDLE_PATH [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:MY_EXAM_BUNDLE_NAME]

//根据授权地址获取
#define ExamBaseUrl [[HXExamSessionManager sharedClient] baseUrlAbsoluteString]


@interface HXExamSessionManager : AFHTTPSessionManager

/**
 @return HXExamSessionManager
 */
+ (instancetype)sharedClient;

//清除cookies
-(void)clearCookies;

//手动设置baseURL
-(void)setBaseUrl:(NSString *)url;

//得到baseURL
-(NSString *)baseUrlAbsoluteString;

/**
 普通GET请求
 */
+ (void)getDataWithNSString : (NSString *)actionUrlStr
             withDictionary : (nullable NSDictionary *) nsDic
                    success : (void (^)(NSDictionary* dictionary))success
                    failure : (void (^)(NSError *error))failure;

/**
 普通POST请求
 */
+ (void)postDataWithNSString : (NSString *)actionUrlStr
              withDictionary : (nullable NSDictionary *) nsDic
                     success : (void (^)(NSDictionary* dictionary))success
                     failure : (void (^)(NSError *error))failure;

/**
 获取考试数据
 */
+ (void)getDataWithExamId:(NSString *)examid
                  success:(void (^)(NSDictionary * dic))success
                  failure:(void (^)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
