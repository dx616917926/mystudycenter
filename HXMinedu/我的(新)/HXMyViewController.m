//
//  HXMyViewController.m
//  HXMinedu
//
//  Created by mac on 2021/4/6.
//

#import "HXMyViewController.h"
#import "HXPaymentDtailsContainerViewController.h"
#import "HXRegistFormViewController.h"
#import "HXPictureInforConfirmViewController.h"
#import "HXAboutUsViewController.h"
#import "HXLianXiUsViewController.h"
#import "HXSetViewController.h"
#import "HXHeadMasterViewController.h"
#import "HXSystemNotificationViewController.h"
#import "HXYiDongAndRefundConfirmViewController.h"
#import "HXRecordCell.h"
#import "HXStudentInfoModel.h"
#import "HXMajorModel.h"
#import "HXBannerLogoModel.h"
#import "SDWebImage.h"
#import "WMZBannerView.h"


@interface HXMyViewController ()

@property(nonatomic,strong) UIScrollView *mainScrollView;

@property(nonatomic,strong) UIView *topView;
@property(nonatomic,strong) UIImageView *headerImageView;
@property(nonatomic,strong) UILabel *nameLabel;
@property(nonatomic,strong) UIButton *phoneBtn;
@property(nonatomic,strong) UIButton *collectInfoBtn;
@property(nonatomic,strong) UIButton *messageBtn;
@property(nonatomic,strong) UIView *messageRedDot;
@property(nonatomic,strong) UILabel *messageCountLabel;


@property(nonatomic,strong)  WMZBannerView *bannerView;
@property(nonatomic,strong)  WMZBannerParam *bannerParam;

@property(nonatomic,strong) NSMutableArray *bujuArray;
@property(nonatomic,strong) UIView *middleContainerView;
@property(nonatomic,strong) NSMutableArray *middleBtns;
@property(nonatomic,strong) UIImageView *logoViewImageView;
@property(nonatomic,strong) UIButton *tuifeiBtn;

@property(nonatomic,strong) HXStudentInfoModel*stuInfoModel;
@property(nonatomic,strong) NSArray *majorList;
//第一次
@property(nonatomic,assign) BOOL isFirst;

@property(nonatomic,strong) UIView *bottomContainerView;
@property(nonatomic,strong) UIButton *aboutUsBtn;
@property(nonatomic,strong) UIView *line;
@property(nonatomic,strong) UIButton *lianXiUsBtn;
@property(nonatomic,strong) UIView *line2;
@property(nonatomic,strong) UIButton *commomSetBtn;
//未读消息数量
@property(nonatomic,assign) NSInteger messageCount;

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
    //获取学生退费信息，控制退费确认按钮的显示与隐藏
    [self getStudentRefundList];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //请求未读消息数量
    [self getMessageWDCount];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.isFirst) {
        self.isFirst  = NO;
        //获取学生信息和考生信息
        [self getStuInfo];
        //获取学生专业
        [self geMajorList];
        //获取学生退费信息，控制退费确认按钮的显示与隐藏
        [self getStudentRefundList];
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
            [self refreshTopHeaderUI];
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
        }
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

