//
//  HXRefundDetailsViewController.m
//  HXMinedu
//
//  Created by mac on 2021/6/4.
//

#import "HXRefundDetailsViewController.h"
#import "HXRefundHeadInfoCell.h"
#import "HXCostDetailsCell.h"
#import "HXRefundMethodCell.h"
#import "HXSuggestionCell.h"
#import "HXRefundVoucherCell.h"
#import "HXToastSuggestionView.h"
#import "HXCustomToastView.h"
#import "HXPhotoManager.h"
#import "SDWebImage.h"
#import "GKPhotoBrowser.h"
#import "UIViewController+HXExtension.h"

@interface HXRefundDetailsViewController ()<UITableViewDelegate,UITableViewDataSource,HXRefundMethodCellDelegate>
@property(nonatomic,strong) UITableView *mainTableView;
@property(nonatomic,strong) UIView *bottomView;
@property(nonatomic,strong) UIView *bottomShadowView;
@property(nonatomic,strong) UIButton *rejectBtn;//驳回
@property(nonatomic,strong) UIButton *confirmBtn;//确认异动
/** 这里用weak是防止GKPhotoBrowser被强引用，导致不能释放 */
@property (nonatomic, weak) GKPhotoBrowser *browser;
@property(nonatomic,strong) HXPhotoManager *photoManager;
@end

@implementation HXRefundDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
}

#pragma mark - Event
-(void)reject:(UIButton *)sender{
    HXToastSuggestionView *toastSuggestionView = [[HXToastSuggestionView alloc] init];
    [toastSuggestionView showRejecttoastWithCallBack:^(NSString * _Nonnull cotent) {
        [self loadRejectData];
    }];
}

-(void)confirm:(UIButton *)sender{
    HXToastSuggestionView *toastSuggestionView = [[HXToastSuggestionView alloc] init];
    [toastSuggestionView showConfirmToastWithCallBack:^(NSString * _Nonnull cotent) {
        [self loadConfirmData];
    }];
}


-(void)loadRejectData{
    HXCustomToastView *toastView = [[HXCustomToastView alloc] init];
    [toastView showRejectToastHideAfter:2];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.bottomView.hidden = self.bottomShadowView.hidden = YES;
    });
    
}

-(void)loadConfirmData{
    HXCustomToastView *toastView = [[HXCustomToastView alloc] init];
    [toastView showConfirmToastHideAfter:2];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.bottomView.hidden = self.bottomShadowView.hidden = YES;
    });
}

#pragma mark - <HXRefundMethodCellDelegate>
-(void)refundMethodCell:(HXRefundMethodCell *)cell clickUpLoadBtn:(UIButton *)sender showRefundQRCodeImageView:(UIImageView *)refundQRCodeImageView{
    WeakSelf(weakSelf)
    [self hx_presentSelectPhotoControllerWithManager:self.photoManager didDone:^(NSArray<HXPhotoModel *> * _Nullable allList, NSArray<HXPhotoModel *> * _Nullable photoList, NSArray<HXPhotoModel *> * _Nullable videoList, BOOL isOriginal, UIViewController * _Nullable viewController, HXPhotoManager * _Nullable manager) {
        sender.hidden = YES;
        HXPhotoModel *photoModel = allList.firstObject;
        // 因为是编辑过的照片所以直接取
        refundQRCodeImageView.image = photoModel.photoEdit.editPreviewImage;
        NSString *encodedImageStr = [self imageChangeBase64:photoModel.photoEdit.editPreviewImage];
        //上传图片
//        [weakSelf uploadStudentFile:encodedImageStr];
    } cancel:nil];
}

