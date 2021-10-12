//
//  HXCommonWebViewController.m
//  HXMinedu
//
//  Created by 邓雄 on 2021/4/11.
//

#import "HXCommonWebViewController.h"
#import <WebKit/WebKit.h>

//自定义方法名称，提供JS调用
static NSString * const kFunctionName      =   @"callFunctionName";

@interface HXCommonWebViewController ()<WKNavigationDelegate,WKScriptMessageHandler,WKUIDelegate>

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) WKUserContentController *userContentController;

@property (nonatomic,strong) UIProgressView *progressView;  //设置加载进度条
@end

@implementation HXCommonWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //初始化webView
    [self initWebViewSettings];
    [self.sc_navigationBar addSubview:self.progressView];
    if (![HXCommonUtil isNull:self.cuntomTitle]) {
        self.sc_navigationBar.title = self.cuntomTitle;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //如果有js调用，开启
    //    [self addScriptMessageHandler];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //    [self removeScriptMessageHandler];
}

#pragma mark - 初始化webView
- (void)initWebViewSettings {
    //webview配置
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    config.allowsInlineMediaPlayback = YES;
    config.preferences.javaScriptCanOpenWindowsAutomatically = YES;
    config.userContentController = [[WKUserContentController alloc] init];
    if (@available(iOS 10.0, *)) {
        config.mediaTypesRequiringUserActionForPlayback = NO;//iOS 10.0之后
    } else {
        config.requiresUserActionForMediaPlayback = NO;//iOS 9 ～iOS 10
    }
    self.userContentController = config.userContentController;
    if (!_webView) {
        _webView = [[WKWebView alloc] initWithFrame: CGRectMake(0, kNavigationBarHeight, kScreenWidth, kScreenHeight-kNavigationBarHeight) configuration:config];
        _webView.navigationDelegate = self;
        _webView.UIDelegate = self;
        _webView.scrollView.bounces = NO;
    }
    // 加载网页
    [self loadDataWithUrl:self.urlString];
    [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [self.view addSubview:_webView];
    
}

// 加载网页
- (void)loadDataWithUrl:(NSString *)urlstr {
    if ([HXCommonUtil isNull:urlstr]) return;
    if (![urlstr hasPrefix:@"http"]) {
        urlstr = [@"https://" stringByAppendingString:urlstr];
    }
    NSURL *url = HXSafeURL(urlstr);
    NSMutableURLRequest *mutableRequest = [NSMutableURLRequest requestWithURL:url];
    //设置请求头，如果有需要
    //    [mutableRequest setValue:@"" forHTTPHeaderField:@""];
    [self.webView loadRequest:mutableRequest];
}


//js调用原生方法
- (void)addScriptMessageHandler{
    [self.userContentController addScriptMessageHandler:self name:kFunctionName];
}

//移除js调用
- (void)removeScriptMessageHandler{
    [self.userContentController removeScriptMessageHandlerForName:kFunctionName];
}


#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if (object == self.webView && [keyPath isEqualToString:@"estimatedProgress"]){
        [self.progressView setAlpha:1.0f];
        BOOL animated = self.webView.estimatedProgress > self.progressView.progress;
        [self.progressView setProgress:self.webView.estimatedProgress animated:animated];
        if(self.webView.estimatedProgress >= 1.0f) {
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


#pragma mark ---------------------------------------------- WKScriptMessageHandler

// js方法调用,从web界面中接收到一个脚本时调用
- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message{
    
}

#pragma mark- <WKNavigationDelegate>
//// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    [self.progressView setAlpha:1.0f];
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    
}

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
    if (!navigation) {
        return;
    }
    if (![HXCommonUtil isNull:webView.title]&&[HXCommonUtil isNull:self.cuntomTitle]) {
        self.sc_navigationBar.title = webView.title;
    }
    
}

// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation
      withError:(NSError *)error {
    
}

//权限认证的代理方法
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler {
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        if ([challenge previousFailureCount] == 0) {
            NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
            completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
        } else {
            completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
        }
    } else {
        completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
    }
}

- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView{
    
}

// 接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
    
}

//// 在收到响应后，决定是否跳转
//- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
//    NSLog(@"urlScheme:%@",navigationResponse.response.URL.scheme);
//    NSLog(@"%@",navigationResponse.response.URL.absoluteString);
//    //允许跳转
//    decisionHandler(WKNavigationResponsePolicyAllow);
//    //不允许跳转
//    //decisionHandler(WKNavigationResponsePolicyCancel);
//
//
//}