//获取是否渠道学生  控制报名表单隐藏与显示
-(void)getIsQdStu{
    HXMajorModel *selectMajorModel = [HXPublicParamTool sharedInstance].selectMajorModel;
    NSDictionary *dic = @{
        @"version_id":HXSafeString(selectMajorModel.versionId),
        @"major_id":HXSafeString(selectMajorModel.major_id)
    };
    
    [HXBaseURLSessionManager postDataWithNSString:HXPOST_GetIsQdStu withDictionary:dic success:^(NSDictionary * _Nonnull dictionary) {
        
        BOOL success = [dictionary boolValueForKey:@"Success"];
        if (success) {
            NSInteger isQudao = [[dictionary stringValueForKey:@"Data"] integerValue];
            [self.bujuArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSMutableDictionary *dic = obj;
                if ([dic[@"title"] isEqualToString:@"报名表单"]) {
                    dic[@"isShow"] = (isQudao==0?@1:@0);
                    [self updateMiddleContainerViewLayout];
                }
            }];
        }
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

#pragma mark - 获取学生退费信息
-(void)getStudentRefundList{
    
    [HXBaseURLSessionManager postDataWithNSString:HXPOST_GetStudentRefundList withDictionary:nil success:^(NSDictionary * _Nonnull dictionary) {
        
        BOOL success = [dictionary boolValueForKey:@"Success"];
        if (success) {
            //刷新数据
            NSArray *array = [HXStudentRefundModel mj_objectArrayWithKeyValuesArray:[dictionary objectForKey:@"Data"]];
            [self.bujuArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSMutableDictionary *dic = obj;
                if ([dic[@"title"] isEqualToString:@"退费确认"]) {
                    dic[@"isShow"] = (array.count>0?@1:@0);
                    [self updateMiddleContainerViewLayout];
                }
            }];
            
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
    
    //获取学生退费信息，控制退费确认按钮的显示与隐藏
    [self getStudentRefundList];
    
    //获取是否渠道学生  控制报名表单隐藏与显示
    [self getIsQdStu];
    
}

#pragma mark - 请求未读消息数量
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


#pragma mark - 刷新数据
-(void)refreshTopHeaderUI{
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
    self.bannerParam.wDataSet(self.majorList);
    [self.bannerView updateUI];
}


///更新布局
-(void)updateMiddleContainerViewLayout{
    ///移除重新布局
    [self.middleBtns removeAllObjects];
    [self.middleContainerView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
        obj = nil;
    }];
    
    [self.bujuArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *dic = obj;
        if ([dic[@"isShow"] integerValue] ==1) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.titleLabel.textAlignment = NSTextAlignmentCenter;
            btn.titleLabel.font = HXFont(12);
            btn.tag = [dic[@"handleEventTag"] integerValue];
            [btn setTitle:dic[@"title"] forState:UIControlStateNormal];
            [btn setTitleColor:COLOR_WITH_ALPHA(0x2C2C2E, 1) forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:dic[@"iconName"]] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(handleMiddleClick:) forControlEvents:UIControlEventTouchUpInside];
            [_middleContainerView addSubview:btn];
            [self.middleBtns addObject:btn];
            
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
    }];

    [self.middleContainerView setupAutoMarginFlowItems:self.middleBtns withPerRowItemsCount:3 itemWidth:100 verticalMargin:20 verticalEdgeInset:20 horizontalEdgeInset:10];
}

#pragma mark - Event
-(void)clickCollectInfoBtn:(UIButton *)sender{
    HXPictureInforConfirmViewController *infoConfirmVc = [[HXPictureInforConfirmViewController alloc] init];
    infoConfirmVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:infoConfirmVc animated:YES];
}

-(void)clickMessageBtn:(UIButton *)sender{
    HXSystemNotificationViewController *systemNotificationVc = [[HXSystemNotificationViewController alloc] init];
    systemNotificationVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:systemNotificationVc animated:YES];
}

