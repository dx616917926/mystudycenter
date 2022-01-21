//
//  HXVoucherViewController.m
//  HXMinedu
//
//  Created by mac on 2021/4/30.
//

#import "HXVoucherViewController.h"
#import <AFNetworking/AFNetworking.h>
#import <QuickLook/QuickLook.h>
#import "SDWebImage.h"
#import "HXPhotoManager.h"
#import "GKPhotoBrowser.h"

@interface HXVoucherViewController ()<QLPreviewControllerDataSource,GKPhotoBrowserDelegate>
@property (nonatomic, strong) UIImageView *showImageView;
@property (nonatomic, strong) UIButton *downLoadBtn;

@property (nonatomic, strong) QLPreviewController *QLController;
@property (nonatomic, copy) NSURL *fileURL;

/** 这里用weak是防止GKPhotoBrowser被强引用，导致不能释放 */
@property (nonatomic, weak) GKPhotoBrowser *browser;


@end

@implementation HXVoucherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //UI
    [self createUI];
   
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

    [self.view showLoadingWithMessage:@"正在下载..."];
    //下载文件
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress *downloadProgress){
        
    } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        NSURL *url = [documentsDirectoryURL URLByAppendingPathComponent:fileName];
        return url;
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        [self.view hideLoading];
        self.fileURL = filePath;
        [self presentViewController:self.QLController animated:YES completion:nil];
        //刷新界面,如果不刷新的话，不重新走一遍代理方法，返回的url还是上一次的url
        [self.QLController refreshCurrentPreviewItem];
    }];
    [downloadTask resume];
}


-(void)tapImageView:(UITapGestureRecognizer *)ges{
    if ([self.downLoadUrl containsString:@".jpeg"]||[self.downLoadUrl containsString:@".jpg"]||[self.downLoadUrl containsString:@".png"]){
        NSMutableArray *photos = [NSMutableArray new];
        GKPhoto *photo = [GKPhoto new];
        photo.url = [NSURL URLWithString:self.downLoadUrl];
        photo.sourceImageView =(UIImageView *)ges.view;
        [photos addObject:photo];
        [self.browser resetPhotoBrowserWithPhotos:photos];
        [self.browser showFromVC:self];
    }
    
}

-(GKPhotoBrowser *)browser{
    if (!_browser) {
        _browser = [GKPhotoBrowser photoBrowserWithPhotos:[NSArray array] currentIndex:0];
        _browser.showStyle = GKPhotoBrowserShowStyleZoom;        // 缩放显示
        _browser.hideStyle = GKPhotoBrowserHideStyleZoomScale;   // 缩放隐藏
        _browser.loadStyle = GKPhotoBrowserLoadStyleIndeterminateMask; // 不明确的加载方式带阴影
        _browser.maxZoomScale = 5.0f;
        _browser.doubleZoomScale = 2.0f;
        _browser.isAdaptiveSafeArea = YES;
        _browser.hidesCountLabel = YES;
        _browser.pageControl.hidden = YES;
        _browser.isScreenRotateDisabled = YES;
        _browser.isHideSourceView = NO;
        _browser.delegate = self;
        
    }
    return _browser;
}



#pragma mark - UI
-(void)createUI{
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    ///查看凭证 PDFType: 1、已支付待确认,交易凭证     2、已完成,收款凭证    3、已完成,发票凭证
    self.sc_navigationBar.title = (self.PDFType== 1?@"交易凭证":(self.PDFType== 2?@"收款凭证":@"发票凭证"));
    
    [self.view addSubview:self.showImageView];
    [self.view addSubview:self.downLoadBtn];
    
    self.showImageView.sd_layout
    .topSpaceToView(self.view, kNavigationBarHeight+82)
    .leftSpaceToView(self.view, _kpw(105))
    .rightSpaceToView(self.view, _kpw(105))
    .heightIs(191);
    
    self.downLoadBtn.sd_layout
    .bottomSpaceToView(self.view, 18+kScreenBottomMargin)
    .leftSpaceToView(self.view, _kpw(20))
    .rightSpaceToView(self.view, _kpw(20))
    .heightIs(45);
    self.downLoadBtn.sd_cornerRadius = @6;
    [self.downLoadBtn updateLayout];
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.bounds = self.downLoadBtn.bounds;
    gradientLayer.startPoint = CGPointMake(0, 0.5);
    gradientLayer.endPoint = CGPointMake(1, 0.5);
    gradientLayer.anchorPoint = CGPointMake(0, 0);
    NSArray *colorArr = @[(id)COLOR_WITH_ALPHA(0x4BA4FE, 1).CGColor,(id)COLOR_WITH_ALPHA(0x45EFCF, 1).CGColor];
    gradientLayer.colors = colorArr;
    [self.downLoadBtn.layer insertSublayer:gradientLayer below:self.downLoadBtn.titleLabel.layer];
    
    
    
    if ([self.downLoadUrl containsString:@".jpeg"]||[self.downLoadUrl containsString:@".jpg"]||[self.downLoadUrl containsString:@".png"]) {
        [self.showImageView sd_setImageWithURL:[NSURL URLWithString:HXSafeString(self.downLoadUrl)] placeholderImage:nil];
    }else{
        [self.showImageView sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"bigziliao_icon"]];
    }
}

