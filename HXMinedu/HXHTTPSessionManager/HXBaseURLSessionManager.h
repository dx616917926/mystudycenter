//
//  HXBaseURLSessionManager.h
//  HXCloudClass
//
//  Created by Mac on 2020/6/19.
//  Copyright © 2020 华夏大地教育网. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

NS_ASSUME_NONNULL_BEGIN

#define HXGET_TOKEN       @"/api/ApiLogin/Login"         //获取token

#define HXPOST_LOGIN       @"/MD/LoginInfo/Login"        //登录
#define HXPOST_STUINFO     @"/MD/StuInfo/getStuInfo"     //学生信息
#define HXPOST_LIVELIST    @"/MD/Live/getLiveList"       //直播地址
#define HXPOST_COURSELIST  @"/MD/StuCourse/getCourseList"//课程列表
#define HXPOST_MAJORLIST   @"/MD/StuInfo/geMajorList"    //获取学生专业
#define HXPOST_RESET_PWD   @"/MD/StuInfo/resetPassword"  //重置密码
#define HXPOST_SENDCODE    @"/MD/StuInfo/SendMsgVerificationCode"   //发送短信验证码
#define HXPOST_CWSLIST     @"/MD/StuCourse/getCourseDetailList"     //课件列表
#define HXPOST_EXAMLIST    @"/MD/StuCourse/getExamCourseList"       //考试列表

#define HXPOST_CHANGE_PWD           @"/MD/StuInfo/changePassword"         //修改密码
#define HXPOST_MESSAGE_COUNT        @"/MD/MessageInfo/GetMessageWDCount"  //未读消息数量
#define HXPOST_MESSAGE_LIST         @"/MD/MessageInfo/GetMessageList"     //消息列表
#define HXPOST_MESSAGE_UPDATE       @"/MD/MessageInfo/MessageUpdate"      //消息设置已读
#define HXPOST_MESSAGE_UPDATE_ALL   @"/MD/MessageInfo/MessageUpdateAll"   //消息全部设置已读

#define HXPOST_QUITE                @"/MD/ReturnBack/APPQuite"            //退出登录

#pragma mark - 新版增加接口
//获取报考类型专业列表
#define HXPOST_Get_Version_Major_List                         @"/MD/StuScoreInfo/getVersionAndMajorList"

//获取教学计划列表
#define HXPOST_Get_CourseScoreIn_List                         @"/MD/StuScoreInfo/getCourseScoreInfoList"

//获取课程列表
#define HXPOST_Get_Course_List                                @"/MD/StuCourse/getCourseList"

//获取报考课程列表
#define HXPOST_Get_ExamDateSignInfo_List                      @"/MD/StuScoreInfo/getExamDateSignInfoList"

//获取考试成绩列表
#define HXPOST_Get_ExamDateCourseScoreInfo_List               @"/MD/StuScoreInfo/getExamDateCourseScoreInfoList"

//获取学生专业
#define HXPOST_Get_MajorL_List                                 @"/MD/StuInfo/geMajorList"

//获取新生报名表单下载链接V2
#define HXPOST_Get_DownPdf                                 @"/MD/StuInfo/getDownPdfV2"

//获取学生图片信息V2
#define HXPOST_Get_StudentFile                                 @"/MD/StuInfo/getStudentFileV2"

//学生确认图片信息V2
#define HXPOST_UpdateStudentStatu                                @"/MD/StuInfo/UpdateStudentstatusV2"

//上传图片信息V2
#define HXPOST_UpdateStudentFile                               @"/MD/StuInfo/uploadStudentFileV2"

//获取隐私协议
#define HXPOST_Get_PrivacyUrl                                @"/MD/StuInfo/getPrivacyUrl"

//获取学习报告
#define HXPOST_Get_LearnReport                             @"/MD/StuInfo/getLearnReport"

//获取Banner和Logo
#define HXPOST_Get_BannerAndLogo                            @"/MD/StuInfo/getBannerAndLogo"

//获取应缴明细V2
#define HXPOST_Get_PayableDetails                          @"/MD/StuPayInfo/getPayableDetailsV2"

//获取已缴明细V2
#define HXPOST_Get_PaidDetails                           @"/MD/StuPayInfo/getPaidDetailsV2"

//获取订单详情V2
#define HXPOST_Get_PaidDetailsInfo                          @"/MD/StuPayInfo/getPaidDetailsInfoV2"

//确认订单信息V2
#define HXPOST_Get_ConfirmOrder                          @"/MD/StuPayInfo/ConfirmOrderV2"

//上传交易凭证V2
#define HXPOST_UploadProofFile                          @"/MD/StuPayInfo/uploadProofFileV2"

//获取登录状态
#define HXPOST_GetLoginStatus                          @"/MD/LoginInfo/getLoginStatus"

//获取班主任信息
#define HXPOST_GetHeadTeacherList                          @"/MD/StuInfo/getHeadTeacherList"

//获取学生退费信息
#define HXPOST_GetStudentRefundList                          @"/MD/StuInfo/GetStudentRefundList"

//获取学生退费详情
#define HXPOST_GetStudentRefundInfo                        @"/MD/StuInfo/GetStudentRefundInfo"

//学生退费信息确认或驳回
#define HXPOST_GetStudentRefundeConfirmOrReject            @"/MD/StuInfo/stuRefundConfirmOrReject"

//获取学生异动信息
#define HXPOST_GetStopStudyInfoList                          @"/MD/StopStudy/GetStopStudyInfoList"

//学生异动信息确认或驳回
#define HXPOST_StuStopConfirmOrReject                          @"/MD/StopStudy/stuStopConfirmOrReject"

//获取学生退学休学异动详情
#define HXPOST_GetStopStudyByTxAndXxInfo                          @"/MD/StopStudy/GetStopStudyByTxAndXxInfo"

//获取学生转专业转产品异动详情
#define HXPOST_GetStopStudyByZzyAndZcpInfo                         @"/MD/StopStudy/GetStopStudyByZzyAndZcpInfo"

//获取学生转专业转产品异动新专业详情
#define HXPOST_GetStopStudyByZzyAndZcpNewMajorInfo                 @"/MD/StopStudy/GetStopStudyByZzyAndZcpNewMajorInfo"

//获取学生已确认异动详情
#define HXPOST_GetStopStudyConfirmedInfo                            @"/MD/StopStudy/GetStopStudyConfirmedInfo"

@interface HXBaseURLSessionManager : AFHTTPSessionManager

/**
 @return HXBaseURLSessionManager
 */
+ (instancetype)sharedClient;

- (void)clearCookies;

/**
 登录请求
 */
+ (void)doLoginWithUserName:(NSString *)userName
                andPassword:(NSString *)pwd
                    success:(void (^)(NSDictionary* dictionary))success
                    failure:(void (^)(NSString *messsage))failure;

/**
 普通GET请求
 */
+ (void)getDataWithNSString:(NSString *)actionUrlStr
             withDictionary:(nullable NSDictionary *) nsDic
                    success:(void (^)(NSDictionary* dictionary))success
                    failure:(void (^)(NSError *error))failure;

/**
 普通POST请求
 */
+ (void)postDataWithNSString:(NSString *)actionUrlStr
              withDictionary:(nullable NSDictionary *) nsDic
                     success:(void (^)(NSDictionary* dictionary))success
                     failure:(void (^)(NSError *error))failure;

/**
 退出登录请求
 */
+ (void)doLogout;

@end

NS_ASSUME_NONNULL_END
