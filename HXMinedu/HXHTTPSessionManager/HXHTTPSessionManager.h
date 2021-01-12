//
//  HXHTTPSessionManager.h
//  gk_anhui
//
//  Created by iMac on 2016/11/16.
//  Copyright © 2016年 华夏大地教育网. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

//
#define HXCLAZZES_LIST @"/lms/home/my/app/clazz/clazzes/json/1/10000"  //加载在学课程的班级

#define HXSUBCLAZZES_LIST @"/lms/home/my/app/clazz/subclazzes/%@/json"  //加载项目班下的子班数据

#define HXSCORES_JSON  @"/lms/home/my/clazz/%@/scores/json"  //班级成绩及各课程分数  为班级ID

#define HXMODULE_DETAILS_JSON  @"/lms/home/my/clazz/%@/score/module/details/%@/json"  //计分规则  ”+{clazzId}+”  ”+{refId}+”  clazzId :clazzId为班级ID    refId： refId 为   成绩单中   接口班级成绩及各课程分数中的refId的值

#define HXCLAZZES_FINISH_LIST  @"/lms/home/my/clazzes/list/1?_ajax=true&_closed=true&pageCount=1000"  //已学课程

//EXAM
#define HXEXAM_MODULES_LIST @"/exam-admin/home/module/exams/mobile/code/%@"  //{moduleCode}  班级里已开通模块

#define HXEXAM_ANSWER  @"/student/exam/answer/"  //	下载正确答案   {basePath}+”/student/exam/answer/”+{userExamId}

#define HXEXAM_MYANSWER  @"/student/exam/myanswer/list/"  //	下载用户以前的答案 在设置题目导航面板时，可进行已做题目的标识    {basePath}+”/student/exam/myanswer/list/”+{userExamId}

#define HXEXAM_SUBMIT  @"/student/exam/submit/"  //	提交试卷（确保试卷提交成功，并通过下方的考试结束的接口来得到考试的结果信息）    {basePath}+“/student/exam/submit/”+userExamId

#define HXEXAM_FINISHED  @"/student/exam/finished/json/"  //考试结束，得到考试之后的试卷结果   {basePath}+“/student/exam/finished/json/”+{userExamId}

#define HXEXAM_MYANSWER_SAVE  @"/student/exam/myanswer/save/"  // 保存答案：在回答试卷的时候，每答一道题都会将该题的信息保存下来（题目的id，试卷和题目的关联id（paperSuitQuestionId），还有answer），在回答下一道题的时候会将这道题提交（并且当clientjudge为true时，要进行客户端判卷，用 考试试卷 中 下载正确答案 接口的数据 进行对比，得到分数）     {basePath}+“/student/exam/myanswer/save/”+{userExamId}+”/”+questionId

#define HXPOST_ANSWER_FILE  @"/student/exam/question/attaches/upload/filePath/form/"  //把问题附件上传到临时服务器，返回一个tempFIleName 路径值。

#define HXMODULE_EXAMS_LIST  @"/exam-admin/home/my/module/exams/list/"  //1.	获取模块考试数据   +page +”?”+ param +”&pageCount=”+ pageCount

#define HXMODULE_EXAMS_LIST_FREE  @"/exam-admin/home/free/module/exams/list/"  //1.	获取模块考试数据   +page +”?”+ param +”&pageCount=”+ pageCount

#define HXMY_EXAM_RESULT_JSON  @"/exam-admin/home/my/exam/view/result/json/"  //2.  用于查看考试记录时判断考试信息是否过期      +examId

#define HXEXAM_START_JSON  @"/exam-admin/home/my/exam/start/json/%@?credit=true&site_preference=mobile&ct=client"  //3.  用于考试数据的初始化，得到考试试卷和考试服务器的url      examId ---- 考试模块id

#define HXEXAM_RESTART  @"/exam-admin/home/my/exam/restart/json/%@?credit=true&site_preference=mobile&ct=client"  //1.继续考试,在考试记录中，要继续考试时，用这个接口判断是否可以继续考试 如果success为true时，则可以继续考试   +{examId}

#define HXEXAM_RESULT_JSON  @"/exam-admin/home/my/exam/view/result/json/"  //2.考试记录数据   +{examId}

#define HXEXAM_RESET_COOKIE @"/student/exam/resource/jsession"  //给wkwebview重置cookie

//QA
#define HXQA_MODULES_LIST @"/qa/home/room/mobile/questions/code/%@?page=%d&pageCount=%d&which=%@"  //{roomCode}  班级里已开通模块

#define HXQA_ROOM_QUESTIONS  @"/qa/home/room/questions/list/"  //获取当前答疑室下的问题数据 {page}?pageCount={pageCount}&_roomId={roomId}&_keywords={keywords }&_which={ which }&_isManager={ isManager }&_classic={classic }

