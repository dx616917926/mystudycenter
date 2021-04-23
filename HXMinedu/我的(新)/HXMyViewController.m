//
//  HXMyViewController.m
//  HXMinedu
//
//  Created by mac on 2021/4/6.
//

#import "HXMyViewController.h"
#import "HXPaymentDtailsContainerViewController.h"
#import "HXRegistFormViewController.h"
#import "HXInfoConfirmViewController.h"
#import "HXAboutUsViewController.h"
#import "HXSetViewController.h"
#import "HXSystemNotificationViewController.h"
#import "HXCycleScrollView.h"
#import "HXRecordCell.h"
#import "HXStudentInfoModel.h"
#import "HXMajorModel.h"
#import "HXBannerLogoModel.h"
#import "SDWebImage.h"
#import "MJRefresh.h"

@interface HXMyViewController ()<HXCycleScrollViewDelegate, HXCycleScrollViewDataSource>

@property(nonatomic,strong) UIScrollView *mainScrollView;

@property(nonatomic,strong) UIView *topView;
@property(nonatomic,strong) UIImageView *headerImageView;
@property(nonatomic,strong) UILabel *nameLabel;
@property(nonatomic,strong) UIButton *phoneBtn;
@property(nonatomic,strong) UIButton *collectInfoBtn;
@property(nonatomic,strong) UIButton *messageBtn;


@property(nonatomic,strong) HXCycleScrollView *cycleScrollView;
@property(nonatomic,strong) UIView *bottomContainerView;
@property(nonatomic,strong) NSMutableArray *bottomBtns;
@property(nonatomic,strong) UIImageView *logoViewImageView;

@property(nonatomic,strong) HXStudentInfoModel*stuInfoModel;
@property(nonatomic,strong) NSArray *majorList;
//第一次
@property(nonatomic,assign) BOOL isFirst;

@end

@implementation HXMyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //UI
    [self createUI];
    self.isFirst = YES;
    //登录成功的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginInSuccess) name:LOGINSUCCESS object:nil];
    
}

-(void)loginInSuccess{
    //获取学生信息和考生信息
    [self getStuInfo];
    //获取学生专业
    [self geMajorList];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.isFirst) {
        self.isFirst  = NO;
        //获取学生信息和考生信息
        [self getStuInfo];
        //获取学生专业
        [self geMajorList];
    }
    [self.logoViewImageView sd_setImageWithURL:[NSURL URLWithString:HXSafeString([HXPublicParamTool sharedInstance].jiGouLogoUrl)] placeholderImage:[UIImage imageNamed:@"xuexi_logo"] options:SDWebImageRefreshCached];
    
}

