//
//  HXNotZhuanJieYiDongDetailsViewController.m
//  HXMinedu
//
//  Created by mac on 2021/7/8.
//

#import "HXNotZhuanJieYiDongDetailsViewController.h"
#import "HXYiDongAndRefundConfirmViewController.h"
#import "HXMajorInfoCell.h"
#import "HXRecentPaymentInfoCell.h"
#import "HXSuggestionCell.h"
#import "HXToastSuggestionView.h"
#import "HXCustomToastView.h"


@interface HXNotZhuanJieYiDongDetailsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) UITableView *mainTableView;
@property(nonatomic,strong) UIView *bottomView;
@property(nonatomic,strong) UIView *bottomShadowView;
@property(nonatomic,strong) UIButton *rejectBtn;//驳回
@property(nonatomic,strong) UIButton *confirmBtn;//确认异动

//新缴费信息
@property(nonatomic,strong) UIView *headerView;
@property(nonatomic,strong) UIImageView *bigHeaderWhiteImageView;
@property(nonatomic,strong) UILabel *xinPayMentInfoLabel;
@property(nonatomic,strong) UIView *line1;
//应缴合计
@property(nonatomic,strong) UILabel *yinJiaoLabel;
@property(nonatomic,strong) UILabel *yinJiaoMoneyLabel;
//结转合计
@property(nonatomic,strong) UILabel *jieZhuanLabel;
@property(nonatomic,strong) UILabel *jieZhuanMoneyLabel;

@property(nonatomic,strong) UIView *footerView;
@property(nonatomic,strong) UIImageView *bigFooterWhiteImageView;


//转产品/专业详情
@property(nonatomic,strong) HXZzyAndZcpModel *zzyAndZcpModel;


@end

@implementation HXNotZhuanJieYiDongDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
    // 获取学生转专业转产品异动新专业详情
    [self getStopStudyByZzyAndZcpNewMajorInfo];
}

#pragma mark - 获取学生转专业转产品异动新专业详情
-(void)getStopStudyByZzyAndZcpNewMajorInfo{
    
    NSDictionary *dic = @{
        @"stopStudyId":HXSafeString(self.stopStudyId)
    };
    [self.view showLoading];
    [HXBaseURLSessionManager postDataWithNSString:HXPOST_GetStopStudyByZzyAndZcpNewMajorInfo  withDictionary:dic success:^(NSDictionary * _Nonnull dictionary) {
        [self.view hideLoading];
        BOOL success = [dictionary boolValueForKey:@"Success"];
        if (success) {
            self.zzyAndZcpModel = [HXZzyAndZcpModel mj_objectWithKeyValues:[dictionary objectForKey:@"Data"]];
            self.zzyAndZcpModel.jiezhuanMajorInfoModel.isRecent = YES;
            self.yinJiaoMoneyLabel.text = [NSString stringWithFormat:@"¥%.2f",self.zzyAndZcpModel.payMoneyTotal];
            self.jieZhuanMoneyLabel.text =[NSString stringWithFormat:@"¥%.2f",self.zzyAndZcpModel.costMoneyTotal];
            [self.mainTableView reloadData];
        }
    } failure:^(NSError * _Nonnull error) {
        [self.view hideLoading];
    }];
}
#pragma mark - 学生异动信息确认或驳回
-(void)loadRefundConfirmOrRejectRemark:(NSString *)remark reviewStatus:(NSInteger)reviewStatus{
    
    NSDictionary *dic = @{
        @"stopStudyId":HXSafeString(self.stopStudyId),
        @"reviewStatus":@(reviewStatus),
        @"rejectRemark":HXSafeString(remark),
        @"payMode":@"",
        @"image":@"",
        @"khm":@"",
        @"khh":@"",
        @"khsk":@""
    };
    
    [HXBaseURLSessionManager postDataWithNSString:HXPOST_StuStopConfirmOrReject  withDictionary:dic success:^(NSDictionary * _Nonnull dictionary) {
        [self.view hideLoading];
        BOOL success = [dictionary boolValueForKey:@"Success"];
        if (success) {
            self.bottomView.hidden = self.bottomShadowView.hidden = YES;
            //刷新数据
            [self getStopStudyByZzyAndZcpNewMajorInfo];
            
            HXCustomToastView *toastView = [[HXCustomToastView alloc] init];
            reviewStatus == 1?[toastView showConfirmToastHideAfter:2]:[toastView showRejectToastHideAfter:2];
            //通知异动列表刷新
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ConfirmOrRejectYiDongNotification" object:nil];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //返回异动列表界面
                [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj isKindOfClass:[HXYiDongAndRefundConfirmViewController class]]) {
                        [self.navigationController popToViewController:obj animated:YES];
                        *stop =  YES;
                        return;
                    }
                }];
            });
        }
    } failure:^(NSError * _Nonnull error) {
        [self.view hideLoading];
        self.bottomView.hidden = self.bottomShadowView.hidden = NO;
    }];
    
}