//单附件和多附件下载和上传
#define HXGET_QUESTION_FILE  @"/qa/home/room/attach/question/image/"  //问题附件只包含一个，或图片或文件，下载时地址是相同的 questioned：问题id

#define HXGET_ANSWER_FILES  @"/qa/home/room/attach/answer/image/"  //回答附件可能包含一个或多个，具体由所在答疑室的用户权限而定（详情看回答返回json说明）。下载附件时的参数根据所在答疑室用户权限而定（userType） Answered:回答的ID  Id：附件id;如果userType =1或2，id 为attachFileList字段中返回数组对应的索引值 else userType ==3 id= answered

#define HXPOST_QUESTION_FILE  @"/qa/home/room/question/new/upload/file/form/"  //把问题附件上传到临时服务器，返回一个tempFIleName 路径值。该值用来提交问题或回答时post附件的值为tempFIleName字段值/附件名  roomed:答疑室ID

#define HXPOST_ANSWER_FILE_QA  @"/qa/home/room/question/answer/upload/attachFileList/form/"  //把问题附件上传到临时服务器，返回一个tempFIleName 路径值。该值用来提交问题或回答时post附件的值为tempFIleName字段值/附件名  questioned：问题ID

//客户端用户提问模块
//这个是POST请求
#define HXCLIENT_QUESTION_SAVE @"/qa/home/room/question/new/save/"  //把用户提问的问题上传到服务器  _roomId：答疑室ID title：问题标题 content：问题描述

//这个是POST请求
#define HXSEARCH_SAMES @"/qa/home/room/question/new/sames/json"  //提问时根据所输入的关键字搜索相关问题  roomId ：答疑室ID _keyword ：搜索关键字

//这个是POST请求
#define HXADD_QUESTION @"/qa/home/room/question/new/save?"  //把用户对当前问题追加的问题提交到服务器  roomId ：答疑室ID questioned ：问题ID title：问题标题 content：问题描述

//这个是POST请求
#define HXSET_CLASSIC @"/qa/home/room/question/updateclassic/%@"  //设置问题为精选问题{questionId}   questioned：问题Id  comments: 设置精选的内容

//get
#define HXUNSET_CLASSIC @"/qa/home/room/question/updateclassic/%@?site_preference=mobile&ct=client&_act=0"  //取消精选问题{questionId}   questioned：问题Id

//回复列表
#define HXGET_REPLYS_LIST  @"/qa/home/room/question/answer/replys/list/%d?pageCount=%@&_parentId=%@"  //获取回复列表数据 Page ：加载数据的页码 answerId：回答id

#define HXGET_REPLYS_COUNT  @"/qa/home/room/question/answer/replys/count?_parentId=%@"  //获取回复数据的总个数 answerId：问题ID

//这个是POST请求
#define HXANSWER_REPLY  @"/qa/home/room/question/answer/replys/save/"  //回复回答或者对回复进行回复 content ：回复的内容replyId：问题ID replyAccountId：被回复人的账号ID replyAccountAlias：被回复人的账号

#define HXDEL_REPLY  @"/qa/home/room/question/answer/replys/del/%@"  //删除某一条回复 Id ：当前回复的id

//问题下的回答列表
#define HXSEE_QUESTION  @"/qa/home/room/question/%@/json"  //查看问题的基本信息，包括标题，时间、点评、追加问题信息  questionId ：问题ID

#define HXDEL_ANSWER  @"/qa/home/room/question/answer/del/%@/?__ajax=true&_questionId=%@"  //删除问题列表下的某一个回答 answered ：当前回答的ID  questionId：问题ID
#define HXSET_ANSWER_GOOD  @"/qa/home/room/question/answer/update2good/%@"  //把某一回答设置为推荐回答 answered ：回答的ID

//这个是POST请求
#define HXSAVE_ANSWER  @"/qa/home/room/question/answer/save/"  //对问题进行回答，提交到服务器   questioned:问题ID

#define HXSAVE_VOTE @"/qa/home/room/question/answer/vote/%@" //问题id，参数_choices 选项  用;隔开

#define HXGET_ANSWER_LIST  @"/qa/home/room/question/answer/list/%d?pageCount=%@&_questionId=%@"  //获取回答列表的数据  Page ：加载数据的页码  pageCount：每页加载数据的条数  questionId：问题ID
#define HXGET_GOASK_LIST @"/qa/home/room/question/%@/appendquestions/list/%@?pageCount=%@" //获取追问列表的数据 questionId：问题ID  Page ：加载数据的页码  pageCount：每页加载数据的条数

#define HXGET_VOTE_PERSON_LIST  @"/qa/home/room/question/choice/users/%@/%@/json?offset=%d&count=%d"  //获取投票人列表的数据 questionId：问题ID   questionChoiceId:选项id   offset ：加载数据的页码  count：每页加载数据的条数

