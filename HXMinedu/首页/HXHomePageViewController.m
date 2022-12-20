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
#import "HXCommonWebViewController.h"
#import "WMZBannerView.h"
#import "HXHomeBannnerCell.h"
#import "SDWebImage.h"
#import "HXBannerLogoModel.h"
#import "HXHomePageColumnModel.h"
#import "HXVersionModel.h"
#import "HXColumnItemModel.h"
#import "HXNoDataTipView.h"
#import "HXTouSuView.h"
#import "WXApi.h"

@interface HXHomePageViewController ()<YNPageViewControllerDataSource, YNPageViewControllerDelegate>
@property(nonatomic,strong) HXNoDataTipView *noDataTipView;
//自定义导航
@property (nonatomic, strong) UIView *navView;
//头部
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UILabel *logoTitleLabel;
@property (nonatomic, strong) UIButton *dakaBtn;
@property (nonatomic, strong) UIButton *messageBtn;
@property(nonatomic,strong) UIView *messageRedDot;
@property(nonatomic,strong) UILabel *messageCountLabel;
@property(nonatomic,strong)   WMZBannerView *bannerView;
@property(nonatomic,strong)   YNPageViewController *pageVc;
//投诉电话
@property (nonatomic, strong) UIButton *touSuBtn;
//栏目数据源
@property (nonatomic, strong) NSMutableArray *columnList;

//banner数据源
@property (nonatomic, strong) NSMutableArray *bannerList;

@property (nonatomic, strong) NSArray *imagesURLs;
@property (nonatomic, strong) NSArray *h5URLs;
//未读消息数量
@property(nonatomic,assign) NSInteger messageCount;

@end

@implementation HXHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //布局
    [self createUI];
    
    //获取顶部Logo
    [self getLogo];
    //获取首页Banner
    [self getHomePageBannerList];
    //获取首页栏目
    [self getHomePageSettingsList];
    
    ///监听<<报考类型专业改变>>通知
    [HXNotificationCenter addObserver:self selector:@selector(versionAndMajorChangeNotification:) name:VersionAndMajorChangeNotification object:nil];
    
    ///监听<<首页banner改变>通知
    [HXNotificationCenter addObserver:self selector:@selector(getHomePageBannerList) name:HomePageBannerChangeNotification object:nil];
    
    //登录成功的通知
    [HXNotificationCenter addObserver:self selector:@selector(loginsuccessNotification:) name:LOGINSUCCESS object:nil];
}


-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //获取未读消息数量
    [self getMessageWDCount];
    
}

#pragma mark - Event
-(void)clickMessageBtn:(UIButton *)sender{
    [self launchMiniProgram];
    return;
    HXSystemNotificationViewController *systemNotificationVc = [[HXSystemNotificationViewController alloc] init];
    systemNotificationVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:systemNotificationVc animated:YES];
}

-(void)clickTouSuBtn:(UIButton *)sender{
    HXTouSuView *touSuView = [[HXTouSuView alloc] init];
    [touSuView show];
    
}

#pragma mark - 调起微信小程序
-(void)launchMiniProgram{
    WXLaunchMiniProgramReq *launchMiniProgramReq = [WXLaunchMiniProgramReq object];
    launchMiniProgramReq.userName = WechatMiniPrograID;  //拉起的小程序的username
    launchMiniProgramReq.path = @"pages/main/liveRoom";    //拉起小程序页面的可带参路径，不填默认拉起小程序首页，对于小游戏，可以只传入 query 部分，来实现传参效果，如：传入 "?foo=bar"。
    launchMiniProgramReq.miniProgramType = WXMiniProgramTypeRelease; //拉起小程序的类型
    [WXApi sendReq:launchMiniProgramReq completion:^(BOOL success) {
        NSLog(@"调起微信小程序:%d",success);
    }];
}