#pragma mark - 上传图片信息
//-(void)uploadStudentFile:(NSString *)encodedImageStr{
//    [self.view showLoadingWithMessage:@"正在上传..."];
//    HXMajorModel *selectMajorModel = [HXPublicParamTool sharedInstance].selectMajorModel;
//    NSDictionary *dic = @{
//        @"version_id":HXSafeString(selectMajorModel.versionId),
//        @"major_id":HXSafeString(selectMajorModel.major_id),
//        @"fileType_id":HXSafeString(self.pictureInfoModel.fileTypeId),
//        @"image":HXSafeString(encodedImageStr)
//    };
//    [HXBaseURLSessionManager postDataWithNSString:HXPOST_UpdateStudentFile  withDictionary:dic success:^(NSDictionary * _Nonnull dictionary) {
//        [self.view hideLoading];
//        self.topConfirmBtn.userInteractionEnabled = YES;
//        BOOL success = [dictionary boolValueForKey:@"Success"];
//        if (success) {
//            [self.view showTostWithMessage:[dictionary stringValueForKey:@"Message"]];
//            self.topUploadBtn.hidden  = YES;
//            self.pictureInfoModel.imgurl = [dictionary stringValueForKey:@"Data"];
//            ///通知外部刷新
//            if (self.refreshInforBlock) {
//                self.refreshInforBlock();
//            }
//        }
//    } failure:^(NSError * _Nonnull error) {
//        [self.view hideLoading];
//    }];
//}


