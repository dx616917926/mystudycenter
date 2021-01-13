//
//  HXStartExamViewController.m
//  Hxdd_exam
//
//  Created by Marble on 14-9-1.
//  Copyright (c) 2014年 华夏大地教育. All rights reserved.
//

#import "HXStartExamViewController.h"
#import "HXCompleteViewController.h"
#import "TFHpple.h"
#import "HXQuestionGroup.h"
#import "HXQuestionInfo.h"
#import "WKWebViewJavascriptBridge.h"
#import "HXQuestionBtn.h"
#import "ExamResultDetail.h"
#import "AnswerObject.h"
#import "HXDBManager.h"
#import "HXDBManager+ExamResult.h"
#import "HXAudioManager.h"
#import "Track.h"
#import "HXPainterViewController.h"
#import "XHImageViewer.h"
#import "UIImageView+AFNetworking.h"
#import <UMCommon/MobClick.h>

@interface HXStartExamViewController ()<HXPainterViewControllerDelegate,XHImageViewerDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>{
    
    UIView *menuView;//目录视图 点击目录出现 再次点击消失
    
    UIScrollView *scroller;//目录视图上面的滚动视图
    
    WKWebView *myWebView1; //上部的webview
    
    WKWebView *myWebView2; //下部的webview
    
    UIView * mSplitView; //下部可拖拽控件
    
    UIImageView *guideImageView;//用户第一次进入需要显示 引导页面
    
    UIView *leftTimeView;//倒计时
    UILabel *leftTimeLabel;//倒计时的label
    
    NSTimer *examTimer;//定时器 用于倒计时
    
    NSInteger leftTime;//倒计时
    
    NSInteger nowTime;//进入考试后的时间
    
    //int numOfRequest;//判断是否是第一次加载网页
    
    NSMutableArray * qGroups;
    
    NSMutableArray * qList;
    
    /** 题目数 **/
    int qsNum;
    
    /** 分数 **/
    float currentScore;
    
    /** 替换后的Html head **/
    NSString * headHtml;
    
    //试题html
    NSString * contentHtml;
    
    NSString * subHtml;
    
    NSString * titleHtml;
    
    //当前题目是否是textarea
    BOOL textarea;
    
    BOOL noChange;
    
    ExamResultDetail *last;
    
    // 离线答题情况
    NSArray * offlineAnswers; //ExamResultDetail
    
    int offlineProcessNum;
    
    float totalScore;
    
    BOOL isHaveTimer; //是否有倒计时
    
    BOOL isOffLineModel; //是否是离线模式
    
    BOOL isFinal;//是否是最后一次请求
    
    BOOL isOutLink; //是否是试题外部链接
    
    UIImageView * qImage;//用来展示绘图图片的
    
    XHImageViewer *imageViewer; //用来展示绘图图片的
    
    UIAlertView * mAlertView; //来个全局变量保存alert
    
    NSString * type;//类型：开始考试？继续考试？查看试卷？
    
    int shouldLoadCount; //信号量
    
    BOOL shouldHiddenLoading; //临时变量，第一次加载试卷会有很大延迟，这段试卷先转圈
    
    WKProcessPool * pool;//两个WKWebview共用同一个pool
    
    UIButton * leftSwitchButton;//上一题
    
    UIButton * rightSwitchButton;//下一题
    
    NSString *tempTitleText; //临时变量
}
@property WKWebViewJavascriptBridge* bridge1;
@property WKWebViewJavascriptBridge* bridge2;
@property WKWebViewJavascriptBridge* bridgeCurrent; //进入画板回调用的
@property (nonatomic, strong) HXBarButtonItem *gobackBarItem;//返回按钮
@property (nonatomic, strong) HXBarButtonItem *submitBarItem;//提交按钮
@property (nonatomic, strong) HXBarButtonItem *menuBarItem;  //目录

@property(nonatomic, strong) NSString *tempFileName;   //临时的全局变量，用于删除附件
@property(nonatomic, assign) int top;                  //用于textarea键盘控制、焦点控制
@property(nonatomic, strong) ExamResultDetail *lastUserSaveAnswer;

@property(nonatomic, strong) NSMutableDictionary *userAnswers;  //存放答题结果信息, 用于网页显示和客户端判卷
@property(nonatomic, strong) NSMutableDictionary *rightAnswers; //题目正确答案和分数
@property(nonatomic, assign) int subPosition;          //复合题子题位置
@property(nonatomic, strong) HXQuestionInfo * curQuestion;      //当前显示的题目信息
@end

#define SplitViewBottomMargin (IS_iPhoneX?400:0)
#define LeftTimeViewHeight (IS_iPhoneX?60:40)
#define MAX_Attach_Count 5

@implementation HXStartExamViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)loadView
{
    [super loadView];
    
    @weakify(self);
    self.gobackBarItem = [[HXBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navi_back"] style:HXBarButtonItemStylePlain handler:^(id sender) {
        @strongify(self);
        [self backBtnClicked];
    }];
    
    self.submitBarItem = [[HXBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"exam_submit"] style:HXBarButtonItemStylePlain handler:^(id sender) {
        @strongify(self);
        [self backBtnClicked];
    }];
    
    self.menuBarItem = [[HXBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"exam_menu"] style:HXBarButtonItemStylePlain handler:^(id sender) {
        @strongify(self);
        [self menuButtonPressed];
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    qsNum = 0;
    self.subPosition = 0;
    currentScore = 0.0f;
    noChange = NO;
    isOffLineModel = NO;
    self.top = 0;
    offlineProcessNum = 0;
    shouldLoadCount = 0;
    self.userAnswers = [[NSMutableDictionary alloc]init];
    self.rightAnswers = [[NSMutableDictionary alloc]init];
    
    pool = [WKProcessPool new];
    
    //导航栏的按钮们
    if (_isEnterExam) {
        self.sc_navigationBar.leftBarButtonItem = self.submitBarItem;
    }else
    {
        self.sc_navigationBar.leftBarButtonItem = self.gobackBarItem;
    }
    self.sc_navigationBar.rightBarButtonItem = self.menuBarItem;
    
    if (_isEnterExam) {
        //倒计时
        NSString *limitTime = [self.userExam objectForKey:@"limitTime"];
        if ([limitTime intValue]>0) {
            isHaveTimer = YES;
            leftTimeView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-LeftTimeViewHeight, kScreenWidth, LeftTimeViewHeight)];
            leftTimeView.backgroundColor = [UIColor colorWithRed:0.54 green:0.89 blue:0.64 alpha:1]; //[hxTool hexStringToColor:@"#89E2A2"];
            leftTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
            leftTimeLabel.backgroundColor = [UIColor clearColor];
            leftTimeLabel.text = @"00:00";
            leftTimeLabel.textColor = [UIColor whiteColor];
            leftTimeLabel.textAlignment = NSTextAlignmentCenter;
            leftTimeLabel.font = [UIFont systemFontOfSize:17];
            [leftTimeView addSubview:leftTimeLabel];
        }else{
            isHaveTimer = NO;
        }
    }
    
    //初始化webview
    //绘制顶部webview
    [self drawWebView1];
    
    [self drawSplitView];
    
    [self initBridge];
    
    if (isHaveTimer) {
        [self.view addSubview:leftTimeView];
    }
    
    //判断clientjudge 是否需要下载正确答案
    NSString *tmp = [NSString stringWithFormat:@"%@",[self.userExam objectForKey:@"clientJudge"] ];
    if ([tmp isEqualToString:@"1"]) {
        
        shouldLoadCount ++;
        [self downloadTheRightAnswer];
    }
    
    //判断是否是继续考试 如果是则下载用户之前保存的答案
    if (!_isStartExam) {
        
        shouldLoadCount ++;
        [self downLoadTheUserAnswer];
    }
    
    //如果是查看试卷 下载正确答案、用户答案
    if (!_isEnterExam) {
        
        shouldLoadCount ++;
        [self downloadTheRightAnswer];
    }
    
    //设置cookie
    shouldLoadCount ++;
    [self resetCookieForWKWebview];
    
    //开始下载试卷并解析 如果可以的话，就自动开始考试了~
    [self downloadExamHTMLAndParseQuestion];
    
    type = @"开始考试";
    if (!_isStartExam) {
        type = @"继续考试";
    }
    if (!_isEnterExam)
    {
        type = @"查看试卷";
    }
    //发送统计信息
    [MobClick event:@"ExamViewEvent" attributes:@{@"title":_examTitle,@"type":type}];
    
    //引导页
    [self createGuideImageView];
    
    //目录
    [self createMenuView];
    
    //断网通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkDidChangeNotification) name:AFNetworkingReachabilityDidChangeNotification object:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.sc_navigationBar.title = _examTitle;
    
    if (guideImageView) {
        [[UIApplication sharedApplication].keyWindow addSubview:guideImageView];
    }
    
    //注册键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardHidden)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //禁用全局滑动手势
    HXNavigationController * navigationController = (HXNavigationController *)self.navigationController;
    navigationController.enableInnerInactiveGesture = NO;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //开启全局滑动手势
    HXNavigationController * navigationController = (HXNavigationController *)self.navigationController;
    navigationController.enableInnerInactiveGesture = YES;
    
    //结束倒计时.如果不是进入画板应用的话
    if (!_bridgeCurrent && examTimer != nil) {
        [examTimer invalidate];
        examTimer = nil;
    }
    
    [self.view hideLoading];
    
    [[HXAudioManager sharedManager] hiddenWithAnimated:YES];
}

