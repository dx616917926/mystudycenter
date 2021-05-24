//
//  HXHomePageViewController.m
//  HXMinedu
//
//  Created by mac on 2021/5/18.
//

#import "HXHomePageViewController.h"
#import "HXHomePageChildViewController.h"
#import "HXSystemNotificationViewController.h"
#import "HXHomePageShareViewController.h"
#import "YNPageViewController.h"
#import "WMZBannerView.h"
#import "HXHomeBannnerCell.h"
#import "SDWebImage.h"


@interface HXHomePageViewController ()<YNPageViewControllerDataSource, YNPageViewControllerDelegate>
//自定义导航
@property (nonatomic, strong) UIView *navView;
//头部
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UIButton *dakaBtn;
@property (nonatomic, strong) UIButton *messageBtn;
@property(nonatomic,strong)   WMZBannerView *bannerView;

@property (nonatomic, copy) NSArray *imagesURLs;


@end

@implementation HXHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //布局
    [self createUI];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self sc_setNavigationBarHidden:YES animated:NO];
}

#pragma mark - Event
-(void)clickMessageBtn:(UIButton *)sender{
//    HXSystemNotificationViewController *systemNotificationVc = [[HXSystemNotificationViewController alloc] init];
//    systemNotificationVc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:systemNotificationVc animated:YES];

    HXHomePageShareViewController *systemNotificationVc = [[HXHomePageShareViewController alloc] init];
    systemNotificationVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:systemNotificationVc animated:YES];
}

#pragma mark - UI
-(void)createUI{
    self.automaticallyAdjustsScrollViewInsets = NO;
    //设置控制器
    [self setupPageVC];
}


-(UIStatusBarStyle)preferredStatusBarStyle{
    if (@available(iOS 13.0, *)) {
        return UIStatusBarStyleDarkContent;
    } else {
        return UIStatusBarStyleDefault;
    }
   
}

- (void)setupPageVC {
    
    YNPageConfigration *configration = [YNPageConfigration defaultConfig];
    configration.pageStyle = YNPageStyleSuspensionCenter;
    configration.showTabbar = YES;
    configration.showNavigation = NO;
    configration.scrollMenu = YES;
    configration.scrollViewBackgroundColor = COLOR_WITH_ALPHA(0xFDFDFD, 1);
    configration.aligmentModeCenter = NO;
    configration.lineWidthEqualFontWidth = true;
    configration.showBottomLine = NO;
    configration.showScrollLine = NO;
    configration.itemFont = [UIFont systemFontOfSize:16];
    configration.selectedItemFont = [UIFont boldSystemFontOfSize:18];
    configration.normalItemColor = COLOR_WITH_ALPHA(0xB2B2B2, 1);
    configration.selectedItemColor = COLOR_WITH_ALPHA(0xC2C2E, 1);
    configration.itemMargin = 24;
    configration.itemLeftAndRightMargin = _kpw(16);
    configration.menuHeight = 56;
    /// 设置悬浮停顿偏移量
    configration.suspenOffsetY = kNavigationBarHeight-44;
    
    
    YNPageViewController *vc = [YNPageViewController pageViewControllerWithControllers:self.getArrayVCs
                                                                                titles:[self getArrayTitles]
                                                                                config:configration];
    
    vc.dataSource = self;
    vc.delegate = self;
    vc.headerView = self.headerView;
    /// 指定默认选择index 页面
    vc.pageIndex = 0;
    
    /// 作为子控制器加入到当前控制器
    [vc addSelfToParentViewController:self];
    
    [self.view addSubview:self.navView];
    
}

- (NSArray *)getArrayVCs {
    NSMutableArray *vcs = [NSMutableArray array];
    for (int i = 0; i<[self getArrayTitles].count; i++) {
        HXHomePageChildViewController *vc = [[HXHomePageChildViewController alloc] init];
        vc.count = i+1;
        [vcs addObject:vc];
    }
    return vcs;
}

- (NSArray *)getArrayTitles {
    return @[@"成考", @"自考", @"国开", @"网教", @"职业资格"];
}