-(UIImageView *)showImageView{
    if (!_showImageView) {
        _showImageView = [[UIImageView alloc] init];
        _showImageView.userInteractionEnabled = YES;
        
        _showImageView.contentMode = UIViewContentModeScaleAspectFit;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView:)];
        [_showImageView addGestureRecognizer:tap];
    }
    return _showImageView;
}

-(UIButton *)downLoadBtn{
    if (!_downLoadBtn) {
        _downLoadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _downLoadBtn.titleLabel.font = HXBoldFont(18);
        ///查看凭证 PDFType: 1、已支付待确认,交易凭证     2、已完成,收款凭证    3、已完成,发票凭证
        [_downLoadBtn setTitle:(self.PDFType == 1?@"下载交易凭证":(self.PDFType == 2?@"下载收款凭证":@"下载发票凭证")) forState:UIControlStateNormal];
        [_downLoadBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_downLoadBtn addTarget:self action:@selector(downLoad:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _downLoadBtn;
}
#pragma mark - Setter
///查看凭证 PDFType: 1、已支付待确认,交易凭证     2、已完成,收款凭证    3、已完成,发票凭证
- (void)setPDFType:(NSInteger)PDFType{
    _PDFType = PDFType;
}

-(void)setDownLoadUrl:(NSString *)downLoadUrl{
    _downLoadUrl = downLoadUrl;
}

#pragma mark - Private Method
- (UIImage *)getImageFromPDF{
    if ([HXCommonUtil isNull:self.downLoadUrl]) return nil;
    NSURL * url = [[NSURL alloc] initWithString:self.downLoadUrl];
    CFURLRef ref = (__bridge CFURLRef)url;
    CGPDFDocumentRef pdf = CGPDFDocumentCreateWithURL(ref);
    CFRelease(ref);
    CGImageRef imageRef = PDFPageToCGImage(1,pdf);
    UIImage *image = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return image;
   //保存图片到相册
//    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);

}

CGImageRef PDFPageToCGImage(size_t pageNumber, CGPDFDocumentRef document){

    CGPDFPageRef page = CGPDFDocumentGetPage (document, pageNumber);
    if(page){
        CGRect pageSize = CGPDFPageGetBoxRect(page,kCGPDFMediaBox);
        CGContextRef outContext= CreateARGBBitmapContext (pageSize.size.width, pageSize.size.height);
        if(outContext){
            CGContextDrawPDFPage(outContext, page);
            CGImageRef ThePDFImage= CGBitmapContextCreateImage(outContext);
            CFRelease(outContext);
            return ThePDFImage;
        }
    }
    return NULL;
}

CGContextRef CreateARGBBitmapContext (size_t pixelsWide, size_t pixelsHigh){
    CGContextRef    context = NULL;
    CGColorSpaceRef colorSpace;
    void * bitmapData;
    unsigned long   bitmapByteCount;
    unsigned long   bitmapBytesPerRow;
    bitmapBytesPerRow   = (pixelsWide * 4);
    bitmapByteCount     = (bitmapBytesPerRow * pixelsHigh);
    colorSpace =CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB);
    if (colorSpace == NULL){
        fprintf(stderr, "Error allocating color space\n");
        return NULL;
    }

    bitmapData = malloc( bitmapByteCount );
    if (bitmapData == NULL){
        fprintf (stderr, "Memory not allocated!");
        CGColorSpaceRelease( colorSpace );
        return NULL;
    }
    context = CGBitmapContextCreate (bitmapData,

                                     pixelsWide,

                                     pixelsHigh,

                                     8,      // bits per component

                                     bitmapBytesPerRow,

                                     colorSpace,

                                     kCGImageAlphaPremultipliedFirst);

    if (context == NULL){
        free (bitmapData);
        fprintf (stderr, "Context not created!");
    }

    // Make sure and release colorspace before returning

    CGColorSpaceRelease( colorSpace );
    return context;
}


// 功能：显示图片保存结果

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo{
    if (error){
        [self.view showTostWithMessage:@"保存图片失败！"];
    }else {
        [self.view showTostWithMessage:@"保存图片成功！"];
    }
}

@end
