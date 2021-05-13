//
//  HXUpLoadVoucherViewController.m
//  HXMinedu
//
//  Created by mac on 2021/5/6.
//

#import "HXUpLoadVoucherViewController.h"
#import "HXPaymentDtailsContainerViewController.h"
#import "HXPhotoManager.h"
#import "SDWebImage.h"
#import "GKPhotoBrowser.h"
#import "GKCover.h"
#import "UIViewController+HXExtension.h"
@interface HXUpLoadVoucherViewController ()<GKPhotoBrowserDelegate>

@property(nonatomic,strong) UIScrollView *mainScrollView;
@property(nonatomic,strong) UIView *topView;
@property(nonatomic,strong) UIButton *backBtn;
@property(nonatomic,strong) UILabel *titleLabel;
@property(nonatomic,strong) UIButton *successButton;

@property(nonatomic,strong) UIImageView *lineImageView;
@property(nonatomic,strong) UIImageView *middleImageView;
@property(nonatomic,strong) UILabel *paymentMoneyLabel;
@property(nonatomic,strong) UILabel *paymentMethodLabel;
@property(nonatomic,strong) UILabel *paymentMethodContentLabel;
@property(nonatomic,strong) UILabel *orderNumLabel;
@property(nonatomic,strong) UILabel *orderNumContentLabel;
@property(nonatomic,strong) UILabel *orderTimeLabel;
@property(nonatomic,strong) UILabel *orderTimeContentLabel;

@property(nonatomic,strong) UIImageView *showUpLoadImageView;
@property(nonatomic,strong) UIButton *addPhotoBtn;

@property(nonatomic,strong) UILabel *upLoadTipLabel;

@property(nonatomic,strong) UIButton *cancelBtn;
@property(nonatomic,strong) UIButton *upLoadBtn;

@property(nonatomic,strong) HXPhotoManager *photoManager;
/** 这里用weak是防止GKPhotoBrowser被强引用，导致不能释放 */
@property (nonatomic, weak) GKPhotoBrowser *browser;

@end

@implementation HXUpLoadVoucherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
}



#pragma mark - Event
-(void)popBack:(UIButton *)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)addPhoto:(UIButton *)sender{
    WeakSelf(weakSelf)
    [self hx_presentSelectPhotoControllerWithManager:self.photoManager didDone:^(NSArray<HXPhotoModel *> * _Nullable allList, NSArray<HXPhotoModel *> * _Nullable photoList, NSArray<HXPhotoModel *> * _Nullable videoList, BOOL isOriginal, UIViewController * _Nullable viewController, HXPhotoManager * _Nullable manager) {
        HXPhotoModel *photoModel = allList.firstObject;
        // 因为是编辑过的照片所以直接取
        weakSelf.showUpLoadImageView.image = photoModel.photoEdit.editPreviewImage;
        weakSelf.addPhotoBtn.hidden = YES;
    } cancel:nil];
    
    
}

-(void)upLoadImage:(UIButton *)sender{
    NSString *encodedImageStr = [self imageChangeBase64:self.showUpLoadImageView.image];
    if (!self.showUpLoadImageView.image){
        [self.view showTostWithMessage:@"请添加图片"];
        return;
    }
    //上传图片
    [self uploadStudentFile:encodedImageStr];
}

