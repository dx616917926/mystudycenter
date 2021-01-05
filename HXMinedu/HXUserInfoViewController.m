//
//  HXUserInfoViewController.m
//  HXMinedu
//
//  Created by Mac on 2020/12/31.
//

#import "HXUserInfoViewController.h"
#import <WebKit/WebKit.h>

@interface HXUserInfoViewController ()<WKNavigationDelegate>
{
    WKWebView *webView;
    NSString *htmlData;
}
@property (nonatomic, strong) HXBarButtonItem *leftBarItem;
@end

@implementation HXUserInfoViewController

-(void)loadView
{
    [super loadView];
    
    @weakify(self);
    self.leftBarItem = [[HXBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navi_back"] style:HXBarButtonItemStylePlain handler:^(id sender) {
        
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //手动调用创建导航栏
    [HXNavigationController createNavigationBarForViewController:self];
    
    self.sc_navigationBar.title = @"个人信息";
    self.sc_navigationBar.leftBarButtonItem = self.leftBarItem;
    
    [self createWebView];
    [self requestStuInfo];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

- (void)createWebView
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"userInfoView" ofType:@"html"];
    
    htmlData = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, kNavigationBarHeight, kScreenWidth, kScreenHeight-kNavigationBarHeight)];
    webView.backgroundColor = [UIColor whiteColor];
    webView.navigationDelegate = self;
    [self.view addSubview:webView];
}

/**
 请求用户个人信息
 */
-(void)requestStuInfo {
    
    if (!self.isLogin) {
        return;
    }
    
    [self.view showLoading];
    
    [HXBaseURLSessionManager postDataWithNSString:HXPOST_STUINFO withDictionary:nil success:^(NSDictionary *dic) {
        BOOL Success = [dic boolValueForKey:@"Success"];
        if (Success) {
            
            NSArray *array = [dic objectForKey:@"Data"];
            
            if (array.count>0) {
                [self resetWebViewData:array.firstObject];
                [self.view hideLoading];
            }else
            {
                [self.view showErrorWithMessage:@"暂无个人信息！"];
            }
        }else
        {
            [self.view showErrorWithMessage:[dic stringValueForKey:@"Message"]];
        }
    } failure:^(NSError *error) {
        [self.view showErrorWithMessage:@"获取数据失败，请重试！"];
    }];
}

- (void)resetWebViewData:(NSDictionary *)infoDic {
    
    NSArray *allKeys = infoDic.allKeys;
    
    for (NSString *key in allKeys) {
        
        NSString *value = [infoDic stringValueForKey:key];
        
        htmlData = [htmlData stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"@%@",key] withString:value];
    }
    
    [webView loadHTMLString:htmlData baseURL:nil];
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

}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    NSLog(@"个人信息已经释放内存！");
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