#pragma mark - 数据请求
//获取学生信息和考生信息
-(void)getStuInfo{
    [HXBaseURLSessionManager postDataWithNSString:HXPOST_STUINFO  withDictionary:nil success:^(NSDictionary * _Nonnull dictionary) {
        BOOL success = [dictionary boolValueForKey:@"Success"];
        if (success) {
            NSDictionary *dic = [[dictionary objectForKey:@"Data"] firstObject];
            self.stuInfoModel = [HXStudentInfoModel mj_objectWithKeyValues:dic];
            [self refreTopHeaderUI];
            
        }else{
            [self.view showErrorWithMessage:[dictionary stringValueForKey:@"Message"]];
        }
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

//获取学生专业
-(void)geMajorList{
    [self.view showLoading];
    [HXBaseURLSessionManager postDataWithNSString:HXPOST_Get_MajorL_List  withDictionary:nil success:^(NSDictionary * _Nonnull dictionary) {
        [self.mainScrollView.mj_header endRefreshing];
        [self.view hideLoading];
        BOOL success = [dictionary boolValueForKey:@"Success"];
        if (success) {
            self.majorList = [HXMajorModel mj_objectArrayWithKeyValuesArray:[dictionary objectForKey:@"Data"]];
            [self refreshMajorUI];
        }else{
            [self.view showErrorWithMessage:[dictionary stringValueForKey:@"Message"]];
        }
    } failure:^(NSError * _Nonnull error) {
        [self.mainScrollView.mj_header endRefreshing];
        [self.view hideLoading];
    }];
}

//获取Banner和Logo
-(void)getBannerAndLogo{
    HXMajorModel *selectMajorModel = [HXPublicParamTool sharedInstance].selectMajorModel;
    NSDictionary *dic = @{
        @"version_id":HXSafeString(selectMajorModel.versionId),
        @"type":@(selectMajorModel.type),
        @"major_id":HXSafeString(selectMajorModel.major_id)
    };
    
    [HXBaseURLSessionManager postDataWithNSString:HXPOST_Get_BannerAndLogo withDictionary:dic success:^(NSDictionary * _Nonnull dictionary) {

        BOOL success = [dictionary boolValueForKey:@"Success"];
        if (success) {
            HXBannerLogoModel *model = [HXBannerLogoModel mj_objectWithKeyValues:[dictionary objectForKey:@"Data"]];
            [HXPublicParamTool sharedInstance].jiGouLogoUrl = HXSafeString(model.logoUrl);
            [self.logoViewImageView sd_setImageWithURL:[NSURL URLWithString:HXSafeString(model.logoUrl)] placeholderImage:[UIImage imageNamed:@"xuexi_logo"] options:SDWebImageRefreshCached];
        }else{
            [self.view showErrorWithMessage:[dictionary stringValueForKey:@"Message"]];
        }
    } failure:^(NSError * _Nonnull error) {
    
    }];
}

///下拉刷新
-(void)loadNewData{
    //获取学生信息和考生信息
    [self getStuInfo];
    //获取学生专业
    [self geMajorList];
    //没有数据获取
    if ([HXCommonUtil isNull:[HXPublicParamTool sharedInstance].jiGouLogoUrl]) {
        [self getBannerAndLogo];
    }
}



#pragma mark - 刷新数据
-(void)refreTopHeaderUI{
    self.nameLabel.text = HXSafeString(self.stuInfoModel.name);
    if (self.stuInfoModel.mobile.length>=11) {
        self.phoneBtn.hidden = NO;
        NSString *mobileStr = [self.stuInfoModel.mobile stringByReplacingCharactersInRange:NSMakeRange(3,4) withString:@"****"];
        [self.phoneBtn setTitle:mobileStr forState:UIControlStateNormal];
    }else{
        self.phoneBtn.hidden = YES;
    }
    
}
-(void)refreshMajorUI{
    [self.cycleScrollView reloadData];
    if (self.majorList.count>2) {
        [self.cycleScrollView scrollToItemAtIndex:2 animated:NO];
    }
}


#pragma mark - Event
-(void)clickCollectInfoBtn:(UIButton *)sender{
    HXInfoConfirmViewController *infoConfirmVc = [[HXInfoConfirmViewController alloc] init];
    infoConfirmVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:infoConfirmVc animated:YES];
}

-(void)clickMessageBtn:(UIButton *)sender{
    HXSystemNotificationViewController *systemNotificationVc = [[HXSystemNotificationViewController alloc] init];
    systemNotificationVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:systemNotificationVc animated:YES];
}

-(void)handleBottomClick:(UIButton *)sender{
    NSInteger index = sender.tag - 5000;
    switch (index) {
        case 0://缴费明细
        {
            HXPaymentDtailsContainerViewController *payMentVc = [[HXPaymentDtailsContainerViewController alloc] init];
            payMentVc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:payMentVc animated:YES];
        }
            break;
        case 1://报名表单
        {
            HXRegistFormViewController *registFormVc = [[HXRegistFormViewController alloc] init];
            registFormVc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:registFormVc animated:YES];
        }
            break;
        case 2://图片信息
        {
            HXInfoConfirmViewController *infoConfirmVc = [[HXInfoConfirmViewController alloc] init];
            infoConfirmVc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:infoConfirmVc animated:YES];
        }
            break;
        case 3://关于我们
        {
            HXAboutUsViewController *aboutUsVc = [[HXAboutUsViewController alloc] init];
            aboutUsVc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:aboutUsVc animated:YES];
            
        }
            break;
        case 4://通用设置
        {
            HXSetViewController *setVc = [[HXSetViewController alloc] init];
            setVc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:setVc animated:YES];
            
        }
            break;
            
        default:
            break;
    }
}


