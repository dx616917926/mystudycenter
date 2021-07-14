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
#import "HXReviewerSuggestionCell.h"
#import "HXRefundVoucherCell.h"
#import "HXToastSuggestionView.h"
#import "HXCustomToastView.h"
#import "HXPhotoManager.h"
#import "SDWebImage.h"
#import "GKPhotoBrowser.h"
#import "UIViewController+HXExtension.h"
#import "HXStudentRefundDetailsModel.h"

@interface HXRefundDetailsViewController ()<UITableViewDelegate,UITableViewDataSource,HXRefundMethodCellDelegate,HXRefundVoucherCellDelegate>

@property(nonatomic,strong) UITableView *mainTableView;
@property(nonatomic,strong) UIView *bottomView;
@property(nonatomic,strong) UIView *bottomShadowView;
@property(nonatomic,strong) UIButton *rejectBtn;//驳回
@property(nonatomic,strong) UIButton *confirmBtn;//确认异动
/** 这里用weak是防止GKPhotoBrowser被强引用，导致不能释放 */
@property (nonatomic, weak) GKPhotoBrowser *browser;
@property(nonatomic,strong) HXPhotoManager *photoManager;

//退费详情
@property(nonatomic,strong) HXStudentRefundDetailsModel *studentRefundDetailsModel;

//确认信息
@property(nonatomic,assign) NSInteger payMode;
@property(nonatomic,copy) NSString *khm;
@property(nonatomic,copy) NSString *khh;
@property(nonatomic,copy) NSString *khsk;
@property(nonatomic,copy) NSString *base64Str;

@end

@implementation HXRefundDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
    // 获取学生退费详情
    [self getStudentRefundDetailsInfo];
}

#pragma mark - 获取学生退费详情
-(void)getStudentRefundDetailsInfo{
    
    NSDictionary *dic = @{
        @"refund_id":HXSafeString(self.refundId)
    };
    [self.view showLoading];
    [HXBaseURLSessionManager postDataWithNSString:HXPOST_GetStudentRefundInfo  withDictionary:dic success:^(NSDictionary * _Nonnull dictionary) {
        [self.view hideLoading];
        BOOL success = [dictionary boolValueForKey:@"Success"];
        if (success) {
            self.studentRefundDetailsModel = [HXStudentRefundDetailsModel mj_objectWithKeyValues:[dictionary objectForKey:@"Data"]];
            [self.mainTableView reloadData];
            if (self.studentRefundDetailsModel.reviewStatus == 0) {
                self.bottomShadowView.hidden = self.bottomView.hidden = NO;
            }else{
                self.bottomShadowView.hidden = self.bottomView.hidden = YES;
            }
        }
    } failure:^(NSError * _Nonnull error) {
        [self.view hideLoading];
    }];
}
#pragma mark - 学生退费信息确认或驳回
-(void)loadRefundConfirmOrRejectRemark:(NSString *)remark reviewStatus:(NSInteger)reviewStatus{
    
    NSDictionary *dic = @{
        @"refund_id":HXSafeString(self.refundId),
        @"reviewStatus":@(reviewStatus),
        @"rejectRemark":HXSafeString(remark),
        @"payMode":@(self.payMode),
        @"image":(self.payMode == 2?HXSafeString(self.base64Str):@""),
        @"khm":(self.payMode == 1?self.khm:@""),
        @"khh":(self.payMode == 1?self.khh:@""),
        @"khsk":(self.payMode == 1?self.khsk:@"")
    };
    
    [HXBaseURLSessionManager postDataWithNSString:HXPOST_GetStudentRefundeConfirmOrReject  withDictionary:dic success:^(NSDictionary * _Nonnull dictionary) {
        [self.view hideLoading];
        BOOL success = [dictionary boolValueForKey:@"Success"];
        if (success) {
            self.bottomView.hidden = self.bottomShadowView.hidden = YES;
            //刷新数据
            [self getStudentRefundDetailsInfo];
            
            HXCustomToastView *toastView = [[HXCustomToastView alloc] init];
            reviewStatus == 1?[toastView showConfirmToastHideAfter:2]:[toastView showRejectToastHideAfter:2];
            //回调刷新列表
            if (self.refundRefreshCallBack) {
                self.refundRefreshCallBack();
            }
        }
    } failure:^(NSError * _Nonnull error) {
        [self.view hideLoading];
        self.bottomView.hidden = self.bottomShadowView.hidden = NO;
    }];

}
#pragma mark - Event

