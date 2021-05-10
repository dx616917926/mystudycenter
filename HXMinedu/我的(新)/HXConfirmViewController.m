//
//  HXConfirmViewController.m
//  HXMinedu
//
//  Created by mac on 2021/4/9.
//

#import "HXConfirmViewController.h"
#import "HXPhotoManager.h"
#import "SDWebImage.h"
#import "GKPhotoBrowser.h"
#import "GKCover.h"
#import "UIViewController+HXExtension.h"

@interface HXConfirmViewController ()<GKPhotoBrowserDelegate>
@property(nonatomic,strong) UIScrollView *mainScrollView;
@property(nonatomic,strong) UIImageView *topImageView;
@property(nonatomic,strong) UIButton *topConfirmBtn;
@property(nonatomic,strong) UIButton *topUploadBtn;
@property(nonatomic,strong) UIImageView *bottomImageView;
@property(nonatomic,strong) UIButton *bottomConfirmBtn;
/** 这里用weak是防止GKPhotoBrowser被强引用，导致不能释放 */
@property (nonatomic, weak) GKPhotoBrowser *browser;
@property (nonatomic, weak) UIView *fromView;
@property (nonatomic, weak) UIView *actionSheet;

@property(nonatomic,strong) HXPhotoManager *photoManager;


@end

@implementation HXConfirmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //UI
    [self createUI];
}

#pragma mark - Event
-(void)confirm:(UIButton *)sender{
    
    sender.userInteractionEnabled = NO;
    [self confirmStudentStatu];
}

-(void)upLoadImage:(UIButton *)sender{
    WeakSelf(weakSelf)
    [self hx_presentSelectPhotoControllerWithManager:self.photoManager didDone:^(NSArray<HXPhotoModel *> * _Nullable allList, NSArray<HXPhotoModel *> * _Nullable photoList, NSArray<HXPhotoModel *> * _Nullable videoList, BOOL isOriginal, UIViewController * _Nullable viewController, HXPhotoManager * _Nullable manager) {
        HXPhotoModel *photoModel = allList.firstObject;
        // 因为是编辑过的照片所以直接取
        weakSelf.topImageView.image = photoModel.photoEdit.editPreviewImage;
        NSString *encodedImageStr = [self imageChangeBase64:photoModel.photoEdit.editPreviewImage];
        //上传图片
        [weakSelf uploadStudentFile:encodedImageStr];
    } cancel:nil];
    
}

- (void)saveBtnClick:(id)sender {
    [GKCover hideCover];
    GKPhotoView *photoView = self.browser.curPhotoView;
    NSData *imageData = [photoView.imageView.image sd_imageData];
    if (!imageData) return;
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        if (@available(iOS 9, *)) {
            PHAssetCreationRequest *request = [PHAssetCreationRequest creationRequestForAsset];
            [request addResourceWithType:PHAssetResourceTypePhoto data:imageData options:nil];
            request.creationDate = [NSDate date];
        }
    } completionHandler:^(BOOL success, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (success) {
                [[UIApplication sharedApplication].keyWindow showTostWithMessage:@"图片保存成功"];
            } else if (error) {
                [[UIApplication sharedApplication].keyWindow showTostWithMessage:@"图片保存失败"];
            }
        });
    }];
}


- (void)cancelBtnClick:(id)sender {
    [GKCover hideCover];
}

#pragma mark - 学生确认图片信息
-(void)confirmStudentStatu{
    
    [HXBaseURLSessionManager postDataWithNSString:HXPOST_UpdateStudentStatu  withDictionary:@{@"studentFile_id":HXSafeString(self.pictureInfoModel.fileId)} success:^(NSDictionary * _Nonnull dictionary) {
        self.topConfirmBtn.userInteractionEnabled = YES;
        BOOL success = [dictionary boolValueForKey:@"Success"];
        if (success) {
            [self.view showTostWithMessage:[dictionary stringValueForKey:@"Message"]];
            self.topConfirmBtn.hidden  = YES;
            ///通知外部刷新
            if (self.refreshInforBlock) {
                self.refreshInforBlock();
            }
        }else{
            [self.view showErrorWithMessage:[dictionary stringValueForKey:@"Message"]];
        }
    } failure:^(NSError * _Nonnull error) {
        
    }];
}


