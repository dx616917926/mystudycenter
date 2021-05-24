//
//  HXHomePageShareViewController.m
//  HXMinedu
//
//  Created by mac on 2021/5/20.
//

#import "HXHomePageShareViewController.h"
#import "WMZBannerView.h"
#import "HXHomeBannnerCell.h"
#import "YNPageScrollMenuView.h"
#import "YNPageConfigration.h"
#import "HXShareManager.h"
#import <Photos/Photos.h>

@interface HXHomePageShareViewController ()<YNPageScrollMenuViewDelegate>
@property(nonatomic,strong)  UIScrollView *mainScrollView;
@property(nonatomic,strong)  UILabel *tipLabel;
@property(nonatomic,strong)  YNPageScrollMenuView *menuView;
@property(nonatomic,strong)  WMZBannerView *bannerView;
@property(nonatomic,strong)  WMZBannerParam *bannerParam;
@property(nonatomic,strong)  NSArray *shareImages;

@property(nonatomic,strong)  UIView *shareContainerView;
@property(nonatomic,strong)  UIButton *wechatBtn;
@property(nonatomic,strong)  UIButton *wechatFriendsCircleBtn;
@property(nonatomic,strong)  UIButton *savePictureBtn;

@end

@implementation HXHomePageShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
}



#pragma mark - Event
//保存图片
-(void)savePictue:(UIButton *)sender{
    

    NSData *imageData = UIImageJPEGRepresentation([UIImage imageNamed:self.shareImages[self.bannerParam.myCurrentPath]], 1);
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

-(void)wechatShare:(UIButton *)sender{
    NSData *imageData = UIImageJPEGRepresentation([UIImage imageNamed:self.shareImages[self.bannerParam.myCurrentPath]], 1);
    int wxScene = (int)sender.tag - 8000;
    [[HXShareManager manager] wechatShareImageData:imageData wxScene:wxScene];
}


#pragma mark - UI
-(void)createUI{

    self.automaticallyAdjustsScrollViewInsets = NO;
    self.sc_navigationBar.title = @"分享";
    self.view.backgroundColor = COLOR_WITH_ALPHA(0xFCFCFC, 1);
    
    ///
    YNPageConfigration *pageConfigration = [YNPageConfigration defaultConfig];
    pageConfigration.menuHeight = 40;
    pageConfigration.scrollViewBackgroundColor = COLOR_WITH_ALPHA(0xFCFCFC, 1);
    pageConfigration.selectedItemColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
    pageConfigration.normalItemColor = COLOR_WITH_ALPHA(0xB2B2B2, 1);
    pageConfigration.selectedItemFont = HXBoldFont(18);
    pageConfigration.itemFont = HXFont(16);
    pageConfigration.aligmentModeCenter = YES;
    pageConfigration.lineWidthEqualFontWidth = NO;
    pageConfigration.lineLeftAndRightAddWidth = -10;
    pageConfigration.lineColor = COLOR_WITH_ALPHA(0x4BA4FE, 1);
    pageConfigration.lineHeight = 3;
    pageConfigration.lineCorner = 1.5;
    pageConfigration.lineBottomMargin = 3;
     
    YNPageScrollMenuView *menuView = [YNPageScrollMenuView pagescrollMenuViewWithFrame:CGRectMake(0, 20, kScreenWidth, 44) titles:@[@"成考", @"自考", @"国开", @"网教", @"职业资格"].mutableCopy configration:pageConfigration delegate:self currentIndex:1];
    self.menuView = menuView;
   
    
    [self.view addSubview:self.mainScrollView];
    [self.mainScrollView addSubview:self.menuView];
    [self.mainScrollView addSubview:self.tipLabel];
    [self.mainScrollView addSubview:self.bannerView];
    [self.mainScrollView addSubview:self.shareContainerView];
    [self.shareContainerView addSubview:self.wechatBtn];
    [self.shareContainerView addSubview:self.wechatFriendsCircleBtn];
    [self.shareContainerView addSubview:self.savePictureBtn];
   
    
    self.mainScrollView.sd_layout
    .topSpaceToView(self.view, kNavigationBarHeight)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomSpaceToView(self.view, 0);

    self.tipLabel.sd_layout
    .topSpaceToView(self.menuView, 10)
    .leftSpaceToView(self.mainScrollView, 22)
    .rightSpaceToView(self.mainScrollView, 22)
    .heightIs(17);
    
    self.bannerView.sd_layout
    .topSpaceToView(self.tipLabel, 6)
    .leftEqualToView(self.mainScrollView)
    .rightEqualToView(self.mainScrollView)
    .heightIs((kScreenWidth-44)*1170/662);
    
    self.shareContainerView.sd_layout
    .topSpaceToView(self.bannerView, 16)
    .leftEqualToView(self.mainScrollView)
    .rightEqualToView(self.mainScrollView);
    
    self.wechatBtn.sd_layout.heightIs(90);
    self.wechatFriendsCircleBtn.sd_layout.heightIs(90);
    self.savePictureBtn.sd_layout.heightIs(90);
    
    [self.shareContainerView setupAutoWidthFlowItems:@[self.wechatBtn,self.wechatFriendsCircleBtn,self.savePictureBtn] withPerRowItemsCount:3 verticalMargin:0 horizontalMargin:10 verticalEdgeInset:0 horizontalEdgeInset:22];
    
    self.wechatBtn.imageView.sd_layout
    .centerXEqualToView(self.wechatBtn)
    .topSpaceToView(self.wechatBtn, 0)
    .widthIs(44)
    .heightIs(44);
    
    self.wechatBtn.titleLabel.sd_layout
    .topSpaceToView(self.wechatBtn.imageView, 6)
    .leftEqualToView(self.wechatBtn)
    .rightEqualToView(self.wechatBtn)
    .heightIs(17);
    
    self.wechatFriendsCircleBtn.imageView.sd_layout
    .centerXEqualToView(self.wechatFriendsCircleBtn)
    .topSpaceToView(self.wechatFriendsCircleBtn, 0)
    .widthIs(44)
    .heightIs(44);
    
    self.wechatFriendsCircleBtn.titleLabel.sd_layout
    .topSpaceToView(self.wechatFriendsCircleBtn.imageView, 6)
    .leftEqualToView(self.wechatFriendsCircleBtn)
    .rightEqualToView(self.wechatFriendsCircleBtn)
    .heightIs(17);
    
    self.savePictureBtn.imageView.sd_layout
    .centerXEqualToView(self.savePictureBtn)
    .topSpaceToView(self.savePictureBtn, 0)
    .widthIs(44)
    .heightIs(44);
    
    self.savePictureBtn.titleLabel.sd_layout
    .topSpaceToView(self.savePictureBtn.imageView, 6)
    .leftEqualToView(self.savePictureBtn)
    .rightEqualToView(self.savePictureBtn)
    .heightIs(17);
    
    [self.mainScrollView setupAutoContentSizeWithBottomView:self.shareContainerView bottomMargin:20+kScreenBottomMargin];
    
}

#pragma mark - <YNPageScrollMenuViewDelegate>
- (void)pagescrollMenuViewItemOnClick:(UIButton *)button index:(NSInteger)index{
    
    [self.bannerView scrolToPath:[NSIndexPath indexPathForRow:index inSection:0] animated:YES];
}

-(NSArray *)shareImages{
    return @[@"chengkao_share",@"zikaokao_share",@"guokai_share",@"wangjiao_share",@"zhiye_share"];
}

#pragma mark - lazyLoad
-(UIScrollView *)mainScrollView{
    if (!_mainScrollView) {
        _mainScrollView = [[UIScrollView alloc] init];
        _mainScrollView.backgroundColor = [UIColor clearColor];
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

-(UILabel *)tipLabel{
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.font = HXFont(12);
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.textColor = COLOR_WITH_ALPHA(0xFE664B, 1);
        _tipLabel.text = @"分享到朋友圈，更容易获得奖励哦~";
    }
    return _tipLabel;
}

-(WMZBannerView *)bannerView{
    if (!_bannerView) {
        WMZBannerParam *param =
        BannerParam()
        //自定义视图必传
        .wMyCellClassNameSet(@"HXHomeBannnerCell")
        .wMyCellSet(^UICollectionViewCell *(NSIndexPath *indexPath, UICollectionView *collectionView, id model, UIImageView *bgImageView,NSArray*dataArr) {
                   //自定义视图
            HXHomeBannnerCell *cell = ( HXHomeBannnerCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ HXHomeBannnerCell class]) forIndexPath:indexPath];
            cell.showImageView.image = [UIImage imageNamed:self.shareImages[indexPath.row]];
            return cell;
        })
        .wFrameSet(CGRectMake(0, kNavigationBarHeight, BannerWitdh, (kScreenWidth-44)*1170/662))
        .wDataSet(self.shareImages)
        //显示pageControl
        .wHideBannerControlSet(NO)
        .wBannerControlImageSet(@"bannercontrol_default")
        .wBannerControlSelectImageSet(@"bannercontrol_select")
        .wBannerControlSelectImageSizeSet(CGSizeMake(14, 5))
        .wBannerControlImageSizeSet(CGSizeMake(5, 5))
        .wBannerControlSelectMarginSet(4)
         //开启缩放
         .wScaleSet(YES)
         ///缩放系数
         .wScaleFactorSet(0.15)
        //自定义item的大小
        .wItemSizeSet(CGSizeMake(kScreenWidth-44,(kScreenWidth-44)*1170/662))
        //固定移动的距离
        .wContentOffsetXSet(0.5)
         //自动滚动
        .wAutoScrollSet(NO)
        //cell动画的位置
        .wPositionSet(BannerCellPositionCenter)
         //循环
         .wRepeatSet(NO)
        //整体左右间距  让最后一个可以居中
        .wSectionInsetSet(UIEdgeInsetsMake(0,22, 0, 22))
        //间距
        .wLineSpacingSet(10);
       _bannerView = [[WMZBannerView alloc] initConfigureWithModel:param];
        self.bannerParam = param;
        WeakSelf(weakSelf);
        __weak __typeof(&*param)   weakSelfParam  = param;
        param.wEventDidScroll = ^(CGPoint point) {
            [weakSelf.menuView selectedItemIndex:weakSelfParam.myCurrentPath animated:YES];
        };
    }
    return _bannerView;
}