//驳回
-(void)reject:(UIButton *)sender{
    
    if(![self verificationPass]) return;
    
    HXToastSuggestionView *toastSuggestionView = [[HXToastSuggestionView alloc] init];
    [toastSuggestionView showRejecttoastWithCallBack:^(NSString * _Nonnull cotent) {
        [self loadRefundConfirmOrRejectRemark:cotent reviewStatus:3];
    }];
}

//确认
-(void)confirm:(UIButton *)sender{
    
    if(![self verificationPass]) return;
    
    HXToastSuggestionView *toastSuggestionView = [[HXToastSuggestionView alloc] init];
    [toastSuggestionView showConfirmToastWithCallBack:^(NSString * _Nonnull cotent) {
        [self loadRefundConfirmOrRejectRemark:cotent reviewStatus:1];
    }];
}

-(BOOL)verificationPass{
    //1:银联  2:扫码
    if (self.payMode == 1) {
        if ([HXCommonUtil isNull:self.khm]) {
            [self.view showTostWithMessage:@"请输入开户名"];
            return  NO;
        }
        if ([HXCommonUtil isNull:self.khh]) {
            [self.view showTostWithMessage:@"请输入开户行"];
            return  NO;
        }
        if ([HXCommonUtil isNull:self.khsk]) {
            [self.view showTostWithMessage:@"请输入收款账户"];
            return  NO;
        }
        return YES;
    }
    if (self.payMode == 2) {
        if ([HXCommonUtil isNull:self.base64Str]&&[HXCommonUtil isNull:self.studentRefundDetailsModel.skewm]) {
            [self.view showTostWithMessage:@"请添加退费二维码"];
            return  NO;
        }
        return YES;
    }
    return YES;
}


#pragma mark - <HXRefundMethodCellDelegate>
-(void)refundMethodCell:(HXRefundMethodCell *)cell clickUpLoadBtn:(UIButton *)sender showRefundQRCodeImageView:(UIImageView *)refundQRCodeImageView{
    WeakSelf(weakSelf)
    [self hx_presentSelectPhotoControllerWithManager:self.photoManager didDone:^(NSArray<HXPhotoModel *> * _Nullable allList, NSArray<HXPhotoModel *> * _Nullable photoList, NSArray<HXPhotoModel *> * _Nullable videoList, BOOL isOriginal, UIViewController * _Nullable viewController, HXPhotoManager * _Nullable manager) {
        sender.hidden = YES;
        HXPhotoModel *photoModel = allList.firstObject;
        // 因为是编辑过的照片所以直接取
        refundQRCodeImageView.image = photoModel.photoEdit.editPreviewImage;
        weakSelf.base64Str = [self imageChangeBase64:photoModel.photoEdit.editPreviewImage];
    } cancel:nil];
}



-(void)refundMethodCell:(HXRefundMethodCell *)cell tapShowRefundQRCodeImageView:(UIImageView *)refundQRCodeImageView{
    if([HXCommonUtil isNull:self.studentRefundDetailsModel.skewm] && self.studentRefundDetailsModel.reviewStatus != 0) {
        return;
    }else if(![HXCommonUtil isNull:self.studentRefundDetailsModel.skewm] && self.studentRefundDetailsModel.reviewStatus == 0){
        [self refundMethodCell:cell clickUpLoadBtn:nil showRefundQRCodeImageView:refundQRCodeImageView];
        return;
    }
    NSMutableArray *photos = [NSMutableArray new];
    GKPhoto *photo = [GKPhoto new];
    photo.url = [NSURL URLWithString:self.studentRefundDetailsModel.skewm];
    photo.sourceImageView = refundQRCodeImageView;
    [photos addObject:photo];
    [self.browser resetPhotoBrowserWithPhotos:photos];
    [self.browser showFromVC:self];
}

#pragma mark - <HXRefundVoucherCellDelegate>
- (void)refundVoucherCell:(HXRefundVoucherCell *)cell tapImageView:(UIImageView *)imageView url:(NSString *)url{
    if([HXCommonUtil isNull:url]) return;
    NSMutableArray *photos = [NSMutableArray new];
    GKPhoto *photo = [GKPhoto new];
    photo.url = [NSURL URLWithString:url];
    photo.sourceImageView = imageView;
    [photos addObject:photo];
    [self.browser resetPhotoBrowserWithPhotos:photos];
    [self.browser showFromVC:self];
}
    