#pragma mark - Event
//驳回
-(void)reject:(UIButton *)sender{
    HXToastSuggestionView *toastSuggestionView = [[HXToastSuggestionView alloc] init];
    [toastSuggestionView showRejecttoastWithCallBack:^(NSString * _Nonnull cotent) {
        [self loadRefundConfirmOrRejectRemark:cotent reviewStatus:2];
    }];
}

//确认
-(void)confirm:(UIButton *)sender{
    
    HXToastSuggestionView *toastSuggestionView = [[HXToastSuggestionView alloc] init];
    [toastSuggestionView showConfirmToastWithCallBack:^(NSString * _Nonnull cotent) {
        [self loadRefundConfirmOrRejectRemark:cotent reviewStatus:1];
    }];
}



#pragma mark - <UITableViewDelegate,UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return self.headerView;
    }else{
        return nil;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 1) {
        return self.footerView;
    }else{
        return nil;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 106;
    }else{
        return 0.001;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 1) {
        return 30;
    }else{
        return 0.001;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return 156;
            break;
        case 1:
           {
               HXZzyAndZcpModel *zzyAndZcpModel = self.zzyAndZcpModel;
               CGFloat rowHeight = [tableView cellHeightForIndexPath:indexPath
                                                               model:zzyAndZcpModel keyPath:@"zzyAndZcpModel"
                                                           cellClass:([HXRecentPaymentInfoCell class])
                                                    contentViewWidth:kScreenWidth];
               return rowHeight;
           }
            break;
        case 2:
           {
               return 110;
           }
            break;
        default:
            return 0;
            break;
    }
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
  
    static NSString *majorInfoCellIdentifier = @"HXMajorInfoCellIdentifier";
    static NSString *recentPaymentInfoCellIdentifier = @"HXRecentPaymentInfoCellIdentifier";
    static NSString *suggestionCellIdentifier = @"HXSuggestionCellIdentifier";
    
    switch (indexPath.section) {
        case 0:
        {
            HXMajorInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:majorInfoCellIdentifier];
            if (!cell) {
                cell = [[HXMajorInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:majorInfoCellIdentifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.majorInfoModel = self.zzyAndZcpModel.jiezhuanMajorInfoModel;
            return cell;
        }
            break;
        case 1:
        {
            HXRecentPaymentInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:recentPaymentInfoCellIdentifier];
            if (!cell) {
                cell = [[HXRecentPaymentInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:recentPaymentInfoCellIdentifier];
            }
            HXZzyAndZcpModel *zzyAndZcpModel = self.zzyAndZcpModel;
            [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
            cell.zzyAndZcpModel = zzyAndZcpModel;
            return cell;
        }
            break;
        default:
            return nil;
            break;
    }
    
}

#pragma mark - UI
-(void)createUI{
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.sc_navigationBar.title = @"异动详情";
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
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
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
        _mainTableView.contentInset = UIEdgeInsetsMake(10, 0, 150, 0);
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
        [_confirmBtn setTitle:@"确认异动" forState:UIControlStateNormal];
        [_confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_confirmBtn addTarget:self action:@selector(confirm:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmBtn;
}

-(UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 106)];
        _headerView.backgroundColor = [UIColor clearColor];
        [_headerView addSubview:self.bigHeaderWhiteImageView];
        self.bigHeaderWhiteImageView.sd_layout
        .topSpaceToView(_headerView, 8)
        .leftSpaceToView(_headerView, 10)
        .rightSpaceToView(_headerView, 10)
        .bottomEqualToView(_headerView);

        [self.bigHeaderWhiteImageView addSubview:self.xinPayMentInfoLabel];
        [self.bigHeaderWhiteImageView addSubview:self.line1];
        [self.bigHeaderWhiteImageView addSubview:self.yinJiaoLabel];
        [self.bigHeaderWhiteImageView addSubview:self.yinJiaoMoneyLabel];
        [self.bigHeaderWhiteImageView addSubview:self.jieZhuanLabel];
        [self.bigHeaderWhiteImageView addSubview:self.jieZhuanMoneyLabel];
       
        
        self.xinPayMentInfoLabel.sd_layout
        .topSpaceToView(self.bigHeaderWhiteImageView, 14)
        .leftSpaceToView(self.bigHeaderWhiteImageView, 24)
        .rightSpaceToView(self.bigHeaderWhiteImageView, 24)
        .heightIs(22);
        
        self.line1.sd_layout
        .topSpaceToView(self.bigHeaderWhiteImageView, 55)
        .leftSpaceToView(self.bigHeaderWhiteImageView, (kScreenWidth-20)/2)
        .widthIs(1)
        .heightIs(28);
        
        self.yinJiaoLabel.sd_layout
        .topSpaceToView(self.xinPayMentInfoLabel, 16)
        .leftSpaceToView(self.bigHeaderWhiteImageView, 0)
        .rightSpaceToView(self.line1, 0)
        .heightIs(17);
        
        self.yinJiaoMoneyLabel.sd_layout
        .topSpaceToView(self.yinJiaoLabel, 3)
        .leftEqualToView(self.yinJiaoLabel)
        .rightEqualToView(self.yinJiaoLabel)
        .heightIs(20);
        
      
        
        self.jieZhuanLabel.sd_layout
        .topEqualToView(self.yinJiaoLabel)
        .leftSpaceToView(self.line1, 0)
        .rightSpaceToView(self.bigHeaderWhiteImageView, 0)
        .heightRatioToView(self.yinJiaoLabel, 1);
        
        self.jieZhuanMoneyLabel.sd_layout
        .topEqualToView(self.yinJiaoMoneyLabel)
        .leftEqualToView(self.jieZhuanLabel)
        .rightEqualToView(self.jieZhuanLabel)
        .heightRatioToView(self.yinJiaoMoneyLabel, 1);
        
        
        
        
    }
    return _headerView;
}
-(UIImageView *)bigHeaderWhiteImageView{
    if (!_bigHeaderWhiteImageView) {
        _bigHeaderWhiteImageView = [[UIImageView alloc] init];
        _bigHeaderWhiteImageView.image = [UIImage resizedImageWithName:@"top_radius"];
    }
    return _bigHeaderWhiteImageView;
}

-(UILabel *)xinPayMentInfoLabel{
    if (!_xinPayMentInfoLabel) {
        _xinPayMentInfoLabel = [[UILabel alloc] init];
        _xinPayMentInfoLabel.textAlignment = NSTextAlignmentLeft;
        _xinPayMentInfoLabel.font = HXBoldFont(16);
        _xinPayMentInfoLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        _xinPayMentInfoLabel.text = @"新缴费信息";
    }
    return _xinPayMentInfoLabel;
}

-(UIView *)line1{
    if (!_line1) {
        _line1 = [[UIView alloc] init];
        _line1.backgroundColor = COLOR_WITH_ALPHA(0x979797, 1);
    }
    return _line1;
}

-(UILabel *)yinJiaoLabel{
    if (!_yinJiaoLabel) {
        _yinJiaoLabel = [[UILabel alloc] init];
        _yinJiaoLabel.textAlignment = NSTextAlignmentCenter;
        _yinJiaoLabel.font = HXBoldFont(12);
        _yinJiaoLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        _yinJiaoLabel.text = @"应缴合计";
    }
    return _yinJiaoLabel;
}

-(UILabel *)yinJiaoMoneyLabel{
    if (!_yinJiaoMoneyLabel) {
        _yinJiaoMoneyLabel = [[UILabel alloc] init];
        _yinJiaoMoneyLabel.textAlignment = NSTextAlignmentCenter;
        _yinJiaoMoneyLabel.font = HXFont(12);
        _yinJiaoMoneyLabel.textColor = COLOR_WITH_ALPHA(0x5699FF, 1);
        _yinJiaoMoneyLabel.text = @"¥5800.00";
    }
    return _yinJiaoMoneyLabel;
}



-(UILabel *)jieZhuanLabel{
    if (!_jieZhuanLabel) {
        _jieZhuanLabel = [[UILabel alloc] init];
        _jieZhuanLabel.textAlignment = NSTextAlignmentCenter;
        _jieZhuanLabel.font = HXBoldFont(12);
        _jieZhuanLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        _jieZhuanLabel.text = @"结转合计";
    }
    return _jieZhuanLabel;
}

-(UILabel *)jieZhuanMoneyLabel{
    if (!_jieZhuanMoneyLabel) {
        _jieZhuanMoneyLabel = [[UILabel alloc] init];
        _jieZhuanMoneyLabel.textAlignment = NSTextAlignmentCenter;
        _jieZhuanMoneyLabel.font = HXFont(12);
        _jieZhuanMoneyLabel.textColor = COLOR_WITH_ALPHA(0xFE664B, 1);
        _jieZhuanMoneyLabel.text = @"¥5800.00";
    }
    return _jieZhuanMoneyLabel;
}




-(UIView *)footerView{
    if (!_footerView) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
        _footerView.backgroundColor = [UIColor clearColor];
        [_footerView addSubview:self.bigFooterWhiteImageView];
        
        self.bigFooterWhiteImageView.sd_layout
        .topSpaceToView(_footerView, 0)
        .leftSpaceToView(_footerView, 10)
        .rightSpaceToView(_footerView, 10)
        .bottomSpaceToView(_footerView, 8);
        
    }
    return _footerView;
}

-(UIImageView *)bigFooterWhiteImageView{
    if (!_bigFooterWhiteImageView) {
        _bigFooterWhiteImageView = [[UIImageView alloc] init];
        _bigFooterWhiteImageView.image = [UIImage resizedImageWithName:@"bottom_radius"];
    }
    return _bigFooterWhiteImageView;
}






@end