#pragma mark - 预览大图
-(void)tapImageView:(UITapGestureRecognizer *)ges{
    if (!self.showUpLoadImageView.image) return;
    NSMutableArray *photos = [NSMutableArray new];
    GKPhoto *photo = [GKPhoto new];
    photo.image = self.showUpLoadImageView.image;
    photo.sourceImageView =(UIImageView *)ges.view;
    [photos addObject:photo];
    [self.browser resetPhotoBrowserWithPhotos:photos];
    [self.browser showFromVC:self];
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


#pragma mark - 上传图片信息
-(void)uploadStudentFile:(NSString *)encodedImageStr{
    [self.view showLoadingWithMessage:@"正在上传..."];
    HXMajorModel *selectMajorModel = [HXPublicParamTool sharedInstance].selectMajorModel;
    NSDictionary *dic = @{
        @"version_id":HXSafeString(selectMajorModel.versionId),
        @"major_id":HXSafeString(selectMajorModel.major_id),
        @"type":@(selectMajorModel.type),
        @"image":HXSafeString(encodedImageStr),
        @"orderNum":HXSafeString(self.scanCodePaymentModel.orderNum)
    };
    [HXBaseURLSessionManager postDataWithNSString:HXPOST_UploadProofFile  withDictionary:dic success:^(NSDictionary * _Nonnull dictionary) {
        [self.view hideLoading];
        BOOL success = [dictionary boolValueForKey:@"Success"];
        if (success) {
            [self.view showTostWithMessage:[dictionary stringValueForKey:@"Message"] hideAfter:3];
            //返回全部订单页面，刷新数据
            [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:[HXPaymentDtailsContainerViewController class]]) {
                    [self.navigationController popToViewController:obj animated:YES];
                    *stop = YES;
                    //发出支付截图上传成功通知
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"ZhiFuImageUploadSuccessNotification" object:nil];
                    return;;
                }
            }];
        }
    } failure:^(NSError * _Nonnull error) {
        [self.view hideLoading];
    }];
}
#pragma mark -- image转化成Base64位
-(NSString *)imageChangeBase64: (UIImage *)image{
    UIImage*compressImage = [HXCommonUtil compressImageSize:image toByte:250000];
    NSData*imageData =  UIImageJPEGRepresentation(compressImage, 1);
    NSLog(@"压缩后图片大小：%.2f M",(float)imageData.length/(1024*1024.0f));
    return [NSString stringWithFormat:@"%@",[imageData base64EncodedStringWithOptions:0]];
}

#pragma mark - UI