-(void)networkDidChangeNotification
{
    switch ([[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus]) {
        case AFNetworkReachabilityStatusUnknown:
            [self.view showTostWithMessage:@"您已断开网络连接"];
            break;
        case AFNetworkReachabilityStatusNotReachable:
            [self.view showTostWithMessage:@"您已断开网络连接"];
            break;
        case AFNetworkReachabilityStatusReachableViaWWAN:
            [self.view showTostWithMessage:@"您已连接上移动网络"];
            break;
        case AFNetworkReachabilityStatusReachableViaWiFi:
            [self.view showTostWithMessage:@"您已连接上WiFi"];
            break;
        default:
            break;
    }
}

-(void)dealloc
{
    //取消通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/**
 *  @author wangxuanao, 15-11-10 16:11:53
 *
 *  初始化目录视图
 */
-(void)createMenuView
{
    //初始化目录view
    CGRect menuRect;
    if (isHaveTimer) {
        menuRect = CGRectMake(0, kNavigationBarHeight, kScreenWidth, kScreenHeight-LeftTimeViewHeight-kNavigationBarHeight);
    }else{
        menuRect = CGRectMake(0, kNavigationBarHeight, kScreenWidth, kScreenHeight-kNavigationBarHeight);
        
    }
    menuView = [[UIView alloc]initWithFrame:menuRect];
    menuView.backgroundColor = [UIColor whiteColor]; //@"#535353";
    menuView.hidden = YES;
    menuView.userInteractionEnabled = YES;
    [self.view addSubview:menuView];
}

/**
 *  @author wangxuanao, 15-11-09
 *
 *  引导页视图
 */
-(void)createGuideImageView
{
    if (_isEnterExam) {
        //判断是否是第一次进入app，如果是则显示引导页面
        BOOL firstLaunch = [[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch3"];
        if (!firstLaunch && [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            
            guideImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
            guideImageView.userInteractionEnabled = YES;
            guideImageView.image = [UIImage imageNamed:@"exam_guide_image"];
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            CGFloat y = 400;
            if (IS_iPhoneX) {
                y = 600;
            }
            [btn setFrame:CGRectMake((kScreenWidth-210)/2, y, 210, 62)];
            [btn setImage:[UIImage imageNamed:@"exam_guide_button"] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(guideBtn) forControlEvents:UIControlEventTouchUpInside];
            [guideImageView addSubview:btn];
            
            //这个页面只显示一次
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch3"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
}

#pragma mark - 一些网络请求放在这里了---

/**
 给webview加载cookie
 */
-(void)resetCookieForWKWebview
{
    NSHTTPCookieStorage* storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *cookies = storage.cookies;
    
    NSURL * examurl = [NSURL URLWithString:self.examBasePath];
    NSString * host = [examurl host];
    NSMutableString *cookieHeaders = [NSMutableString string];
    
    for (NSHTTPCookie * cookie in cookies) {
        
        NSString * cookieValue = @"";
        NSString * domain = @"";
        NSString * path = @"";
        
        if ([cookie.domain isEqualToString:host]) {
            cookieValue = cookie.value;
            domain = cookie.domain;
            path = cookie.path;
            
            NSString *cookieHeader = [NSString stringWithFormat:@"%@=%@;domain=%@;path=%@;",cookie.name,cookieValue,domain,path];
            [cookieHeaders appendString:cookieHeader];
        }
    }
    
    NSMutableURLRequest *requestObj = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@%@",self.examBasePath,HXEXAM_RESET_COOKIE]]];
    
    [requestObj setHTTPShouldHandleCookies:YES];
    
    // 注入Cookie
    [requestObj setValue:cookieHeaders forHTTPHeaderField:@"Cookie"];
    
    [myWebView1 loadRequest:requestObj];
}

-(void)loadComplete
{
    @synchronized (self) {
        if (shouldLoadCount <= 1) {
            shouldHiddenLoading = YES;
            [self drawSwitchButton];
            [self setWebViewContentWithInfo:self.curQuestion];
        }
        shouldLoadCount--;
    }
}

/**
 下载试卷，并解析
 */
-(void)downloadExamHTMLAndParseQuestion{
    
    [self.view showLoading];
    
    AFHTTPSessionManager * manager = [[AFHTTPSessionManager alloc] init];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:self.examUrl parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //
        //解析数据
        [self parseQuestionGroup:responseObject];
        
        //初始化第一道题
        if (qList.count > 0) {
            self.curQuestion = [qList objectAtIndex:0];
            
            if (_isEnterExam) {
                //初始化考试时限
                nowTime = [[self getCurrentDate]intValue];
                NSString *limitTime = [self.userExam objectForKey:@"limitTime"];
                if ([limitTime intValue]>0) {
                    NSString *str = [self.userExam objectForKey:@"leftTime"];
                    leftTime = [str intValue]/1000;
                    examTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(examTimeRun) userInfo:nil repeats:YES];
                    [[NSRunLoop currentRunLoop]addTimer:examTimer forMode:NSRunLoopCommonModes];
                }
            }
        }
        
        if (shouldLoadCount == 0) {
            [self loadComplete];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //
        [self.view showErrorWithMessage:@"请求试卷错误！"];
    }];
}

/** 下载正确答案 如果clientjudge 为true 时候请求 **/

- (void)downloadTheRightAnswer{
    
    NSString *url = nil;
    if (!_isEnterExam) {
        //查看试卷
        url = [NSString stringWithFormat:@"%@%@%@",self.examBasePath,HXEXAM_ANSWER,[self.userExam objectForKey:@"id"]];
    }else
    {
        //考试
        url = [NSString stringWithFormat:@"%@%@%@",self.examBasePath,HXEXAM_ANSWER,[self.userExam objectForKey:@"userExamId"]];
    }
    
    
    [HXExamSessionManager getDataWithNSString:url withDictionary:nil success:^(NSDictionary *dictionary) {
        NSLog(@"answer = %@",dictionary);
        
        NSString *success = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"success"]];
        if ([success isEqualToString:@"1"]) {
            NSArray * answers = [dictionary objectForKey:@"answers"];
            self.rightAnswers = [[NSMutableDictionary alloc]initWithCapacity:answers.count];
            for (NSDictionary * ans in answers) {
                AnswerObject * obj = [[AnswerObject alloc]initWithQuestionId:[[ans objectForKey:@"questionId"] longValue] Type:[[ans objectForKey:@"type"] intValue] Ansewer:[NSString stringWithFormat:@"%@",[ans objectForKey:@"answer"]] Score:[[ans objectForKey:@"score"] floatValue]];
                obj.hint = [self replaceImageUrl:[ans objectForKey:@"hint"]];
                obj.answer = [self replaceImageUrl:[ans objectForKey:@"answer"]];
                [self.rightAnswers setObject:obj forKey:[[ans objectForKey:@"questionId"] stringValue]];
            }
            
            [self loadComplete];
        }else
        {
            [self.view showErrorWithMessage:@"下载答案出错!"];
        }
        
        
    } failure:^(NSError *error) {
        [self.view showErrorWithMessage:@"下载答案出错!"];
    }];
    
}

/** 下载用户答案 如果为继续考试的时候 时候请求 **/

- (void)downLoadTheUserAnswer{
    
    NSString * userExamId = nil;
    if (!_isEnterExam) {
        //查看试卷
        userExamId =[self.userExam objectForKey:@"id"];
    }else
    {
        //考试
        userExamId =[self.userExam objectForKey:@"userExamId"];
    }
    
    NSString *url =[NSString stringWithFormat:@"%@%@%@",self.examBasePath,HXEXAM_MYANSWER,userExamId];

    [HXExamSessionManager getDataWithNSString:url withDictionary:nil success:^(NSDictionary *dictionary) {
        NSLog(@"UserAnswer = %@",dictionary);
        NSString *success = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"success"]];
        if ([success isEqualToString:@"1"]) {
            NSArray * answers = [dictionary objectForKey:@"answers"];
            self.userAnswers = [[NSMutableDictionary alloc]initWithCapacity:answers.count];
            for (NSDictionary * ans in answers) {
                if (![[ans stringValueForKey:@"answer"] isEqualToString:@""] || ![[ans stringValueForKey:@"file"] isEqualToString:@""]) {
                    [self.userAnswers setObject:ans forKey:[[ans objectForKey:@"id"] stringValue]];
                }            }
            // 离线保存的答案
            NSArray * ers = [[HXDBManager defaultDBManager] listAnswerByUserExamId:userExamId];
            for (ExamResultDetail *er in ers) {
                NSDictionary * an = @{@"answer":er.answer,@"id":[NSNumber numberWithInteger:er.questionId],@"right":@"0",@"file":er.attach};
                [self.userAnswers setObject:an forKey:[NSString stringWithFormat:@"%ld",er.questionId]];
            }
            
            [self loadComplete];
            
        }else
        {
            [self.view showErrorWithMessage:@"下载答案出错!"];
        }
    } failure:^(NSError *error) {
        [self.view showErrorWithMessage:@"下载答案出错!"];
    }];
    
}

/**
 准备提交试卷
 */
- (void)prepareSubmitTheExampaper {
    
    //直接提交试卷
    [[[UIApplication sharedApplication] keyWindow] showLoading];
    isFinal =NO;
    [self submitTheExampaper];
}

/** 提交试卷  **/
- (void)submitTheExampaper{
    
    offlineAnswers = [[HXDBManager defaultDBManager] listAnswerByUserExamId:[self.userExam objectForKey:@"userExamId"]];
    if (self.lastUserSaveAnswer == nil) {
        if (offlineAnswers.count > 0) {
            self.lastUserSaveAnswer = [offlineAnswers objectAtIndex:0];
            offlineProcessNum = 1;
        }
    }
    
    //保存最后一题的答案
    if (self.lastUserSaveAnswer != nil &&!isFinal) {
        // 保存到网络
        [self saveTheCurrentAnswer:self.lastUserSaveAnswer andTheFinalSave:YES];
        self.lastUserSaveAnswer = nil;
        return;
    }
    
    [self submit];
}

-(void)submit
{
    NSString *url = [NSString stringWithFormat:@"%@%@%@",self.examBasePath,HXEXAM_SUBMIT,[self.userExam objectForKey:@"userExamId"]];
    NSDictionary *dic = nil;
    
    NSString *str = [NSString stringWithFormat:@"%@",[self.userExam objectForKey:@"clientJudge"]];
    
    if ([str isEqualToString:@"1"]) {
        
        dic = @{@"score": [NSString stringWithFormat:@"%f",currentScore]};
    }
    
    [HXExamSessionManager postDataWithNSString:url withDictionary:dic success:^(NSDictionary *dictionary) {
        
        NSString *Str = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"success"]];
        if (![Str isEqualToString:@"1"]) {
            NSLog(@"submit考试失败！");  //虽然失败了（就是session过期了）依然让它继续执行交卷操作
        }
        [self overTheExam];
        
    } failure:^(NSError *error) {
        
        [[[UIApplication sharedApplication] keyWindow] hideLoading];
        //断网
        NSString *suspendContinue = [NSString stringWithFormat:@"%@",[self.userExam objectForKey:@"suspendContinue"]];
        NSString *msg;
        if ([suspendContinue isEqualToString:@"1"]) {
            msg = @"连接网络失败!您回答的问题已被暂存在客户端中,请检查您的网络条件后重试!";
        }else{
            msg = @"连接网络失败!您回答的问题已被暂存在客户端中,请检查您的网络条件后重试!该考试支持续考,您也可以选择\"退出\"后,通过\"继续考试\"功能重新提交!";
            
        }
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"退出" otherButtonTitles:@"重试", nil];
        alert.tag = 170;
        [alert show];
    }];
}

/** 结束考试 **/
- (void)overTheExam{
    NSString *url = [NSString stringWithFormat:@"%@%@%@",self.examBasePath,HXEXAM_FINISHED,[self.userExam objectForKey:@"userExamId"]];
    [HXExamSessionManager getDataWithNSString:url withDictionary:nil success:^(NSDictionary *dictionary) {
        
        NSString *Str = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"success"]];
        if (![Str isEqualToString:@"1"]) {
            NSLog(@"结束考试失败！");  //虽然失败了（就是session过期了）依然让它继续执行交卷操作
        }
        
        [self.view hideLoading];
        
        HXCompleteViewController  *cvc = [[HXCompleteViewController alloc]init];
        cvc.basePath = self.examBasePath;
        cvc.resultUrlDic = dictionary;
        cvc.examTitle = _examTitle;
        cvc.examBasePath = _examBasePath;
        [self.navigationController pushViewController:cvc animated:YES];
        
        [[[UIApplication sharedApplication] keyWindow] hideLoading];
        
    } failure:^(NSError *error) {
        //断网
        [self.view hideLoading];
        
        NSString *suspendContinue = [NSString stringWithFormat:@"%@",[self.userExam objectForKey:@"suspendContinue"]];
        NSString *msg;
        if ([suspendContinue isEqualToString:@"1"]) {
            msg = @"连接网络失败!您回答的问题已被暂存在客户端中,请检查您的网络条件后重试!";
        }else{
            msg = @"连接网络失败!您回答的问题已被暂存在客户端中,请检查您的网络条件后重试!该考试支持续考,您也可以选择\"退出\"后,通过\"继续考试\"功能重新提交!";
            
        }
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"退出" otherButtonTitles:@"重试", nil];
        alert.tag = 170;
        [alert show];
    }];
}


/** 提交用户答案  **/
- (void)saveTheCurrentAnswer:(ExamResultDetail *)data andTheFinalSave:(BOOL)finalSave{
    
    if (data == nil && !finalSave) {
        // 结束考试
        [self submitTheExampaper];
        return;
    }
    
    if(data.answer==nil)
    {
        data.answer = @"";
    }
    if(data.attach==nil)
    {
        data.attach = @"";
    }
    
    NSString *url = [NSString stringWithFormat:@"%@%@%@/%ld",self.examBasePath,HXEXAM_MYANSWER_SAVE,[self.userExam objectForKey:@"userExamId"],data.questionId];
    
    NSString *tmp = [NSString stringWithFormat:@"%@",[self.userExam objectForKey:@"clientJudge"] ];
    float score = 0.0f;
    NSString * right = @"false";
    if ([tmp isEqualToString:@"1"]) {
        //允许判卷
        AnswerObject * ob = [self.rightAnswers objectForKey:[NSString stringWithFormat:@"%ld",data.questionId]];
        if (ob != nil) {
            score = [self countAnswerScore:ob andUserAnswer:data.answer];
            if (score == ob.score) {
                right = @"true";
            }
        }
    }
    
    NSDictionary *dic = @{@"psqId":[NSNumber numberWithInteger:data.paperSuitQuestionId],@"questionId":[NSNumber numberWithInteger:data.questionId],@"answer":data.answer,@"right":right ,@"score":[NSNumber numberWithFloat:score],@"attach":data.attach};

    [HXExamSessionManager postDataWithNSString:url withDictionary:dic success:^(NSDictionary *dictionary) {
        
        NSLog(@"answer = %@",dictionary);
        
        if (![[dictionary objectForKey:@"success"] boolValue]) {
            
            [self.view showErrorWithMessage:[dictionary objectForKey:@"errMsg"]];
            //离线保存
            [[HXDBManager defaultDBManager] saveOneExamResultDetail:data];
            
            if (finalSave) {
                [self submit];
            }
            
        }else{
            //lastUserSaveAnswer = nil;
            if (offlineAnswers != nil && offlineAnswers.count > 0) {
                //删除数据
                [[HXDBManager defaultDBManager] deleteOneNewExamResultDetail:data];
            }
            if (finalSave) {
                if (offlineAnswers != nil && offlineAnswers.count!=0 && offlineProcessNum < offlineAnswers.count-1)
                {
                    offlineProcessNum++;
                    [self saveTheCurrentAnswer:[offlineAnswers objectAtIndex:offlineProcessNum] andTheFinalSave:YES];
                } else { // 结束考试
                    [self submitTheExampaper];
                }
            }
        }
        
    } failure:^(NSError *error) {
        
        //离线保存
        [[HXDBManager defaultDBManager]saveOneExamResultDetail:data];
        
        if (!isOffLineModel && !finalSave) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"连接网络失败,您是否进入离线考试模式?" delegate:self cancelButtonTitle:@"重试" otherButtonTitles:@"确定", nil];
            alert.tag = 160;
            [alert show];
        }
        
        if (finalSave) {
            isFinal = YES;
            [self submitTheExampaper];
        }
    }];
    
}

