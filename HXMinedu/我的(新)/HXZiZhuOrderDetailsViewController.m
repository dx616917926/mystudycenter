//
//  HXZiZhuOrderDetailsViewController.m
//  HXMinedu
//
//  Created by mac on 2021/12/8.
//

#import "HXZiZhuOrderDetailsViewController.h"
#import "HXOrderDetailsViewController.h"
#import "HXCommonWebViewController.h"
#import "HXZiZhuJiaoFeiViewController.h"
#import "HXZiZhuOrderDetailsViewController.h"
#import "HXFeeEditItemCell.h"
#import "HXNoDataTipView.h"
#import "YBPopupMenu.h"
#import "HXCommonSelectModel.h"


@interface HXZiZhuOrderDetailsViewController ()<UITableViewDelegate,UITableViewDataSource,YBPopupMenuDelegate>

//支付方式数据源
@property(nonatomic,strong) NSMutableArray *paymentMethodList;
@property(nonatomic,strong) NSMutableArray *paymentMethodTitles;
@property(nonatomic,strong) NSString *payModeId;
//支付类型数据源
@property(nonatomic,strong) NSMutableArray *paymentTypeList;
@property(nonatomic,strong) NSMutableArray *paymentTypeTitles;
@property(nonatomic,strong) NSString *payTypeId;

@property(strong,nonatomic) UITableView *mainTableView;

@property(strong,nonatomic) UIView *orderDetailsTableHeaderView;
@property(strong,nonatomic) UIButton *copyBtn;//复制
@property(nonatomic,strong) UILabel *orderNumLabel;//订单编号：
@property(nonatomic,strong) UILabel *orderTimeLabel;//订单时间：


@property(strong,nonatomic) UIView *orderDetailsTableFooterView;
@property(nonatomic,strong) UILabel *paymentMethodLabel;//支付方式：
@property(nonatomic,strong) UIButton *paymentMethodBtn;
@property(nonatomic,strong) UILabel *paymentTypeLabel;//支付类型：
@property(nonatomic,strong) UIButton *paymentTypeBtn;
@property(nonatomic,strong) UILabel *yingjiaoTotalLabel;//本次应缴合计：
@property(nonatomic,strong) UILabel *yingjiaoTotalMoneyLabel;
@property(nonatomic,strong) UILabel *xuJiaoNaLabel;//需缴款：
@property(nonatomic,strong) UILabel *xuJiaoNaMoneyLabel;

@property(strong,nonatomic) UIView *bottomView;
@property(strong,nonatomic) UIButton *preStepBtn;//上一步
@property(nonatomic,strong) UIButton *payBtn;//确认并支付

@property(nonatomic,strong) HXNoDataTipView *noDataTipView;



///全部订单数组
@property(nonatomic,strong) NSArray *paidDetailsList;


@end

@implementation HXZiZhuOrderDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //UI
    [self createUI];
    //获取支付方式
    [self getPayMode];
    //监听修改自助缴费本次实缴金额通知，计算本次应缴合计
    [HXNotificationCenter addObserver:self selector:@selector(changeZiZhuShiJiaoFeeNotification:) name:kChangeZiZhuShiJiaoFeeNotification object:nil];
}

-(void)dealloc{
    
    [HXNotificationCenter removeObserver:self];
}

#pragma mark -  获取支付方式
-(void)getPayMode{
    [HXBaseURLSessionManager postDataWithNSString:HXPOST_GetPayMode withDictionary:nil success:^(NSDictionary * _Nonnull dictionary) {
        [self.mainTableView.mj_header endRefreshing];
        BOOL success = [dictionary boolValueForKey:@"Success"];
        if (success) {
            [self.paymentMethodList removeAllObjects];
            NSArray *list = [HXCommonSelectModel mj_objectArrayWithKeyValuesArray:[dictionary objectForKey:@"Data"]];
            if (list.count>0) {
                [self.paymentMethodList addObjectsFromArray:list];
                [self.paymentMethodTitles removeAllObjects];
                [self.paymentMethodList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    HXCommonSelectModel *model = obj;
                    [self.paymentMethodTitles addObject:model.text];
                }];
                HXCommonSelectModel *payModel = self.paymentMethodList.firstObject;
                self.payModeId = payModel.value;
                [self.paymentMethodBtn setTitle:payModel.text forState:UIControlStateNormal];
                //获取支付类型
                [self getPayType:self.payModeId];
            }
            
        }
    } failure:^(NSError * _Nonnull error) {
       
    }];
}

