//
//  TXMoviePlayerController.m
//  TXMoviePlayer
//
//  Created by Mac on 2019/5/17.
//  Copyright © 2019 华夏大地教育网. All rights reserved.
//

#import "TXMoviePlayerController.h"
#import "SuperPlayer.h"
#import "QCSlideSwitchView.h"
#import "TXCatalogListViewController.h"
#import "TXLectureViewController.h"
#import "TXHTTPSessionManager.h"
#import "TXExamPopView.h"
#import "TXDownloadViewController.h"
#import "DownloadManager.h"

@interface TXMoviePlayerController ()<SuperPlayerDelegate,QCSlideSwitchViewDelegate,TXCatalogListViewControllerDelegate,TXExamPopViewDelegate,TXDownloadViewControllerDelegate>
@property(nonatomic, strong) UIView *playerFatherView;              //播放器View的父视图
@property(nonatomic, strong) SuperPlayerView *playerView;           //播放器View
@property(nonatomic, assign) BOOL isPlaying;                        //离开页面时候是否在播放
@property(nonatomic, strong) QCSlideSwitchView *slideSwitchView;

@property(nonatomic, strong) TXCatalogListViewController *catalogListVC;   //目录
@property(nonatomic, strong) TXLectureViewController *lectureVC;           //讲义
@property(nonatomic, strong) TXDownloadViewController *downloadVC;         //下载

@property(nonatomic, strong) TXCatalog *currentCatalog;             //当前正在播放的课件
@property(nonatomic, strong) NSString *learnRecordId;               //听课记录ID，每换一个课件就重置一次
@property(nonatomic, weak) NSTimer *timer;                          //计时器
@property(nonatomic, weak) NSTimer *timer2;                         //计时器
@property(nonatomic, assign) NSInteger accumulativeTime;            //本次累计时长

@end

@implementation TXMoviePlayerController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
#if __has_include("HXNavigationController.h")
    //禁用全局滑动手势
    HXNavigationController * navigationController = (HXNavigationController *)self.navigationController;
    navigationController.enableInnerInactiveGesture = NO;
    
    //隐藏导航栏
    [self.sc_navigationBar mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.offset(-44);
    }];
    self.sc_navigationBar.y = -44;
    self.sc_navigationBarHidden = YES;
#else
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    UIImageView *topView = [[UIImageView alloc] init];
    NSString *imageString = @"pic_top";
    if (kIphoneX) {
        imageString = @"pic_top_iPhoneX";
    }
    [topView setImage:[UIImage imageNamed:imageString]];
    [self.view addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.leading.trailing.equalTo(self.view);
        make.height.mas_equalTo(kStatusBarHeight);
    }];
    
#endif
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.playerFatherView = [[UIView alloc] init];
    self.playerFatherView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.playerFatherView];
    [self.playerFatherView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (IS_iPhoneX) {
            make.top.mas_equalTo(44);
        } else {
            make.top.mas_equalTo(20);  //+self.navigationController.navigationBar.bounds.size.height
        }
        make.leading.trailing.mas_equalTo(0);
        // 这里宽高比16：9,可自定义宽高比
        make.height.mas_equalTo(self.playerFatherView.mas_width).multipliedBy(9.0f/16.0f);
    }];
    self.playerView.fatherView = self.playerFatherView;
    [self.playerView.coverImageView setImage:SuperPlayerImage(@"loading_bgView")];
    
    [self initQCSlideSwitchView];
    
    [self requestCatalogListData];
    
    [self initTimer];
}

- (void)initTimer {
    //每秒记录一下学习时间
    NSTimer * tempTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerRun) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:tempTimer forMode:NSRunLoopCommonModes];
    self.timer = tempTimer;
    
    //60秒上传一次学习记录
    NSTimer * tempTimer2 = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(updateLearnRecord) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:tempTimer2 forMode:NSRunLoopCommonModes];
    self.timer2 = tempTimer2;
}