#pragma mark - /监听<<报考类型专业改变>>通知
-(void)versionAndMajorChangeNotification:(NSNotification *)not{
    //获取顶部Logo
    [self getLogo];
    //获取首页Banner
    [self getHomePageBannerList];
    //获取首页栏目
    [self getHomePageSettingsList];
    //获取联系方式和投诉电话
    [self getContactDetailsList];
}

-(void)loginsuccessNotification:(NSNotification *)not{
    [HXBaseURLSessionManager postDataWithNSString:HXPOST_Get_Version_Major_List withDictionary:nil success:^(NSDictionary * _Nonnull dictionary) {
        BOOL success = [dictionary boolValueForKey:@"Success"];
        if (success) {
            //////由于报考类型数据多处用到，避免频繁获取，此处保存在单例中
            [HXPublicParamTool sharedInstance].versionList = [HXVersionModel mj_objectArrayWithKeyValuesArray:[dictionary objectForKey:@"Data"]];
            ///默认选择第一个
            HXVersionModel *model = [HXPublicParamTool sharedInstance].versionList.firstObject;
            model.isSelected = YES;
            HXMajorModel *majorModel = model.majorList.firstObject;
            majorModel.isSelected = YES;
            //获取首页栏目
            [self getHomePageSettingsList];
        }
    } failure:^(NSError * _Nonnull error) {
       
        [self.view hideLoading];
    }];
}