#pragma mark - 上传图片信息
-(void)uploadStudentFile:(NSString *)encodedImageStr{
    [self.view showLoadingWithMessage:@"正在上传..."];
    HXMajorModel *selectMajorModel = [HXPublicParamTool sharedInstance].selectMajorModel;
    NSDictionary *dic = @{
        @"version_id":HXSafeString(selectMajorModel.versionId),
        @"major_id":HXSafeString(selectMajorModel.major_id),
        @"fileType_id":HXSafeString(self.pictureInfoModel.fileTypeId),
        @"image":HXSafeString(encodedImageStr)
    };
    [HXBaseURLSessionManager postDataWithNSString:HXPOST_UpdateStudentFile  withDictionary:dic success:^(NSDictionary * _Nonnull dictionary) {
        [self.view hideLoading];
        self.topConfirmBtn.userInteractionEnabled = YES;
        BOOL success = [dictionary boolValueForKey:@"Success"];
        if (success) {
            [self.view showTostWithMessage:[dictionary stringValueForKey:@"Message"]];
            self.topUploadBtn.hidden  = YES;
            self.pictureInfoModel.imgurl = [dictionary stringValueForKey:@"Data"];
            ///通知外部刷新
            if (self.refreshInforBlock) {
                self.refreshInforBlock();
            }
        }else{
            [self.view showErrorWithMessage:[dictionary stringValueForKey:@"Message"]];
        }
    } failure:^(NSError * _Nonnull error) {
        [self.view hideLoading];
    }];
}


#pragma mark - 预览大图
-(void)tapImageView:(UITapGestureRecognizer *)ges{
    if([HXCommonUtil isNull:self.pictureInfoModel.imgurl]) return;
    NSMutableArray *photos = [NSMutableArray new];
    GKPhoto *photo = [GKPhoto new];
    photo.url = [NSURL URLWithString:self.pictureInfoModel.imgurl];
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


#pragma mark - <GKPhotoBrowserDelegate>
- (void)photoBrowser:(GKPhotoBrowser *)browser longPressWithIndex:(NSInteger)index {
    
    if (self.fromView) return;
    if (browser.currentOrientation == UIDeviceOrientationPortraitUpsideDown) return;
    
    UIView *contentView = browser.contentView;
    
    UIView *fromView = [UIView new];
    fromView.backgroundColor = [UIColor clearColor];
    self.fromView = fromView;
    
    CGFloat actionSheetH  = 100 + kScreenBottomMargin;
    fromView.frame = browser.view.bounds;
    [[UIApplication sharedApplication].keyWindow addSubview:fromView];
    
    UIView *actionSheet = [[UIView alloc] initWithFrame:CGRectMake(0, 0, contentView.bounds.size.width, actionSheetH)];
    actionSheet.backgroundColor = [UIColor whiteColor];
    self.actionSheet = actionSheet;
    
    
    UIButton *saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, actionSheet.width, 50)];
    [saveBtn setTitle:@"保存图片" forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(saveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    saveBtn.backgroundColor = [UIColor whiteColor];
    [actionSheet addSubview:saveBtn];
    
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 50, actionSheet.width, 50)];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.backgroundColor = [UIColor whiteColor];
    [actionSheet addSubview:cancelBtn];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 50, actionSheet.width, 0.5)];
    lineView.backgroundColor = [UIColor grayColor];
    [actionSheet addSubview:lineView];
    
    
    [GKCover coverFrom:fromView
           contentView:actionSheet
                 style:GKCoverStyleTranslucent
             showStyle:GKCoverShowStyleBottom
         showAnimStyle:GKCoverShowAnimStyleBottom
         hideAnimStyle:GKCoverHideAnimStyleBottom
              notClick:NO
             showBlock:nil
             hideBlock:^{
        [self.fromView removeFromSuperview];
        self.fromView = nil;
    }];
}



