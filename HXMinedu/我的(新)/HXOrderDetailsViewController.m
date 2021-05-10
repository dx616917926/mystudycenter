//
//  HXOrderDetailsViewController.m
//  HXMinedu
//
//  Created by mac on 2021/4/29.
//

#import "HXOrderDetailsViewController.h"
#import "HXScanCodePaymentViewController.h"
#import "HXCommonWebViewController.h"
#import "HXPaymentDetailCell.h"
#import "HXYingJiaoCell.h"
#import "HXPaidDetailCell.h"
#import "HXUnPaidDetailCell.h"
#import "HXNoDataTipView.h"
#import "HXPaymentModel.h"
#import "MJRefresh.h"


@interface HXOrderDetailsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(strong,nonatomic) UITableView *mainTableView;

@property(strong,nonatomic) UIView *orderDetailsTableHeaderView;
@property(strong,nonatomic) UIButton *copyBtn;//复制
@property(nonatomic,strong) UILabel *orderNumLabel;//订单编号：
@property(nonatomic,strong) UILabel *orderTimeLabel;//订单时间：


@property(strong,nonatomic) UIView *orderDetailsTableFooterView;
@property(nonatomic,strong) UILabel *paymentMethodLabel;//支付方式：
@property(nonatomic,strong) UILabel *paymentMethodContentLabel;
@property(nonatomic,strong) UILabel *paymentTimeLabel;//支付时间：
@property(nonatomic,strong) UILabel *paymentTimeContentLabel;
@property(nonatomic,strong) UILabel *yingjiaoTotalLabel;//本次应缴总额：
@property(nonatomic,strong) UILabel *yingjiaoTotalMoneyLabel;
@property(nonatomic,strong) UILabel *shiJiaoLabel;//实付金额：
@property(nonatomic,strong) UILabel *shiJiaoMoneyLabel;

@property(nonatomic,strong) UIButton *payBtn;//确认并支付

@property(nonatomic,strong) HXNoDataTipView *noDataTipView;

//订单详情模型
@property(nonatomic,strong) HXPaymentModel *paidDetailsInfoModel;

///全部订单数组
@property(nonatomic,strong) NSArray *paidDetailsList;


@end

@implementation HXOrderDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
    
    //获取订单详情
    [self getPaidDetailsInfo];
    
    
}

#pragma mark - 下拉刷新
-(void)loadNewData{
    //获取订单详情
    [self getPaidDetailsInfo];
}

#pragma mark -  获取订单详情
-(void)getPaidDetailsInfo{
    HXMajorModel *selectMajorModel = [HXPublicParamTool sharedInstance].selectMajorModel;
    NSDictionary *dic = @{
        @"version_id":HXSafeString(selectMajorModel.versionId),
        @"major_id":HXSafeString(selectMajorModel.major_id),
        @"type":@(selectMajorModel.type),
        @"orderNum":HXSafeString(self.orderNum),
    };
    
    [HXBaseURLSessionManager postDataWithNSString:HXPOST_Get_PaidDetailsInfo withDictionary:dic success:^(NSDictionary * _Nonnull dictionary) {
        [self.mainTableView.mj_header endRefreshing];
        BOOL success = [dictionary boolValueForKey:@"Success"];
        if (success) {
            //刷新数据
            self.paidDetailsInfoModel = [HXPaymentModel mj_objectWithKeyValues:[dictionary objectForKey:@"Data"]];
            [self refreshUI];
        }else{
            [self.view showErrorWithMessage:[dictionary stringValueForKey:@"Message"]];
        }
    } failure:^(NSError * _Nonnull error) {
        [self.mainTableView.mj_header endRefreshing];

    }];
}

