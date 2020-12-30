//
//  HXMessageDetailController.m
//  HXMinedu
//
//  Created by Mac on 2020/12/29.
//

#import "HXMessageDetailController.h"
#import <WebKit/WebKit.h>

@interface HXMessageDetailController ()<WKNavigationDelegate>
{
    WKWebView *webView;
    UIView *errorView;
}
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) NSTimer *fakeProgressTimer;
@property (nonatomic, strong) HXBarButtonItem *leftBarItem;
@end

@implementation HXMessageDetailController

-(void)loadView
{
    [super loadView];
    
    @weakify(self);
    self.leftBarItem = [[HXBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navi_back"] style:HXBarButtonItemStylePlain handler:^(id sender) {
        
        @strongify(self);
        if (self.presentingViewController)
        {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //手动调用创建导航栏
    [HXNavigationController createNavigationBarForViewController:self];
    
    self.sc_navigationBar.title = self.message.MessageTitle;
    self.sc_navigationBar.leftBarButtonItem = self.leftBarItem;
    
    [self createWebView];
    [self messageUpdate];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    @try {
        [webView removeObserver:self forKeyPath:@"estimatedProgress"];
    } @catch (NSException *exception) {

    }
}

- (NSString *)messageURL
{
    if (self.message) {
        return self.message.redirectURL;
    }
    return @"";
}

- (void)createWebView
{
    NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";

    WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    WKUserContentController *wkUController = [[WKUserContentController alloc] init];
    [wkUController addUserScript:wkUScript];

    WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
    wkWebConfig.userContentController = wkUController;
    
    webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, kNavigationBarHeight, kScreenWidth, kScreenHeight-kNavigationBarHeight) configuration:wkWebConfig];
    webView.backgroundColor = [UIColor whiteColor];
    webView.navigationDelegate = self;
    [self.view addSubview:webView];

    NSString * webUrl = [self messageURL];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:webUrl]]];
    
    self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    [self.progressView setTrackTintColor:[UIColor clearColor]];
    [self.progressView setFrame:CGRectMake(0, kNavigationBarHeight-2, kScreenWidth, 2)];

    //设置进度条颜色
    [self.progressView setTintColor:[UIColor whiteColor]];
    [self.sc_navigationBar addSubview:self.progressView];

    [webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"estimatedProgress"])
    {
        [self.progressView setAlpha:1];
        self.progressView.progress = webView.estimatedProgress;
        if (self.progressView.progress == 1) {
            [UIView animateWithDuration:0.3f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self.progressView setAlpha:0.0f];
            } completion:^(BOOL finished) {
                [self.progressView setProgress:0.0f animated:NO];
            }];
        }
    }
}

/**
 更新文章为已读状态
 */
-(void)messageUpdate {
    
    if (!self.message.message_id) {
        return;
    }
    
    NSDictionary *parameters = @{@"message_id":self.message.message_id};
    
    [HXBaseURLSessionManager postDataWithNSString:HXPOST_MESSAGE_UPDATE withDictionary:parameters success:^(NSDictionary *dic) {
        BOOL Success = [dic boolValueForKey:@"Success"];
        if (Success) {
            NSLog(@"更新文章状态为已读！");
        }else
        {
            NSLog(@"文章标记为已读失败！");
        }
    } failure:^(NSError *error) {
        NSLog(@"文章标记为已读失败！");
    }];
}

-(void)refresh
{
    [self removeErrorView];
    
    if (!NETWORK_AVAILIABLE) {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"当前网络不可用" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alertC addAction:confirmAction];
        [self presentViewController:alertC animated:YES completion:nil];
        
        [self set404ErrorPage];
        return;
    }
    NSString * webUrl = [self messageURL];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:webUrl]]];
}

-(void)set404ErrorPage
{
    if (!errorView) {
        errorView = [[UIView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight, kScreenWidth, kScreenHeight-kNavigationBarHeight)];
        
        UIImageView *logoImg = [[UIImageView alloc]initWithFrame:CGRectMake((kScreenWidth-120)/2, 100, 120, 100)];
        logoImg.image = [UIImage imageNamed:@"ic_no_events"];
        [errorView addSubview:logoImg];
        UILabel *warnMsg = [[UILabel alloc]initWithFrame:CGRectMake(0, logoImg.bottom+10, kScreenWidth, 90)];
        warnMsg.text = @"该内容暂时无法访问！\n\n点我重新加载";
        warnMsg.numberOfLines = 3;
        warnMsg.textColor = [UIColor colorWithRed:0.78 green:0.78 blue:0.78 alpha:1];
        warnMsg.font = [UIFont systemFontOfSize:17];
        warnMsg.textAlignment = NSTextAlignmentCenter;
        warnMsg.userInteractionEnabled = YES;
        [errorView addSubview:warnMsg];
        
        //点击刷新
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(refresh)];
        [warnMsg addGestureRecognizer:tap];
    }
    
    if (errorView.superview == nil) {
        [self.view addSubview:errorView];
    }
}

-(void)removeErrorView
{
    if (errorView) {
        [errorView removeFromSuperview];
    }
}

#pragma mark - WKWebViewDelegate

-(WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures
{
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{

//    __weak __typeof(self)weakSelf = self;
//    [webView evaluateJavaScript:@"document.title" completionHandler:^(id result, NSError * _Nullable error) {
//        if (error == nil) {
//            if (result != nil) {
//                weakSelf.sc_navigationBar.title = [NSString stringWithFormat:@"%@", result];
//            }
//        } else {
//            NSLog(@"evaluateJavaScript error : %@", error.localizedDescription);
//        }
//    }];
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    [self set404ErrorPage];
    [self fakeProgressBarStopLoading];
}

- (void)fakeProgressBarStopLoading {
    if(self.progressView) {
        [self.progressView setProgress:1.0f animated:YES];
        [UIView animateWithDuration:0.3f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
            [self.progressView setAlpha:0.0f];
        } completion:^(BOOL finished) {
            [self.progressView setProgress:0.0f animated:NO];
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    NSLog(@"文章已经释放内存！");
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