#pragma mark -  获取顶部Logo
-(void)getLogo{
    HXMajorModel *selectMajorModel = [HXPublicParamTool sharedInstance].selectMajorModel;
    NSDictionary *dic;
    if ([HXCommonUtil isNull:selectMajorModel.versionId]) {
        dic = nil;
    }else{
        dic = @{
            @"version_id":HXSafeString(selectMajorModel.versionId),
            @"type":@(selectMajorModel.type),
            @"major_id":HXSafeString(selectMajorModel.major_id)
        };
    }
    
    [HXBaseURLSessionManager postDataWithNSString:HXPOST_Get_BannerAndLogo withDictionary:dic success:^(NSDictionary * _Nonnull dictionary) {
        
        BOOL success = [dictionary boolValueForKey:@"Success"];
        if (success) {
            HXBannerLogoModel *bannerLogoModel = [HXBannerLogoModel mj_objectWithKeyValues:[dictionary objectForKey:@"Data"]];
            //刷新顶部部logo
            [self.logoImageView sd_setImageWithURL:HXSafeURL(bannerLogoModel.logoIndexUrl) placeholderImage:nil];
        }
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

#pragma mark -  获取首页Banner
-(void)getHomePageBannerList{
    HXMajorModel *selectMajorModel = [HXPublicParamTool sharedInstance].selectMajorModel;
    NSDictionary *dic;
    if ([HXCommonUtil isNull:selectMajorModel.versionId]) {
        dic = nil;
    }else{
        dic = @{
            @"version_id":HXSafeString(selectMajorModel.versionId),
            @"type":@(selectMajorModel.type),
            @"major_id":HXSafeString(selectMajorModel.major_id)
        };
    }
    
    [HXBaseURLSessionManager postDataWithNSString:HXPOST_GetHomePageBannerList withDictionary:dic success:^(NSDictionary * _Nonnull dictionary) {
        
        BOOL success = [dictionary boolValueForKey:@"Success"];
        if (success) {
            NSArray *array = [HXColumnItemModel mj_objectArrayWithKeyValuesArray:[dictionary objectForKey:@"Data"]];
            [self.bannerList removeAllObjects];
            [self.bannerList addObjectsFromArray:array];
            [self.bannerView updateUI];
        }
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

#pragma mark - 获取未读消息数量
- (void)getMessageWDCount {
    
    [HXBaseURLSessionManager postDataWithNSString:HXPOST_MESSAGE_COUNT withDictionary:nil success:^(NSDictionary * _Nonnull dictionary) {
        
        BOOL Success = [dictionary boolValueForKey:@"Success"];
        if (Success) {
            NSDictionary *data = [dictionary objectForKey:@"Data"];
            self.messageCount = [[data stringValueForKey:@"WDCount"] integerValue];
            self.messageRedDot.hidden = !(self.messageCount>0);
            if (self.messageCount>99) {
                self.messageCountLabel.text = @"99+";
            }else{
                self.messageCountLabel.text = [NSString stringWithFormat:@"%ld",(long)self.messageCount];
            }
        }else{
            self.messageCount = 0;
            self.messageRedDot.hidden = YES;
        }
        
    } failure:^(NSError * _Nonnull error) {
        //do nothing
        NSLog(@"请求未读消息数量失败！");
        self.messageRedDot.hidden = YES;
    }];
}

#pragma mark - 获取首页栏目
-(void)getHomePageSettingsList{
   
    HXMajorModel *selectMajorModel = [HXPublicParamTool sharedInstance].selectMajorModel;
    NSDictionary *dic = @{
        @"version_id":HXSafeString(selectMajorModel.versionId),
        @"type":@(selectMajorModel.type),
        @"major_id":HXSafeString(selectMajorModel.major_id)
    };
    
    [HXBaseURLSessionManager postDataWithNSString:HXPOST_GetHomePageSettingsList withDictionary:dic success:^(NSDictionary * _Nonnull dictionary) {
        
        BOOL success = [dictionary boolValueForKey:@"Success"];
        if (success) {
            NSArray *list = [HXHomePageColumnModel mj_objectArrayWithKeyValuesArray:[dictionary objectForKey:@"Data"]];
            [self.columnList removeAllObjects];
            [self.columnList addObjectsFromArray:list];
            //设置子控制器
            if (self.columnList.count>0) {
                [self.noDataTipView removeFromSuperview];
                [self.headerView removeFromSuperview];
                [self setupPageVC];
            }else{
                [self.view addSubview:self.noDataTipView];
                [self.view addSubview:self.headerView];
            }
            
        }
        [self.view bringSubviewToFront:self.touSuBtn];
    } failure:^(NSError * _Nonnull error) {
        [self.view bringSubviewToFront:self.touSuBtn];
    }];
    
}


#pragma mark - 获取联系方式和投诉电话
-(void)getContactDetailsList{
   
    HXMajorModel *selectMajorModel = [HXPublicParamTool sharedInstance].selectMajorModel;
    NSDictionary *dic = @{
        @"version_id":HXSafeString(selectMajorModel.versionId),
        @"type":@(selectMajorModel.type),
        @"major_id":HXSafeString(selectMajorModel.major_id)
    };
    
    [HXBaseURLSessionManager postDataWithNSString:HXPOST_GetContactDetailsList withDictionary:dic success:^(NSDictionary * _Nonnull dictionary) {
        
        BOOL success = [dictionary boolValueForKey:@"Success"];
        if (success) {
            HXContactDetailsModel *model = [HXContactDetailsModel mj_objectWithKeyValues:[dictionary objectForKey:@"Data"]];
            [HXPublicParamTool sharedInstance].selectContactDetailsModel = model;
            self.touSuBtn.hidden = (model.complaintNumberList.count>0?NO:YES);
        }
       
    } failure:^(NSError * _Nonnull error) {
        
    }];
    
}



#pragma mark - UI
-(void)createUI{
    self.automaticallyAdjustsScrollViewInsets = NO;
   
    [self.view addSubview:self.touSuBtn];

    self.touSuBtn.sd_layout
    .rightEqualToView(self.view).offset(0)
    .bottomSpaceToView(self.view, 426+kScreenBottomMargin)
    .widthIs(64)
    .heightIs(32);
    
}


-(UIStatusBarStyle)preferredStatusBarStyle{
    if (@available(iOS 13.0, *)) {
        return UIStatusBarStyleDarkContent;
    } else {
        return UIStatusBarStyleDefault;
    }
    
}


//设置子控制器
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
    
    
    self.pageVc = [YNPageViewController pageViewControllerWithControllers:[self getArrayVCs ]
                                                                    titles:[self getArrayTitles]
                                                                    config:configration];
    
    self.pageVc.dataSource = self;
    self.pageVc.delegate = self;
    self.pageVc.headerView = self.headerView;
    /// 指定默认选择index 页面
    self.pageVc.pageIndex = 0;
    
    /// 作为子控制器加入到当前控制器
    [self.pageVc addSelfToParentViewController:self];
    
    [self.view addSubview:self.navView];
    
}

- (NSArray *)getArrayVCs {
    NSMutableArray *vcs = [NSMutableArray array];
    for (int i = 0; i<self.columnList.count; i++) {
        HXHomePageChildViewController *vc = [[HXHomePageChildViewController alloc] init];
        vc.homePageColumnModel = self.columnList[i];
        [vcs addObject:vc];
    }
    return vcs;
}

- (NSArray *)getArrayTitles {
    NSMutableArray *titles = [NSMutableArray array];
    for (int i = 0; i<self.columnList.count; i++) {
        HXHomePageColumnModel *homePageColumnModel = self.columnList[i];
        [titles addObject:homePageColumnModel.name];
    }
    return titles;
}



#pragma mark - Getter and Setter

-(NSMutableArray *)columnList{
    if (!_columnList) {
        _columnList = [NSMutableArray array];
    }
    return _columnList;
}

-(NSMutableArray *)bannerList{
    if (!_bannerList) {
        _bannerList = [NSMutableArray array];
    }
    return _bannerList;
}
- (NSArray *)imagesURLs {
    if (!_imagesURLs) {
        _imagesURLs = @[
            @"homepagebanner_1"];
    }
    return _imagesURLs;
}

- (NSArray *)h5URLs{
    if (!_h5URLs) {
        _h5URLs = @[
            [KHXUserDefaultsForValue(KP_SERVER_KEY) stringByAppendingString:@"/appGuide/ckGuide.html"],
            [KHXUserDefaultsForValue(KP_SERVER_KEY) stringByAppendingString:@"/appGuide/zkGuide.html"],
            [KHXUserDefaultsForValue(KP_SERVER_KEY) stringByAppendingString:@"/appGuide/gKGuide.html"],
            [KHXUserDefaultsForValue(KP_SERVER_KEY) stringByAppendingString:@"/appGuide/ycjyGuide.html"],
            [KHXUserDefaultsForValue(KP_SERVER_KEY) stringByAppendingString:@"/appGuide/zyzgGuide.html"],
            [KHXUserDefaultsForValue(KP_SERVER_KEY) stringByAppendingString:@"/appGuide/qrzGuide.html"]
        ];
    }
    return _h5URLs;
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
        .topSpaceToView(_headerView, kNavigationBarHeight-10)
        .leftSpaceToView(_headerView, 20)
        .autoWidthRatio(3)
        .heightIs(50);
        
        self.messageBtn.sd_layout
        .centerYEqualToView(self.logoImageView)
        .rightSpaceToView(_headerView, 0)
        .widthIs(60)
        .heightIs(30);
        
        self.messageBtn.imageView.sd_layout
        .centerYEqualToView(self.messageBtn)
        .rightSpaceToView(self.messageBtn, 20)
        .widthIs(20)
        .heightIs(20);
        
        self.messageRedDot.sd_layout
        .topEqualToView(self.messageBtn).offset(-6)
        .rightEqualToView(self.messageBtn).offset(-6)
        .widthIs(20)
        .heightEqualToWidth();
        self.messageRedDot.sd_cornerRadiusFromHeightRatio = @0.5;
        
        self.messageCountLabel.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
        
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
        _logoImageView.contentMode = UIViewContentModeScaleAspectFit;
        _logoImageView.clipsToBounds = YES;
        _logoImageView.userInteractionEnabled = YES;
    }
    return _logoImageView;;
}

-(UILabel *)logoTitleLabel{
    if (!_logoTitleLabel) {
        _logoTitleLabel = [[UILabel alloc] init];
        _logoTitleLabel.textAlignment = NSTextAlignmentLeft;
        _logoTitleLabel.font = HXBoldFont(20);
        _logoTitleLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        _logoTitleLabel.text = @"首页";
    }
    return _logoTitleLabel;
}

-(UIButton *)messageBtn{
    if (!_messageBtn) {
        _messageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_messageBtn setImage:[UIImage imageNamed:@"homepage_icon_message"] forState:UIControlStateNormal];
        [_messageBtn addTarget:self action:@selector(clickMessageBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_messageBtn addSubview:self.messageRedDot];
    }
    return _messageBtn;
}

-(UIView *)messageRedDot{
    if (!_messageRedDot) {
        _messageRedDot = [[UIView alloc] init];
        _messageRedDot.backgroundColor = [UIColor redColor];
        _messageRedDot.hidden = YES;
        [_messageRedDot addSubview:self.messageCountLabel];
    }
    return _messageRedDot;
}

-(UILabel *)messageCountLabel{
    if (!_messageCountLabel) {
        _messageCountLabel = [[UILabel alloc] init];
        _messageCountLabel.textAlignment = NSTextAlignmentCenter;
        _messageCountLabel.font = HXFont(11);
        _messageCountLabel.textColor = COLOR_WITH_ALPHA(0xffffff, 1);
    }
    return _messageCountLabel;
}

-(UIButton *)touSuBtn{
    if (!_touSuBtn) {
        _touSuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_touSuBtn setImage:[UIImage imageNamed:@"tousu_icon"] forState:UIControlStateNormal];
        [_touSuBtn addTarget:self action:@selector(clickTouSuBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _touSuBtn;
}


-(WMZBannerView *)bannerView{
    if (!_bannerView) {
        WMZBannerParam *param =
        BannerParam()
        //自定义视图必传
        .wMyCellClassNameSet(@"HXHomeBannnerCell")
        .wMyCellSet(^UICollectionViewCell *(NSIndexPath *indexPath, UICollectionView *collectionView, id model, UIImageView *bgImageView,NSArray*dataArr) {
            //自定义视图
            HXHomeBannnerCell *cell = ( HXHomeBannnerCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HXHomeBannnerCell class]) forIndexPath:indexPath];
            HXColumnItemModel *itemModel = self.bannerList[indexPath.row];
            [cell.showImageView sd_setImageWithURL:HXSafeURL(itemModel.imgUrl) placeholderImage:nil options:SDWebImageRefreshCached];
            return cell;
        })
        .wFrameSet(CGRectMake(0, 0, BannerWitdh, 144))
        .wDataSet(self.bannerList)
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
        .wRepeatSet(NO)
        //整体左右间距  让最后一个可以居中
        .wSectionInsetSet(UIEdgeInsetsMake(0,13, 0, 13))
        //间距
        .wLineSpacingSet(5);
        _bannerView = [[WMZBannerView alloc] initConfigureWithModel:param];
        //点击banner
        param.wEventClick = ^(id anyID, NSInteger index) {
            NSLog(@"点击了%ld  %@",(long)index,anyID);
            HXColumnItemModel *itemModel = self.bannerList[index];
            HXCommonWebViewController *webViewVC = [[HXCommonWebViewController alloc] init];
            webViewVC.urlString = itemModel.url;
            webViewVC.cuntomTitle = itemModel.name;
            webViewVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:webViewVC animated:YES];

        };
    }
    return _bannerView;
}


-(HXNoDataTipView *)noDataTipView{
    if (!_noDataTipView) {
        _noDataTipView = [[HXNoDataTipView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight, kScreenWidth, kScreenHeight-kNavigationBarHeight)];
        _noDataTipView.tipTitle = @"暂无数据~";
    }
    return _noDataTipView;
}



@end
