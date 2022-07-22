//
//  HXLoadDownloadFileViewController.m
//  HXMinedu
//
//  Created by mac on 2022/4/11.
//

#import "HXLoadDownloadFileViewController.h"
#import <WebKit/WebKit.h>

@interface HXLoadDownloadFileViewController ()

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) WKUserContentController *userContentController;

@end

@implementation HXLoadDownloadFileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
//        _webView.navigationDelegate = self;
//        _webView.UIDelegate = self;
        _webView.scrollView.bounces = NO;
    }
    

    [self.view addSubview:_webView];
    
}


- (void)loadLocalFileWebView:(NSString *)filePath{
    
    [self initWebViewSettings];

    NSURL *url = [NSURL fileURLWithPath:filePath];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    /// 加载网页
    [self.webView loadRequest:request];
}

@end