#pragma mark - UI
-(void)createUI{
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.sc_navigationBar.leftBarButtonItem = nil;
    [self sc_setNavigationBarBackgroundAlpha:0];
    [self setSc_NavigationBarAnimateInvalid:YES];
    
    [self.view addSubview:self.mainScrollView];
    [self.mainScrollView addSubview:self.topView];
    [self.topView addSubview:self.headerImageView];
    [self.topView addSubview:self.nameLabel];
    [self.topView addSubview:self.phoneBtn];
    [self.topView addSubview:self.collectInfoBtn];
    [self.topView addSubview:self.messageBtn];
 
    [self.mainScrollView addSubview:self.cycleScrollView];
    [self.mainScrollView addSubview:self.bottomContainerView];
    [self.mainScrollView addSubview:self.logoViewImageView];
    
    self.mainScrollView.sd_layout
    .topEqualToView(self.view)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomSpaceToView(self.view, kTabBarHeight);
    
    
    self.topView.sd_layout
    .topEqualToView(self.mainScrollView)
    .centerXEqualToView(self.mainScrollView)
    .widthIs(kScreenWidth)
    .heightIs(200);
    
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.bounds = CGRectMake(0, 0, kScreenWidth, 200);
    gradientLayer.startPoint = CGPointMake(0, 0.5);
    gradientLayer.endPoint = CGPointMake(1, 0.5);
    gradientLayer.anchorPoint = CGPointMake(0, 0);
    NSArray *colorArr = @[(id)COLOR_WITH_ALPHA(0x4BA4FE, 1).CGColor,(id)COLOR_WITH_ALPHA(0x45EFCF, 1).CGColor];
    gradientLayer.colors = colorArr;
    [self.topView.layer addSublayer:gradientLayer];
    [self.topView.layer insertSublayer:gradientLayer below:self.headerImageView.layer];
    
    self.headerImageView.sd_layout
    .topSpaceToView(self.topView, kNavigationBarHeight)
    .leftSpaceToView(self.topView, 20)
    .widthIs(50)
    .heightEqualToWidth();
    self.headerImageView.sd_cornerRadiusFromHeightRatio = @0.5;
    
    self.nameLabel.sd_layout
    .topEqualToView(self.headerImageView)
    .leftSpaceToView(self.headerImageView, 16)
    .heightIs(20);
    [self.nameLabel setSingleLineAutoResizeWithMaxWidth:80];
    
    self.collectInfoBtn.sd_layout
    .leftSpaceToView(self.nameLabel, 10)
    .centerYEqualToView(self.nameLabel);
    self.collectInfoBtn.sd_cornerRadiusFromHeightRatio = @0.5;
    [self.collectInfoBtn setupAutoSizeWithHorizontalPadding:16 buttonHeight:22];
    
    self.phoneBtn.sd_layout
    .leftEqualToView(self.nameLabel)
    .bottomEqualToView(self.headerImageView);
    [self.phoneBtn setupAutoSizeWithHorizontalPadding:8 buttonHeight:18];
    self.phoneBtn.sd_cornerRadiusFromHeightRatio = @0.5;
    

    self.messageBtn.sd_layout
    .centerYEqualToView(self.phoneBtn).offset(5)
    .rightSpaceToView(self.topView, 15)
    .widthIs(60)
    .heightIs(30);
        
    
    
    self.cycleScrollView.sd_layout
    .topSpaceToView(self.mainScrollView, 160)
    .leftEqualToView(self.mainScrollView)
    .rightEqualToView(self.mainScrollView)
    .heightIs(200);
    
    self.bottomContainerView.sd_layout
    .topSpaceToView(self.cycleScrollView, 15)
    .leftSpaceToView(self.mainScrollView, _kpw(25))
    .rightSpaceToView(self.mainScrollView, _kpw(25));
    
    for (UIButton *btn in self.bottomBtns) {
        btn.sd_layout.heightIs(90);
        btn.imageView.sd_layout
        .centerXEqualToView(btn)
        .topSpaceToView(btn, 10)
        .widthIs(44)
        .heightEqualToWidth();
        
        btn.titleLabel.sd_layout
        .leftEqualToView(btn)
        .rightEqualToView(btn)
        .bottomSpaceToView(btn, 10)
        .heightIs(15);
    }
    
    
    [self.bottomContainerView setupAutoMarginFlowItems:self.bottomBtns withPerRowItemsCount:3 itemWidth:100 verticalMargin:20 verticalEdgeInset:20 horizontalEdgeInset:10];
    self.bottomContainerView.sd_cornerRadius = @10;
    
    self.logoViewImageView.sd_layout
    .topSpaceToView(self.bottomContainerView, 25)
    .centerXEqualToView(self.mainScrollView)
    .leftEqualToView(self.mainScrollView)
    .rightEqualToView(self.mainScrollView)
    .heightIs(48);
    
    [self.mainScrollView setupAutoContentSizeWithBottomView:self.logoViewImageView bottomMargin:30];
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    header.automaticallyChangeAlpha = YES;
    
     //设置header
    self.mainScrollView.mj_header = header;

    
}