-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    NSLog(@"urlScheme:%@",navigationAction.request.URL.scheme);
    NSLog(@"urlStr:%@",navigationAction.request.URL.absoluteString);
    
    //先判断一下，找到需要跳转的再做处理
    if ([navigationAction.request.URL.scheme isEqualToString:@"alipay"]) {
        //  1.以？号来切割字符串
        NSArray * urlBaseArr = [navigationAction.request.URL.absoluteString componentsSeparatedByString:@"?"];
        NSString * urlBaseStr = urlBaseArr.firstObject;
        NSString * urlNeedDecode = urlBaseArr.lastObject;
        //  2.将截取以后的Str，做一下解码，方便我们处理数据
        NSMutableString * afterDecodeStr = [NSMutableString stringWithString:[HXCommonUtil strDecodedString:urlNeedDecode]];
        //  3.替换里面的默认Scheme为自己的Scheme
        NSString * afterHandleStr = [afterDecodeStr stringByReplacingOccurrencesOfString:@"alipays" withString:@"www.edu-edu.com"];
        //  4.然后把处理后的，和最开始切割的做下拼接，就得到了最终的字符串
        NSString * finalStr = [NSString stringWithFormat:@"%@?%@",urlBaseStr, [HXCommonUtil  stringEncoding:afterHandleStr]];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //  判断一下，是否安装了支付宝APP（也就是看看能不能打开这个URL）
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:finalStr]]) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:finalStr]];
            }else{
                [self.view showTostWithMessage:@"未安装支付宝APP"];
            }
        });
        
        //  2.这里告诉页面不走了 -_-
        decisionHandler(WKNavigationActionPolicyCancel);
    }else if ([navigationAction.request.URL.scheme isEqualToString:@"weixin"]) {
        //  1.以？号来切割字符串
        NSArray * urlBaseArr = [navigationAction.request.URL.absoluteString componentsSeparatedByString:@"?"];
        NSString * urlBaseStr = urlBaseArr.firstObject;
        NSString * urlNeedDecode = urlBaseArr.lastObject;
        //  2.将截取以后的Str，做一下解码，方便我们处理数据
        NSMutableString * afterDecodeStr = [NSMutableString stringWithString:[HXCommonUtil strDecodedString:urlNeedDecode]];
        //  3.替换里面的默认Scheme为自己的Scheme
        NSString * afterHandleStr = [afterDecodeStr stringByReplacingOccurrencesOfString:@"weixin" withString:@"www.edu-edu.com"];
        //  4.然后把处理后的，和最开始切割的做下拼接，就得到了最终的字符串
        NSString * finalStr = [NSString stringWithFormat:@"%@?%@",urlBaseStr, [HXCommonUtil  stringEncoding:afterHandleStr]];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //  判断一下，是否安装了支付宝APP（也就是看看能不能打开这个URL）
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:finalStr]]) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:finalStr]];
            }else{
                [self.view showTostWithMessage:@"未安装微信APP"];
            }
        });
        
        //  2.这里告诉页面不走了 -_-
        decisionHandler(WKNavigationActionPolicyCancel);
    }else if([navigationAction.request.URL.absoluteString rangeOfString:@"https://wx.tenpay.com/cgi-bin/mmpayweb-bin/checkmweb?"].location != NSNotFound){
        //设置redirect_url，如果存在redirect_url，那么需要替换redirect_url对应的值（替换内容为，自已公司支付的网页域名）
        NSString *absoluteUrl  = @"https://wx.tenpay.com/cgi-bin/mmpayweb-bin/checkmweb?";
        NSString *redirect_url = @"&redirect_url=www.edu-edu.com";
        NSString *newUrl = [NSString stringWithFormat:@"%@%@",absoluteUrl,redirect_url];
        //字符串进行替换，让回调之后返回自己的app
        newUrl = [newUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSLog(@"newUrl - - - - - - %@",newUrl);
        NSDictionary *headers = [navigationAction.request allHTTPHeaderFields];
        BOOL hasReferer = [headers objectForKey:@"Referer"]!=nil;
        if (hasReferer) {
            decisionHandler(WKNavigationActionPolicyAllow);
        } else {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:newUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
                    [request setHTTPMethod:@"GET"];
                    [request setValue:@"www.edu-edu.com://" forHTTPHeaderField: @"Referer"];
                    [self.webView loadRequest:request];
                });
            });
            decisionHandler(WKNavigationActionPolicyCancel);
        }
    }else{
        decisionHandler(WKNavigationActionPolicyAllow);
    }
    
}



#pragma mark- <WKUIDelegate>
// 输入框
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler{
    completionHandler(@"http");
}
// 确认框
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler{
    completionHandler(YES);
}
// 警告框
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    NSLog(@"%@",message);
    completionHandler();
}

#pragma mark - lazyLoad
- (UIProgressView *)progressView{
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight-1, kScreenWidth, 1)];
        _progressView.tintColor = COLOR_WITH_ALPHA(0x4BA4FE, 0.3);
        [_progressView setTrackTintColor:[UIColor clearColor]];
    }
    return _progressView;
}

- (void)dealloc {
    NSLog(@"web控制器释放！！！！");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    @try {
        [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    } @catch (NSException *exception) {
        
    }
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