-(void)handleMiddleClick:(UIButton *)sender{
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
            HXPictureInforConfirmViewController *infoConfirmVc = [[HXPictureInforConfirmViewController alloc] init];
            infoConfirmVc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:infoConfirmVc animated:YES];
        }
            break;
            
        case 3://班主任
        {
            HXHeadMasterViewController *headMasterVc = [[HXHeadMasterViewController alloc] init];
            headMasterVc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:headMasterVc animated:YES];
        }
            break;
        case 4://异动确认
        {
            HXYiDongAndRefundConfirmViewController *yiDongAndRefundConfirmVc = [[HXYiDongAndRefundConfirmViewController alloc] init];
            yiDongAndRefundConfirmVc.hidesBottomBarWhenPushed = YES;
            yiDongAndRefundConfirmVc.confirmType = HXYiDongConfirmType;
            [self.navigationController pushViewController:yiDongAndRefundConfirmVc animated:YES];
            
        }
            break;
        case 5://退费确认
        {
            HXYiDongAndRefundConfirmViewController *yiDongAndRefundConfirmVc = [[HXYiDongAndRefundConfirmViewController alloc] init];
            yiDongAndRefundConfirmVc.hidesBottomBarWhenPushed = YES;
            yiDongAndRefundConfirmVc.confirmType = HXRefundConfirmType;
            [self.navigationController pushViewController:yiDongAndRefundConfirmVc animated:YES];
            
        }
            break;
            
        case 6://关于我们
        {
            HXAboutUsViewController *aboutUsVc = [[HXAboutUsViewController alloc] init];
            aboutUsVc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:aboutUsVc animated:YES];
            
        }
            break;
        case 7://联系我们
        {
            HXLianXiUsViewController *lianXiUsVc = [[HXLianXiUsViewController alloc] init];
            lianXiUsVc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:lianXiUsVc animated:YES];
        }
            break;
        case 8://通用设置
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
    [self.view addSubview:self.mainScrollView];
    [self.mainScrollView addSubview:self.topView];
    [self.topView addSubview:self.headerImageView];
    [self.topView addSubview:self.nameLabel];
    [self.topView addSubview:self.phoneBtn];
    [self.topView addSubview:self.collectInfoBtn];
    [self.topView addSubview:self.messageBtn];
    
    [self.mainScrollView addSubview:self.bannerView];
    [self.mainScrollView addSubview:self.middleContainerView];
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
    NSArray *colorArr = @[(id)COLOR_WITH_ALPHA(0x3EADFF, 1).CGColor,(id)COLOR_WITH_ALPHA(0x15E88D, 1).CGColor];
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
    [self.nameLabel setSingleLineAutoResizeWithMaxWidth:120];
    
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
    
    self.messageRedDot.sd_layout
    .topEqualToView(self.messageBtn).offset(-6)
    .rightEqualToView(self.messageBtn).offset(-6)
    .widthIs(20)
    .heightEqualToWidth();
    self.messageRedDot.sd_cornerRadiusFromHeightRatio = @0.5;
    
    self.messageCountLabel.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    
    self.bannerView.sd_layout
    .topSpaceToView(self.mainScrollView, 160)
    .leftEqualToView(self.mainScrollView)
    .rightEqualToView(self.mainScrollView)
    .heightIs(200);
    
    self.middleContainerView.sd_layout
    .topSpaceToView(self.bannerView, 15)
    .leftSpaceToView(self.mainScrollView, _kpw(25))
    .rightSpaceToView(self.mainScrollView, _kpw(25));
    
    for (UIButton *btn in self.middleBtns) {
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
    
    
    [self.middleContainerView setupAutoMarginFlowItems:self.middleBtns withPerRowItemsCount:3 itemWidth:100 verticalMargin:20 verticalEdgeInset:20 horizontalEdgeInset:10];
    self.middleContainerView.sd_cornerRadius = @10;
    
    self.bottomContainerView.sd_layout
    .topSpaceToView(self.middleContainerView, 15)
    .leftSpaceToView(self.mainScrollView, _kpw(25))
    .rightSpaceToView(self.mainScrollView, _kpw(25))
    .heightIs(152);
    self.bottomContainerView.sd_cornerRadius = @10;
    
    
    
    
    
    self.aboutUsBtn.sd_layout
    .topEqualToView(self.bottomContainerView)
    .leftEqualToView(self.bottomContainerView)
    .rightEqualToView(self.bottomContainerView)
    .heightIs(50);
    
    self.aboutUsBtn.titleLabel.sd_layout
    .centerYEqualToView(self.aboutUsBtn)
    .leftSpaceToView(self.aboutUsBtn, 22)
    .widthIs(150)
    .heightIs(22);
    
    self.aboutUsBtn.imageView.sd_layout
    .centerYEqualToView(self.aboutUsBtn)
    .rightSpaceToView(self.aboutUsBtn, 16)
    .widthIs(16)
    .heightEqualToWidth();
    
    self.line.sd_layout
    .topSpaceToView(self.aboutUsBtn, 0)
    .leftSpaceToView(self.bottomContainerView, 21)
    .rightSpaceToView(self.bottomContainerView, 0)
    .heightIs(1);
    
    self.lianXiUsBtn.sd_layout
    .topSpaceToView(self.line, 0)
    .leftEqualToView(self.bottomContainerView)
    .rightEqualToView(self.bottomContainerView)
    .heightIs(50);
    
    self.lianXiUsBtn.titleLabel.sd_layout
    .centerYEqualToView(self.lianXiUsBtn)
    .leftSpaceToView(self.lianXiUsBtn, 22)
    .widthIs(150)
    .heightIs(22);
    
    self.lianXiUsBtn.imageView.sd_layout
    .centerYEqualToView(self.lianXiUsBtn)
    .rightSpaceToView(self.lianXiUsBtn, 16)
    .widthIs(16)
    .heightEqualToWidth();
    
    self.line2.sd_layout
    .topSpaceToView(self.lianXiUsBtn, 0)
    .leftSpaceToView(self.bottomContainerView, 21)
    .rightSpaceToView(self.bottomContainerView, 0)
    .heightIs(1);
    
    self.commomSetBtn.sd_layout
    .topSpaceToView(self.line2, 0)
    .leftEqualToView(self.bottomContainerView)
    .rightEqualToView(self.bottomContainerView)
    .heightIs(50);
    
    self.commomSetBtn.titleLabel.sd_layout
    .centerYEqualToView(self.commomSetBtn)
    .leftSpaceToView(self.commomSetBtn, 22)
    .widthIs(150)
    .heightIs(22);
    
    self.commomSetBtn.imageView.sd_layout
    .centerYEqualToView(self.commomSetBtn)
    .rightSpaceToView(self.commomSetBtn, 16)
    .widthIs(16)
    .heightEqualToWidth();
    
    
    self.logoViewImageView.sd_layout
    .topSpaceToView(self.bottomContainerView, 25)
    .leftEqualToView(self.mainScrollView)
    .rightEqualToView(self.mainScrollView)
    .heightIs(48);
    
    [self.mainScrollView setupAutoHeightWithBottomView:self.logoViewImageView bottomMargin:30];
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    header.automaticallyChangeAlpha = YES;
    
    //设置header
    self.mainScrollView.mj_header = header;
    
    
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
        _nameLabel.font = HXBoldFont(18);
        
    }
    return _nameLabel;
}