-(void)createUI{
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.sc_navigationBar.leftBarButtonItem = nil;
    [self sc_setNavigationBarBackgroundAlpha:0];
    [self setSc_NavigationBarAnimateInvalid:YES];
    
    [self.view addSubview:self.mainScrollView];
    [self.mainScrollView addSubview:self.topView];
    [self.topView addSubview:self.backBtn];
    [self.topView addSubview:self.titleLabel];
    [self.topView addSubview:self.successButton];
    [self.mainScrollView addSubview:self.lineImageView];
    [self.mainScrollView addSubview:self.middleImageView];
    [self.middleImageView addSubview:self.paymentMoneyLabel];
    [self.middleImageView addSubview:self.paymentMethodLabel];
    [self.middleImageView addSubview:self.paymentMethodContentLabel];
    [self.middleImageView addSubview:self.orderNumLabel];
    [self.middleImageView addSubview:self.orderNumContentLabel];
    [self.middleImageView addSubview:self.orderTimeLabel];
    [self.middleImageView addSubview:self.orderTimeContentLabel];
    [self.mainScrollView addSubview:self.showUpLoadImageView];
    [self.showUpLoadImageView addSubview:self.addPhotoBtn];
    [self.mainScrollView addSubview:self.upLoadTipLabel];
    [self.mainScrollView addSubview:self.cancelBtn];
    [self.mainScrollView addSubview:self.upLoadBtn];
    
    self.mainScrollView.sd_layout
    .topEqualToView(self.view)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomSpaceToView(self.view, 0);
    
    
    self.topView.sd_layout
    .topEqualToView(self.mainScrollView)
    .centerXEqualToView(self.mainScrollView)
    .widthIs(kScreenWidth)
    .heightIs(233);
    
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.bounds = self.topView.bounds;
    gradientLayer.startPoint = CGPointMake(0, 0.5);
    gradientLayer.endPoint = CGPointMake(1, 0.5);
    gradientLayer.anchorPoint = CGPointMake(0, 0);
    NSArray *colorArr = @[(id)COLOR_WITH_ALPHA(0x4BA4FE, 1).CGColor,(id)COLOR_WITH_ALPHA(0x45EFCF, 1).CGColor];
    gradientLayer.colors = colorArr;
    [self.topView.layer insertSublayer:gradientLayer below:self.backBtn.layer];
    
    
    self.titleLabel.sd_layout
    .topSpaceToView(self.topView, kNavigationBarHeight)
    .centerXEqualToView(self.topView)
    .heightIs(25)
    .widthIs(120);
    
    self.backBtn.sd_layout
    .leftSpaceToView(self.topView, 0)
    .centerYEqualToView(self.titleLabel)
    .widthIs(100)
    .heightIs(30);
    
    self.backBtn.imageView.sd_layout
    .centerYEqualToView(self.backBtn)
    .leftSpaceToView(self.backBtn, 15)
    .widthIs(24)
    .heightEqualToWidth();
    
    self.successButton.sd_layout
    .centerXEqualToView(self.topView)
    .topSpaceToView(self.titleLabel, 28)
    .heightIs(52);
    
    self.successButton.imageView.sd_layout
    .centerYEqualToView(self.successButton)
    .leftEqualToView(self.successButton)
    .widthIs(45)
    .heightIs(52);
    
    self.successButton.titleLabel.sd_layout
    .centerYEqualToView(self.successButton)
    .leftSpaceToView(self.successButton.imageView, 8)
    .heightIs(22);
    [self.successButton.titleLabel setSingleLineAutoResizeWithMaxWidth:100];
    
    [self.successButton setupAutoWidthWithRightView:self.successButton.titleLabel rightMargin:0];
    
    self.lineImageView.sd_layout
    .topSpaceToView(self.topView, -30)
    .leftSpaceToView(self.mainScrollView, 30)
    .rightSpaceToView(self.mainScrollView, 30)
    .heightIs(10);
    
    self.middleImageView.sd_layout
    .topSpaceToView(self.lineImageView, -9)
    .leftSpaceToView(self.mainScrollView, 33)
    .rightSpaceToView(self.mainScrollView, 33)
    .heightIs(198);
    
    self.paymentMoneyLabel.sd_layout
    .topSpaceToView(self.middleImageView, 32)
    .leftSpaceToView(self.middleImageView, _kpw(34))
    .rightSpaceToView(self.middleImageView, _kpw(34))
    .heightIs(40);
    
    self.paymentMethodLabel.sd_layout
    .topSpaceToView(self.paymentMoneyLabel, 27)
    .leftEqualToView(self.paymentMoneyLabel)
    .widthIs(70)
    .heightIs(17);
    
    self.paymentMethodContentLabel.sd_layout
    .centerYEqualToView(self.paymentMethodLabel)
    .leftSpaceToView(self.paymentMethodLabel, 10)
    .rightEqualToView(self.paymentMoneyLabel)
    .heightRatioToView(self.paymentMethodLabel, 1);
    
    self.orderNumLabel.sd_layout
    .topSpaceToView(self.paymentMethodLabel, 12)
    .leftEqualToView(self.paymentMoneyLabel)
    .widthRatioToView(self.paymentMethodLabel, 1)
    .heightRatioToView(self.paymentMethodLabel, 1);
    
    self.orderNumContentLabel.sd_layout
    .centerYEqualToView(self.orderNumLabel)
    .leftSpaceToView(self.orderNumLabel, 10)
    .rightEqualToView(self.paymentMoneyLabel)
    .heightRatioToView(self.paymentMethodLabel, 1);
    
    self.orderTimeLabel.sd_layout
    .topSpaceToView(self.orderNumLabel, 12)
    .leftEqualToView(self.paymentMoneyLabel)
    .widthRatioToView(self.paymentMethodLabel, 1)
    .heightRatioToView(self.paymentMethodLabel, 1);
    
    self.orderTimeContentLabel.sd_layout
    .centerYEqualToView(self.orderTimeLabel)
    .leftSpaceToView(self.orderTimeLabel, 10)
    .rightEqualToView(self.paymentMoneyLabel)
    .heightRatioToView(self.paymentMethodLabel, 1);
    
    self.showUpLoadImageView.sd_layout
    .topSpaceToView(self.middleImageView, 23)
    .leftEqualToView(self.middleImageView)
    .rightEqualToView(self.middleImageView)
    .heightIs(170);
    self.showUpLoadImageView.sd_cornerRadius = @6;
    
    self.addPhotoBtn.sd_layout
    .centerXEqualToView(self.showUpLoadImageView)
    .centerYEqualToView(self.showUpLoadImageView)
    .widthIs(50)
    .heightEqualToWidth();
    
    self.upLoadTipLabel.sd_layout
    .topSpaceToView(self.showUpLoadImageView, 5)
    .leftEqualToView(self.middleImageView)
    .rightEqualToView(self.middleImageView)
    .heightIs(17);
    
    self.cancelBtn.sd_layout
    .topSpaceToView(self.upLoadTipLabel, 25)
    .leftEqualToView(self.middleImageView)
    .widthIs(_kpw(138))
    .heightIs(42);
    self.cancelBtn.sd_cornerRadius =@6;
    
    self.upLoadBtn.sd_layout
    .centerYEqualToView(self.cancelBtn)
    .rightEqualToView(self.middleImageView)
    .widthRatioToView(self.cancelBtn, 1)
    .heightRatioToView(self.cancelBtn, 1);
    self.upLoadBtn.sd_cornerRadius =@6;
    [self.upLoadBtn updateLayout];
    
    CAGradientLayer *btGradientLayer = [CAGradientLayer layer];
    btGradientLayer.bounds = self.upLoadBtn.bounds;
    btGradientLayer.startPoint = CGPointMake(0, 0.5);
    btGradientLayer.endPoint = CGPointMake(1, 0.5);
    btGradientLayer.anchorPoint = CGPointMake(0, 0);
    btGradientLayer.colors = colorArr;
    [self.upLoadBtn.layer insertSublayer:btGradientLayer below:self.upLoadBtn.titleLabel.layer];
    
    [self.mainScrollView setupAutoContentSizeWithBottomView:self.cancelBtn bottomMargin:kScreenBottomMargin+30];
}