#pragma mark - <UITableViewDelegate,UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    ///0-待确认           1-确认无误       2-待退费     4-已退费     3-已驳回    5-已撤消
    NSInteger reviewStatus = self.studentRefundDetailsModel.reviewStatus;
    switch (reviewStatus) {
        case 0://待确认
            return 3;
            break;
        case 1://确认无误
        case 2://待退费
        case 5:
            return 4;
            break;
        case 3://已驳回
        {
            if (![HXCommonUtil isNull:self.studentRefundDetailsModel.reviewerRemark]) {
                return 5;
            }else{
                return 4;
            }
            
        }
            break;
        case 4://已退费
            return 6;
            break;
        default:
            break;
    }
    return 0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            return 120;
            break;
        case 1:
            {
                HXStudentRefundDetailsModel *studentRefundDetailsModel = self.studentRefundDetailsModel;
                CGFloat rowHeight = [tableView cellHeightForIndexPath:indexPath
                                                                model:studentRefundDetailsModel keyPath:@"studentRefundDetailsModel"
                                                            cellClass:([HXCostDetailsCell class])
                                                     contentViewWidth:kScreenWidth];
                return rowHeight;
            }
            break;
        case 2:
            return 190;
            break;
        case 3:
        {
            HXStudentRefundDetailsModel *studentRefundDetailsModel = self.studentRefundDetailsModel;
            CGFloat rowHeight = [tableView cellHeightForIndexPath:indexPath
                                                            model:studentRefundDetailsModel keyPath:@"studentRefundDetailsModel"
                                                        cellClass:([HXSuggestionCell class])
                                                 contentViewWidth:kScreenWidth];
            return rowHeight;
        }
            break;
        case 4:
        {
            HXStudentRefundDetailsModel *studentRefundDetailsModel = self.studentRefundDetailsModel;
            CGFloat rowHeight = [tableView cellHeightForIndexPath:indexPath
                                                            model:studentRefundDetailsModel keyPath:@"studentRefundDetailsModel"
                                                        cellClass:([HXReviewerSuggestionCell class])
                                                 contentViewWidth:kScreenWidth];
            return rowHeight;
        }
            break;
        case 5:
            return 200;
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
    static NSString *reviewerSuggestionCellIdentifier = @"HXReviewerSuggestionCellIdentifier";
    static NSString *refundVoucherCellIdentifier = @"HXRefundVoucherCellIdentifier";
    switch (indexPath.row) {
        case 0:
        {
            
            HXRefundHeadInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:refundHeadInfoCellIdentifier];
            if (!cell) {
                cell = [[HXRefundHeadInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:refundHeadInfoCellIdentifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.studentRefundDetailsModel = self.studentRefundDetailsModel;
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
            [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
            cell.studentRefundDetailsModel = self.studentRefundDetailsModel;
            return cell;
        }
            break;
        case 2:
        {
            HXRefundMethodCell *cell = [tableView dequeueReusableCellWithIdentifier:refundMethodCellIdentifier];
            if (!cell) {
                cell = [[HXRefundMethodCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:refundMethodCellIdentifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
            cell.studentRefundDetailsModel = self.studentRefundDetailsModel;
            WeakSelf(weakSelf);
            cell.infoConfirmCallBack = ^(NSInteger payMode, NSString * _Nonnull khm, NSString * _Nonnull khh, NSString * _Nonnull khsk) {
                weakSelf.payMode = payMode;
                weakSelf.khm = khm;
                weakSelf.khh = khh;
                weakSelf.khsk = khsk;

            };
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
            [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
            cell.studentRefundDetailsModel = self.studentRefundDetailsModel;
            return cell;
        }
            break;
        case 4:
        {
            HXReviewerSuggestionCell *cell = [tableView dequeueReusableCellWithIdentifier:reviewerSuggestionCellIdentifier];
            if (!cell) {
                cell = [[HXReviewerSuggestionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reviewerSuggestionCellIdentifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
            cell.studentRefundDetailsModel = self.studentRefundDetailsModel;
            return cell;
        }
            break;
        
            break;
        case 5:
        {
            HXRefundVoucherCell *cell = [tableView dequeueReusableCellWithIdentifier:refundVoucherCellIdentifier];
            if (!cell) {
                cell = [[HXRefundVoucherCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:refundVoucherCellIdentifier];
            }

            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
            cell.studentRefundDetailsModel = self.studentRefundDetailsModel;
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
//        _browser.delegate = self;
        
    }
    return _browser;
}

@end