-(UIButton *)phoneBtn{
    if (!_phoneBtn) {
        _phoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _phoneBtn.hidden = YES;
        _phoneBtn.titleLabel.font = HXFont(12);
        _phoneBtn.backgroundColor = COLOR_WITH_ALPHA(0xB8DCF9, 1);
        [_phoneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
    }
    return _phoneBtn;
}

-(UIButton *)collectInfoBtn{
    if (!_collectInfoBtn) {
        _collectInfoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _collectInfoBtn.titleLabel.font = HXFont(10);
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


-(WMZBannerView *)bannerView{
    if (!_bannerView) {
        WMZBannerParam *param =
        BannerParam()
        //自定义视图必传
        .wMyCellClassNameSet(@"HXRecordCell")
        .wMyCellSet(^UICollectionViewCell *(NSIndexPath *indexPath, UICollectionView *collectionView, id model, UIImageView *bgImageView,NSArray*dataArr) {
            //自定义视图
            HXRecordCell *cell = (HXRecordCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HXRecordCell class]) forIndexPath:indexPath];
            HXMajorModel *majorModel = model;
            cell.majorModel = majorModel;
            return cell;
        })
        .wFrameSet(CGRectMake(0, 0, kScreenWidth, 200))
        //关闭pageControl
        .wHideBannerControlSet(YES)
        //开启缩放
        .wScaleSet(YES)
        ///缩放系数
        .wScaleFactorSet(0.1)
        //自定义item的大小
        .wItemSizeSet(CGSizeMake(kScreenWidth-46,180))
        //固定移动的距离
        .wContentOffsetXSet(0.5)
        //自动滚动
        .wAutoScrollSet(NO)
        //cell动画的位置
        .wPositionSet(BannerCellPositionCenter)
        //循环
        .wRepeatSet(NO)
        //整体左右间距 让最后一个可以居中
        .wSectionInsetSet(UIEdgeInsetsMake(0,23, 0,23))
        //间距
        .wLineSpacingSet(10);
        self.bannerParam = param;
        _bannerView = [[WMZBannerView alloc] initConfigureWithModel:param];
        
    }
    return _bannerView;
}

-(NSMutableArray *)bujuArray{
    if (!_bujuArray) {
        _bujuArray = [NSMutableArray array];
        [_bujuArray addObjectsFromArray:@[
            [@{@"title":@"缴费明细",@"iconName":@"payment_icon",@"handleEventTag":@(5000),@"isShow":@(1)} mutableCopy],
            [@{@"title":@"报名表单",@"iconName":@"registform_icon",@"handleEventTag":@(5001),@"isShow":@(1)} mutableCopy],
            [@{@"title":@"图片信息确认",@"iconName":@"infconfirm_icon",@"handleEventTag":@(5002),@"isShow":@(1)} mutableCopy],
            [ @{@"title":@"班主任",@"iconName":@"headmaster_icon",@"handleEventTag":@(5003),@"isShow":@(1)} mutableCopy],
            [@{@"title":@"异动确认",@"iconName":@"yidongconfirm_icon",@"handleEventTag":@(5004),@"isShow":@(1)} mutableCopy],
            [@{@"title":@"退费确认",@"iconName":@"refundconfirm_icon",@"handleEventTag":@(5005),@"isShow":@(1)} mutableCopy]
        ]];
    }
    return _bujuArray;
}

-(UIView *)middleContainerView{
    if (!_middleContainerView) {
        _middleContainerView = [[UIView alloc] init];
        _middleContainerView.backgroundColor = [UIColor whiteColor];
        
        for (int i = 0; i<self.bujuArray.count; i++) {
            NSDictionary *dic = self.bujuArray[i];
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.titleLabel.textAlignment = NSTextAlignmentCenter;
            btn.titleLabel.font = HXFont(12);
            btn.tag = [dic[@"handleEventTag"] integerValue];
            [btn setTitle:dic[@"title"] forState:UIControlStateNormal];
            [btn setTitleColor:COLOR_WITH_ALPHA(0x2C2C2E, 1) forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:dic[@"iconName"]] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(handleMiddleClick:) forControlEvents:UIControlEventTouchUpInside];
            [_middleContainerView addSubview:btn];
            [self.middleBtns addObject:btn];
        }
    }
    return _middleContainerView;;
}