#pragma mark - lazyLoad
- (HXPhotoManager *)photoManager {
    if (!_photoManager) {
        _photoManager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhotoAndVideo];
        _photoManager.selectPhotoFinishDismissAnimated = YES;
        _photoManager.cameraFinishDismissAnimated = YES;
        _photoManager.type = HXPhotoManagerSelectedTypePhoto;
        _photoManager.configuration.singleJumpEdit = YES;
        _photoManager.configuration.singleSelected = YES;
        _photoManager.configuration.lookGifPhoto = NO;
        _photoManager.configuration.lookLivePhoto = NO;
        _photoManager.configuration.photoEditConfigur.aspectRatio = HXPhotoEditAspectRatioType_Custom;
        _photoManager.configuration.photoEditConfigur.onlyCliping = YES;
    }
    return _photoManager;
}
-(UIScrollView *)mainScrollView{
    if (!_mainScrollView) {
        _mainScrollView = [[UIScrollView alloc] init];
        _mainScrollView.backgroundColor = COLOR_WITH_ALPHA(0xF5F6FA, 1);
        _mainScrollView.showsVerticalScrollIndicator = NO;
        _mainScrollView.bounces = NO;
        self.extendedLayoutIncludesOpaqueBars = YES;
        if (@available(iOS 11.0, *)) {
            _mainScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    return _mainScrollView;
}

-(UIView *)topView{
    if (!_topView) {
        _topView = [[UIView alloc] init];
    }
    return _topView;
}


-(UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:[UIImage imageNamed:@"navi_whiteback"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(popBack:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = HXBoldFont(18);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = @"支付订单";
    }
    return _titleLabel;
}

-(UIButton *)successButton{
    if (!_successButton) {
        _successButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _successButton.titleLabel.font = HXFont(16);
        [_successButton setImage:[UIImage imageNamed:@"zhifu_success"] forState:UIControlStateNormal];
        [_successButton setTitle:@"支付成功" forState:UIControlStateNormal];
    }
    return _successButton;
}

- (UIImageView *)lineImageView{
    if (!_lineImageView) {
        _lineImageView = [[UIImageView alloc] init];
        _lineImageView.image = [UIImage imageNamed:@"zhifu_juxing"];
    }
    return _lineImageView;
}

- (UIImageView *)middleImageView{
    if (!_middleImageView) {
        _middleImageView = [[UIImageView alloc] init];
        _middleImageView.image = [UIImage imageNamed:@"zhifu_middle"];
    }
    return _middleImageView;
}

- (UILabel *)paymentMoneyLabel{
    if (!_paymentMoneyLabel) {
        _paymentMoneyLabel = [[UILabel alloc] init];
        _paymentMoneyLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        _paymentMoneyLabel.font = HXBoldFont(28);
        _paymentMoneyLabel.textAlignment = NSTextAlignmentCenter;
        NSString *needStr = [NSString stringWithFormat:@"%.2f",self.scanCodePaymentModel.fee];
        NSString *contentStr = [@"¥ " stringByAppendingString:needStr];
        _paymentMoneyLabel.attributedText = [HXCommonUtil getAttributedStringWith:needStr needAttributed:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:28]} content:contentStr defaultAttributed:@{NSFontAttributeName:[UIFont systemFontOfSize:18]}];
    }
    return _paymentMoneyLabel;
}

- (UILabel *)paymentMethodLabel{
    if (!_paymentMethodLabel) {
        _paymentMethodLabel = [[UILabel alloc] init];
        _paymentMethodLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        _paymentMethodLabel.font = HXFont(12);
        _paymentMethodLabel.textAlignment = NSTextAlignmentLeft;
        _paymentMethodLabel.text = @"支付类型：";
    }
    return _paymentMethodLabel;
}

- (UILabel *)paymentMethodContentLabel{
    if (!_paymentMethodContentLabel) {
        _paymentMethodContentLabel = [[UILabel alloc] init];
        _paymentMethodContentLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        _paymentMethodContentLabel.font = HXFont(12);
        _paymentMethodContentLabel.textAlignment = NSTextAlignmentRight;
        _paymentMethodContentLabel.text = @"扫码";
    }
    return _paymentMethodContentLabel;
}

- (UILabel *)orderNumLabel{
    if (!_orderNumLabel) {
        _orderNumLabel = [[UILabel alloc] init];
        _orderNumLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        _orderNumLabel.font = HXFont(12);
        _orderNumLabel.textAlignment = NSTextAlignmentLeft;
        _orderNumLabel.text = @"订单编号：";
    }
    return _orderNumLabel;
}

- (UILabel *)orderNumContentLabel{
    if (!_orderNumContentLabel) {
        _orderNumContentLabel = [[UILabel alloc] init];
        _orderNumContentLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        _orderNumContentLabel.font = HXFont(12);
        _orderNumContentLabel.textAlignment = NSTextAlignmentRight;
        _orderNumContentLabel.text = HXSafeString(self.scanCodePaymentModel.orderNum);
    }
    return _orderNumContentLabel;
}

- (UILabel *)orderTimeLabel{
    if (!_orderTimeLabel) {
        _orderTimeLabel = [[UILabel alloc] init];
        _orderTimeLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        _orderTimeLabel.font = HXFont(12);
        _orderTimeLabel.textAlignment = NSTextAlignmentLeft;
        _orderTimeLabel.text = @"订单时间：";
    }
    return _orderTimeLabel;
}

- (UILabel *)orderTimeContentLabel{
    if (!_orderTimeContentLabel) {
        _orderTimeContentLabel = [[UILabel alloc] init];
        _orderTimeContentLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        _orderTimeContentLabel.font = HXFont(12);
        _orderTimeContentLabel.textAlignment = NSTextAlignmentRight;
        _orderTimeContentLabel.text =HXSafeString(self.scanCodePaymentModel.createDate);
    }
    return _orderTimeContentLabel;
}

- (UIImageView *)showUpLoadImageView{
    if (!_showUpLoadImageView) {
        _showUpLoadImageView = [[UIImageView alloc] init];
        _showUpLoadImageView.backgroundColor = [UIColor whiteColor];
        _showUpLoadImageView.userInteractionEnabled = YES;
        _showUpLoadImageView.clipsToBounds = YES;
        _showUpLoadImageView.contentMode = UIViewContentModeScaleAspectFit;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView:)];
        [_showUpLoadImageView addGestureRecognizer:tap];
    }
    return _showUpLoadImageView;
}

