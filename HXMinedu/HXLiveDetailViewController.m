//
//  HXLiveDetailViewController.m
//  HXMinedu
//
//  Created by Mac on 2020/12/21.
//

#import "HXLiveDetailViewController.h"
#import <WebKit/WebKit.h>

@interface HXLiveDetailViewController ()<WKNavigationDelegate>
{
    UIView * errorView;
}
@property (nonatomic,strong) WKWebView *wkWebView;
@property (nonatomic,strong) UIProgressView *progressView;  //设置加载进度条
@property (nonatomic, strong) HXBarButtonItem *leftBarItem;
@property (nonatomic, strong) HXBarButtonItem *rigthBarItem;
@end

@implementation HXLiveDetailViewController

-(void)loadView
{
    [super loadView];
    
    @weakify(self);
    self.leftBarItem = [[HXBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navi_back"] style:HXBarButtonItemStylePlain handler:^(id sender) {
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    self.rigthBarItem  = [[HXBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_menu_Refresh"] style:HXBarButtonItemStylePlain handler:^(id sender) {
        @strongify(self);
        [self refresh];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.sc_navigationBar.title = self.liveModel.liveName;
    self.sc_navigationBar.leftBarButtonItem = self.leftBarItem;
    self.sc_navigationBar.rightBarButtonItem = self.rigthBarItem;
    [self.sc_navigationBar addSubview:self.progressView];
    [self wkWebView];
    [self loadRequest];
}

#pragma mark 懒加载

- (WKWebView *)wkWebView {
    if (!_wkWebView) {
        
        WKWebViewConfiguration *webViewConfig = [[WKWebViewConfiguration alloc] init];
        WKUserContentController *wkUController = [[WKUserContentController alloc] init];
        webViewConfig.userContentController = wkUController;
        
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

        [self.view addSubview:_wkWebView];
    }
    return _wkWebView;
}

- (UIProgressView *)progressView
{
    if (_progressView == nil) {
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight-2, kScreenWidth, 2)];
        _progressView.tintColor = [UIColor whiteColor];
        [_progressView setTrackTintColor:[UIColor clearColor]];
    }
    return _progressView;
}

-(void)loadRequest
{
    //decode URL解码
    NSString *decodedURL = [self.liveModel.liveUrl stringByRemovingPercentEncoding];
    
    [self.wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:decodedURL]]];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
@end