#define HXMYROOM_MESSAGES_DEL  @"/qa/home/room/questions/del/"  //删除答疑室下问题  {questionId}?__ajax=true&_roomId={roomId}&_isManager={isManager }&_keywords=&_which=latest  questioned：问题ID  roomId：答疑室ID  isManager：是否具有管理权限

#define HXQASEARCH_SUGGEST @"/qa/home/room/questions/keywords"//qa搜索建议 _keyword={keyword}&_roomId={roomId}

#define HXQASEARCH_SEARCH @"/qa/home/room/mobile/questions/code/%@"//qz搜索  {clazzId}?page={offset}&pageCount={count}&keywords={}

//CWS


//7.3、大视频和三分屏的目录列表
#define HXRUNTIME_MANIFEST_XML @"/cws/home/couresware/runtime/manifest/xml?site_preference=mobile&ct=client"  //1.课件目录列表---获取课件目录。请求前需要进行初始化课件，返回数据为xml，解析xml得到课件目录。

#define HXRUNTIME_SCO_RECORDS @"/cws/home/couresware/runtime/sco/records?site_preference=mobile&ct=client"  //2.课件学习记录---获取用户课件目录对应的学习记录数据。请求前需要对课件进行初始化。

//7.4、
#define HXPLAY_VIDEO_INFO @"/cws/home/couresware/play/video/info/%@?site_preference=mobile&ct=client"  //大视频播放---获取大视频的视频信息。请求前需要对视频进行初始化  {videoId}

//7.5、三分屏课件播放和下载
#define HXRUNTIME_AUTH_TOKEN  @"/cws/home/couresware/runtime/auth/token/"  //三分屏课件在线播放和下载都要对视频进行初始化，并请求token数据，服务端回返的json数据要拼接到三分屏音频地址后。

//7.6、保存学习记录
#define HXRUNTIME_RECORD_SAVE @"/cws/home/couresware/runtime/record/save/"  //保存大视频和三分屏的学习记录，包括学习时间和完成状态。请求前必须初始化


//7.7、大视频和音频初始化
#define HXCOURESWARE_PLAY_JSON  @"/cws/home/couresware/play/json/%@?credit=true&site_preference=mobile&ct=client" //大视频和三分屏播放下载和提交学习记录前必须先调用此接口 --- {coursewareId}?credit=true

//7.8、接着上次学
#define HXCOURESWARE_EXIT @"/cws/home/couresware/runtime/exit" //课件退出播放时请求该接口，把同步的学习数据保存到服务器。

#define HXCOURESWARE_RECORD_INIT @"/cws/home/couresware/runtime/node/record/init?_node=%@&credit=true&site_preference=mobile&ct=client"   //获取上次播放退出时课件的播放时间    {exitNodeId}   exitNodeId:课件节点ID

#define HXCWS_MODULES_LIST @"/cws/home/my/modules/json/coursewares/mobile/code/%@"  //{moduleCode}  班级里已开通模块

#define HXMY_GETTHEQUESTION @"%@/exam-admin/remote/question/take/%@"//加载测评题

#define HXMY_GETTHEQUESTION_PREVIEW @"%@/exam-admin/remote/question/preview/%@"//加载测评题 ?answer=%@   answer 为学员答案

#define HXMY_GETTHEQUESTION_RIGHT_ANSWER @"/exam-admin/remote/question/answer/%@" //加载正确答案


@interface HXHTTPSessionManager : AFHTTPSessionManager

/**
 从二维码获取的动态服务器地址,read & write
 */

+ (instancetype)sharedClient;

//清除cookies
-(void)clearCookies;

//手动设置baseURL
-(void)setBaseUrl:(NSString *)url;

//得到baseURL
-(NSString *)baseUrlAbsoluteString;

//普通GET请求
+ (void)getDataWithNSString : (NSString *)actionUrlStr
             withDictionary : (NSDictionary *) nsDic
                    success : (void (^)(NSDictionary* dictionary))success
                    failure : (void (^)(NSError *error))failure;

//普通POST请求
+ (void)postDataWithNSString : (NSString *)actionUrlStr
              withDictionary : (NSDictionary *) nsDic
                     success : (void (^)(NSDictionary* dictionary))success
                     failure : (void (^)(NSError *error))failure;

//大视频和三分屏播放下载和提交学习记录前必须先调用此接口
+ (void)getDataWithCoursewareId:(NSString *)cid
                        success:(void (^)(NSDictionary * dic))success
                        failure:(void (^)(NSError *error))failure;

//三分屏flash播放前要调用这个接口 拼接 flv 的有效 url
+ (void)getTokenSuccess:(void (^)(NSDictionary * dic))success
                failure:(void (^)(NSError *error))failure;

+ (void)getDataWithExamId:(NSString *)examid
                  success:(void (^)(NSDictionary * dic))success
                  failure:(void (^)(NSError *error))failure;

@end