#pragma mark - Getter and Setter
- (NSArray *)imagesURLs {
    if (!_imagesURLs) {
//        _imagesURLs = @[
//                        @"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=2802198789,311299169&fm=26&gp=0.jpg",
//                        @"https://ss3.baidu.com/9fo3dSag_xI4khGko9WTAnF6hhy/zhidao/pic/item/72f082025aafa40f2982756baa64034f78f0193b.jpg",
//                        @"https://ss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/pic/item/2fdda3cc7cd98d104e8010d4233fb80e7aec90fa.jpg",
//                        @"https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/zhidao/pic/item/cc11728b4710b91293eda145c8fdfc0392452258.jpg"];
        _imagesURLs = @[
                        @"homepagebanner_1"];
    }
    return _imagesURLs;
}
#pragma mark - YNPageViewControllerDataSource
- (UIScrollView *)pageViewController:(YNPageViewController *)pageViewController pageForIndex:(NSInteger)index {
    UIViewController *vc = pageViewController.controllersM[index];
    if ([vc isKindOfClass:[HXHomePageChildViewController class]]) {
        return [(HXHomePageChildViewController *)vc tableView];
    }
    return nil;
}
#pragma mark - YNPageViewControllerDelegate
- (void)pageViewController:(YNPageViewController *)pageViewController
            contentOffsetY:(CGFloat)contentOffset
                  progress:(CGFloat)progress {

    self.navView.backgroundColor = COLOR_WITH_ALPHA(0xffffff, progress);
    
}

#pragma mark - Lazyload
- (UIView *)navView {
    if (!_navView) {
        _navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kNavigationBarHeight-44)];
        _navView.backgroundColor = COLOR_WITH_ALPHA(0xffffff, 0);
    }
    return _navView;
}

-(UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth,300)];
        _headerView.backgroundColor = [UIColor clearColor];
        [_headerView addSubview:self.logoImageView];
        [_headerView addSubview:self.messageBtn];
        [_headerView addSubview:self.bannerView];
        
        self.logoImageView.sd_layout
        .topSpaceToView(_headerView, kNavigationBarHeight-20)
        .leftSpaceToView(_headerView, 20)
        .widthIs(148)
        .heightIs(48);
        
        self.messageBtn.sd_layout
        .centerYEqualToView(self.logoImageView)
        .rightSpaceToView(_headerView, 15)
        .widthIs(60)
        .heightIs(30);
        
        self.bannerView.sd_layout
        .topSpaceToView(self.logoImageView, 20)
        .leftEqualToView(_headerView)
        .rightEqualToView(_headerView)
        .heightIs(144);
    }
    return _headerView;
}

-(UIImageView *)logoImageView{
    if (!_logoImageView) {
        _logoImageView = [[UIImageView alloc] init];
        _logoImageView.image = [UIImage imageNamed:@"launch_logo"];
        _logoImageView.contentMode = UIViewContentModeScaleAspectFill;
        _logoImageView.clipsToBounds = YES;
        _logoImageView.userInteractionEnabled = YES;
    }
    return _logoImageView;;
}

-(UIButton *)messageBtn{
    if (!_messageBtn) {
        _messageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_messageBtn setImage:[UIImage imageNamed:@"set_icon_message"] forState:UIControlStateNormal];
        [_messageBtn addTarget:self action:@selector(clickMessageBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _messageBtn;
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
//            [cell.showImageView sd_setImageWithURL:[NSURL URLWithString:[HXCommonUtil stringEncoding:self.imagesURLs[indexPath.row]]] placeholderImage:nil options:SDWebImageRefreshCached];
            cell.showImageView.image = [UIImage imageNamed:self.imagesURLs[indexPath.row]];
            return cell;
        })
        .wFrameSet(CGRectMake(0, 0, BannerWitdh, 144))
        .wDataSet(self.imagesURLs)
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
        .wItemSizeSet(CGSizeMake(kScreenWidth-26,144))
        //固定移动的距离
        .wContentOffsetXSet(0.5)
         //自动滚动
        .wAutoScrollSet(YES)
        //cell动画的位置
        .wPositionSet(BannerCellPositionCenter)
         //循环
         .wRepeatSet(YES)
        //整体左右间距  让最后一个可以居中
        .wSectionInsetSet(UIEdgeInsetsMake(0,13, 0, 13))
        //间距
        .wLineSpacingSet(5);
       _bannerView = [[WMZBannerView alloc] initConfigureWithModel:param];
        //点击banner
        param.wEventClick = ^(id anyID, NSInteger index) {
            NSLog(@"点击了%ld  %@",(long)index,anyID);
        };
    }
    return _bannerView;
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