#pragma mark -  获取支付类型
-(void)getPayType:(NSString *)paytype{
    NSDictionary *paramsDic = @{
        @"version_id":HXSafeString(self.paidDetailsInfoModel.version_id),
        @"major_id":HXSafeString(self.paidDetailsInfoModel.major_id),
        @"type":@(self.paidDetailsInfoModel.type),
        @"paytype":HXSafeString(paytype)
        
    };
    [HXBaseURLSessionManager postDataWithNSString:HXPOST_GetPayType withDictionary:paramsDic success:^(NSDictionary * _Nonnull dictionary) {
        [self.mainTableView.mj_header endRefreshing];
        BOOL success = [dictionary boolValueForKey:@"Success"];
        if (success) {
            [self.paymentTypeList removeAllObjects];
            NSArray *list = [HXCommonSelectModel mj_objectArrayWithKeyValuesArray:[dictionary objectForKey:@"Data"]];
            if (list.count>0) {
                [self.paymentTypeList addObjectsFromArray:list];
                [self.paymentTypeTitles removeAllObjects];
                [self.paymentTypeList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    HXCommonSelectModel *model = obj;
                    [self.paymentTypeTitles addObject:model.text];
                }];
                HXCommonSelectModel *payTypeModel = self.paymentTypeList.firstObject;
                self.payTypeId = payTypeModel.value;
                [self.paymentTypeBtn setTitle:payTypeModel.text forState:UIControlStateNormal];
            }
        }
    } failure:^(NSError * _Nonnull error) {
       
    }];
}

#pragma mark - 监听修改自助缴费本次实缴金额通知，计算应缴合计、需缴纳
-(void)changeZiZhuShiJiaoFeeNotification:(NSNotification *)notification{
    
    __block float payMoneyTotal = 0.0;
    [self.paidDetailsInfoModel.payableTypeList enumerateObjectsUsingBlock:^(HXPaymentDetailsInfoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        HXPaymentDetailsInfoModel *paymentDetailsInfoModel = obj;
        [paymentDetailsInfoModel.payableDetailsInfoList enumerateObjectsUsingBlock:^(HXPaymentDetailModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            payMoneyTotal += obj.payMoney;
        }];
    }];
    self.yingjiaoTotalMoneyLabel.text = [NSString stringWithFormat:@"¥%.2f",payMoneyTotal];
    self.xuJiaoNaMoneyLabel.text = [NSString stringWithFormat:@"¥%.2f",payMoneyTotal];
}

#pragma mark -刷新数据
-(void)refreshUI{
    
    if (self.paidDetailsInfoModel.payableTypeList.count == 0) {
        [self.view addSubview:self.noDataTipView];
    }else{
        [self.noDataTipView removeFromSuperview];
    }
    self.mainTableView.tableFooterView = self.orderDetailsTableFooterView;
    [self.mainTableView reloadData];
    
    self.orderNumLabel.text = [NSString stringWithFormat:@"订单编号：%@",HXSafeString(self.paidDetailsInfoModel.orderNum)];
    self.orderTimeLabel.text = [NSString stringWithFormat:@"订单时间：%@",HXSafeString(self.paidDetailsInfoModel.createDate)];
    //计算应缴合计、需缴纳
    __block float payMoneyTotal = 0.0;
    [self.paidDetailsInfoModel.payableTypeList enumerateObjectsUsingBlock:^(HXPaymentDetailsInfoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        HXPaymentDetailsInfoModel *paymentDetailsInfoModel = obj;
        [paymentDetailsInfoModel.payableDetailsInfoList enumerateObjectsUsingBlock:^(HXPaymentDetailModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            payMoneyTotal += obj.payMoney;
        }];
    }];
    self.yingjiaoTotalMoneyLabel.text = [NSString stringWithFormat:@"¥%.2f",payMoneyTotal];
    self.xuJiaoNaMoneyLabel.text = [NSString stringWithFormat:@"¥%.2f",payMoneyTotal];
}

#pragma mark - EVent