-(void)refreshUI{
    if (self.paidDetailsInfoModel.paidDetailsTypeList.count == 0) {
        [self.view addSubview:self.noDataTipView];
    }else{
        [self.noDataTipView removeFromSuperview];
    }
    self.mainTableView.tableHeaderView = self.orderDetailsTableHeaderView;
    self.mainTableView.tableFooterView = self.orderDetailsTableFooterView;
    [self.mainTableView reloadData];
    
    self.orderNumLabel.text = [NSString stringWithFormat:@"订单编号：%@",HXSafeString(self.paidDetailsInfoModel.orderNum)];
    self.orderTimeLabel.text = [NSString stringWithFormat:@"订单时间：%@",HXSafeString(self.paidDetailsInfoModel.createDate)];
    self.paymentMethodContentLabel.text = HXSafeString(self.paidDetailsInfoModel.alias);
    self.paymentTimeContentLabel.text = HXSafeString(self.paidDetailsInfoModel.feeDate);
    self.yingjiaoTotalMoneyLabel.text = [NSString stringWithFormat:@"¥%.2f",self.paidDetailsInfoModel.feeTotal];
    self.shiJiaoMoneyLabel.text = [NSString stringWithFormat:@"¥%.2f",self.paidDetailsInfoModel.payMoneyTotal];
}

#pragma mark - EVent
-(void)pushPaymentVC:(UIButton *)sender{
    if (self.paidDetailsInfoModel.payMode_id == 2) {//扫码支付
        HXScanCodePaymentViewController *vc = [[HXScanCodePaymentViewController alloc] init];
        vc.orderNum = self.paidDetailsInfoModel.orderNum;
        [self.navigationController pushViewController:vc animated:YES];
    }else{//银联支付
//        @"https://demo.hlw-study.com/OP.Enroll/EnrollOP/mbPayMWEB?sid=MjY4NA==&rmb=MTAw&aid=MQ==";
//        @"https://wx.tenpay.com/cgi-bin/mmpayweb-bin/checkmweb?prepay_id=wx20180115115052bedf091fba0369993002&package=2975002856";
        HXCommonWebViewController * vc = [[HXCommonWebViewController alloc] init];
        vc.urlString = self.paidDetailsInfoModel.payUrl;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

#pragma mark - 布局子视图
-(void)createUI{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.sc_navigationBar.title = @"订单详情";
    [self.view addSubview:self.mainTableView];
    
    // 下拉刷新
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    header.automaticallyChangeAlpha = YES;
    self.mainTableView.mj_header = header;
    
}

#pragma mark - Event
-(void)copyOrderNum:(UIButton *)sender{
    UIPasteboard *pastboard = [UIPasteboard generalPasteboard];
    [pastboard setString:HXSafeString(self.paidDetailsInfoModel.orderNum)];
    [self.view showTostWithMessage:@"复制成功"];
}

#pragma mark - <UITableViewDelegate,UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.paidDetailsInfoModel.paidDetailsTypeList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HXPaymentDetailsInfoModel *paymentDetailsInfoModel = self.paidDetailsInfoModel.paidDetailsTypeList[indexPath.section];
    return 90+paymentDetailsInfoModel.paidDetailsOrderInfoList.count*40;
//    CGFloat rowHeight = [tableView cellHeightForIndexPath:indexPath
//                                                         model:paymentDetailsInfoModel keyPath:@"paymentDetailsInfoModel"
//                                                     cellClass:([HXYingJiaoCell class])
//                                              contentViewWidth:kScreenWidth];



}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *yingJiaoCellIdentifier = @"HXYingJiaoCellIdentifier";
    HXYingJiaoCell *cell = [tableView dequeueReusableCellWithIdentifier:yingJiaoCellIdentifier];
    if (!cell) {
        cell = [[HXYingJiaoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:yingJiaoCellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.showType = HXOrderDetailsShowType;
    [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    HXPaymentDetailsInfoModel *paymentDetailsInfoModel = self.paidDetailsInfoModel.paidDetailsTypeList[indexPath.section];
    cell.paymentDetailsInfoModel = paymentDetailsInfoModel;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


#pragma mark - lazyLoad

-(void)setFlag:(NSInteger)flag{
    _flag = flag;
}
-(void)setOrderNum:(NSString *)orderNum{
    _orderNum = orderNum;
}

-(UITableView *)mainTableView{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavigationBarHeight, kScreenWidth, kScreenHeight-kNavigationBarHeight) style:UITableViewStylePlain];
        _mainTableView.bounces = YES;
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.backgroundColor = COLOR_WITH_ALPHA(0xF5F6FA, 1);
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
        _mainTableView.contentInset = UIEdgeInsetsMake(0, 0, kScreenBottomMargin, 0);
        _mainTableView.scrollIndicatorInsets = _mainTableView.contentInset;
        _mainTableView.showsVerticalScrollIndicator = NO;
    }
    return _mainTableView;
}

-(UIView *)orderDetailsTableHeaderView{
    if (!_orderDetailsTableHeaderView) {
        _orderDetailsTableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth,78)];
        _orderDetailsTableHeaderView.backgroundColor = [UIColor clearColor];
        
        [_orderDetailsTableHeaderView addSubview:self.orderNumLabel];
        [_orderDetailsTableHeaderView addSubview:self.orderTimeLabel];
        [_orderDetailsTableHeaderView addSubview:self.copyBtn];
        
        self.orderNumLabel.sd_layout
        .topSpaceToView(_orderDetailsTableHeaderView, 20)
        .leftSpaceToView(_orderDetailsTableHeaderView, _kpw(20))
        .heightIs(20);
        [self.orderNumLabel setSingleLineAutoResizeWithMaxWidth:(kScreenWidth-_kpw(120))];
        
        self.copyBtn.sd_layout
        .centerYEqualToView(self.orderNumLabel)
        .leftSpaceToView(self.orderNumLabel, 6);
        [self.copyBtn setupAutoSizeWithHorizontalPadding:10 buttonHeight:20];
        
        self.orderTimeLabel.sd_layout
        .topSpaceToView(self.orderNumLabel, 8)
        .leftSpaceToView(_orderDetailsTableHeaderView, _kpw(20))
        .rightSpaceToView(_orderDetailsTableHeaderView, _kpw(20))
        .heightIs(20);
    }
    return _orderDetailsTableHeaderView;
}