- (void)photoBrowser:(GKPhotoBrowser *)browser onDeciceChangedWithIndex:(NSInteger)index isLandscape:(BOOL)isLandscape {
    [GKCover hideCover];
}

- (void)photoBrowser:(GKPhotoBrowser *)browser didDisappearAtIndex:(NSInteger)index {
    NSLog(@"浏览器完全消失%@", browser);
    [self.fromView removeFromSuperview];
    self.fromView = nil;
}





- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSLog(@"image = %@, error = %@, contextInfo = %@", image, error, contextInfo);
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - UI
-(void)createUI{
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.sc_navigationBar.title = self.pictureInfoModel.fileTypeName;
    
    [self.view addSubview:self.mainScrollView];
    [self.mainScrollView addSubview:self.topImageView];
    [self.mainScrollView addSubview:self.topConfirmBtn];
    [self.mainScrollView addSubview:self.topUploadBtn];
    [self.mainScrollView addSubview:self.bottomImageView];
    [self.mainScrollView addSubview:self.bottomConfirmBtn];
    
    self.mainScrollView.sd_layout
    .topSpaceToView(self.view, kNavigationBarHeight)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomEqualToView(self.view);
    
    self.topImageView.sd_layout
    .topSpaceToView(self.mainScrollView, 20)
    .rightSpaceToView(self.mainScrollView, 20)
    .leftSpaceToView(self.mainScrollView, 20)
    .heightIs(190);
    
    self.topConfirmBtn.sd_layout
    .topSpaceToView(self.topImageView, 24)
    .centerXEqualToView(self.mainScrollView)
    .widthIs(164)
    .heightIs(30);
    self.topConfirmBtn.sd_cornerRadius = @6;
    
    self.topUploadBtn.sd_layout
    .topSpaceToView(self.topConfirmBtn, 10)
    .centerXEqualToView(self.mainScrollView)
    .widthIs(164)
    .heightIs(30);
    self.topUploadBtn.sd_cornerRadius = @6;
    
    self.bottomImageView.sd_layout
    .topSpaceToView(self.topUploadBtn, 24)
    .leftEqualToView(self.topImageView)
    .rightEqualToView(self.topImageView)
    .heightRatioToView(self.topImageView, 1);
    
    self.bottomConfirmBtn.sd_layout
    .topSpaceToView(self.bottomImageView, 24)
    .leftEqualToView(self.topConfirmBtn)
    .rightEqualToView(self.topConfirmBtn)
    .heightRatioToView(self.topConfirmBtn, 1);
    self.bottomConfirmBtn.sd_cornerRadius = @6;
    
    [self.mainScrollView setupAutoContentSizeWithBottomView:self.bottomConfirmBtn bottomMargin:30];
    
    if (self.pictureInfoModel.status == 0) {//0:待上传 1:已上传
        self.topConfirmBtn.hidden  = YES;
        self.topUploadBtn.hidden  = NO;
        self.topConfirmBtn.sd_layout.topSpaceToView(self.topImageView, 14).heightIs(0);
    }else{
        self.topUploadBtn.hidden = YES;
        if (self.pictureInfoModel.studentstatus == 1) {//已确认隐藏确认按钮
            self.topConfirmBtn.hidden  = YES;
        }else{
            self.topConfirmBtn.hidden  = NO;
        }
    }
    
    
    [self.topImageView sd_setImageWithURL:[NSURL URLWithString:HXSafeString(self.pictureInfoModel.imgurl)] placeholderImage:[UIImage imageNamed:@"uploaddash"]];
    
}

-(void)setPictureInfoModel:(HXPictureInfoModel *)pictureInfoModel{
    _pictureInfoModel = pictureInfoModel;
}