-(UIView *)shareContainerView{
    if (!_shareContainerView) {
        _shareContainerView = [[UIView alloc] init];
    }
    return _shareContainerView;
}
\
-(UIButton *)wechatBtn{
    if (!_wechatBtn) {
        _wechatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _wechatBtn.tag = 8000;
        _wechatBtn.titleLabel.font = HXFont(12);
        _wechatBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_wechatBtn setTitleColor:COLOR_WITH_ALPHA(0x2C2C2E, 1) forState:UIControlStateNormal];
        [_wechatBtn setImage:[UIImage imageNamed:@"wechat_icon"] forState:UIControlStateNormal];
        [_wechatBtn setTitle:@"微信好友" forState:UIControlStateNormal];
        [_wechatBtn addTarget:self action:@selector(wechatShare:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _wechatBtn;
}

-(UIButton *)wechatFriendsCircleBtn{
    if (!_wechatFriendsCircleBtn) {
        _wechatFriendsCircleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _wechatFriendsCircleBtn.tag = 8001;
        _wechatFriendsCircleBtn.titleLabel.font = HXFont(12);
        _wechatFriendsCircleBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_wechatFriendsCircleBtn setTitleColor:COLOR_WITH_ALPHA(0x2C2C2E, 1) forState:UIControlStateNormal];
        [_wechatFriendsCircleBtn setImage:[UIImage imageNamed:@"wechatfriendscircle_icon"] forState:UIControlStateNormal];
        [_wechatFriendsCircleBtn setTitle:@"朋友圈" forState:UIControlStateNormal];
        [_wechatFriendsCircleBtn addTarget:self action:@selector(wechatShare:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _wechatFriendsCircleBtn;
}



-(UIButton *)savePictureBtn{
    if (!_savePictureBtn) {
        _savePictureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _savePictureBtn.titleLabel.font = HXFont(12);
        _savePictureBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_savePictureBtn setTitleColor:COLOR_WITH_ALPHA(0x2C2C2E, 1) forState:UIControlStateNormal];
        [_savePictureBtn setImage:[UIImage imageNamed:@"savepicture_icon"] forState:UIControlStateNormal];
        [_savePictureBtn setTitle:@"保存图片" forState:UIControlStateNormal];
        [_savePictureBtn addTarget:self action:@selector(savePictue:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _savePictureBtn;
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