-(void)popBack:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)copyOrderNum:(UIButton *)sender{
    UIPasteboard *pastboard = [UIPasteboard generalPasteboard];
    [pastboard setString:HXSafeString(self.paidDetailsInfoModel.orderNum)];
    [self.view showTostWithMessage:@"复制成功"];
}
//支付方式
-(void)showPaymentMethodMenu:(UIButton *)sender{
    
    [YBPopupMenu showRelyOnView:sender titles:self.paymentMethodTitles icons:nil menuWidth:100 otherSettings:^(YBPopupMenu *popupMenu) {
        popupMenu.tag = 8888;
        popupMenu.itemHeight = 35;
        popupMenu.delegate = self;
        popupMenu.isShowShadow = NO;
    }];
}

//支付类型
-(void)showPaymentTypeMenu:(UIButton *)sender{
    
    [YBPopupMenu showRelyOnView:sender titles:self.paymentTypeTitles icons:nil menuWidth:100 otherSettings:^(YBPopupMenu *popupMenu) {
        popupMenu.tag = 9999;
        popupMenu.itemHeight = 35;
        popupMenu.delegate = self;
        popupMenu.isShowShadow = NO;
    }];
}

-(void)pushPaymentVC:(UIButton *)sender{
    
     __block NSMutableArray *ordrInfoArr = [NSMutableArray array];
    [self.paidDetailsInfoModel.payableTypeList enumerateObjectsUsingBlock:^(HXPaymentDetailsInfoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        HXPaymentDetailsInfoModel *paymentDetailsInfoModel = obj;
        [paymentDetailsInfoModel.payableDetailsInfoList enumerateObjectsUsingBlock:^(HXPaymentDetailModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSMutableDictionary *orderDic = [NSMutableDictionary dictionary];
            HXPaymentDetailModel *paymentDetailModel = obj;
            [orderDic setObject:HXSafeString(paymentDetailModel.enrollFeeId) forKey:@"id"];
            [orderDic setObject:@(paymentDetailModel.fee) forKey:@"fee"];
            [orderDic setObject:@(paymentDetailModel.payMoney) forKey:@"inputMoney"];
            [orderDic setObject:HXSafeString(paymentDetailsInfoModel.ftypeName) forKey:@"ftype"];
            [ordrInfoArr addObject:orderDic];
        }];
    }];
    
    NSDictionary *paramsDic = @{
        @"version_id":HXSafeString(self.paidDetailsInfoModel.version_id),
        @"major_id":HXSafeString(self.paidDetailsInfoModel.major_id),
        @"type":@(self.paidDetailsInfoModel.type),
        @"PayMode_id":HXSafeString(self.payModeId),
        @"PayType_id":HXSafeString(self.payTypeId),
        @"ordrInfoArr":ordrInfoArr
    };
    NSLog(@"%@",paramsDic);
    [HXBaseURLSessionManager postDataWithNSString:HXPOST_SaveStuPay withDictionary:paramsDic success:^(NSDictionary * _Nonnull dictionary) {
        
        BOOL success = [dictionary boolValueForKey:@"Success"];
        if (success) {
            HXOrderDetailsViewController *orderDetailsVC = [[HXOrderDetailsViewController alloc] init];
            orderDetailsVC.orderNum = [dictionary stringValueForKey:@"Data"];
            //flag:1.待支付订单详情   2.已支付订单详情
            orderDetailsVC.flag = 1;
            [self.navigationController pushViewController:orderDetailsVC animated:YES];
            //返回全部订单页面，刷新数据
            __block NSMutableArray *tempArray = [NSMutableArray array];
            NSMutableArray *navs = [NSMutableArray array];
            [navs addObjectsFromArray:self.navigationController.viewControllers];
            [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:[HXZiZhuJiaoFeiViewController class]]||[obj isKindOfClass:[HXZiZhuOrderDetailsViewController class]]) {
                    [tempArray addObject:obj];
                }
            }];
            [navs removeObjectsInArray:tempArray];
            self.navigationController.viewControllers = navs;
        }
    } failure:^(NSError * _Nonnull error) {
        

    }];
    
    
}

#pragma mark - 布局子视图
-(void)createUI{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.sc_navigationBar.title = @"订单详情";
    [self.view addSubview:self.mainTableView];
    [self.view addSubview:self.bottomView];
    [self.bottomView addSubview:self.preStepBtn];
    [self.bottomView addSubview:self.payBtn];
    
    self.bottomView.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomEqualToView(self.view)
    .heightIs(70+kScreenBottomMargin);
    
    self.preStepBtn.sd_layout
    .topSpaceToView(self.bottomView, 5)
    .leftSpaceToView(self.bottomView, 15)
    .widthIs(_kpw(160))
    .heightIs(50);
    self.preStepBtn.sd_cornerRadius = @6;
    
    self.payBtn.sd_layout
    .centerYEqualToView(self.preStepBtn)
    .rightSpaceToView(self.bottomView, 15)
    .widthRatioToView(self.preStepBtn, 1)
    .heightRatioToView(self.preStepBtn, 1);
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
    
    self.mainTableView.sd_layout
    .topSpaceToView(self.view, kNavigationBarHeight)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomSpaceToView(self.bottomView, 0);
    
    
    [self refreshUI];
    
    
    
}