- (void)timerRun {
    
    if (self.playerView.state == StatePlaying) {
        //本次累计时长
        self.accumulativeTime += 1;
    }
}

- (SuperPlayerView *)playerView {
    if (!_playerView) {
        _playerView = [[SuperPlayerView alloc] init];
        _playerView.fatherView = _playerFatherView;
        // 设置代理
        _playerView.delegate = self;
        _playerView.playerConfig.canDownload = self.canDownload;
    }
    return _playerView;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)destroyPlayVideo{
    if (_playerView != nil) {
        [_playerView resetPlayer];
        [_playerView removeFromSuperview];
        _playerView = nil;
    }
}

- (void)dealloc{

    [self destroyPlayVideo];
}

- (void)invalidateTimer {
    
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    
    if (self.timer2) {
        [self.timer2 invalidate];
        self.timer2 = nil;
    }
}

#pragma mark - SuperPlayerDelegate
/**
 下载按钮点击通知
*/
- (void)superPlayerDownloadAction:(SuperPlayerView *)player {
    
    NSLog(@"点击了下载按钮");
    TXCatalog *catalog = self.currentCatalog;
    if (catalog.isMedia) {
        
        //判断是否已经下载完成、正在下载
        DownloadSource *video = [DEFAULT_DM findDownloadSourceWithCatalogID:catalog.ID];
        if (video) {
            if (video.downloadStatus == DownloadTypeLoading || video.downloadStatus == DownloadTypeWaiting) {
                [[UIApplication sharedApplication].keyWindow showTostWithMessage:@"该视频已在下载,请耐心等待"];
                return;
            }
            if (video.downloadStatus == DownloadTypefinish) {
                [[UIApplication sharedApplication].keyWindow showSuccessWithMessage:@"视频已下载"];
                return;
            }
        }
        //通知下载管理页面开始下载
        [[NSNotificationCenter defaultCenter] postNotificationName:TXDownloadViewPepareToDownloadNotification object:catalog];
    }
}

/**
 开始学习按钮点击事件
 */
- (void)superPlayerStartPlayAction:(SuperPlayerView *)player {
    
    //默认播放第一个
    for (TXCatalog *catalog in self.catalogListVC.catalogArray) {
        if (catalog.isMedia) {
            [self.catalogListVC prepareToPlayCatalog:catalog];
            return;
        }
    }
}

/**
 返回事件
 */
- (void)superPlayerBackAction:(SuperPlayerView *)player {
    
    [self invalidateTimer];
    
    //上传当前学习记录
    [self updateLearnRecord];
    
#if __has_include("HXNavigationController.h")
    //开启全局滑动手势
    HXNavigationController * navigationController = (HXNavigationController *)self.navigationController;
    navigationController.enableInnerInactiveGesture = YES;
#else
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
#endif
    
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 播放时间点
 */
- (void)superPlayerPlaying:(SuperPlayerView *)player withTime:(NSInteger)currentTime {
    
    //在这里判断是否需要弹题
    if (self.currentCatalog.questions.count != 0) {
        TXQuestion *question = [self.currentCatalog.questionMediaTimeDic objectForKey:[NSString stringWithFormat:@"%d",(int)currentTime]];
        if (question) {
            //弹题
            NSLog(@"弹题 id=%@",question.questionId);
            
            //暂停播放
            [self.playerView pause];
            
            TXExamPopView *popView = [[TXExamPopView alloc] init];
            popView.delegate = self;
            popView.questionItem = question;
            [popView showInView:[UIApplication sharedApplication].keyWindow];
        }
    }
}

/**
 重试按钮点击通知
 */
- (void)superPlayerRetryPlayAction:(SuperPlayerView *)player {
    
    if (self.currentCatalog && self.currentCatalog.isMedia) {
        [self.catalogListVC prepareToPlayCatalog:self.currentCatalog];
    }
}

/**
播放错误通知
*/
- (void)superPlayerError:(SuperPlayerView *)player errCode:(int)code errMessage:(NSString *)why {
    
    
}

#pragma mark - 目录、讲义

-(void)initQCSlideSwitchView
{
    self.slideSwitchView = [[QCSlideSwitchView alloc]init];
    self.slideSwitchView.slideSwitchViewDelegate = self;
    [self.view addSubview:self.slideSwitchView];
    
    [self.slideSwitchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.playerFatherView.mas_bottom);
        make.leading.trailing.bottom.mas_equalTo(0);
    }];
    
    self.slideSwitchView.tabItemNormalColor = [UIColor colorWithRed:0.53 green:0.53 blue:0.53 alpha:1];
    self.slideSwitchView.tabItemSelectedColor = [UIColor blackColor];
    
    UIImage * shadow = [[UIImage imageNamed:@"qc_slide_shadow"] stretchableImageWithLeftCapWidth:59.0f topCapHeight:0.0f];

    self.slideSwitchView.shadowImage =shadow;
    
    [self.slideSwitchView buildUI];
    
    //下载管理
    if (self.canDownload) {
        [self.view addSubview:self.downloadVC.view];
    }
}