-(NSMutableArray *)middleBtns{
    if (!_middleBtns) {
        _middleBtns = [NSMutableArray array];
    }
    return _middleBtns;;
}



-(UIView *)bottomContainerView{
    if (!_bottomContainerView) {
        _bottomContainerView = [[UIView alloc] init];
        _bottomContainerView.backgroundColor = [UIColor whiteColor];
        [_bottomContainerView addSubview:self.aboutUsBtn];
        [_bottomContainerView addSubview:self.line];
        [_bottomContainerView addSubview:self.lianXiUsBtn];
        [_bottomContainerView addSubview:self.line2];
        [_bottomContainerView addSubview:self.commomSetBtn];
    }
    return _bottomContainerView;
}

-(UIButton *)aboutUsBtn{
    if (!_aboutUsBtn) {
        _aboutUsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _aboutUsBtn.tag = 5006;
        _aboutUsBtn.titleLabel.font = HXFont(14);
        _aboutUsBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        [_aboutUsBtn setTitleColor:COLOR_WITH_ALPHA(0x2C2C2E, 1) forState:UIControlStateNormal];
        [_aboutUsBtn setTitle:@"关于我们" forState:UIControlStateNormal];
        [_aboutUsBtn setImage:[UIImage imageNamed:@"left_arrow"] forState:UIControlStateNormal];
        [_aboutUsBtn addTarget:self action:@selector(handleMiddleClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _aboutUsBtn;
}

-(UIButton *)lianXiUsBtn{
    if (!_lianXiUsBtn) {
        _lianXiUsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _lianXiUsBtn.tag = 5007;
        _lianXiUsBtn.titleLabel.font = HXFont(14);
        _lianXiUsBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        [_lianXiUsBtn setTitleColor:COLOR_WITH_ALPHA(0x2C2C2E, 1) forState:UIControlStateNormal];
        [_lianXiUsBtn setTitle:@"联系我们" forState:UIControlStateNormal];
        [_lianXiUsBtn setImage:[UIImage imageNamed:@"left_arrow"] forState:UIControlStateNormal];
        [_lianXiUsBtn addTarget:self action:@selector(handleMiddleClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _lianXiUsBtn;
}

-(UIButton *)commomSetBtn{
    if (!_commomSetBtn) {
        _commomSetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _commomSetBtn.tag = 5008;
        _commomSetBtn.titleLabel.font = HXFont(14);
        _commomSetBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        [_commomSetBtn setTitleColor:COLOR_WITH_ALPHA(0x2C2C2E, 1) forState:UIControlStateNormal];
        [_commomSetBtn setTitle:@"通用设置" forState:UIControlStateNormal];
        [_commomSetBtn setImage:[UIImage imageNamed:@"left_arrow"] forState:UIControlStateNormal];
        [_commomSetBtn addTarget:self action:@selector(handleMiddleClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _commomSetBtn;
}

-(UIView *)line{
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = COLOR_WITH_ALPHA(0x979797, 0.5);
    }
    return _line;
}

-(UIView *)line2{
    if (!_line2) {
        _line2 = [[UIView alloc] init];
        _line2.backgroundColor = COLOR_WITH_ALPHA(0x979797, 0.5);
    }
    return _line2;
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
