//
//  HXRegistFormViewController.m
//  HXMinedu
//
//  Created by mac on 2021/4/8.
//

#import "HXRegistFormViewController.h"
#import <AFNetworking/AFNetworking.h>
#import <QuickLook/QuickLook.h>


@interface HXRegistFormViewController ()<QLPreviewControllerDataSource>
@property (nonatomic, strong) UIImageView *formImageView;
@property (nonatomic, strong) UIButton *downLoadBtn;

@property (nonatomic, copy) NSString *downLoadUrl;

@property (nonatomic, strong) QLPreviewController *QLController;
@property (nonatomic, copy) NSURL *fileURL;

@end

@implementation HXRegistFormViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //UI
    [self createUI];
    ///获取新生报名表单下载链接
    [self getDownPdf];
    
    self.QLController = [[QLPreviewController alloc] init];
    self.QLController.dataSource = self;
}

#pragma mark - QLPreviewControllerDataSource
/// 文件路径
- (id<QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index {
    return self.fileURL;
}
/// 文件数
- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller {
    return 1;
}

#pragma mark - Event

-(void)downLoad:(UIButton *)sender{
    if ([HXCommonUtil isNull:self.downLoadUrl]) {
        [self.view showTostWithMessage:@"资源无效"];
        return;
    }
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    // 1. 创建会话管理者
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    // 2. 创建下载路径和请求对象
    NSURL *URL = [NSURL URLWithString:self.downLoadUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    NSString *fileName = [self.downLoadUrl lastPathComponent]; //获取文件名称
    //判断是否存在
        if ([self isFileExist:fileName]) {
            NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
            NSURL *url = [documentsDirectoryURL URLByAppendingPathComponent:fileName];
            self.fileURL = url;
            [self presentViewController:self.QLController animated:YES completion:nil];
            //刷新界面,如果不刷新的话，不重新走一遍代理方法，返回的url还是上一次的url
            [self.QLController refreshCurrentPreviewItem];
        } else {
            //下载文件
            NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress *downloadProgress){
                
            } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
                NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
                NSURL *url = [documentsDirectoryURL URLByAppendingPathComponent:fileName];
                return url;
            } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
                self.fileURL = filePath;
                [self presentViewController:self.QLController animated:YES completion:nil];
                //刷新界面,如果不刷新的话，不重新走一遍代理方法，返回的url还是上一次的url
                [self.QLController refreshCurrentPreviewItem];
            }];
            [downloadTask resume];
        }
}

// 判断文件是否已经在沙盒中存在，1:存在 0:不存在
- (BOOL)isFileExist:(NSString *)fileName{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *filePath = [path stringByAppendingPathComponent:fileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL result = [fileManager fileExistsAtPath:filePath];
    return result;
}

#pragma mark - 获取新生报名表单下载链接
-(void)getDownPdf{
    HXMajorModel *selectMajorModel = [HXPublicParamTool sharedInstance].selectMajorModel;
    NSDictionary *dic = @{
        @"version_id":HXSafeString(selectMajorModel.versionId),
        @"major_id":HXSafeString(selectMajorModel.major_id)
    };
    [HXBaseURLSessionManager postDataWithNSString:HXPOST_Get_DownPdf  withDictionary:dic success:^(NSDictionary * _Nonnull dictionary) {
        
        BOOL success = [dictionary boolValueForKey:@"Success"];
        if (success) {
            self.downLoadUrl = [dictionary objectForKey:@"Data"];
            
        }else{
            [self.view showErrorWithMessage:[dictionary stringValueForKey:@"Message"]];
        }
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

#pragma mark - UI
-(void)createUI{
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.sc_navigationBar.title = @"报名表单";
    
    [self.view addSubview:self.formImageView];
    [self.view addSubview:self.downLoadBtn];
    
    self.formImageView.sd_layout
    .centerXEqualToView(self.view)
    .topSpaceToView(self.view, kNavigationBarHeight+40)
    .widthIs(176)
    .heightIs(131);
    
    self.downLoadBtn.sd_layout
    .centerXEqualToView(self.view)
    .topSpaceToView(self.formImageView, 40)
    .widthIs(190)
    .heightIs(36);
    self.downLoadBtn.sd_cornerRadius = @8;
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.bounds = self.downLoadBtn.bounds;
    gradientLayer.startPoint = CGPointMake(0, 0.5);
    gradientLayer.endPoint = CGPointMake(1, 0.5);
    gradientLayer.anchorPoint = CGPointMake(0, 0);
    NSArray *colorArr = @[(id)COLOR_WITH_ALPHA(0x4BA4FE, 1).CGColor,(id)COLOR_WITH_ALPHA(0x45EFCF, 1).CGColor];
    gradientLayer.colors = colorArr;
    [self.downLoadBtn.layer insertSublayer:gradientLayer below:self.downLoadBtn.titleLabel.layer];
    
}

-(UIImageView *)formImageView{
    if (!_formImageView) {
        _formImageView = [[UIImageView alloc] init];
        _formImageView.image = [UIImage imageNamed:@"ziliao_icon"];
    }
    return _formImageView;
}

-(UIButton *)downLoadBtn{
    if (!_downLoadBtn) {
        _downLoadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _downLoadBtn.titleLabel.font = HXBoldFont(18);
        [_downLoadBtn setTitle:@"点击下载" forState:UIControlStateNormal];
        [_downLoadBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _downLoadBtn.backgroundColor = COLOR_WITH_ALPHA(0x4BA4FE, 1);
        [_downLoadBtn addTarget:self action:@selector(downLoad:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _downLoadBtn;
}



@end