- (TXCatalogListViewController *)catalogListVC {
    
    if (!_catalogListVC) {
        _catalogListVC = [[TXCatalogListViewController alloc] init];
        _catalogListVC.title = @"课件目录";
        _catalogListVC.delegate = self;
        _catalogListVC.canDownload = self.canDownload;
        [self addChildViewController:_catalogListVC];
    }
    return _catalogListVC;
}

- (TXLectureViewController *)lectureVC {
 
    if (!_lectureVC) {
        _lectureVC = [[TXLectureViewController alloc] init];
        _lectureVC.title = @"在线讲义";
        [self addChildViewController:_lectureVC];
    }
    return _lectureVC;
}

- (TXDownloadViewController *)downloadVC {
    
    if (!_downloadVC) {
        _downloadVC = [[TXDownloadViewController alloc] init];
        _downloadVC.title = @"下载管理";
        _downloadVC.view.hidden = YES;
        _downloadVC.view.frame = CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight - CGRectGetMaxY(self.playerFatherView.frame));
        _downloadVC.delegate = self;
        _downloadVC.cws_param = self.cws_param;
        _downloadVC.coursewareId = self.coursewareId;
        _downloadVC.coursewareTitle = self.coursewareTitle;
        _downloadVC.classID = self.classID;
        [self addChildViewController:_lectureVC];
    }
    return _downloadVC;
}

#pragma mark - TXCatalogListViewControllerDelegate

/**
*  下载管理按钮点击事件
*/
- (void)downloadManagerButtonCliecked {
    [self showDownLoadView:YES];
}