#pragma mark - <UITableViewDelegate,UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            return 140;
            break;
        case 1:
            return 235;
            break;
        case 2:
            return 190;
            break;
        case 3:
            return 110;
            break;
        case 4:
            return 110;
            break;
        case 5:
            return 140;
            break;
        default:
            return 0;
            break;
    };

}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *refundHeadInfoCellIdentifier = @"HXRefundHeadInfoCellIdentifier";
    static NSString *costDetailsCellIdentifier = @"HXCostDetailsCellIdentifier";
    static NSString *refundMethodCellIdentifier = @"HXRefundMethodCellIdentifier";
    static NSString *suggestionCellIdentifier = @"HXSuggestionCellIdentifier";
    static NSString *refundVoucherCellIdentifier = @"HXRefundVoucherCellIdentifier";
    switch (indexPath.row) {
        case 0:
        {
            
            HXRefundHeadInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:refundHeadInfoCellIdentifier];
            if (!cell) {
                cell = [[HXRefundHeadInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:refundHeadInfoCellIdentifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
        case 1:
        {
           
            HXCostDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:costDetailsCellIdentifier];
            if (!cell) {
                cell = [[HXCostDetailsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:costDetailsCellIdentifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
        case 2:
        {
            HXRefundMethodCell *cell = [tableView dequeueReusableCellWithIdentifier:refundMethodCellIdentifier];
            if (!cell) {
                cell = [[HXRefundMethodCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:refundMethodCellIdentifier];
            }
            cell.delegate = self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
        case 3:
        {
            HXSuggestionCell *cell = [tableView dequeueReusableCellWithIdentifier:suggestionCellIdentifier];
            if (!cell) {
                cell = [[HXSuggestionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:suggestionCellIdentifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
        case 4:
        {
            HXSuggestionCell *cell = [tableView dequeueReusableCellWithIdentifier:suggestionCellIdentifier];
            if (!cell) {
                cell = [[HXSuggestionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:suggestionCellIdentifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
        case 5:
        {
            HXRefundVoucherCell *cell = [tableView dequeueReusableCellWithIdentifier:refundVoucherCellIdentifier];
            if (!cell) {
                cell = [[HXRefundVoucherCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:refundVoucherCellIdentifier];
            }

            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
            
        default:
            return nil;
            break;
    }
    
}
-(NSString *)imageChangeBase64: (UIImage *)image{
    UIImage*compressImage = [HXCommonUtil compressImageSize:image toByte:250000];
    NSData*imageData =  UIImageJPEGRepresentation(compressImage, 1);
    NSLog(@"压缩后图片大小：%.2f M",(float)imageData.length/(1024*1024.0f));
    return [NSString stringWithFormat:@"%@",[imageData base64EncodedStringWithOptions:0]];
}

#pragma mark - UI
-(void)createUI{
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.sc_navigationBar.title = @"退费详情";
    [self.view addSubview:self.mainTableView];
    [self.view addSubview:self.bottomShadowView];
    [self.view addSubview:self.bottomView];
    [self.bottomView addSubview:self.rejectBtn];
    [self.bottomView addSubview:self.confirmBtn];
    
    self.mainTableView.sd_layout
    .topSpaceToView(self.view, kNavigationBarHeight)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomEqualToView(self.view);
    
    self.bottomView.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomEqualToView(self.view)
    .heightIs(120);
    [self.bottomView updateLayout];
    
    UIBezierPath * bPath = [UIBezierPath bezierPathWithRoundedRect:self.bottomView.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(24, 24)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.path = bPath.CGPath;
    self.bottomView.layer.mask = maskLayer;
    
    self.bottomShadowView.sd_layout
    .leftEqualToView(self.bottomView)
    .rightEqualToView(self.bottomView)
    .bottomEqualToView(self.bottomView)
    .heightRatioToView(self.bottomView, 1);
    self.bottomShadowView.layer.cornerRadius = 24;
    
    self.rejectBtn.sd_layout
    .topSpaceToView(self.bottomView, 28)
    .leftSpaceToView(self.bottomView, 28)
    .widthIs(145)
    .heightIs(44);
    self.rejectBtn.sd_cornerRadiusFromHeightRatio = @0.5;
    
    self.confirmBtn.sd_layout
    .topSpaceToView(self.bottomView, 28)
    .rightSpaceToView(self.bottomView, 28)
    .widthIs(145)
    .heightIs(44);
    self.confirmBtn
    .sd_cornerRadiusFromHeightRatio = @0.5;
}

#pragma mark - lazyLoad
-(UITableView *)mainTableView{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _mainTableView.bounces = YES;
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.backgroundColor = COLOR_WITH_ALPHA(0xFCFCFC, 1);
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if ([_mainTableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_mainTableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
        self.extendedLayoutIncludesOpaqueBars = YES;
        if (@available(iOS 11.0, *)) {
            _mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _mainTableView.estimatedRowHeight = 0;
            _mainTableView.estimatedSectionHeaderHeight = 0;
            _mainTableView.estimatedSectionFooterHeight = 0;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        _mainTableView.contentInset = UIEdgeInsetsMake(0, 0, 150, 0);
        _mainTableView.scrollIndicatorInsets = _mainTableView.contentInset;
        _mainTableView.showsVerticalScrollIndicator = NO;
    }
    return _mainTableView;
}


-(UIView *)bottomShadowView{
    if (!_bottomShadowView) {
        _bottomShadowView = [[UIView alloc] init];
        _bottomShadowView.backgroundColor = [UIColor whiteColor];
        _bottomShadowView.layer.shadowColor = COLOR_WITH_ALPHA(0x000000, 0.15).CGColor;
        _bottomShadowView.layer.shadowOffset = CGSizeMake(0, -2);
        _bottomShadowView.layer.shadowRadius = 4;
        _bottomShadowView.layer.shadowOpacity = 1;
    }
    return _bottomShadowView;
}

-(UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = [UIColor whiteColor];
        _bottomView.clipsToBounds = YES;
    }
    return _bottomView;
}

-(UIButton *)rejectBtn{
    if (!_rejectBtn) {
        _rejectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rejectBtn.titleLabel.font = HXBoldFont(16);
        _rejectBtn.backgroundColor = COLOR_WITH_ALPHA(0xFE664B, 1);
        [_rejectBtn setTitle:@"驳 回" forState:UIControlStateNormal];
        [_rejectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_rejectBtn addTarget:self action:@selector(reject:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rejectBtn;
}

-(UIButton *)confirmBtn{
    if (!_confirmBtn) {
        _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _confirmBtn.titleLabel.font = HXBoldFont(16);
        _confirmBtn.backgroundColor = COLOR_WITH_ALPHA(0x4DC656, 1);
        [_confirmBtn setTitle:@"确认信息" forState:UIControlStateNormal];
        [_confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_confirmBtn addTarget:self action:@selector(confirm:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmBtn;
}

- (HXPhotoManager *)photoManager {
    if (!_photoManager) {
        _photoManager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
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
@end