#pragma mark - <YBPopupMenuDelegate>
- (void)ybPopupMenu:(YBPopupMenu *)ybPopupMenu didSelectedAtIndex:(NSInteger)index{
    
    if (ybPopupMenu.tag == 8888) {//支付方式
        HXCommonSelectModel *model = self.paymentMethodList[index];
        [self.paymentMethodBtn setTitle:model.text forState:UIControlStateNormal];
        self.payModeId = model.value;
        [self getPayType:self.payModeId];
        
    }else if (ybPopupMenu.tag == 9999) {//支付类型
        HXCommonSelectModel *model = self.paymentTypeList[index];
        [self.paymentTypeBtn setTitle:model.text forState:UIControlStateNormal];
        self.payTypeId = model.value;
    }
    
}

#pragma mark - <UITableViewDelegate,UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.paidDetailsInfoModel.payableTypeList.count;
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
    return 16;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    HXPaymentDetailsInfoModel *paymentDetailsInfoModel = self.paidDetailsInfoModel.payableTypeList[indexPath.section];
    CGFloat rowHeight = [tableView cellHeightForIndexPath:indexPath
                                                    model:paymentDetailsInfoModel keyPath:@"paymentDetailsInfoModel"
                                                cellClass:([HXFeeEditItemCell class])
                                         contentViewWidth:kScreenWidth];
    return rowHeight;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *feeEditItemCellIdentifier = @"HXFeeEditItemCellIdentifier";
    HXFeeEditItemCell *cell = [tableView dequeueReusableCellWithIdentifier:feeEditItemCellIdentifier];
    if (!cell) {
        cell = [[HXFeeEditItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:feeEditItemCellIdentifier];
    }
  
    HXPaymentDetailsInfoModel *paymentDetailsInfoModel = self.paidDetailsInfoModel.payableTypeList[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    cell.paymentDetailsInfoModel = paymentDetailsInfoModel;
    return cell;
}



#pragma mark -Setter
-(void)setPaidDetailsInfoModel:(HXPaymentModel *)paidDetailsInfoModel{
    _paidDetailsInfoModel = paidDetailsInfoModel;
}

#pragma mark - lazyLoad
-(NSMutableArray *)paymentMethodList{
    if (!_paymentMethodList) {
        _paymentMethodList = [NSMutableArray array];
    }
    return _paymentMethodList;
}

-(NSMutableArray *)paymentMethodTitles{
    if (!_paymentMethodTitles) {
        _paymentMethodTitles = [NSMutableArray array];
    }
    return _paymentMethodTitles;
}

-(NSMutableArray *)paymentTypeList{
    if (!_paymentTypeList) {
        _paymentTypeList = [NSMutableArray array];
    }
    return _paymentTypeList;
}

-(NSMutableArray *)paymentTypeTitles{
    if (!_paymentTypeTitles) {
        _paymentTypeTitles = [NSMutableArray array];
    }
    return _paymentTypeTitles;
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
        _orderDetailsTableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 190)];
        _orderDetailsTableFooterView.backgroundColor = [UIColor clearColor];
        [_orderDetailsTableFooterView addSubview:self.paymentMethodLabel];
        [_orderDetailsTableFooterView addSubview:self.paymentMethodBtn];
        [_orderDetailsTableFooterView addSubview:self.paymentTypeLabel];
        [_orderDetailsTableFooterView addSubview:self.paymentTypeBtn];
        [_orderDetailsTableFooterView addSubview:self.yingjiaoTotalLabel];
        [_orderDetailsTableFooterView addSubview:self.yingjiaoTotalMoneyLabel];
        [_orderDetailsTableFooterView addSubview:self.xuJiaoNaLabel];
        [_orderDetailsTableFooterView addSubview:self.xuJiaoNaMoneyLabel];
   
        //支付方式
        self.paymentMethodLabel.sd_layout
        .topSpaceToView(_orderDetailsTableFooterView, 20)
        .leftSpaceToView(_orderDetailsTableFooterView, 10)
        .heightIs(18);
        [self.paymentMethodLabel setSingleLineAutoResizeWithMaxWidth:120];
        
       
        
        self.paymentMethodBtn.sd_layout
        .centerYEqualToView(self.paymentMethodLabel)
        .rightSpaceToView(_orderDetailsTableFooterView, 10)
        .heightIs(26)
        .widthIs(100);
        self.paymentMethodBtn.sd_cornerRadius = @4;
        
        self.paymentMethodBtn.imageView.sd_layout
        .rightSpaceToView(self.paymentMethodBtn, 5)
        .centerYEqualToView(self.paymentMethodBtn)
        .heightIs(6)
        .widthIs(8);
        
        self.paymentMethodBtn.titleLabel.sd_layout
        .centerYEqualToView(self.paymentMethodBtn)
        .leftSpaceToView(self.paymentMethodBtn, 5)
        .rightSpaceToView(self.paymentMethodBtn.imageView, 0)
        .heightIs(20);
        
        
        //支付类型
        self.paymentTypeLabel.sd_layout
        .topSpaceToView(self.paymentMethodLabel, 17)
        .leftEqualToView(self.paymentMethodLabel)
        .heightRatioToView(self.paymentMethodLabel, 1);
        [self.paymentTypeLabel setSingleLineAutoResizeWithMaxWidth:120];
        
      
        self.paymentTypeBtn.sd_layout
        .centerYEqualToView(self.paymentTypeLabel)
        .rightEqualToView(self.paymentMethodBtn)
        .heightIs(26)
        .widthIs(100);
        self.paymentTypeBtn.sd_cornerRadius = @4;
        
        self.paymentTypeBtn.imageView.sd_layout
        .rightSpaceToView(self.paymentTypeBtn, 5)
        .centerYEqualToView(self.paymentTypeBtn)
        .heightIs(6)
        .widthIs(8);
        
        self.paymentTypeBtn.titleLabel.sd_layout
        .centerYEqualToView(self.paymentTypeBtn)
        .leftSpaceToView(self.paymentTypeBtn, 5)
        .rightSpaceToView(self.paymentTypeBtn.imageView, 0)
        .heightIs(20);
        
        
        self.yingjiaoTotalLabel.sd_layout
        .topSpaceToView(self.paymentTypeLabel, 17)
        .leftEqualToView(self.paymentMethodLabel)
        .heightRatioToView(self.paymentMethodLabel, 1);
        [self.yingjiaoTotalLabel setSingleLineAutoResizeWithMaxWidth:160];
        
        self.yingjiaoTotalMoneyLabel.sd_layout
        .centerYEqualToView(self.yingjiaoTotalLabel)
        .rightSpaceToView(_orderDetailsTableFooterView, 42)
        .heightIs(22);
        
        self.xuJiaoNaMoneyLabel.sd_layout
        .topSpaceToView(self.yingjiaoTotalMoneyLabel, 20)
        .rightEqualToView(self.yingjiaoTotalMoneyLabel)
        .heightIs(22);
        [self.xuJiaoNaMoneyLabel setSingleLineAutoResizeWithMaxWidth:150];
        
        self.xuJiaoNaLabel.sd_layout
        .centerYEqualToView(self.xuJiaoNaMoneyLabel)
        .rightSpaceToView(self.xuJiaoNaMoneyLabel, 0)
        .heightIs(18);
        [self.xuJiaoNaMoneyLabel setSingleLineAutoResizeWithMaxWidth:100];
       
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