-(UIButton *)addPhotoBtn{
    if (!_addPhotoBtn) {
        _addPhotoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addPhotoBtn setImage:[UIImage imageNamed:@"zhifu_upload"] forState:UIControlStateNormal];
        [_addPhotoBtn addTarget:self action:@selector(addPhoto:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addPhotoBtn;
}

- (UILabel *)upLoadTipLabel{
    if (!_upLoadTipLabel) {
        _upLoadTipLabel = [[UILabel alloc] init];
        _upLoadTipLabel.textColor = COLOR_WITH_ALPHA(0xFE664B, 1);
        _upLoadTipLabel.font = HXFont(12);
        _upLoadTipLabel.textAlignment = NSTextAlignmentCenter;
        _upLoadTipLabel.text = @"请上传交易凭证，如支付记录详情截图";
    }
    return _upLoadTipLabel;
}

-(UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBtn.backgroundColor = COLOR_WITH_ALPHA(0xE5E5E5, 1);
        _cancelBtn.titleLabel.font = HXFont(16);
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:COLOR_WITH_ALPHA(0x2C2C2E, 1) forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(popBack:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

-(UIButton *)upLoadBtn{
    if (!_upLoadBtn) {
        _upLoadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _upLoadBtn.titleLabel.font = HXFont(16);
        [_upLoadBtn setTitle:@"确认上传" forState:UIControlStateNormal];
        [_upLoadBtn setTitleColor:COLOR_WITH_ALPHA(0xffffff, 1) forState:UIControlStateNormal];
        [_upLoadBtn addTarget:self action:@selector(upLoadImage:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _upLoadBtn;
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
