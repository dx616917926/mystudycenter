//
//  HXMoocViewController.m
//  gaojijiao
//
//  Created by Mac on 2020/7/7.
//  Copyright © 2020 华夏大地教育网. All rights reserved.
//

#import "HXMoocViewController.h"
#import <WebKit/WebKit.h>

@interface HXMoocViewController ()<WKNavigationDelegate>
{
    UIView * errorView;
}
@property (nonatomic,strong) WKWebView *wkWebView;
@property (nonatomic,strong) UIProgressView *progressView;  //设置加载进度条
@property (nonatomic, strong) HXBarButtonItem *rigthBarItem;
@end

@implementation HXMoocViewController

-(void)loadView
{
    [super loadView];
    
   
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    WeakSelf(weakSelf)
    self.rigthBarItem  = [[HXBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_menu_Refresh"] style:HXBarButtonItemStylePlain handler:^(id sender) {
        StrongSelf(strongSelf)
        [strongSelf refresh];
    }];
    self.sc_navigationBar.title = HXSafeString(self.titleName);
    self.sc_navigationBar.rightBarButtonItem = self.rigthBarItem;
    [self.sc_navigationBar addSubview:self.progressView];
    [self wkWebView];
    [self loadRequest];
}


-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    //强制竖屏
    [self setOrientation:UIDeviceOrientationPortrait];
}

#pragma mark 懒加载

- (WKWebView *)wkWebView {
    if (!_wkWebView) {
        
        WKWebViewConfiguration *webViewConfig = [[WKWebViewConfiguration alloc] init];
        WKUserContentController *wkUController = [[WKUserContentController alloc] init];
        webViewConfig.userContentController = wkUController;
        //隐藏网页顶部的下载栏
        NSString *jSString = @"let styleElement = document.createElement('style');document.body.parentElement.appendChild(styleElement);styleElement.sheet.addRule('#wap-course-intro-nav', 'display: none');";
        WKUserScript *wkUserScript = [[WKUserScript alloc] initWithSource:jSString injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        [wkUController addUserScript:wkUserScript];
        
        //视频页面播放支持
        webViewConfig.allowsInlineMediaPlayback = YES;
        //关闭画中画播放模式
        webViewConfig.allowsPictureInPictureMediaPlayback = NO;
        _wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight, kScreenWidth,kScreenHeight - kNavigationBarHeight) configuration:webViewConfig];
        _wkWebView.navigationDelegate = self;
        _wkWebView.userInteractionEnabled = YES;
        _wkWebView.scrollView.scrollEnabled = YES;
        _wkWebView.allowsLinkPreview = NO;
        [self.wkWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];

        [self setUserAgent];
        [self.view addSubview:_wkWebView];
    }
    return _wkWebView;
}

- (void)setUserAgent {
    // 获取当前UserAgent, 并对其进行修改
    [self.wkWebView evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id userAgent, NSError * _Nullable error) {
        if ([userAgent isKindOfClass:[NSString class]]) {
          
            // 防止重复添加
            if ([userAgent containsString:@"hxdd_gaojijiao"]) {
                return;
            }

            NSString *systemUserAgent = userAgent;
            //  自定义UA格式: `原始UA` + `空格` + `自定义字符`
            NSString *newUserAgent = [systemUserAgent stringByAppendingString:@" hxdd_gaojijiao"];
            
            NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:newUserAgent, @"UserAgent", nil];
            [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            // 关键代码, 必须实现这个方法, 否则第一次打开UA还是原始值, 待第二次打开webview才是正确的UA;
            [self.wkWebView setCustomUserAgent:newUserAgent];
        }
    }];
}

- (UIProgressView *)progressView
{
    if (_progressView == nil) {
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight-2, kScreenWidth, 2)];
        _progressView.tintColor = COLOR_WITH_ALPHA(0x8EB4FE, 1);
        [_progressView setTrackTintColor:[UIColor clearColor]];
    }
    return _progressView;
}

-(void)loadRequest
{
    //decode URL解码 -- 已更换为新课件系统的链接  2021年08月05日
    NSString *decodedURL = [self.moocUrl stringByRemovingPercentEncoding];
    
    //编码
    NSString *encodeUrl = [decodedURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    [self.wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:encodeUrl]]];
}

- (void)refresh{
    [errorView removeFromSuperview];
    [self loadRequest];
}

-(void)set404ErrorPage
{
    if (!errorView) {
        errorView = [[UIView alloc] initWithFrame:self.view.frame];
        
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
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(loadRequest)];
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

#pragma mark - WKNavigationDelegate

//开始加载
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    self.progressView.hidden = NO;
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    self.progressView.hidden = YES;
    
    //自动点击立即参加学习按钮
    [self.wkWebView evaluateJavaScript:@"var buy = document.getElementsByClassName('ux-coursedetail-wap-buy')[0]; if(buy){buy.click();}" completionHandler:^(id userAgent, NSError * _Nullable error) {
        
    }];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"%@",error.accessibilityValue);
    self.progressView.hidden = YES;
}

#pragma mark - Method

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if (object == self.wkWebView && [keyPath isEqualToString:@"estimatedProgress"]){
        [self.progressView setAlpha:1.0f];
        BOOL animated = self.wkWebView.estimatedProgress > self.progressView.progress;
        [self.progressView setProgress:self.wkWebView.estimatedProgress animated:animated];
        
        // Once complete, fade out UIProgressView
        if(self.wkWebView.estimatedProgress >= 1.0f) {
            [UIView animateWithDuration:0.3f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self.progressView setAlpha:0.0f];
            } completion:^(BOOL finished) {
                [self.progressView setProgress:0.0f animated:NO];
            }];
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)dealloc{
    @try {
        [self.wkWebView removeObserver:self forKeyPath:@"estimatedProgress"];
    } @catch (NSException *exception) {

    }
    
}


#pragma mark - 强制竖屏
- (void)setOrientation:(int)orientation
{
    if (UIDeviceOrientationIsLandscape([[UIDevice currentDevice] orientation])) {
        [UIViewController attemptRotationToDeviceOrientation];
        return;
    }
    
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = orientation;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

@end