/**
*  章节点击事件
*/
- (void)didSelectCatalog:(TXCatalog *)catalog {
 
    //保存一下
    [self updateLearnRecord];
    
    self.learnRecordId = nil;
    self.accumulativeTime = 0;
    self.currentCatalog = nil;
    
    //请求课件信息
    NSDictionary *param = self.cws_param;
    
    [self.view showLoading];
    
    [TXHTTPSessionManager requestCatalogInfoWithId:catalog.ID param:param success:^(NSDictionary *dictionary) {
        //
        TXCatalog *item = [TXCatalog mj_objectWithKeyValues:[dictionary objectForKey:@"data"]];
        item.orderNum = catalog.orderNum;
        self.currentCatalog = item;
        
        SuperPlayerModel *model = [SuperPlayerModel new];
        
        //查询是否已经下载
        BOOL localVideo = NO;
        NSMutableArray *doneVideoArray = [NSMutableArray arrayWithArray:DEFAULT_DM.doneSources];
        for (DownloadSource *video in doneVideoArray){
            if ([item.media.mediaSource isEqualToString:video.vid] && [item.ID isEqualToString:video.catalogID]) {
                
                //拼接视频下载路径
                NSString *path = DEFAULT_DM.downLoadPath;
                NSString *str = [NSString stringWithFormat:@"%@/%@",path,video.downloadedFilePath];

                //准备播放本地视频
                model.playMethod = AliyunPlayMedthodLocal;
                model.videoUrl = [NSURL URLWithString:str];
                localVideo = YES;
                break;
            }
        }
        
        if (!localVideo) {
            if ([item.media.serverType isEqualToString:@"aliyunCode"]) {
                model.playMethod = AliyunPlayMedthodPlayAuth;
                model.videoId = item.media.mediaSource;
                model.playAuth = item.media.playAuth;
            }else
            {
                model.playMethod = AliyunPlayMedthodURL;
                model.videoUrl = [NSURL URLWithString:item.media.mediaSource];
            }
            [self.view hideLoading];
        }else
        {
            [self.view showTostWithMessage:@"正在为您播放本地视频"];
        }
        
        NSMutableArray *points = [NSMutableArray array];
        for (TXQuestion * question in item.questions) {
            [points addObject:question.mediaTime];
        }
        model.videoPointList = points;

        [self.playerView.controlView setTitle:catalog.name];
        
        int lastTime = [[item.learnRecord stringValueForKey:@"lastTime"] intValue];
        [self.playerView setStartTime:lastTime];   //接着上次播
        
//        [self.playerView setAutoPlay:NO];
        
        [self.playerView playWithModel:model];
        
    } failure:^(NSString *failureMessage) {
        //
        NSLog(@"%@",failureMessage);
        
        [self.view showErrorWithMessage:failureMessage];
    }];
}

#pragma mark - TXDownloadViewControllerDelegate

- (void)closeButtonAction:(TXDownloadViewController *)viewController
{
    [self showDownLoadView:NO];
}

#pragma mark - TXExamPopViewDelegate

/**
 继续播放
 */
- (void)continuePlay
{
    [self.playerView resume];
}

/**
 作答结果
 */
- (void)examQuestion:(TXQuestion *)question withResult:(BOOL)result
{
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    
    [param setObject:[NSNumber numberWithBool:result] forKey:@"isPass"];  // 考核点是否通过(弹题是否选择正确)
    [param setObject:question.questionId forKey:@"questionId"];           // 试题 ID
    [param setObject:question.examinePoint forKey:@"examinePoint"];       // 考核点内容(弹题考核点内容)
    [param setObject:question.mediaTime forKey:@"lastTime"];              // 当前媒体播放时间点(必填)
    
    [param setObject:self.currentCatalog.media.mediaDuration forKey:@"videoTime"];   // 视频时长(秒)(必填)
    [param setObject:question.catalogId forKey:@"catalogId"];                        // 章节目录 ID(必填)
    [param setObject:self.currentCatalog.coursewareCode forKey:@"coursewareCode"];   // 课件编码(必填)
    [param setObject:[self.cws_param stringValueForKey:@"clientCode"] forKey:@"clientCode"]; // 客户端编码(必填)
    
    [param setObject:[NSNumber numberWithInteger:self.accumulativeTime] forKey:@"accumulativeTime"];// 本次累计时长(必填)
    
    [param setObject:self.learnRecordId?self.learnRecordId:[NSNull null] forKey:@"learnRecordId"]; // 主键 ID 首次听课时为null (必填)
    
    [param setObject:[self.cws_param stringValueForKey:@"userId"] forKey:@"userId"];               // 用户ID(必填)
    [param setObject:[self.cws_param stringValueForKey:@"userName"] forKey:@"userName"];           // 用户名称(必填)
    [param setObject:[self.cws_param stringValueForKey:@"serverUrl"] forKey:@"serverUrl"];         // 服务器域名（选填）
    
    [TXHTTPSessionManager uploadLearnRecordWithParam:param success:^(NSDictionary *dictionary) {
        //先判断是否是正在播放的章节
        NSDictionary *data = [dictionary dictionaryValueForKey:@"data"];
        if (data) {
            if ([[data stringValueForKey:@"catalogId"] isEqualToString:self.currentCatalog.ID]) {
                self.learnRecordId = [[dictionary objectForKey:@"data"] objectForKey:@"learnRecordId"];
            }
        }
        
        NSLog(@"上传做题结果成功！");
        
    } failure:^(NSString *failureMessage) {
        //
        NSLog(@"%@",failureMessage);
        
        [self.view showErrorWithMessage:failureMessage];
    }];
}