#pragma mark -- HXCycleScrollView DataSource
- (NSInteger)numberOfItemsInCycleScrollView:(HXCycleScrollView *)cycleScrollView {
    return self.majorList.count;
}

- (UICollectionViewCell *)cycleScrollView:(HXCycleScrollView *)cycleScrollView cellForItemAtIndex:(NSInteger)index {
    HXRecordCell *cell = [cycleScrollView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HXRecordCell class]) forIndex:index];
    HXMajorModel *majorModel = self.majorList[index];
    cell.majorModel = majorModel;
    return cell;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    CGFloat offset = _kpw(5);
    for (UITabBarItem *item in self.tabBarController.tabBar.items) {
        if ([item.title isEqualToString:@"我的"]) {
            item.imageInsets = UIEdgeInsetsMake(offset, 0, -offset, 0);
            item.titlePositionAdjustment = UIOffsetMake(0, 100);
        }else{
            if ([item.title isEqualToString:@"我的"]){
                item.titlePositionAdjustment = UIOffsetMake(0, -100);
            }
            item.imageInsets = UIEdgeInsetsMake(0, 0, 0, 0);
            item.titlePositionAdjustment = UIOffsetMake(0, 0);
        }
    }

}

#pragma mark - lazyLoad
-(UIScrollView *)mainScrollView{
    if (!_mainScrollView) {
        _mainScrollView = [[UIScrollView alloc] init];
        _mainScrollView.backgroundColor = COLOR_WITH_ALPHA(0xF5F6FA, 1);
        _mainScrollView.showsVerticalScrollIndicator = NO;
        _mainScrollView.bounces = YES;
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
        _topView.backgroundColor = [UIColor blueColor];
    }
    return _topView;
}

-(UIImageView *)headerImageView{
    if (!_headerImageView) {
        _headerImageView = [[UIImageView alloc] init];
        _headerImageView.image = [UIImage imageNamed:@"defaultheader"];
    }
    return _headerImageView;
}

-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.font = HXBoldFont(_kpAdaptationWidthFont(18));
        
    }
    return _nameLabel;
}