-(UIButton *)copyBtn{
    if (!_copyBtn) {
        _copyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _copyBtn.titleLabel.font = HXFont(14);
        _copyBtn.backgroundColor = [UIColor clearColor];
        [_copyBtn setTitleColor:COLOR_WITH_ALPHA(0x59ABFE, 1) forState:UIControlStateNormal];
        [_copyBtn setTitle:@"复制" forState:UIControlStateNormal];
        [_copyBtn addTarget:self action:@selector(copyOrderNum:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _copyBtn;
}

-(UILabel *)orderNumLabel{
    if (!_orderNumLabel) {
        _orderNumLabel = [[UILabel alloc] init];
        _orderNumLabel.textAlignment = NSTextAlignmentLeft;
        _orderNumLabel.font = HXFont(14);
        _orderNumLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        
    }
    return _orderNumLabel;
}

-(UILabel *)orderTimeLabel{
    if (!_orderTimeLabel) {
        _orderTimeLabel = [[UILabel alloc] init];
        _orderTimeLabel.textAlignment = NSTextAlignmentLeft;
        _orderTimeLabel.font = HXFont(14);
        _orderTimeLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        
    }
    return _orderTimeLabel;
}

-(UIView *)orderDetailsTableFooterView{
    if (!_orderDetailsTableFooterView) {
        _orderDetailsTableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 150)];
        _orderDetailsTableFooterView.backgroundColor = [UIColor clearColor];
        [_orderDetailsTableFooterView addSubview:self.paymentMethodLabel];
        [_orderDetailsTableFooterView addSubview:self.paymentMethodContentLabel];
        [_orderDetailsTableFooterView addSubview:self.paymentTimeLabel];
        [_orderDetailsTableFooterView addSubview:self.paymentTimeContentLabel];
        [_orderDetailsTableFooterView addSubview:self.yingjiaoTotalLabel];
        [_orderDetailsTableFooterView addSubview:self.yingjiaoTotalMoneyLabel];
        [_orderDetailsTableFooterView addSubview:self.shiJiaoLabel];
        [_orderDetailsTableFooterView addSubview:self.shiJiaoMoneyLabel];
        [_orderDetailsTableFooterView addSubview:self.payBtn];
        
        self.paymentMethodLabel.sd_layout
        .topSpaceToView(_orderDetailsTableFooterView, 14)
        .leftSpaceToView(_orderDetailsTableFooterView, _kpw(30))
        .widthIs(110)
        .heightIs(20);
        
        self.paymentMethodContentLabel.sd_layout
        .centerYEqualToView(self.paymentMethodLabel)
        .leftSpaceToView(self.paymentMethodLabel, 5)
        .rightSpaceToView(_orderDetailsTableFooterView, _kpw(30))
        .heightRatioToView(self.paymentMethodLabel, 1);
        
        self.paymentTimeLabel.sd_layout
        .topSpaceToView(self.paymentMethodLabel, (self.flag == 1?0: 8))
        .leftEqualToView(self.paymentMethodLabel)
        .widthIs(110)
        .heightRatioToView(self.paymentMethodLabel, (self.flag == 1?0: 1));
        
        self.paymentTimeContentLabel.sd_layout
        .centerYEqualToView(self.paymentTimeLabel)
        .leftSpaceToView(self.paymentTimeLabel, 5)
        .rightEqualToView(self.paymentMethodContentLabel)
        .heightRatioToView(self.paymentMethodLabel, 1);
        
        self.yingjiaoTotalLabel.sd_layout
        .topSpaceToView(self.paymentTimeLabel, 8)
        .leftEqualToView(self.paymentMethodLabel)
        .widthIs(110)
        .heightRatioToView(self.paymentMethodLabel, 1);
        
        self.yingjiaoTotalMoneyLabel.sd_layout
        .centerYEqualToView(self.yingjiaoTotalLabel)
        .leftSpaceToView(self.yingjiaoTotalLabel, 5)
        .rightEqualToView(self.paymentMethodContentLabel)
        .heightRatioToView(self.paymentMethodLabel, 1);
        
        self.shiJiaoLabel.sd_layout
        .topSpaceToView(self.yingjiaoTotalLabel, 8)
        .leftEqualToView(self.paymentMethodLabel)
        .widthIs(110)
        .heightRatioToView(self.paymentMethodLabel, 1);
        
        self.shiJiaoMoneyLabel.sd_layout
        .centerYEqualToView(self.shiJiaoLabel)
        .leftSpaceToView(self.shiJiaoLabel, 5)
        .rightEqualToView(self.paymentMethodContentLabel)
        .heightRatioToView(self.paymentMethodLabel, 1);
        
        self.payBtn.sd_layout
        .topSpaceToView(self.shiJiaoLabel, 20)
        .leftSpaceToView(_orderDetailsTableFooterView, 10)
        .rightSpaceToView(_orderDetailsTableFooterView, 10)
        .heightIs(45);
        self.payBtn.sd_cornerRadius = @6;
        [self.payBtn updateLayout];
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.bounds = self.payBtn.bounds;
        gradientLayer.startPoint = CGPointMake(0, 0.5);
        gradientLayer.endPoint = CGPointMake(1, 0.5);
        gradientLayer.anchorPoint = CGPointMake(0, 0);
        NSArray *colorArr = @[(id)COLOR_WITH_ALPHA(0x4BA4FE, 1).CGColor,(id)COLOR_WITH_ALPHA(0x45EFCF, 1).CGColor];
        gradientLayer.colors = colorArr;
        [self.payBtn.layer insertSublayer:gradientLayer below:self.payBtn.titleLabel.layer];
        
    }
    return _orderDetailsTableFooterView;
}

-(UILabel *)paymentMethodLabel{
    if (!_paymentMethodLabel) {
        _paymentMethodLabel = [[UILabel alloc] init];
        _paymentMethodLabel.textAlignment = NSTextAlignmentLeft;
        _paymentMethodLabel.font = HXFont(14);
        _paymentMethodLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        _paymentMethodLabel.text = @"支付方式：";
    }
    return _paymentMethodLabel;
}

-(UILabel *)paymentMethodContentLabel{
    if (!_paymentMethodContentLabel) {
        _paymentMethodContentLabel = [[UILabel alloc] init];
        _paymentMethodContentLabel.textAlignment = NSTextAlignmentRight;
        _paymentMethodContentLabel.font = HXFont(14);
        _paymentMethodContentLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
    }
    return _paymentMethodContentLabel;
}

-(UILabel *)paymentTimeLabel{
    if (!_paymentTimeLabel) {
        _paymentTimeLabel = [[UILabel alloc] init];
        _paymentTimeLabel.textAlignment = NSTextAlignmentLeft;
        _paymentTimeLabel.font = HXFont(14);
        _paymentTimeLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        _paymentTimeLabel.text = @"支付时间：";
        _paymentTimeLabel.hidden = (self.flag == 1?YES:NO);
    }
    return _paymentTimeLabel;
}

-(UILabel *)paymentTimeContentLabel{
    if (!_paymentTimeContentLabel) {
        _paymentTimeContentLabel = [[UILabel alloc] init];
        _paymentTimeContentLabel.textAlignment = NSTextAlignmentRight;
        _paymentTimeContentLabel.font = HXFont(14);
        _paymentTimeContentLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        _paymentTimeContentLabel.hidden = (self.flag == 1?YES:NO);
    }
    return _paymentTimeContentLabel;
}

-(UILabel *)yingjiaoTotalLabel{
    if (!_yingjiaoTotalLabel) {
        _yingjiaoTotalLabel = [[UILabel alloc] init];
        _yingjiaoTotalLabel.textAlignment = NSTextAlignmentLeft;
        _yingjiaoTotalLabel.font = HXFont(14);
        _yingjiaoTotalLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        _yingjiaoTotalLabel.text = @"本次应缴总额：";
    }
    return _yingjiaoTotalLabel;
}

-(UILabel *)yingjiaoTotalMoneyLabel{
    if (!_yingjiaoTotalMoneyLabel) {
        _yingjiaoTotalMoneyLabel = [[UILabel alloc] init];
        _yingjiaoTotalMoneyLabel.textAlignment = NSTextAlignmentRight;
        _yingjiaoTotalMoneyLabel.font = HXFont(14);
        _yingjiaoTotalMoneyLabel.textColor = self.flag == 1?COLOR_WITH_ALPHA(0x59ABFE, 1):COLOR_WITH_ALPHA(0x2C2C2E, 1);
    }
    return _yingjiaoTotalMoneyLabel;
}


-(UILabel *)shiJiaoLabel{
    if (!_shiJiaoLabel) {
        _shiJiaoLabel = [[UILabel alloc] init];
        _shiJiaoLabel.textAlignment = NSTextAlignmentLeft;
        _shiJiaoLabel.font = HXFont(14);
        _shiJiaoLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        _shiJiaoLabel.text = @"实付金额：";
    }
    return _shiJiaoLabel;
}

-(UILabel *)shiJiaoMoneyLabel{
    if (!_shiJiaoMoneyLabel) {
        _shiJiaoMoneyLabel = [[UILabel alloc] init];
        _shiJiaoMoneyLabel.textAlignment = NSTextAlignmentRight;
        _shiJiaoMoneyLabel.font = HXFont(14);
        _shiJiaoMoneyLabel.textColor = self.flag == 1?COLOR_WITH_ALPHA(0xFE664B, 1):COLOR_WITH_ALPHA(0x2C2C2E, 1);
    }
    return _shiJiaoMoneyLabel;
}

-(UIButton *)payBtn{
    if (!_payBtn) {
        _payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _payBtn.titleLabel.font = HXFont(16);
        [_payBtn setTitle:@"确认并支付" forState:UIControlStateNormal];
        _payBtn.hidden = self.flag == 1?NO:YES;
        [_payBtn addTarget:self action:@selector(pushPaymentVC:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _payBtn;
}




-(HXNoDataTipView *)noDataTipView{
    if (!_noDataTipView) {
        _noDataTipView = [[HXNoDataTipView alloc] initWithFrame:self.mainTableView.frame];
        _noDataTipView.tipTitle = @"暂无数据~";
    }
    return _noDataTipView;
}

-(void)dealloc{
    
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