#pragma mark - Show Download View

- (void)showDownLoadView:(BOOL)show{
    
    self.downloadVC.view.hidden = NO;
    __weak typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.25 animations:^{
        if (show) {
            weakSelf.downloadVC.view.frame = CGRectMake(0, CGRectGetMaxY(weakSelf.playerFatherView.frame), ScreenWidth, ScreenHeight -CGRectGetMaxY(weakSelf.playerFatherView.frame));
            weakSelf.downloadVC.catalogArray = weakSelf.catalogListVC.catalogArray;
            weakSelf.downloadVC.currentCatalog = weakSelf.currentCatalog;
        } else {
            weakSelf.downloadVC.view.frame = CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight - CGRectGetMaxY(weakSelf.playerFatherView.frame));
        }
    } completion:^(BOOL finished) {
        if (!show) {
            weakSelf.downloadVC.view.hidden = YES;
        }
    }];
}

#pragma mark - QCSlideSwitchViewDelegate

- (NSUInteger)numberOfTab:(QCSlideSwitchView *)view
{
    return 2;
}

- (UIViewController *)slideSwitchView:(QCSlideSwitchView *)view viewOfTab:(NSUInteger)number
{
    if (number==0) {
        return self.catalogListVC;
    }
    return self.lectureVC;
}

- (void)slideSwitchView:(QCSlideSwitchView *)view didselectTab:(NSUInteger)number
{
    NSLog(@"didselectTab: %lu",(unsigned long)number);
}

#pragma mark - 网络请求

/**
 请求课件目录
 */
- (void)requestCatalogListData {
    
    NSDictionary *param = self.cws_param;
//    @{@"businessLineCode":@"ld_gk",
//        @"coursewareCode":@"2216_ept",
//        @"courseCode":@"04732",
//        @"catalogId":@"314972266083385344",
//        @"clientCode":@"123456",
//        @"userId":@"123456654",
//        @"userName":@"李亚飞测试",
//        @"validTime":@0,
//        @"lastTime":@0,
//        @"timestamp": @"1559094293576",             // 时间戳
//        @"publicKey": @"43787ba392c144ad50b1b1c36efdd0d5"// md5加密 校验参数
//      };
//
    [self.view showLoading];
    
    [TXHTTPSessionManager requestCatalogsWithParam:param success:^(NSDictionary *dictionary) {
        //
        NSArray *data = [TXCatalog mj_objectArrayWithKeyValuesArray:[dictionary objectForKey:@"data"]];
        //手动给目录增加排序序列，为了下载之后的列表有个顺序
        int i = 0;
        for (TXCatalog *catalog in data) {
            catalog.orderNum = i;
            i++;
        }
        self.catalogListVC.catalogArray = data;
        
        //此时判断是否有指定播放的章节
        NSString *lastCatalogId = [self.cws_param stringValueForKey:@"catalogId" WithHolder:nil];
        BOOL hiddenLoading = YES;
        if (lastCatalogId) {
            for (TXCatalog *catalog in data) {
                if ([catalog.ID isEqualToString:lastCatalogId])
                {
                    [self.catalogListVC prepareToPlayCatalog:catalog];
                    hiddenLoading = NO;
                    break;
                }
            }
        }else
        {
            [self.playerView setShowStartPlayBtn:YES];  //开始学习按钮
        }
        if (hiddenLoading) {
            [self.view hideLoading];
        }
        
    } failure:^(NSString *failureMessage) {
        //
        self.catalogListVC.catalogArray = nil;
        
        [self.view showErrorWithMessage:failureMessage];
        
        //这里注意⚠️需要手动销毁播放器
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self superPlayerBackAction:nil];
        });
        
        NSLog(@"%@",failureMessage);
    }];
}