-(UIButton *)paymentMethodBtn{
    if (!_paymentMethodBtn) {
        _paymentMethodBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _paymentMethodBtn.layer.borderWidth = 1;
        _paymentMethodBtn.layer.borderColor = COLOR_WITH_ALPHA(0x5699FF, 1).CGColor;
        _paymentMethodBtn.backgroundColor = [UIColor clearColor];
        _paymentMethodBtn.titleLabel.font = HXFont(14);
        _paymentMethodBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_paymentMethodBtn setTitleColor:COLOR_WITH_ALPHA(0x5699FF, 1) forState:UIControlStateNormal];
        [_paymentMethodBtn setImage:[UIImage imageNamed:@"bluetriangle_icon"] forState:UIControlStateNormal];
        [_paymentMethodBtn addTarget:self action:@selector(showPaymentMethodMenu:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _paymentMethodBtn;
}

-(UILabel *)paymentTypeLabel{
    if (!_paymentTypeLabel) {
        _paymentTypeLabel = [[UILabel alloc] init];
        _paymentTypeLabel.textAlignment = NSTextAlignmentLeft;
        _paymentTypeLabel.font = HXFont(14);
        _paymentTypeLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        _paymentTypeLabel.text = @"支付类型：";
    }
    return _paymentTypeLabel;
}

-(UIButton *)paymentTypeBtn{
    if (!_paymentTypeBtn) {
        _paymentTypeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _paymentTypeBtn.layer.borderWidth = 1;
        _paymentTypeBtn.layer.borderColor = COLOR_WITH_ALPHA(0x5699FF, 1).CGColor;
        _paymentTypeBtn.backgroundColor = [UIColor clearColor];
        _paymentTypeBtn.titleLabel.font = HXFont(14);
        _paymentTypeBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_paymentTypeBtn setTitleColor:COLOR_WITH_ALPHA(0x5699FF, 1) forState:UIControlStateNormal];
        [_paymentTypeBtn setImage:[UIImage imageNamed:@"bluetriangle_icon"] forState:UIControlStateNormal];
        [_paymentTypeBtn addTarget:self action:@selector(showPaymentTypeMenu:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _paymentTypeBtn;
}



-(UILabel *)yingjiaoTotalLabel{
    if (!_yingjiaoTotalLabel) {
        _yingjiaoTotalLabel = [[UILabel alloc] init];
        _yingjiaoTotalLabel.textAlignment = NSTextAlignmentLeft;
        _yingjiaoTotalLabel.font = HXFont(14);
        _yingjiaoTotalLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        _yingjiaoTotalLabel.text = @"本次应缴合计：";
    }
    return _yingjiaoTotalLabel;
}

-(UILabel *)yingjiaoTotalMoneyLabel{
    if (!_yingjiaoTotalMoneyLabel) {
        _yingjiaoTotalMoneyLabel = [[UILabel alloc] init];
        _yingjiaoTotalMoneyLabel.textAlignment = NSTextAlignmentRight;
        _yingjiaoTotalMoneyLabel.font = HXBoldFont(16);
        _yingjiaoTotalMoneyLabel.textColor = COLOR_WITH_ALPHA(0x5699FF, 1);
    }
    return _yingjiaoTotalMoneyLabel;
}


-(UILabel *)xuJiaoNaLabel{
    if (!_xuJiaoNaLabel) {
        _xuJiaoNaLabel = [[UILabel alloc] init];
        _xuJiaoNaLabel.textAlignment = NSTextAlignmentRight;
        _xuJiaoNaLabel.font = HXFont(14);
        _xuJiaoNaLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        _xuJiaoNaLabel.text = @"需缴款：";
    }
    return _xuJiaoNaLabel;
}

-(UILabel *)xuJiaoNaMoneyLabel{
    if (!_xuJiaoNaMoneyLabel) {
        _xuJiaoNaMoneyLabel = [[UILabel alloc] init];
        _xuJiaoNaMoneyLabel.textAlignment = NSTextAlignmentRight;
        _xuJiaoNaMoneyLabel.font =  HXBoldFont(16);
        _xuJiaoNaMoneyLabel.textColor = COLOR_WITH_ALPHA(0xFF5722, 1);
    }
    return _xuJiaoNaMoneyLabel;
}

-(UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = UIColor.whiteColor;
    }
    return _bottomView;
}

-(UIButton *)preStepBtn{
    if (!_preStepBtn) {
        _preStepBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _preStepBtn.backgroundColor = COLOR_WITH_ALPHA(0xE8E8E8, 1);
        _preStepBtn.titleLabel.font = HXFont(16);
        [_preStepBtn setTitleColor:COLOR_WITH_ALPHA(0x5D5D63, 1) forState:UIControlStateNormal];
        [_preStepBtn setTitle:@"上一步" forState:UIControlStateNormal];
        [_preStepBtn addTarget:self action:@selector(popBack:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _preStepBtn;
}

-(UIButton *)payBtn{
    if (!_payBtn) {
        _payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _payBtn.titleLabel.font = HXFont(16);
        [_payBtn setTitleColor:COLOR_WITH_ALPHA(0xffffff, 1) forState:UIControlStateNormal];
        [_payBtn setTitle:@"确认并支付" forState:UIControlStateNormal];
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