-(float)countAnswerScore:(AnswerObject *)ao andUserAnswer:(NSString *)userAnswer
{
    if (ao.type != 1 && ao.type !=2) {
        return 0;
    }
    if (ao.type == 1) {
        if ([userAnswer isEqualToString:ao.answer]) {
            
            currentScore += ao.score;
            return ao.score;
        }else
        {
            return 0;
        }
    }else
    {
        BOOL right = NO;
        if (ao.answer.length == userAnswer.length) {
            NSMutableString * rightAnswer = [NSMutableString stringWithString:ao.answer];
            for (NSUInteger i= 0; i<userAnswer.length; i++) {
                unichar c = [userAnswer characterAtIndex:i];
                [rightAnswer replaceOccurrencesOfString:[NSString stringWithFormat:@"%c",c] withString:@"" options:NSLiteralSearch range:NSMakeRange(0, rightAnswer.length)];
            }
            if (rightAnswer.length == 0) {
                right = YES;
            }
        }
        if (right) {
            currentScore += ao.score;
            return  ao.score;
        }else
        {
            return 0;
        }
    }
    
}

#pragma mark - bridge 初始化js
//初始化Bridge
-(void)initBridge
{
    //[WKWebViewJavascriptBridge enableLogging];
    
    __weak __typeof(self)weakSelf = self;
    
    //webView1注册js方法
    _bridge1 = [WKWebViewJavascriptBridge bridgeForWebView:myWebView1];
    
    [_bridge1 setWebViewDelegate:self];
    
    //是否是考试，还是查看试卷
    [_bridge1 registerHandler:@"isEnterExam" handler:^(id data, WVJBResponseCallback responseCallback) {
        if (weakSelf.isEnterExam) {
            responseCallback(@"1");
        }else
        {
            responseCallback(@"0");
        }
    }];
    
    //判断是否是平板，默认是手机
    [_bridge1 registerHandler:@"isTablet" handler:^(id data, WVJBResponseCallback responseCallback) {
        responseCallback(@"0");
    }];
    
    [_bridge1 registerHandler:@"SaveItem" handler:^(id data1, WVJBResponseCallback responseCallback) {
        //
        NSDictionary * data = (NSDictionary *)data1;
        
        NSLog(@"%@",data);
        // 保存答题情况
        NSString * qId = [data objectForKey:@"qId1"];
        NSString * answer = [data objectForKey:@"answer"];
        NSString * attach = [data objectForKey:@"attach"];
        
        if (weakSelf.lastUserSaveAnswer != nil && weakSelf.lastUserSaveAnswer.questionId != [qId intValue]) {
            // 保存到网络
            [weakSelf saveTheCurrentAnswer:weakSelf.lastUserSaveAnswer andTheFinalSave:NO];
            weakSelf.lastUserSaveAnswer = nil;
        }
        
        if (![qId isEqualToString:@"0"]) {
            //没有答案就删除
            if ([answer isEqualToString:@""] &&([attach isEqualToString:@""] || attach == nil)) {
                [weakSelf.userAnswers removeObjectForKey:qId];
                attach = @"";
            } else {
                //有答案就保存
                if (attach==nil) {
                    NSDictionary * ans = [weakSelf.userAnswers objectForKey:qId];
                    if (ans) {
                        attach = [ans objectForKey:@"file"];
                    }
                    if (!attach) {
                        attach = @"";
                    }
                }
                
                NSDictionary * an = @{@"answer": answer,@"id":qId,@"right":@"0",@"file":attach};
                [weakSelf.userAnswers setObject:an forKey:qId];
            }
            
            // 更新lastUserSaveAnswer
            if (weakSelf.lastUserSaveAnswer == nil) {
                weakSelf.lastUserSaveAnswer = [[ExamResultDetail alloc]init];
            }
            weakSelf.lastUserSaveAnswer.userExamId = [weakSelf.userExam objectForKey:@"userExamId"];
            weakSelf.lastUserSaveAnswer.questionId = [[data objectForKey:@"qId1"] integerValue];
            weakSelf.lastUserSaveAnswer.paperSuitQuestionId = [[data objectForKey:@"psqId1"] integerValue];
            weakSelf.lastUserSaveAnswer.answer = answer;
            weakSelf.lastUserSaveAnswer.attach = attach;
        }
        
    }];
    
    //判断键盘缩放
    [_bridge1 registerHandler:@"setTop" handler:^(id data1, WVJBResponseCallback responseCallback) {
        
        NSDictionary * data = (NSDictionary *)data1;
        
        NSLog(@"top == %@",[data objectForKey:@"top"]);
        
        weakSelf.top = [[data objectForKey:@"top"] intValue];
    }];
    
    [_bridge1 registerHandler:@"getUserAnswer" handler:^(id data, WVJBResponseCallback responseCallback) {
        //
        if (weakSelf.userAnswers == nil) {
            responseCallback(@"");
        }
        else
        {
            NSDictionary * dic = [weakSelf.userAnswers objectForKey:[data objectForKey:@"qid"]];
            if (dic != nil) {
                responseCallback(@{@"answer":[dic objectForKey:@"answer"],@"file":[dic objectForKey:@"file"],@"baseurl":self.examBasePath});
            }else
            {
                responseCallback(@"");
            }
        }
    }];
    
    [_bridge1 registerHandler:@"getQuestionAnswer" handler:^(id data, WVJBResponseCallback responseCallback) {
        //
        if (weakSelf.rightAnswers == nil) {
            responseCallback(@"");
        }else
        {
            AnswerObject * ao = [weakSelf.rightAnswers objectForKey:[data objectForKey:@"qid"]];
            if (ao == nil) {
                responseCallback(@"");
            }else
            {
                NSDictionary * dic = @{@"type": [NSString stringWithFormat:@"%d",ao.type],@"answer":ao.answer,@"hint":ao.hint};
                responseCallback(dic);
            }
        }
    }];
    
    [_bridge1 registerHandler:@"isAllowSeeAnswer" handler:^(id data, WVJBResponseCallback responseCallback) {
        //
        if(weakSelf.isAllowSeeAnswer){
            responseCallback(@"1");
        }else
        {
            responseCallback(@"0");
        }
    }];
    
    [_bridge1 registerHandler:@"viewAttachImage" handler:^(id data, WVJBResponseCallback responseCallback) {
        //
        weakSelf.bridgeCurrent = weakSelf.bridge1;
        
        NSString * src = [data objectForKey:@"src"];
        
        NSRange range = [src rangeOfString:@"?__id="];
        weakSelf.tempFileName = [src substringFromIndex:range.location+range.length];
        
        NSURL *imageUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@",src]];
        
        [weakSelf showImageView:imageUrl];
    }];
    
    [_bridge1 registerHandler:@"downloadAttachFile" handler:^(id data, WVJBResponseCallback responseCallback) {
        //
        [weakSelf.view showErrorWithMessage:@"暂不支持下载！"];
    }];
    
    //进入画板应用----上传照片按钮
    [_bridge1 registerHandler:@"enterPainterApp" handler:^(id data1, WVJBResponseCallback responseCallback) {
        //
        weakSelf.bridgeCurrent = weakSelf.bridge1;
        
        HXQuestionInfo * question = weakSelf.curQuestion;
        
        if ([weakSelf.curQuestion isComplex] && weakSelf.subPosition >= 0) {
            //如果是小题的话，要用小题的id
            question = [question.subs objectAtIndex:weakSelf.subPosition];
        }
        
        NSDictionary * ans = [weakSelf.userAnswers objectForKey:[NSString stringWithFormat:@"%d",question._id]];
        
        if (ans) {
            NSString * attach = [ans objectForKey:@"file"];
            
            if (attach && ![attach isEqualToString:@""]) {
                
                NSArray * attachs = [attach componentsSeparatedByString:@","];
                if (attachs.count>=MAX_Attach_Count) {
                    [weakSelf.view showErrorWithMessage:@"附件数量不能超过5个！"];
                    
                    weakSelf.bridgeCurrent = nil;
                    return;
                }
            }
        }
        
        //选择照片
        [weakSelf showSelectPhotoAlertView];
        
//        HXPainterViewController * painterViewC = [[HXPainterViewController alloc] initWithNibName:@"HXPainterViewController" bundle:nil];
//        painterViewC.delegate = weakSelf;
//        [weakSelf.navigationController pushViewController:painterViewC animated:YES];
//        painterViewC.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    }];
    
    //webView2注册js方法
    _bridge2 = [WKWebViewJavascriptBridge bridgeForWebView:myWebView2];
    
    [_bridge2 setWebViewDelegate:self];
    
    //是否是考试，还是查看试卷
    [_bridge2 registerHandler:@"isEnterExam" handler:^(id data, WVJBResponseCallback responseCallback) {
        if (weakSelf.isEnterExam) {
            responseCallback(@"1");
        }else
        {
            responseCallback(@"0");
        }
    }];
    
    //判断是否是平板，默认是手机
    [_bridge2 registerHandler:@"isTablet" handler:^(id data, WVJBResponseCallback responseCallback) {
        responseCallback(@"0");
    }];
    
    
    [_bridge2 registerHandler:@"SaveItem" handler:^(id data1, WVJBResponseCallback responseCallback) {
        //
        NSDictionary * data = (NSDictionary *)data1;
        
        NSLog(@"%@",data);
        // 保存答题情况
        NSString * qId = [data objectForKey:@"qId1"];
        NSString * answer = [data objectForKey:@"answer"];
        NSString * attach = [data objectForKey:@"attach"];
        
        if (weakSelf.lastUserSaveAnswer != nil && weakSelf.lastUserSaveAnswer.questionId != [qId intValue]) {
            // 保存到网络
            [weakSelf saveTheCurrentAnswer:weakSelf.lastUserSaveAnswer andTheFinalSave:NO];
            weakSelf.lastUserSaveAnswer = nil;
        }
        
        if (![qId isEqualToString:@"0"]) {
            //没有答案就删除
            if ([answer isEqualToString:@""] &&([attach isEqualToString:@""] || attach == nil)) {
                [weakSelf.userAnswers removeObjectForKey:qId];
                attach = @"";
            } else {
                //有答案就保存
                if (attach==nil) {
                    NSDictionary * ans = [weakSelf.userAnswers objectForKey:qId];
                    if (ans) {
                        attach = [ans objectForKey:@"file"];
                    }
                    if (!attach) {
                        attach = @"";
                    }
                }
                
                NSDictionary * an = @{@"answer": answer,@"id":qId,@"right":@"0",@"file":attach};
                [weakSelf.userAnswers setObject:an forKey:qId];
            }
            
            // 更新lastUserSaveAnswer
            if (weakSelf.lastUserSaveAnswer == nil) {
                weakSelf.lastUserSaveAnswer = [[ExamResultDetail alloc]init];
            }
            weakSelf.lastUserSaveAnswer.userExamId = [weakSelf.userExam objectForKey:@"userExamId"];
            weakSelf.lastUserSaveAnswer.questionId = [[data objectForKey:@"qId1"] integerValue];
            weakSelf.lastUserSaveAnswer.paperSuitQuestionId = [[data objectForKey:@"psqId1"] integerValue];
            weakSelf.lastUserSaveAnswer.answer = answer;
            weakSelf.lastUserSaveAnswer.attach = attach;
        }
    }];
    
    //判断键盘缩放
    [_bridge2 registerHandler:@"setTop" handler:^(id data1, WVJBResponseCallback responseCallback) {
        
        
        NSDictionary * data = (NSDictionary *)data1;
        
        NSLog(@"top == %@",[data objectForKey:@"top"]);
        
        weakSelf.top = [[data objectForKey:@"top"] intValue];
    }];
    
    [_bridge2 registerHandler:@"getUserAnswer" handler:^(id data, WVJBResponseCallback responseCallback) {
        //
        if (weakSelf.userAnswers == nil) {
            responseCallback(@"");
        }
        else
        {
            NSDictionary * dic = [weakSelf.userAnswers objectForKey:[data objectForKey:@"qid"]];
            if (dic != nil) {
                responseCallback(@{@"answer":[dic objectForKey:@"answer"],@"file":[dic objectForKey:@"file"],@"baseurl":self.examBasePath});
            }else
            {
                responseCallback(@"");
            }
        }
    }];
    
    [_bridge2 registerHandler:@"getQuestionAnswer" handler:^(id data, WVJBResponseCallback responseCallback) {
        //
        if (weakSelf.rightAnswers == nil) {
            responseCallback(@"");
        }else
        {
            AnswerObject * ao = [weakSelf.rightAnswers objectForKey:[data objectForKey:@"qid"]];
            if (ao == nil) {
                responseCallback(@"");
            }else{
                NSDictionary * dic = @{@"type": [NSString stringWithFormat:@"%d",ao.type],@"answer":ao.answer,@"hint":ao.hint};
                responseCallback(dic);
            }
        }
    }];
    
    [_bridge2 registerHandler:@"isAllowSeeAnswer" handler:^(id data, WVJBResponseCallback responseCallback) {
        //
        //
        if(weakSelf.isAllowSeeAnswer){
            responseCallback(@"1");
        }else
        {
            responseCallback(@"0");
        }
    }];
    
    [_bridge2 registerHandler:@"viewAttachImage" handler:^(id data, WVJBResponseCallback responseCallback) {
        //
        
        weakSelf.bridgeCurrent = weakSelf.bridge2;
        
        NSString * src = [data objectForKey:@"src"];
        
        NSRange range = [src rangeOfString:@"?__id="];
        weakSelf.tempFileName = [src substringFromIndex:range.location+range.length];
        
        NSURL *imageUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@",src]];
        
        [weakSelf showImageView:imageUrl];
        
    }];
    
    [_bridge2 registerHandler:@"downloadAttachFile" handler:^(id data, WVJBResponseCallback responseCallback) {
        //
    }];
    
    //进入画板应用----上传照片按钮
    [_bridge2 registerHandler:@"enterPainterApp" handler:^(id data1, WVJBResponseCallback responseCallback) {
        //
        weakSelf.bridgeCurrent = weakSelf.bridge2;
        
        HXQuestionInfo * question = weakSelf.curQuestion;
        
        if ([weakSelf.curQuestion isComplex] && weakSelf.subPosition >= 0) {
            //如果是小题的话，要用小题的id
            question = [question.subs objectAtIndex:weakSelf.subPosition];
        }
        
        NSDictionary * ans = [weakSelf.userAnswers objectForKey:[NSString stringWithFormat:@"%d",question._id]];
        if (ans) {
            NSString * attach = [ans objectForKey:@"file"];
            
            if (attach && ![attach isEqualToString:@""]) {
                
                NSArray * attachs = [attach componentsSeparatedByString:@","];
                if (attachs.count>=MAX_Attach_Count) {
                    [weakSelf.view showErrorWithMessage:@"附件数量不能超过5个！"];
                    
                    weakSelf.bridgeCurrent = nil;
                    return;
                }
            }
        }
        
        //选择照片
        [weakSelf showSelectPhotoAlertView];
        
//        HXPainterViewController * painterViewC = [[HXPainterViewController alloc] initWithNibName:@"HXPainterViewController" bundle:nil];
//        painterViewC.delegate = weakSelf;
//        [weakSelf.navigationController pushViewController:painterViewC animated:YES];
//        painterViewC.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    }];
}

#pragma mark - 键盘事件

-(void)keyboardHidden
{
    if (self.curQuestion.isComplex && textarea) {
        [myWebView2 evaluateJavaScript:@"javascript:lose_focus()" completionHandler:nil];
        if (self.top > 0) {
            [myWebView2 evaluateJavaScript:@"javascript:__OnKeybordHidden()" completionHandler:nil];
        }
    } else {
        [myWebView1 evaluateJavaScript:@"javascript:lose_focus()" completionHandler:nil];
        if (self.top > 0) {
            [myWebView1 evaluateJavaScript:@"javascript:__OnKeybordHidden()" completionHandler:nil];
        }
    }
}

#pragma mark - 绘制WebView
- (void)drawTheMenulist{
    
    [scroller removeFromSuperview];
    scroller = [[UIScrollView alloc]initWithFrame:CGRectMake(10, 10, kScreenWidth-20, menuView.height-12)];
    scroller.alwaysBounceVertical = YES;
    scroller.showsVerticalScrollIndicator = NO;
    scroller.backgroundColor = [UIColor whiteColor];
    [menuView addSubview:scroller];
    
    //默认 每个题的按钮size 为 48*48（4寸） title 的高度为40
    int rowNum = 5;
    if (IS_IPAD) {
        rowNum = 10;
    }
    
    CGFloat itemMargin = 10; //item外边距
    CGFloat itemHeight = 48;  //item宽高
    
    itemHeight = (scroller.width-itemMargin*(rowNum+1))/(CGFloat)rowNum; //动态计算item宽高
    
    if (qGroups.count != 0 ) {
        
        //用来确定 scroller 的高度
        float scrollerHeight =0;//scroller 的高度
        
        //然后绘制其中的内容 包括题型的标题 以及其中的小题
        for (int i = 0; i<qGroups.count; i++) {
            
            if (i>=1) {
                scrollerHeight += itemMargin*2;
            }
            
            HXQuestionGroup *gmodel = [qGroups objectAtIndex:i];
            //绘制题目的标题
            
            UILabel *qTitle = [[UILabel alloc]initWithFrame:CGRectMake(itemMargin,scrollerHeight, 280, 40)];
            
            qTitle.text = [NSString stringWithFormat:@"%d.%@",i+1,gmodel.title];
            
            [scroller addSubview:qTitle];
            
            scrollerHeight = qTitle.bottom;
            
            //绘制每种题型下的小题
            
            if (gmodel.questions.count !=0) {
                
                for (int i2 = 0; i2<gmodel.questions.count; i2++) {
                    HXQuestionInfo *qInfo = [gmodel.questions objectAtIndex:i2];
                    
                    //要分2种情况 一种是普通的选择题 一种是复合题 需要做判断
                    
                    if (qInfo.subs.count == 0) { //等于0 的时候说明是普通的题
                        
                        HXQuestionBtn *qbtn = [HXQuestionBtn buttonWithType:UIButtonTypeCustom];
                        qbtn.tag = [NSString stringWithFormat:@"%d%d",i,i2].intValue;
                        
                        qbtn.info = qInfo;
                        
                        //判断是考试 还是查看试卷
                        
                        if (_isEnterExam) {
                            
                            [qbtn setTitle:qInfo.label forState:UIControlStateNormal];
                            
                            if ([self.userAnswers objectForKey:[NSString stringWithFormat:@"%d",qInfo._id]] != nil) {
                                [qbtn setBackgroundImage:[UIImage imageNamed:@"exam_img3"] forState:UIControlStateNormal];
                                [qbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                            }else{
                                [qbtn setBackgroundImage:[UIImage imageNamed:@"exam_img4"] forState:UIControlStateNormal];
                                [qbtn setTitleColor:[UIColor colorWithRed:0.54 green:0.54 blue:0.54 alpha:1] forState:UIControlStateNormal];//@"#8A8A8A"
                            }
                            
                        }else{
                            
                            if ([[[self.userAnswers objectForKey:[NSString stringWithFormat:@"%d",qInfo._id]]objectForKey:@"right"] boolValue]) {
                                [qbtn setBackgroundImage:[UIImage imageNamed:@"exam_img5"] forState:UIControlStateNormal];
                                [qbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                            }else{
                                [qbtn setBackgroundImage:[UIImage imageNamed:@"exam_img6"] forState:UIControlStateNormal];
                                [qbtn setTitleColor:[UIColor colorWithRed:0.54 green:0.54 blue:0.54 alpha:1] forState:UIControlStateNormal];//@"#8A8A8A"
                            }
                        }
                        
                        [qbtn addTarget:self action:@selector(qbtnClicked:) forControlEvents:UIControlEventTouchUpInside];
                        
                        qbtn.frame = CGRectMake((i2%rowNum)*(itemMargin+itemHeight)+itemMargin, (i2/rowNum)*(itemMargin+itemHeight)+qTitle.bottom, itemHeight, itemHeight);
                        [scroller addSubview:qbtn];
                        
                        scrollerHeight = qbtn.bottom;
                    }
                    else//复合title 跟 btn 的绘制
                    {
                        //先绘制题号 横线+半圆的那个 ~
                        
                        UILabel *fhTitle = [[UILabel alloc]initWithFrame:CGRectMake(20,scrollerHeight+10, scroller.frame.size.width-40,30 )];
                        fhTitle.backgroundColor = [UIColor clearColor];
                        UIImage * fuheQImg2 = [UIImage imageNamed:@"exam_img2"];
                        fuheQImg2 = [fuheQImg2 resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
                        UIImageView * fuheView2 = [[UIImageView alloc]initWithImage:fuheQImg2];
                        fuheView2.frame = fhTitle.frame;
                        [scroller addSubview:fuheView2];
                        
                        UIImage * fuheQImg1 = [UIImage imageNamed:@"exam_img1"];
                        UIImageView * fuheView1 = [[UIImageView alloc]initWithImage:fuheQImg1];
                        fuheView1.center = fhTitle.center;
                        [scroller addSubview:fuheView1];
                        
                        
                        fhTitle.textAlignment = NSTextAlignmentCenter;
                        fhTitle.text = [NSString stringWithFormat:@"%d.%d",i+1,i2+1];
                        fhTitle.textColor = [UIColor colorWithRed:0.54 green:0.54 blue:0.54 alpha:1]; //@"#8A8A8A"
                        [scroller addSubview:fhTitle];
                        
                        for (int i3 = 0; i3<qInfo.subs.count; i3++) {
                            
                            HXQuestionInfo *q3Info = [qInfo.subs objectAtIndex:i3];
                            
                            //然后再绘制小btn 呵呵
                            HXQuestionBtn *qbtn = [HXQuestionBtn buttonWithType:UIButtonTypeCustom];
                            qbtn.info = q3Info;
                            
                            //判断是考试 还是查看试卷
                            
                            if (_isEnterExam) {
                                [qbtn setTitle:[NSString stringWithFormat:@"( %d )",i3+1]forState:UIControlStateNormal];
                                if ([self.userAnswers objectForKey:[NSString stringWithFormat:@"%d",q3Info._id]] != nil) {
                                    [qbtn setBackgroundImage:[UIImage imageNamed:@"exam_img3"] forState:UIControlStateNormal];
                                    [qbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                                }else{
                                    [qbtn setBackgroundImage:[UIImage imageNamed:@"exam_img4"] forState:UIControlStateNormal];
                                    [qbtn setTitleColor:[UIColor colorWithRed:0.54 green:0.54 blue:0.54 alpha:1] forState:UIControlStateNormal];//@"#8A8A8A"
                                }
                                
                            }else{
                                
                                if ([[[self.userAnswers objectForKey:[NSString stringWithFormat:@"%d",q3Info._id]]objectForKey:@"right"] boolValue]) {
                                    [qbtn setBackgroundImage:[UIImage imageNamed:@"exam_img5"] forState:UIControlStateNormal];
                                    [qbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                                }else{
                                    [qbtn setBackgroundImage:[UIImage imageNamed:@"exam_img6"] forState:UIControlStateNormal];
                                    [qbtn setTitleColor:[UIColor colorWithRed:0.54 green:0.54 blue:0.54 alpha:1] forState:UIControlStateNormal];//@"#8A8A8A"
                                }
                            }
                            
                            qbtn.fuhe_position = i3;
                            qbtn.tag = [NSString stringWithFormat:@"%d%d%d",i,i2,i3].intValue;
                            [qbtn addTarget:self action:@selector(qbtnClicked:) forControlEvents:UIControlEventTouchUpInside];
                            qbtn.frame = CGRectMake((i3%rowNum)*(itemMargin+itemHeight)+itemMargin, (i3/rowNum)*(itemMargin+itemHeight)+fhTitle.bottom+itemMargin, itemHeight, itemHeight);
                            [scroller addSubview:qbtn];
                            
                            scrollerHeight = qbtn.bottom;
                        }
                    }
                }
            }
        }
        
        scroller.contentSize = CGSizeMake(scroller.frame.size.width, scrollerHeight+20);
    }
}

//题目按钮点击事件
- (void)qbtnClicked:(HXQuestionBtn *)qbtn{
    //NSLog(@"qbtnTag = %@",qbtn.info);
    isOutLink = NO;
    if (qbtn.info.parent != nil) {
        
        self.subPosition = qbtn.fuhe_position;
        [self setWebViewContentWithInfo:qbtn.info.parent];
        //将小题最大化
        if (mSplitView.frame.origin.y != kNavigationBarHeight) {
            if (IS_iPhoneX) {
                // 中
                if (isHaveTimer) {
                    myWebView2.frame = CGRectMake(0, kScreenHeight-SplitViewBottomMargin-LeftTimeViewHeight, kScreenWidth,SplitViewBottomMargin);
                    mSplitView.frame = CGRectMake(0, kScreenHeight - 40 - SplitViewBottomMargin-LeftTimeViewHeight, kScreenWidth, 40);
                    myWebView1.frame =CGRectMake(0,kNavigationBarHeight, kScreenWidth, kScreenHeight-40-kNavigationBarHeight-SplitViewBottomMargin-LeftTimeViewHeight);
                }else
                {
                    myWebView2.frame = CGRectMake(0, kScreenHeight-SplitViewBottomMargin, kScreenWidth,SplitViewBottomMargin);
                    mSplitView.frame = CGRectMake(0, kScreenHeight - 40 - SplitViewBottomMargin, kScreenWidth, 40);
                    myWebView1.frame =CGRectMake(0,kNavigationBarHeight, kScreenWidth, kScreenHeight-40-kNavigationBarHeight-SplitViewBottomMargin);
                }
            }else
            {
                // 上
                if (isHaveTimer) {
                    myWebView2.frame = CGRectMake(0, kNavigationBarHeight+40, kScreenWidth, kScreenHeight-kNavigationBarHeight-40-LeftTimeViewHeight);
                }else
                {
                    myWebView2.frame = CGRectMake(0, kNavigationBarHeight+40, kScreenWidth, kScreenHeight-kNavigationBarHeight-40);
                }
                myWebView1.frame = CGRectMake(0,kNavigationBarHeight, kScreenWidth, 60);
                mSplitView.frame = CGRectMake(0, kNavigationBarHeight, kScreenWidth, 40);
            }
        }
        
    }else{
        [self setWebViewContentWithInfo:qbtn.info];
    }
    menuView.hidden = YES;
    self.sc_navigationBar.title = _examTitle;
    [self refreshSwitchButton];
}

//绘制顶部webview
-(void)drawWebView1
{
    if (myWebView1 == nil) {
        
        WKUserContentController* userContentController = [WKUserContentController new];
        
        WKWebViewConfiguration *configuration = [WKWebViewConfiguration new];
        // 全局使用同一个processPool
        configuration.processPool = pool;
        configuration.userContentController = userContentController;
        
        CGRect frame = CGRectMake(0,kNavigationBarHeight, kScreenWidth, kScreenHeight-kNavigationBarHeight);
        
        myWebView1 = [[WKWebView alloc]initWithFrame:frame configuration:configuration];
        
        myWebView1.navigationDelegate = self;
        //向左手势
        UISwipeGestureRecognizer *left = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleWeb1SwipeFromRight:)];
        [left setDirection:(UISwipeGestureRecognizerDirectionLeft)];
        [myWebView1.scrollView.panGestureRecognizer requireGestureRecognizerToFail:left];
        [myWebView1.scrollView addGestureRecognizer:left];
        //向右手势
        UISwipeGestureRecognizer *right = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleWeb1SwipeFromLeft:)];
        [right setDirection:(UISwipeGestureRecognizerDirectionRight)];
        [myWebView1.scrollView.panGestureRecognizer requireGestureRecognizerToFail:right];
        [myWebView1.scrollView addGestureRecognizer:right];
        [self.view addSubview:myWebView1];
    }
}

//绘制底部webview
-(void)drawWebView2
{
    if (myWebView2 == nil) {
        //默认是在底部隐藏的
        WKUserContentController* userContentController = [WKUserContentController new];
        
        WKWebViewConfiguration *configuration = [WKWebViewConfiguration new];
        // 全局使用同一个processPool
        configuration.processPool = pool;
        configuration.userContentController = userContentController;
        
        CGRect frame = CGRectZero;
        if (isHaveTimer) {
            frame = CGRectMake(0, kScreenHeight-SplitViewBottomMargin-LeftTimeViewHeight, kScreenWidth,IS_iPhoneX?SplitViewBottomMargin-LeftTimeViewHeight:0);
        }else
        {
            frame = CGRectMake(0, kScreenHeight-SplitViewBottomMargin, kScreenWidth, SplitViewBottomMargin);
        }
        
        myWebView2 = [[WKWebView alloc]initWithFrame:frame configuration:configuration];
        
        myWebView2.navigationDelegate = self;
        //向左手势
        UISwipeGestureRecognizer *left = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleWeb2SwipeFromRight:)];
        [left setDirection:(UISwipeGestureRecognizerDirectionLeft)];
        [myWebView2.scrollView.panGestureRecognizer requireGestureRecognizerToFail:left];
        [myWebView2 addGestureRecognizer:left];
        //向右手势
        UISwipeGestureRecognizer *right = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleWeb2SwipeFromLeft:)];
        [right setDirection:(UISwipeGestureRecognizerDirectionRight)];
        [myWebView2.scrollView.panGestureRecognizer requireGestureRecognizerToFail:right];
        [myWebView2 addGestureRecognizer:right];
        [self.view addSubview:myWebView2];
    }
}

//绘制底部可拖拽控件
-(void)drawSplitView
{
    if (mSplitView == nil) {
        
        [self drawWebView2];
        int y = kScreenHeight - 40;
        if (isHaveTimer) {
            y -= LeftTimeViewHeight;
        }
        
        y -= SplitViewBottomMargin;
        
        mSplitView = [[UIView alloc]initWithFrame:CGRectMake(0, y, kScreenWidth, 40)];
        mSplitView.backgroundColor = [UIColor whiteColor];
        UIImageView * bgImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
        [bgImg setImage:[UIImage imageNamed:@"exam_splistview"]];
        [mSplitView addSubview:bgImg];
        
        UILabel * text = [[UILabel alloc]initWithFrame:CGRectMake((kScreenWidth-80)/2.0-30, 0, 80, 40)];
        text.backgroundColor = [UIColor clearColor];
        text.text = @"查看小题";
        text.textColor = [UIColor colorWithWhite:0.576 alpha:1.000];
        text.textAlignment = NSTextAlignmentCenter;
        text.font = [UIFont systemFontOfSize:17];
        [mSplitView addSubview:text];
        
        UILabel * text2 = [[UILabel alloc]initWithFrame:CGRectMake(text.right-10, 0, 40, 40)];
        text2.backgroundColor = [UIColor clearColor];
        text2.tag = 201;
        text2.text = @"0";
        text2.textColor = [UIColor colorWithRed:1.000 green:0.600 blue:0.000 alpha:1.000];
        text2.textAlignment = NSTextAlignmentRight;
        text2.font = [UIFont systemFontOfSize:17];
        [mSplitView addSubview:text2];
        
        UILabel * text3 = [[UILabel alloc]initWithFrame:CGRectMake(text2.right, 0, 40, 40)];
        text3.backgroundColor = [UIColor clearColor];
        text3.tag = 202;
        text3.text = @"/0";
        text3.textColor = [UIColor colorWithWhite:0.576 alpha:1.000];
        text3.textAlignment = NSTextAlignmentLeft;
        text3.font = [UIFont systemFontOfSize:17];
        [mSplitView addSubview:text3];
        
        //平移手势
        UIPanGestureRecognizer *panGestureRecognizer =[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
        [mSplitView addGestureRecognizer:panGestureRecognizer];
        
        //轻击手势
        UITapGestureRecognizer *tapGestureRecognizer =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
        [mSplitView addGestureRecognizer:tapGestureRecognizer];
        
        [self.view addSubview:mSplitView];
        
        [mSplitView setHidden:YES]; //默认先隐藏
    }
}
//设置底部可拖拽控件当前进度
-(void)splistViewSetProgress:(int)current andTotal:(NSInteger)total
{
    UILabel * cut = (UILabel *)[mSplitView viewWithTag:201];
    cut.text = [NSString stringWithFormat:@"%d",current];
    
    UILabel * tot = (UILabel *)[mSplitView viewWithTag:202];
    tot.text = [NSString stringWithFormat:@"/%ld",total];
    
}

-(void)setSplistViewHidden:(BOOL)hidden
{
    if (hidden) {
        CGFloat h = 0;
        if (isHaveTimer) {
            h = kScreenHeight-kNavigationBarHeight-LeftTimeViewHeight;
        }else
        {
            h = kScreenHeight-kNavigationBarHeight;
        }
        myWebView1.frame = CGRectMake(0,kNavigationBarHeight, kScreenWidth, h);
        
        [mSplitView setHidden:YES];
        [myWebView2 setHidden:YES];
    }
    else
    {
        if (isHaveTimer) {
            myWebView2.frame = CGRectMake(0, kScreenHeight-SplitViewBottomMargin-LeftTimeViewHeight, kScreenWidth, SplitViewBottomMargin);
            mSplitView.frame = CGRectMake(0, kScreenHeight - 40 - SplitViewBottomMargin-LeftTimeViewHeight, kScreenWidth, 40);
            myWebView1.frame = CGRectMake(0, kNavigationBarHeight, kScreenWidth, kScreenHeight-40-kNavigationBarHeight-SplitViewBottomMargin-LeftTimeViewHeight);
        }else
        {
            myWebView2.frame = CGRectMake(0, kScreenHeight-SplitViewBottomMargin, kScreenWidth, SplitViewBottomMargin);
            mSplitView.frame = CGRectMake(0, kScreenHeight - 40 - SplitViewBottomMargin, kScreenWidth, 40);
            myWebView1.frame = CGRectMake(0, kNavigationBarHeight, kScreenWidth, kScreenHeight-40-kNavigationBarHeight-SplitViewBottomMargin);
        }
        [mSplitView setHidden:NO];
        [myWebView2 setHidden:NO];
    }
}

//平移手势
- (void)handlePan:(UIPanGestureRecognizer*)recognizer
{
    CGPoint translation = [recognizer translationInView:self.view];
    
    int y = recognizer.view.frame.origin.y+ translation.y;
    
    int h = kScreenHeight-40;
    int hh = kScreenHeight-y-40;
    if (isHaveTimer) {
        h -= LeftTimeViewHeight;
        hh -= LeftTimeViewHeight;
    }else
    {
        if (IS_iPhoneX) {
            h -= 44;
        }
    }
    
    //不能超出这个范围
    if (y > kNavigationBarHeight && y < h) {
        recognizer.view.center = CGPointMake(recognizer.view.center.x,
                                             recognizer.view.center.y + translation.y);
        
        myWebView1.frame = CGRectMake(myWebView1.frame.origin.x, myWebView1.frame.origin.y, kScreenWidth, y-kNavigationBarHeight);
        
        myWebView2.frame = CGRectMake(myWebView2.frame.origin.x, myWebView2.frame.origin.y + translation.y, kScreenWidth, hh);
        
    }
    
    [recognizer setTranslation:CGPointZero inView:self.view];
    
}
//轻击手势
- (void)handleTap:(UITapGestureRecognizer*)recognizer
{
    if (recognizer.view.frame.origin.y != kNavigationBarHeight) {
        //上
        if (isHaveTimer) {
            myWebView2.frame = CGRectMake(0, kNavigationBarHeight+40, kScreenWidth, kScreenHeight-kNavigationBarHeight-40-LeftTimeViewHeight);
        }else
        {
            myWebView2.frame = CGRectMake(0, kNavigationBarHeight+40, kScreenWidth, kScreenHeight-kNavigationBarHeight-40);
        }
        recognizer.view.frame = CGRectMake(0, kNavigationBarHeight, kScreenWidth, 40);
        myWebView1.frame =CGRectMake(0,kNavigationBarHeight, kScreenWidth, 60);
    }else
    {
        //下、中
        if (isHaveTimer) {
            myWebView2.frame = CGRectMake(0, kScreenHeight-SplitViewBottomMargin-LeftTimeViewHeight, kScreenWidth,SplitViewBottomMargin);
            recognizer.view.frame = CGRectMake(0, kScreenHeight - 40 - SplitViewBottomMargin-LeftTimeViewHeight, kScreenWidth, 40);
            myWebView1.frame =CGRectMake(0,kNavigationBarHeight, kScreenWidth, kScreenHeight-40-kNavigationBarHeight-SplitViewBottomMargin-LeftTimeViewHeight);
        }else
        {
            myWebView2.frame = CGRectMake(0, kScreenHeight-SplitViewBottomMargin, kScreenWidth,SplitViewBottomMargin);
            recognizer.view.frame = CGRectMake(0, kScreenHeight - 40 - SplitViewBottomMargin, kScreenWidth, 40);
            myWebView1.frame =CGRectMake(0,kNavigationBarHeight, kScreenWidth, kScreenHeight-40-kNavigationBarHeight-SplitViewBottomMargin);
        }
    }
}

#pragma mark - 左右切换题目按钮

//上一题、下一题按钮
-(void)drawSwitchButton
{
    if (leftSwitchButton == nil) {
        leftSwitchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        leftSwitchButton.frame = CGRectMake(-10, kScreenHeight/2.0-20, 70, 70);
        [leftSwitchButton setBackgroundColor:[UIColor clearColor]];
        [leftSwitchButton setImage:[UIImage imageNamed:@"exam_left_switch"] forState:UIControlStateNormal];
        [leftSwitchButton addTarget:self action:@selector(handleWeb1SwipeFromLeft:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:leftSwitchButton];
    }
    //默认隐藏上一题按钮
    leftSwitchButton.hidden = YES;
    
    if (rightSwitchButton == nil) {
        rightSwitchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        rightSwitchButton.frame = CGRectMake(kScreenWidth-60, kScreenHeight/2.0-20, 70, 70);
        [rightSwitchButton setBackgroundColor:[UIColor clearColor]];
        [rightSwitchButton setImage:[UIImage imageNamed:@"exam_right_switch"] forState:UIControlStateNormal];
        [rightSwitchButton addTarget:self action:@selector(handleWeb1SwipeFromRight:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:rightSwitchButton];
    }
    //当题目数大约1时才显示下一题按钮
    if (qList.count<=1) {
        rightSwitchButton.hidden = YES;
    }
}

//刷新两个按钮的状态
-(void)refreshSwitchButton
{
    //当出现菜单的时候隐藏按钮
    if (menuView.hidden == NO) {
        leftSwitchButton.hidden = YES;
        rightSwitchButton.hidden = YES;
        
    }else if (self.curQuestion!=nil) {
        
        int currentPosition = self.curQuestion.position;
        
        if (currentPosition==0)
        {
            leftSwitchButton.hidden = YES;
            rightSwitchButton.hidden = NO;
        }else if (currentPosition==qList.count-1)
        {
            leftSwitchButton.hidden = NO;
            rightSwitchButton.hidden = YES;
        }else
        {
            leftSwitchButton.hidden = NO;
            rightSwitchButton.hidden = NO;
        }
    }
}

#pragma mark - webView左右手势

//顶部webView
-(void)handleWeb1SwipeFromLeft:(UISwipeGestureRecognizer*)swipe
{
    isOutLink = NO;
    NSLog(@"前一个");
    if (self.curQuestion != nil) {
        //主观题要先保存答案
        if (self.curQuestion.objective) {
            [self keyboardHidden];
        }
        
        HXQuestionInfo * prevQuestion = nil;
        if (self.curQuestion.isComplex && self.subPosition>0) {
            self.subPosition -- ;
            prevQuestion = self.curQuestion;
        }else if (self.curQuestion.position > 0)
        {
            prevQuestion = [qList objectAtIndex:self.curQuestion.position - 1];
            self.subPosition = 0;
            
            [self setWebViewContentWithInfo:prevQuestion];
        }else
        {
            //没有了
            [self.view showTostWithMessage:@"已经是第一题了！"];
        }
        [self refreshSwitchButton];
    }
}

-(void)handleWeb1SwipeFromRight:(UISwipeGestureRecognizer*)swipe
{
    isOutLink = NO;
    NSLog(@"后一个");
    if (self.curQuestion != nil) {
        //主观题要先保存答案
        if (self.curQuestion.objective) {
            [self keyboardHidden];
        }
        
        HXQuestionInfo * nextQuestion = nil;
        
        if (self.curQuestion.position < qList.count-1) {
            nextQuestion = [qList objectAtIndex:self.curQuestion.position + 1];
            self.subPosition = 0;
            
            [self setWebViewContentWithInfo:nextQuestion];
        }else
        {
            //没有了
            [self.view showTostWithMessage:@"已经是最后一题了！"];
        }
        [self refreshSwitchButton];
    }
}
//底部webView
-(void)handleWeb2SwipeFromLeft:(UISwipeGestureRecognizer*)swipe
{
    isOutLink = NO;
    NSLog(@"前一个小题");
    if (self.curQuestion != nil) {
        //主观题要先保存答案
        if (self.curQuestion.objective) {
            [self keyboardHidden];
        }
        
        HXQuestionInfo * prevQuestion = nil;
        if (self.curQuestion.isComplex && self.subPosition>0) {
            self.subPosition--;
            prevQuestion = self.curQuestion;
            [self setWebViewContentWithInfo:prevQuestion];
        }
        else if (self.curQuestion.position >0)
        {
            prevQuestion = [qList objectAtIndex:self.curQuestion.position - 1];
            self.subPosition = 0;
            [self setWebViewContentWithInfo:prevQuestion];
        }
        else
        {
            //没有了
            [self.view showTostWithMessage:@"已经是第一题了！"];
        }
        [self refreshSwitchButton];
    }
}

-(void)handleWeb2SwipeFromRight:(UISwipeGestureRecognizer*)swipe
{
    isOutLink = NO;
    NSLog(@"后一个小题");
    if (self.curQuestion != nil) {
        //主观题要先保存答案
        if (self.curQuestion.objective) {
            [self keyboardHidden];
        }
        
        HXQuestionInfo * nextQuestion = nil;
        
        if (self.subPosition < self.curQuestion.subs.count-1) {
            self.subPosition ++;
            nextQuestion = self.curQuestion;
            [self setWebViewContentWithInfo:nextQuestion];
        }
        else if (self.curQuestion.position < qList.count-1)
        {
            self.subPosition = 0;
            nextQuestion = [qList objectAtIndex:self.curQuestion.position + 1];
            [self setWebViewContentWithInfo:nextQuestion];
        }
        else
        {
            //没有了
            [self.view showTostWithMessage:@"已经是最后一题了！"];
        }
        [self refreshSwitchButton];
    }
}

#pragma mark - 刷新网页内容

-(void)setWebViewContentWithInfo:(HXQuestionInfo *)question
{
    //
    if (question != nil) {
        //当切换题目的时候，如果正在播放音频，则停止。
        [[HXAudioManager sharedManager] hiddenWithAnimated:YES];
        
        if ([question isComplex] && question.subs.count > self.subPosition && self.subPosition >= 0) {
            //
            HXQuestionInfo * sub = [question.subs objectAtIndex:self.subPosition];
            subHtml = [self getHtmlWithHeadAndJS:NO Content:sub.content];
            if ([subHtml rangeOfString:@"ui-question-textarea"].location != NSNotFound) {
                textarea = YES;
            }else
            {
                textarea = NO;
            }
            
            if (self.curQuestion!=nil && self.curQuestion.position == question.position && contentHtml) {
                noChange = YES;
            }else
            {
                noChange = NO;
                
            }
            if (!noChange) {
                contentHtml = [self getHtmlWithHeadAndJS:YES Content:question.content];
                
                [myWebView1 loadHTMLString:contentHtml baseURL:[NSURL fileURLWithPath:MY_EXAM_BUNDLE_PATH]];
                
                [self setSplistViewHidden:NO];
            }
            //更新数值
            [self splistViewSetProgress:self.subPosition+1 andTotal:question.subs.count];
            
            [myWebView2 loadHTMLString:subHtml baseURL:[NSURL fileURLWithPath:MY_EXAM_BUNDLE_PATH]];
            
            
        }else
        {
            contentHtml = [self getHtmlWithHeadAndJS:NO Content:question.content];
            
            if ([contentHtml rangeOfString:@"ui-question-textarea"].location != NSNotFound)
            {
                textarea = YES;
            }else
            {
                textarea = NO;
            }
            
            [myWebView1 loadHTMLString:contentHtml baseURL:[NSURL fileURLWithPath:MY_EXAM_BUNDLE_PATH]];
            
            
            [self setSplistViewHidden:YES];
        }
    }
    
    self.curQuestion = question;
}

#pragma mark - 倒计时
//倒计时 1s 执行一次
- (void)examTimeRun{
    int currentTime = [[self getCurrentDate]intValue];
    long lTime =leftTime - (currentTime-nowTime);
    
    if (lTime <=0) {
        //提交试卷
        [examTimer invalidate];
        
        leftTimeLabel.text = @"时间到";
        
        [[[UIApplication sharedApplication] keyWindow] showLoadingWithMessage:@"考试时间到，系统自动交卷"];
        
        //如果是在画板应用，则退回来。
        if (self.navigationController.topViewController != self) {
            
            if (self.navigationController.topViewController.presentedViewController) {
                [self.navigationController.topViewController dismissViewControllerAnimated:NO completion:nil];
            }
            
            [self.navigationController popToViewController:self animated:NO];
            _bridgeCurrent = nil;
        }
        //如果是在预览图片，则消失。
        if (imageViewer) {
            [imageViewer dismiss];
        }
        
        //把alertView也消失掉
        if (mAlertView) {
            
            [mAlertView dismissWithClickedButtonIndex:0 animated:NO];
        }
        
        [self performSelector:@selector(prepareSubmitTheExampaper) withObject:nil afterDelay:2];
        
    }else {
        if (lTime <= 30)
        {
            leftTimeView.backgroundColor = [UIColor colorWithRed:1 green:0.31 blue:0.28 alpha:1];
            
            if (lTime == 30) {
                //如果是在画板应用，发送个通知提示时间将要到来，请保存
                if (self.navigationController.topViewController != self && _bridgeCurrent) {
                    
                    if ([self.navigationController.topViewController isKindOfClass:[HXPainterViewController class]]) {
                        
                        HXPainterViewController * paintVC =(HXPainterViewController*)self.navigationController.topViewController;
                        paintVC.hintString = @"时间快要到了，请尽快保存!";
                        [paintVC setShowHintLabel:YES];
                    }
                    
                }
            }
            
        }else if (lTime <=300) {
            leftTimeView.backgroundColor = [UIColor colorWithRed:0.99 green:0.76 blue:0.43 alpha:1];//[hxTool hexStringToColor:@"#FDC16E"];
        }
        
        int m = (int)lTime/60;
        int s = lTime%60;
        if (s<10) {
            leftTimeLabel.text = [NSString stringWithFormat:@"%d:0%d",m,s];
        }else{
            leftTimeLabel.text = [NSString stringWithFormat:@"%d:%d",m,s];
        }
        
    }
}

- (NSString*)getCurrentDate
{
    NSDate *datenow = [NSDate date];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    NSLog(@"timeSp:%@",timeSp);
    return timeSp;
}
#pragma mark  - 导航栏按钮点击事件 -

//关闭引导页面按钮
- (void)guideBtn{
    
    [guideImageView removeFromSuperview];
    guideImageView = nil;
}

#pragma mark - 返回按钮--提交按钮单击事件

- (void)backBtnClicked{
    if (_isEnterExam) {
        
        //撤销键盘
        [self keyboardHidden];
        
        NSInteger i = qsNum - self.userAnswers.count;
        NSString *msg;
        if (i !=0) {
            msg = [NSString stringWithFormat:@"您还有%ld道题未作答，确认交卷？",i];
        }else{
            msg = [NSString stringWithFormat:@"确认提交试卷吗？"];
        }
        
        mAlertView = [[UIAlertView alloc]initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        mAlertView.tintColor = [UIColor colorWithRed:0.275 green:0.796 blue:0.396 alpha:1.000];
        mAlertView.tag = 150;
        [mAlertView show];
    }else{
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    if (menuView.hidden == NO) {
        menuView.hidden = YES;
        self.sc_navigationBar.title = _examTitle;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 150) {//点击返回跟提交
        if (buttonIndex == 0) {
            NSLog(@"cancle");
            [alertView  dismissWithClickedButtonIndex:1 animated:YES];
        }else{
            
            [self prepareSubmitTheExampaper];
        }
    }else if (alertView.tag == 160){ //提交每道小题时候网络出问题的时候弹出
        if (buttonIndex == 0) {
            //重试
            [self saveTheCurrentAnswer:self.lastUserSaveAnswer andTheFinalSave:NO];
        }else{
            //确定（进入离线考试模式）
            isOffLineModel = YES;
        }
        
    }else if(alertView.tag == 170){
        if (buttonIndex == 0) {
            //退出
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else{
            //重试
            [[[UIApplication sharedApplication] keyWindow] showLoading];
            isFinal =NO;
            [self submitTheExampaper];
        }
        
    }
}

#pragma mark - 菜单导航按钮单击事件

-(void)menuButtonPressed{
    
    if (menuView.hidden == YES) {
        
        //撤销键盘
        [self keyboardHidden];
        
        [self drawTheMenulist];
        
        menuView.hidden = NO;
        self.sc_navigationBar.title = @"答题卡";
        
    }else{
        menuView.hidden = YES;
        self.sc_navigationBar.title = _examTitle;
    }
    
    [self refreshSwitchButton];
}

#pragma mark - webview Delegate -


- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSLog(@"url == %@",navigationAction.request.URL.absoluteString);
    
    //target = "_black"  的情况
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
        decisionHandler(WKNavigationActionPolicyAllow);
        return;
    }
    
    
    NSString *url = [navigationAction.request.URL.absoluteString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    if ([url isEqualToString:[NSString stringWithFormat:@"%@%@",self.examBasePath,HXEXAM_RESET_COOKIE]])
    {
        decisionHandler(WKNavigationActionPolicyAllow);
        return;
        
    }else if ([url isEqualToString:BaseUrl]) {
        decisionHandler(WKNavigationActionPolicyAllow);
        return;
        
    }else if([url isEqualToString:[[NSURL fileURLWithPath:MY_EXAM_BUNDLE_PATH] absoluteString]])
    {
        decisionHandler(WKNavigationActionPolicyAllow);
        return;
        
    }else if(!isOutLink)
    {
        if (!NETWORK_AVAILIABLE) {
            [self.view showErrorWithMessage:@"请检查网络链接！"];
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
        }
        
        //不支持mp4
        if ([url.lowercaseString hasSuffix:@".mp4"]||[url.lowercaseString hasSuffix:@".m4v"]||[url.lowercaseString hasSuffix:@".mov"]||[url.lowercaseString hasSuffix:@".3gp"]||[url.lowercaseString hasSuffix:@".avi"]||[url.lowercaseString hasSuffix:@".rmvb"])
        {
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
        }
        
        if ([url.lowercaseString hasSuffix:@".mp3"]||[url.lowercaseString hasSuffix:@".m4a"]) {
            
            NSLog(@"MP3：url == %@",url);
            
            HXAudioManager * manager = [HXAudioManager sharedManager];
            
            Track * track = [[Track alloc]init];
            [track setTitle:@"123"];
            [track setAudioFileURL:[NSURL URLWithString:url]];
            manager.tracks = @[track];
            [manager showWithAnimated:YES];
            
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
        }
        
        isOutLink = YES;
        decisionHandler(WKNavigationActionPolicyAllow);
        return;
    }
    
    decisionHandler(WKNavigationActionPolicyAllow);
    
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation
{
    
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
    //等加载完cookie的时候再加载试卷
    if ([webView.URL.absoluteString hasSuffix:HXEXAM_RESET_COOKIE]) {
        [self loadComplete];
    }
    
    if (shouldHiddenLoading) {
        [self.view hideLoading];
        shouldHiddenLoading = NO;
    }
}

#pragma mark - 解析试卷中题目信息

/***
 * 解析试卷中题目信息
 *
 * @param html
 */
- (void)parseQuestionGroup:(NSData *)data
{
    NSData * htmlData;
    
    //如果是考试的话，就显示启动画板入口
    if (_isEnterExam) {
        NSMutableString * html = [[NSMutableString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        
        [html replaceOccurrencesOfString:@"</textarea>" withString:@"</textarea> <button type=\"button\" id=\"btn_open_painter\" style='font-size:18px'>添加照片</button><p style='font-size:16px;color:#ec8580;'>答题需要画图或者写计算过程的可在纸上完成，拍照成一张图上传。如需删除图片，可点击图片，右上角删除。</p>" options:NSLiteralSearch range:NSMakeRange(0, html.length)];   //改为从相册选择照片   2020年12月10日
        
        htmlData = [html dataUsingEncoding:NSUTF8StringEncoding];
    }else
    {
        htmlData = data;
    }
    
    qGroups = [[NSMutableArray alloc]init];
    
    qList = [[NSMutableArray alloc]init];
    
    TFHpple * doc = [[TFHpple alloc] initWithHTMLData:htmlData];
    
    headHtml = [[doc peekAtSearchWithXPathQuery:@"//head"] raw];
    
    if (headHtml!=nil && [headHtml rangeOfString:@"normal/paper/paper.css"].location != NSNotFound) {
        
        //替换本地路径
        NSMutableString * head = [NSMutableString stringWithString:headHtml];
        
        NSString * jquery1 = [NSString stringWithContentsOfFile:[MY_EXAM_BUNDLE_PATH stringByAppendingPathComponent:@"exam/statics/scripts/paper_cellphone.js"] encoding:NSUTF8StringEncoding error:nil];
        
        [head replaceOccurrencesOfString:@"normal/paper/paper.css" withString:@"mobile/paper/paper_cellphone.css" options:NSLiteralSearch range:NSMakeRange(0, head.length)];
        
        [head replaceOccurrencesOfString:@"jquery-1.9.0.min.js\" type=\"text/javascript\"/>" withString:@"jquery-1.9.0.min.js\" type=\"text/javascript\"></script> " options:NSLiteralSearch range:NSMakeRange(0, head.length)];
        
        [head replaceOccurrencesOfString:@"<script src=\"/exam/statics/scripts/paper.js\" type=\"text/javascript\"/>" withString:[NSString stringWithFormat:@"<script type=\"text/javascript\"> %@ </script><script type=\"text/javascript\">jQuery(document).on(\"mobileinit\", function() { jQuery.mobile.autoInitializePage = false;}); </script><script src=\"exam/statics/scripts/jquery.mobile-1.3.2.min.js\" type=\"text/javascript\"></script>",jquery1] options:NSLiteralSearch range:NSMakeRange(0, head.length)];
        
        //将根目录写成相对路径
        [head replaceOccurrencesOfString:@"/exam/" withString:@"exam/" options:NSLiteralSearch range:NSMakeRange(0, head.length)];
        
        [head replaceOccurrencesOfString:@"</head>" withString:@"</script><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no\"></head>" options:NSLiteralSearch range:NSMakeRange(0, head.length)];
        
        headHtml = [NSString stringWithString:head];
    }
    
    //四种大题类型
    //ui-question-group question-group-1
    //ui-question-group question-group-2
    //ui-question-group question-group-3
    //ui-question-group question-group-4
    NSArray * elGroups = [doc searchWithXPathQuery:@"//div[contains(@class,'ui-question-group question-group-')]"];
    
    int pos = 0;
    
    for (TFHppleElement * elGroup in elGroups) {
        //
        HXQuestionGroup * qGroup = [[HXQuestionGroup alloc]init];
        
        NSString *title = [[elGroup firstChildWithClassName:@"ui-question-group-title"] text];
        title = [title stringByReplacingOccurrencesOfString:@" " withString:@""];
        title = [title stringByReplacingOccurrencesOfString:@"\\r" withString:@""];
        title = [title stringByReplacingOccurrencesOfString:@"\\n" withString:@""];
        title = [title stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        title = [title stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        
        [qGroup setTitle:title];
        tempTitleText = title;
        
        //四种小题类型
        NSArray * a = [elGroup childrenWithClassName:@"ui-question ui-question-independency ui-question-1"];
        NSArray * b = [elGroup childrenWithClassName:@"ui-question ui-question-independency ui-question-2"];
        NSArray * c = [elGroup childrenWithClassName:@"ui-question ui-question-independency ui-question-3"];
        NSArray * d = [elGroup childrenWithClassName:@"ui-question ui-question-independency ui-question-4"];
        
        NSMutableArray * elQuestions = [NSMutableArray arrayWithArray:a];
        [elQuestions addObjectsFromArray:b];
        [elQuestions addObjectsFromArray:c];
        [elQuestions addObjectsFromArray:d];
        
        NSMutableArray * questions = [[NSMutableArray alloc]initWithCapacity:0];
        for (TFHppleElement * el in elQuestions) {
            HXQuestionInfo * question = [self parseQuestionInfo:el];
            question.position = pos;
            [questions addObject:question];
            [qList addObject:question];
            pos ++;
        }
        [qGroup setQuestions:questions];
        
        [qGroups addObject:qGroup];
    }
    
}

/**
 * 解析题目属性
 *
 * @param elQuestion
 * @return
 */
-(HXQuestionInfo*)parseQuestionInfo:(TFHppleElement*)elQuestion
{
    NSString * _id = [[elQuestion objectForKey:@"id"] substringFromIndex:2];
    BOOL com = [[elQuestion objectForKey:@"class"] isEqualToString:@"ui-question ui-question-independency ui-question-4"];
    BOOL objectiv = [[elQuestion objectForKey:@"class"] isEqualToString:@"ui-question ui-question-independency ui-question-3"];
    NSString * label = [[[elQuestion firstChildWithClassName:@"ui-question-title"] firstChildWithClassName:@"ui-question-serial-no"] text];
    
    NSString * content;
    NSMutableArray *subs = [[NSMutableArray alloc]init];
    
    HXQuestionInfo * question = [[HXQuestionInfo alloc]initWithId:[_id intValue] andLabel:label Complex:com Objective:objectiv];
    
    if (com) {
        
        //复合题类型需要遍历子题目
        content = [[elQuestion firstChildWithClassName:@"ui-question-title"] raw];
        
        NSArray * a = [elQuestion childrenWithClassName:@"ui-question ui-question-sub ui-question-1"];
        NSArray * b = [elQuestion childrenWithClassName:@"ui-question ui-question-sub ui-question-2"];
        NSArray * c = [elQuestion childrenWithClassName:@"ui-question ui-question-sub ui-question-3"];
        NSArray * d = [elQuestion childrenWithClassName:@"ui-question ui-question-sub ui-question-4"];
        
        NSMutableArray * elQuestions = [NSMutableArray arrayWithArray:a];
        [elQuestions addObjectsFromArray:b];
        [elQuestions addObjectsFromArray:c];
        [elQuestions addObjectsFromArray:d];
        
        for (int i =0 ; i<elQuestions.count; i++) {
            HXQuestionInfo * sub = [self parseQuestionInfo:[elQuestions objectAtIndex:i]];
            sub.position = i;
            sub.parent = question;
            NSString * label = sub.label;
            sub.label = [NSString stringWithFormat:@"(%@)",[label substringToIndex:[label rangeOfString:@"." options:NSBackwardsSearch].location +2]];
            [subs addObject:sub];
        }
        question.subs = subs;
    }else
    {
        qsNum++;
        content = elQuestion.raw;
    }
    //替换图片路径为绝对路径
    content = [self replaceImageUrl:content];
    
    [question setContent:content];
    
    [self checkQuestionContent:question];
    
    return question;
}

//替换图片路径为绝对路径
-(NSString *)replaceImageUrl:(NSString *)content
{
    if (content!=nil && [content rangeOfString:@"=\"attachments/"].location != NSNotFound) {
        NSRange range = [_examUrl rangeOfString:@"/" options:NSBackwardsSearch];
        NSString * imgurl = [_examUrl substringToIndex:range.location];
        NSMutableString * mutContent = [NSMutableString stringWithString:content];
        [mutContent replaceOccurrencesOfString:@"=\"attachments/" withString:[NSString stringWithFormat:@"=\"%@/attachments/",imgurl] options:NSLiteralSearch range:NSMakeRange(0, mutContent.length)];
        content = mutContent;
    }
    return content;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - 创建网页正文
//做题时使用
-(NSString *)getHtmlWithHeadAndJS:(BOOL)isComplex Content:(NSString *)content
{
    if ([content rangeOfString:@"ui-question-textarea"].location != NSNotFound)
    {
        NSMutableString * con = [NSMutableString stringWithString:content];
        [con replaceOccurrencesOfString:@"<textarea class=\"ui-question-textarea\" rows=\"6\"/>" withString:@"<textarea class=\"ui-question-textarea\" rows=\"6\"/></textarea>" options:NSLiteralSearch range:NSMakeRange(0, con.length)];
        content = [NSString stringWithString:con];
    }
    
    if (isComplex) {
        return [NSString stringWithFormat:@"<html>%@<body><div class=\"ui-paper-wrapper\"><div class=\"ui-question ui-question-independency ui-question-4\">%@</div></div><script type=\"text/javascript\">(function(){$(document).ready(function(){__Exam_PaperInit();});})();</script></body></html>",headHtml,content];
    }else
    {
        
        return [NSString stringWithFormat:@"%@<body><div class=\"ui-paper-wrapper\">%@</div><script type=\"text/javascript\">(function(){$(document).ready(function(){__Exam_PaperInit();});})();</script></body>",headHtml,content];
    }
}



#pragma mark - HXPainterViewControllerDelegate

//当你画完之后，点击提交按钮会返回的。
-(void)didFinishDrawingWithImage:(UIImage *)image
{
    if (image) {
        
        NSLog(@"准备提交图片");
        [self.view showLoadingWithMessage:@"上传中……"];
        
        NSData * fileData = UIImageJPEGRepresentation(image,0.9);
        
        NSString * name = [NSString stringWithFormat:@"%f.jpg",[[NSDate date] timeIntervalSince1970]];
        NSString *url =[NSString stringWithFormat:@"%@%@",self.examBasePath,HXPOST_ANSWER_FILE];

        HXExamSessionManager *_sharedClient =[HXExamSessionManager sharedClient];
        [_sharedClient POST:url parameters:nil headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            [formData appendPartWithFileData:fileData name:@"file" fileName:name mimeType:@"image/JPG"];
        }
        progress:^(NSProgress * _Nonnull uploadProgress) {
                   //
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            //NSLog(@"Success: %@", responseObject);
            if ([[responseObject objectForKey:@"success"] intValue] == 1)
            {
                
                [self.view showSuccessWithMessage:@"上传成功！"];
                
                NSString * fileName = [NSString stringWithFormat:@"%@/%@",[responseObject objectForKey:@"tmpFileName"],name];
                
                //NSLog(@"%@",fileName);
                
                HXQuestionInfo * question = self.curQuestion;
                
                if ([self.curQuestion isComplex] && self.subPosition >= 0) {
                    //如果是小题的话，要用小题的id
                    question = [self.curQuestion.subs objectAtIndex:self.subPosition];
                }
                
                NSDictionary * ans = [self.userAnswers objectForKey:[NSString stringWithFormat:@"%d",question._id]];
                if (ans) {
                    NSString * file = [ans objectForKey:@"file"];
                    if (file && ![file isEqualToString:@""]) {
                        fileName = [file stringByAppendingFormat:@",%@",fileName];
                    }
                }
                
                [_bridgeCurrent callHandler:@"uploadedCallBack" data:@{@"qId": [NSNumber numberWithInt:question._id],@"uploadName":fileName,@"baseurl":self.examBasePath}];
                
            }else
            {
                [self.view showErrorWithMessage:@"提交答案失败，请重试！"];
            }
            _bridgeCurrent = nil;
            
        } failure:^(NSURLSessionDataTask *operation, NSError *error) {
            
            _bridgeCurrent = nil;
            
            [self.view showErrorWithMessage:@"提交答案失败，请重试！"];
        }];
    }
}

#pragma mark - XHImageViewer

-(void)showImageView:(NSURL *)imageUrl
{
    qImage = [[UIImageView alloc]init];
    qImage.frame = CGRectMake(kScreenWidth/2.0, kScreenHeight/2.0, 1, 1);
    [qImage setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"placeholder"]];
    [self.view addSubview:qImage];
    
    imageViewer = [[XHImageViewer alloc]
                   init];
    imageViewer.delegate = self;
    imageViewer.disablePanDismiss = YES;
    
    [imageViewer showWithImageViews:@[qImage]
                       selectedView:qImage];
}

- (void)imageViewer:(XHImageViewer *)_imageViewer didDismissWithSelectedView:(UIImageView *)selectedView
{
    [qImage removeFromSuperview];
    qImage = nil;
    
    _bridgeCurrent = nil;
    
    imageViewer = nil;
}

- (UIView *)customTopToolBarOfImageViewer:(XHImageViewer *)imageViewer
{
    
    if (!_isEnterExam) {
        return nil;
    }
    UIView * topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 80)];
    topView.backgroundColor = [UIColor clearColor];
    
    UIButton * trashButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [trashButton setBackgroundImage:[UIImage imageNamed:@"trash_green"] forState:UIControlStateNormal];
    
    [trashButton setFrame:CGRectMake(kScreenWidth-50, kStatusBarHeight+10, 40, 40)];
    
    [trashButton addTarget:self action:@selector(trashButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [topView addSubview:trashButton];
    
    return topView;
}

-(void)trashButtonPressed:(UIButton *)button
{
    
    HXQuestionInfo * question = self.curQuestion;
    
    if ([self.curQuestion isComplex] && self.subPosition >= 0) {
        //如果是小题的话，要用小题的id
        question = [self.curQuestion.subs objectAtIndex:self.subPosition];
    }
    NSString * uploadName = @"";
    NSDictionary * ans = [self.userAnswers objectForKey:[NSString stringWithFormat:@"%d",question._id]];
    if (ans) {
        NSString * file = [ans objectForKey:@"file"];
        if (file) {
            
            NSArray * files = [file componentsSeparatedByString:@","];
            NSMutableArray * mfiles = [NSMutableArray arrayWithArray:files];
            for (NSString * temp in files) {
                if ([temp hasPrefix:self.tempFileName]) {
                    [mfiles removeObject:temp];
                }
            }
            if (mfiles.count==0) {
                uploadName = @"";
            }else{
                uploadName = [mfiles componentsJoinedByString:@","];
            }
        }
    }
    
    [_bridgeCurrent callHandler:@"uploadedCallBack" data:@{@"qId": [NSNumber numberWithInt:question._id],@"uploadName":uploadName,@"baseurl":self.examBasePath}];
    
    _bridgeCurrent = nil;
    
    [imageViewer dismiss];
    
    [self.view showSuccessWithMessage:@"删除成功！"];
}

#pragma mark - 上传照片

/// 弹框
- (void)showSelectPhotoAlertView {
    
    __weak __typeof(self)weakSelf = self;
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    if (IS_IPAD) {
        alertC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
    }
    UIAlertAction *confirmAction1 = [UIAlertAction actionWithTitle:@"从相册中选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf showImagePicker:UIImagePickerControllerSourceTypePhotoLibrary];
    }];
    UIAlertAction *confirmAction2 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf showImagePicker:UIImagePickerControllerSourceTypeCamera];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        weakSelf.bridgeCurrent = nil;
    }];
    [alertC addAction:confirmAction1];
    [alertC addAction:confirmAction2];
    [alertC addAction:cancelAction];
    [self presentViewController:alertC animated:YES completion:nil];
}

- (void)showImagePicker:(NSUInteger)sourceType {
    
    // 跳转到相机或相册页面
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.sourceType = sourceType;
    imagePickerController.allowsEditing = NO;
    imagePickerController.modalPresentationStyle = UIModalPresentationFullScreen;
    
    [self presentViewController:imagePickerController animated:YES completion:^{
        //
    }];
}

#pragma mark -  UIImagePickerControllerDelegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    self.bridgeCurrent = nil;
}

//选完图片要上传
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES
                               completion:nil];
    
    if (image) {
        
        CGFloat scale = 1;
        float longSide = MAX(image.size.height, image.size.width);
        scale = MIN(1, 1000/longSide);
        
        image = [UIImage scaleImage:image toScale:scale];
        NSData *jpegData = UIImageJPEGRepresentation(image, 0.93);
        
        [self uploadImageWithData:jpegData];
    }else
    {
        [self.view showErrorWithMessage:@"上传图片失败，请重试！"];
        
        self.bridgeCurrent = nil;
    }
}

//上传
-(void)uploadImageWithData:(NSData *)fileData
{
    if (fileData) {
        
        NSLog(@"准备提交图片");
        [self.view showLoadingWithMessage:@"上传中……"];
        
        NSString *name = [NSString stringWithFormat:@"%f.jpg",[[NSDate date] timeIntervalSince1970]];
        NSString *url =[NSString stringWithFormat:@"%@%@",self.examBasePath,HXPOST_ANSWER_FILE];

        HXExamSessionManager *_sharedClient =[HXExamSessionManager sharedClient];
        [_sharedClient POST:url parameters:nil headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            [formData appendPartWithFileData:fileData name:@"file" fileName:name mimeType:@"image/JPG"];
        }
        progress:^(NSProgress * _Nonnull uploadProgress) {
                   //
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            //NSLog(@"Success: %@", responseObject);
            if ([[responseObject objectForKey:@"success"] intValue] == 1)
            {
                
                [self.view showSuccessWithMessage:@"上传成功！"];
                
                NSString * fileName = [NSString stringWithFormat:@"%@/%@",[responseObject objectForKey:@"tmpFileName"],name];
                
                //NSLog(@"%@",fileName);
                
                HXQuestionInfo * question = self.curQuestion;
                
                if ([self.curQuestion isComplex] && self.subPosition >= 0) {
                    //如果是小题的话，要用小题的id
                    question = [self.curQuestion.subs objectAtIndex:self.subPosition];
                }
                
                NSDictionary * ans = [self.userAnswers objectForKey:[NSString stringWithFormat:@"%d",question._id]];
                if (ans) {
                    NSString * file = [ans objectForKey:@"file"];
                    if (file && ![file isEqualToString:@""]) {
                        fileName = [file stringByAppendingFormat:@",%@",fileName];
                    }
                }
                
                [_bridgeCurrent callHandler:@"uploadedCallBack" data:@{@"qId": [NSNumber numberWithInt:question._id],@"uploadName":fileName,@"baseurl":self.examBasePath}];
                
            }else
            {
                [self.view showErrorWithMessage:@"上传图片失败，请重试！"];
            }
            _bridgeCurrent = nil;
            
        } failure:^(NSURLSessionDataTask *operation, NSError *error) {
            
            _bridgeCurrent = nil;
            
            [self.view showErrorWithMessage:@"上传图片失败，请重试！"];
        }];
    }else
    {
        _bridgeCurrent = nil;
        
        [self.view showErrorWithMessage:@"上传图片失败，请重试！"];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return kStatusBarStyle;
}

/// 检查题目是否拆分成功，并上报给友盟统计
/// 判断依据：是否包含多个class：ui-question-independency
/// @param question 题目
- (void)checkQuestionContent:(HXQuestionInfo *)question {
    
    NSMutableString * mutContent = [NSMutableString stringWithString:question.content];
    NSInteger num = [mutContent replaceOccurrencesOfString:@"class=\"ui-question ui-question-independency ui-question-" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, mutContent.length)];
    
    //判断题干个数，如果超过1，则代表拆分失败
    if (num > 1) {
        [MobClick event:@"ExamQuestionError" attributes:@{@"title":_examTitle,@"qid":[NSString stringWithFormat:@"%@-%d",tempTitleText,question._id]}];
        NSLog(@"⚠️检测到题目拆分失败！⚠️");
    }
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

@end