/**
 上传学习记录
 */
- (void)updateLearnRecord {
    
    if (self.playerView.isLoaded && self.currentCatalog) {
        
        static NSInteger lastAccumulativeTime = 0;
        static NSString * lastCatalogId = @"";
        
        //不要重复传同样的数据
        if ([self.currentCatalog.ID isEqualToString:lastCatalogId] && lastAccumulativeTime == self.accumulativeTime) {
            return;
        }
        
        lastAccumulativeTime = self.accumulativeTime;
        lastCatalogId = self.currentCatalog.ID;
        
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        
        [param setObject:@"0" forKey:@"isPass"];        // 考核点是否通过(弹题是否选择正确)
        [param setObject:@"0" forKey:@"questionId"];    // 试题 ID
        [param setObject:@"0" forKey:@"examinePoint"];  // 考核点内容(弹题考核点内容)
        [param setObject:[NSString stringWithFormat:@"%d",(int)self.playerView.playCurrentTime] forKey:@"lastTime"]; // 当前媒体播放时间点(必填)
        
        [param setObject:self.currentCatalog.media.mediaDuration forKey:@"videoTime"];   // 视频时长(秒)(必填)
        [param setObject:self.currentCatalog.ID forKey:@"catalogId"];                    // 章节目录 ID(必填)
        [param setObject:self.currentCatalog.coursewareCode forKey:@"coursewareCode"];   // 课件编码(必填)
        [param setObject:[self.cws_param stringValueForKey:@"clientCode"] forKey:@"clientCode"]; // 客户端编码(必填)

        [param setObject:[NSNumber numberWithInteger:self.accumulativeTime] forKey:@"accumulativeTime"];// 本次累计时长(必填)
        
        [param setObject:self.learnRecordId?self.learnRecordId:[NSNull null] forKey:@"learnRecordId"]; // 主键 ID 首次听课时为null (必填)
        
        [param setObject:[self.cws_param stringValueForKey:@"userId"] forKey:@"userId"];               // 用户ID(必填)
        [param setObject:[self.cws_param stringValueForKey:@"userName"] forKey:@"userName"];           // 用户名称(必填)
        [param setObject:[self.cws_param stringValueForKey:@"serverUrl"] forKey:@"serverUrl"];         // 服务器域名（选填）

        [TXHTTPSessionManager uploadLearnRecordWithParam:param success:^(NSDictionary *dictionary) {
            //先判断是否是正在播放的章节
            NSDictionary *data = [dictionary dictionaryValueForKey:@"data"];
            if (data) {
                if ([[data stringValueForKey:@"catalogId"] isEqualToString:self.currentCatalog.ID]) {
                    self.learnRecordId = [[dictionary objectForKey:@"data"] objectForKey:@"learnRecordId"];
                }
            }
            
            NSLog(@"上传学习记录成功！");
            
        } failure:^(NSString *failureMessage) {
            //
            NSLog(@"%@",failureMessage);
            
            [self.view showErrorWithMessage:@"上传学习记录失败！"];
        }];
    }
}

#pragma mark -

- (BOOL)shouldAutorotate {
    return !self.playerView.isLockScreen;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    // 这里设置横竖屏不同颜色的statusbar
    if (self.playerView.isFullScreen) {
        return UIStatusBarStyleLightContent;
    }
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden {
    return self.playerView.isStatusBarHidden;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationNone;
}

// 支持哪些屏幕方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

// 全面屏底部横条自动隐藏
- (BOOL)prefersHomeIndicatorAutoHidden {
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