-(UIButton *)phoneBtn{
    if (!_phoneBtn) {
        _phoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _phoneBtn.hidden = YES;
        _phoneBtn.titleLabel.font = HXFont(_kpAdaptationWidthFont(12));
        _phoneBtn.backgroundColor = COLOR_WITH_ALPHA(0xB8DCF9, 1);
        [_phoneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
    }
    return _phoneBtn;
}

-(UIButton *)collectInfoBtn{
    if (!_collectInfoBtn) {
        _collectInfoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _collectInfoBtn.titleLabel.font = HXFont(_kpAdaptationWidthFont(10));
        _collectInfoBtn.backgroundColor = COLOR_WITH_ALPHA(0xffffff, 1);
        [_collectInfoBtn setTitleColor:COLOR_WITH_ALPHA(0x4BA4FE, 1) forState:UIControlStateNormal];
        [_collectInfoBtn setTitle:@"去采集个人信息 >" forState:UIControlStateNormal];
        [_collectInfoBtn addTarget:self action:@selector(clickCollectInfoBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _collectInfoBtn;
}

-(UIButton *)messageBtn{
    if (!_messageBtn) {
        _messageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_messageBtn setImage:[UIImage imageNamed:@"message_icon"] forState:UIControlStateNormal];
        [_messageBtn addTarget:self action:@selector(clickMessageBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _messageBtn;
}





-(HXCycleScrollView *)cycleScrollView{
    if (!_cycleScrollView) {
        _cycleScrollView = [[HXCycleScrollView alloc] initWithFrame:CGRectZero shouldInfiniteLoop:YES];
        
        self.automaticallyAdjustsScrollViewInsets = NO;
        _cycleScrollView.delegate = self;
        _cycleScrollView.dataSource = self;
        _cycleScrollView.hidesPageControl = YES; // 隐藏默认的 pageControl
        _cycleScrollView.autoScroll = NO; // 关闭自动滚动
        _cycleScrollView.itemZoomScale = 0.95;
        _cycleScrollView.itemSpacing = 5.0f; // 设置 cell 间距
        _cycleScrollView.itemSize = CGSizeMake(kScreenWidth - 60.0f,180); // 设置 cell 大小
        [_cycleScrollView registerCellClass:[HXRecordCell class] forCellWithReuseIdentifier:NSStringFromClass([HXRecordCell class])];
    }
    return _cycleScrollView;;
}

-(UIView *)bottomContainerView{
    if (!_bottomContainerView) {
        _bottomContainerView = [[UIView alloc] init];
        _bottomContainerView.backgroundColor = [UIColor whiteColor];
        NSArray *titles = @[@"缴费明细",@"报名表单",@"图片信息确认",@"关于我们",@"通用设置"];
        NSArray *imageNames = @[@"payment_icon",@"registform_icon",@"infconfirm_icon",@"aboutme_icon",@"setting_icon"];
        for (int i = 0; i<titles.count; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.titleLabel.textAlignment = NSTextAlignmentCenter;
            btn.titleLabel.font = HXFont(_kpAdaptationWidthFont(12));
            btn.tag = 5000+i;
            [btn setTitle:titles[i] forState:UIControlStateNormal];
            [btn setTitleColor:COLOR_WITH_ALPHA(0x2C2C2E, 1) forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:imageNames[i]] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(handleBottomClick:) forControlEvents:UIControlEventTouchUpInside];
            [_bottomContainerView addSubview:btn];
            [self.bottomBtns addObject:btn];
        }
    }
    return _bottomContainerView;;
}

-(NSMutableArray *)bottomBtns{
    if (!_bottomBtns) {
        _bottomBtns = [NSMutableArray array];
    }
    return _bottomBtns;;
}

-(UIImageView *)logoViewImageView{
    if (!_logoViewImageView) {
        _logoViewImageView = [[UIImageView alloc] init];
        _logoViewImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _logoViewImageView;
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