#pragma mark -- image转化成Base64位
-(NSString *)imageChangeBase64: (UIImage *)image{
    UIImage*compressImage = [HXCommonUtil compressImageSize:image toByte:250000];
    NSData*imageData =  UIImageJPEGRepresentation(compressImage, 1);
    NSLog(@"压缩后图片大小：%.2f M",(float)imageData.length/(1024*1024.0f));
    return [NSString stringWithFormat:@"%@",[imageData base64EncodedStringWithOptions:0]];
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
        _mainScrollView.backgroundColor = COLOR_WITH_ALPHA(0xffffff, 1);
    }
    return _mainScrollView;
}
-(UIImageView *)topImageView{
    if (!_topImageView) {
        _topImageView = [[UIImageView alloc] init];
        _topImageView.clipsToBounds = YES;
        _topImageView.userInteractionEnabled = YES;
        _topImageView.image = [UIImage imageNamed:@"uploaddash"];
        _topImageView.contentMode = UIViewContentModeScaleAspectFit;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView:)];
        [_topImageView addGestureRecognizer:tap];
    }
    return _topImageView;
}

-(UIButton *)topConfirmBtn{
    if (!_topConfirmBtn) {
        _topConfirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _topConfirmBtn.titleLabel.font = HXBoldFont(16);
        [_topConfirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_topConfirmBtn setBackgroundImage:[UIImage createImageWithColor:COLOR_WITH_ALPHA(0x07C160, 1)] forState:UIControlStateNormal];
        [_topConfirmBtn setBackgroundImage:[UIImage createImageWithColor:COLOR_WITH_ALPHA(0x079A4D, 1)] forState:UIControlStateHighlighted];
        [_topConfirmBtn setTitle:@"确认无误" forState:UIControlStateNormal];
        [_topConfirmBtn addTarget:self action:@selector(confirm:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _topConfirmBtn;
}

-(UIButton *)topUploadBtn{
    if (!_topUploadBtn) {
        _topUploadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _topUploadBtn.titleLabel.font = HXBoldFont(16);
        [_topUploadBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_topUploadBtn setBackgroundImage:[UIImage createImageWithColor:COLOR_WITH_ALPHA(0x07C160, 1)] forState:UIControlStateNormal];
        [_topUploadBtn setBackgroundImage:[UIImage createImageWithColor:COLOR_WITH_ALPHA(0x079A4D, 1)] forState:UIControlStateHighlighted];
        [_topUploadBtn setTitle:@"上传图片" forState:UIControlStateNormal];
        [_topUploadBtn addTarget:self action:@selector(upLoadImage:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _topUploadBtn;
}

-(UIImageView *)bottomImageView{
    if (!_bottomImageView) {
        _bottomImageView = [[UIImageView alloc] init];
        _bottomImageView.clipsToBounds = YES;
        _bottomImageView.image = [UIImage imageNamed:@"uploaddash"];
        _bottomImageView.contentMode = UIViewContentModeScaleAspectFit;
        _bottomImageView.hidden = YES;
    }
    return _bottomImageView;
}
-(UIButton *)bottomConfirmBtn{
    if (!_bottomConfirmBtn) {
        _bottomConfirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _bottomConfirmBtn.titleLabel.font = HXBoldFont(16);
        [_bottomConfirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_bottomConfirmBtn setBackgroundImage:[UIImage createImageWithColor:COLOR_WITH_ALPHA(0x07C160, 1)] forState:UIControlStateNormal];
        [_bottomConfirmBtn setBackgroundImage:[UIImage createImageWithColor:COLOR_WITH_ALPHA(0x079A4D, 1)] forState:UIControlStateHighlighted];
        [_bottomConfirmBtn setTitle:@"确认无误" forState:UIControlStateNormal];
        [_bottomConfirmBtn addTarget:self action:@selector(confirm:) forControlEvents:UIControlEventTouchUpInside];
        _bottomConfirmBtn.hidden = YES;
    }
    return _bottomConfirmBtn;
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
