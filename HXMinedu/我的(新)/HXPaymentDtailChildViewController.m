//
//  HXPaymentDtailChildViewController.m
//  HXMinedu
//
//  Created by mac on 2021/4/8.
//

#import "HXPaymentDtailChildViewController.h"
#import "HXOrderDetailsViewController.h"
#import "HXVoucherViewController.h"
#import "HXPaymentDetailCell.h"
#import "HXYingJiaoCell.h"
#import "HXPaidDetailCell.h"
#import "HXUnPaidDetailCell.h"
#import "HXNoDataTipView.h"
#import "HXPaymentModel.h"
#import "MJRefresh.h"


@interface HXPaymentDtailChildViewController ()<UITableViewDelegate,UITableViewDataSource,HXPaidDetailCellDelegate>

@property(strong,nonatomic) UITableView *mainTableView;
@property(strong,nonatomic) UIView *paymentDtailTableHeaderView;
@property(strong,nonatomic) UIView *bigContainerView;
@property(nonatomic,strong) UILabel *yingJiaoLabel;//应缴合计
@property(nonatomic,strong) UILabel *yingJiaoMoneyLabel;
@property(nonatomic,strong) UILabel *shiJiaoLabel;//实缴合计
@property(nonatomic,strong) UILabel *shiJiaoMoneyLabel;

@property(nonatomic,strong) HXNoDataTipView *noDataTipView;

//应缴模型
@property(nonatomic,strong) HXPaymentModel *yinJiaopaymentModel;

///全部订单数组
@property(nonatomic,strong) NSArray *paidDetailsList;


@end

@implementation HXPaymentDtailChildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
    
    if (self.flag == 1) {
        //获取应缴明细
        [self getPayableDetails];
    }else{
        //获取全部订单
        [self getPaidDetailsList];
    }
    //监听支付截图上传成功通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getPaidDetailsList) name:@"ZhiFuImageUploadSuccessNotification" object:nil];
}

#pragma mark - 下拉刷新
-(void)loadNewData{
    if (self.flag == 1) {
        //获取应缴明细
        [self getPayableDetails];
    }else{
        //获取全部订单
        [self getPaidDetailsList];
    }
}

#pragma mark -  获取应缴明细
-(void)getPayableDetails{
    HXMajorModel *selectMajorModel = [HXPublicParamTool sharedInstance].selectMajorModel;
    NSDictionary *dic = @{
        @"version_id":HXSafeString(selectMajorModel.versionId),
        @"major_id":HXSafeString(selectMajorModel.major_id),
        @"type":@(selectMajorModel.type),
    };
    
    [HXBaseURLSessionManager postDataWithNSString:HXPOST_Get_PayableDetails withDictionary:dic success:^(NSDictionary * _Nonnull dictionary) {
        [self.mainTableView.mj_header endRefreshing];
        BOOL success = [dictionary boolValueForKey:@"Success"];
        if (success) {
            //刷新数据
            self.yinJiaopaymentModel = [HXPaymentModel mj_objectWithKeyValues:[dictionary objectForKey:@"Data"]];
            self.yingJiaoMoneyLabel.text = [NSString stringWithFormat:@"¥%.2f",self.yinJiaopaymentModel.feeTotal];
            self.shiJiaoMoneyLabel.text = [NSString stringWithFormat:@"¥%.2f",self.yinJiaopaymentModel.payMoneyTotal];
            if (self.yinJiaopaymentModel.payableTypeList.count == 0) {
                [self.view addSubview:self.noDataTipView];
            }else{
                [self.noDataTipView removeFromSuperview];
            }
            if (self.flag == 1) {
                self.mainTableView.tableHeaderView = self.paymentDtailTableHeaderView;
            }else{
                self.mainTableView.tableHeaderView = nil;
            }
            [self.mainTableView reloadData];
        }
    } failure:^(NSError * _Nonnull error) {
        [self.mainTableView.mj_header endRefreshing];

    }];
}

#pragma mark -  获取全部订单
-(void)getPaidDetailsList{
    HXMajorModel *selectMajorModel = [HXPublicParamTool sharedInstance].selectMajorModel;
    NSDictionary *dic = @{
        @"version_id":HXSafeString(selectMajorModel.versionId),
        @"major_id":HXSafeString(selectMajorModel.major_id),
        @"type":@(selectMajorModel.type),
    };

    [HXBaseURLSessionManager postDataWithNSString:HXPOST_Get_PaidDetails withDictionary:dic success:^(NSDictionary * _Nonnull dictionary) {
        [self.mainTableView.mj_header endRefreshing];
        BOOL success = [dictionary boolValueForKey:@"Success"];
        if (success) {
            self.paidDetailsList = [HXPaymentDetailModel mj_objectArrayWithKeyValuesArray:[dictionary objectForKey:@"Data"]];
            if (self.paidDetailsList.count == 0) {
                [self.view addSubview:self.noDataTipView];
            }else{
                [self.noDataTipView removeFromSuperview];
            }
            [self.mainTableView reloadData];
        }
    } failure:^(NSError * _Nonnull error) {
        [self.mainTableView.mj_header endRefreshing];
    }];
}

#pragma mark - 布局子视图
-(void)createUI{
    [self.view addSubview:self.mainTableView];
    
    // 下拉刷新
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    header.automaticallyChangeAlpha = YES;
    self.mainTableView.mj_header = header;
    
   
}

#pragma mark - <HXPaidDetailCellDelegate>
-(void)paidDetailCell:(HXPaidDetailCell *)cell checkVoucher:(NSString *)receiptUrl orderStatus:(NSInteger)orderStatus{
    HXVoucherViewController *voucherVc = [[HXVoucherViewController alloc] init];
    voucherVc.downLoadUrl = receiptUrl;
    voucherVc.orderStatus = orderStatus;
    //-1 已支付待确认 1-已完成 0-未完成
    [self.navigationController pushViewController:voucherVc animated:YES];
}

#pragma mark - <UITableViewDelegate,UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.flag == 1){
        return self.yinJiaopaymentModel.payableTypeList.count;
    }else{
        return self.paidDetailsList.count;
    }
    
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
    return self.flag == 1?10:16;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
     if(self.flag == 1){
        HXPaymentDetailsInfoModel *paymentDetailsInfoModel = self.yinJiaopaymentModel.payableTypeList[indexPath.section];
        return 90+paymentDetailsInfoModel.payableDetailsInfoList.count*40;
//         CGFloat rowHeight = [tableView cellHeightForIndexPath:indexPath
//                                                              model:paymentDetailsInfoModel keyPath:@"paymentDetailsInfoModel"
//                                                          cellClass:([HXYingJiaoCell class])
//                                                   contentViewWidth:kScreenWidth];
//
//
//         return rowHeight;

    }else{
        HXPaymentDetailModel *paymentDetailModel = self.paidDetailsList[indexPath.section];
        //-1已支付待确认 1-已完成 0-未完成
        if (paymentDetailModel.orderStatus == 0) {
            return 250;
        }else{
            return 274;
        }
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.flag == 1) {
        static NSString *yingJiaoCellIdentifier = @"HXYingJiaoCellIdentifier";
        HXYingJiaoCell *cell = [tableView dequeueReusableCellWithIdentifier:yingJiaoCellIdentifier];
        if (!cell) {
            cell = [[HXYingJiaoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:yingJiaoCellIdentifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.showType = HXYingJiaoShowType;
        [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
        HXPaymentDetailsInfoModel *paymentDetailsInfoModel = self.yinJiaopaymentModel.payableTypeList[indexPath.section];
        cell.paymentDetailsInfoModel = paymentDetailsInfoModel;
        return cell;
    }else{
        HXPaymentDetailModel *paymentDetailModel = self.paidDetailsList[indexPath.section];
        //订单类型  -1已支付待确认  1-已完成  0-未完成
        if (paymentDetailModel.orderStatus == 0) {
            static NSString *unPaidDetailCelldentifier = @"HXUnPaidDetailCellIdentifier";
            HXUnPaidDetailCell *unPaidCell = [tableView dequeueReusableCellWithIdentifier:unPaidDetailCelldentifier];
            if (!unPaidCell) {
                unPaidCell = [[HXUnPaidDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:unPaidDetailCelldentifier];
            }
            unPaidCell.selectionStyle = UITableViewCellSelectionStyleNone;
            unPaidCell.paymentDetailModel = paymentDetailModel;
            return unPaidCell;
        }else{
            static NSString *paidDetailCellIdentifier = @"HXPaidDetailCellIdentifier";
            HXPaidDetailCell *paidCell = [tableView dequeueReusableCellWithIdentifier:paidDetailCellIdentifier];
            if (!paidCell) {
                paidCell = [[HXPaidDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:paidDetailCellIdentifier];
            }
            paidCell.selectionStyle = UITableViewCellSelectionStyleNone;
            paidCell.delegate = self;
            paidCell.paymentDetailModel = paymentDetailModel;
            return paidCell;
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (self.flag == 2) {
        HXPaymentDetailModel *paymentDetailModel = self.paidDetailsList[indexPath.section];
        HXOrderDetailsViewController *orderDetailsVC = [[HXOrderDetailsViewController alloc] init];
        orderDetailsVC.orderNum = paymentDetailModel.orderNum;
        //订单类型  -1已支付待确认  1-已完成  0-未完成
        if (paymentDetailModel.orderStatus == 0) {
            orderDetailsVC.flag = 1;
        }else{
            orderDetailsVC.flag = 2;
        }
        [self.navigationController pushViewController:orderDetailsVC animated:YES];
    }
}


#pragma mark - lazyLoad

-(void)setFlag:(NSInteger)flag{
    _flag = flag;
}

-(UITableView *)mainTableView{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kNavigationBarHeight-58) style:UITableViewStylePlain];
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

-(UIView *)paymentDtailTableHeaderView{
    if (!_paymentDtailTableHeaderView) {
        _paymentDtailTableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 82)];
        _paymentDtailTableHeaderView.backgroundColor = [UIColor clearColor];
        [_paymentDtailTableHeaderView addSubview:self.bigContainerView];
        [self.bigContainerView addSubview:self.yingJiaoLabel];
        [self.bigContainerView addSubview:self.yingJiaoMoneyLabel];
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = COLOR_WITH_ALPHA(0x979797, 1);
        [self.bigContainerView addSubview:line];
        [self.bigContainerView addSubview:self.shiJiaoLabel];
        [self.bigContainerView addSubview:self.shiJiaoMoneyLabel];
        
        self.bigContainerView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(10, 10, 10, 10));
        self.bigContainerView.sd_cornerRadius = @4;
        
        line.sd_layout
        .centerXEqualToView(self.bigContainerView)
        .centerYEqualToView(self.bigContainerView)
        .widthIs(1)
        .heightIs(30);
        
        self.yingJiaoLabel.sd_layout
        .topSpaceToView(self.bigContainerView, 14)
        .leftSpaceToView(self.bigContainerView, 5)
        .rightSpaceToView(line, 5)
        .heightIs(17);
        
         self.yingJiaoMoneyLabel.sd_layout
         .topSpaceToView(self.yingJiaoLabel, 3)
         .leftSpaceToView(self.bigContainerView, 5)
         .rightSpaceToView(line, 5)
         .heightIs(20);
        
         self.shiJiaoLabel.sd_layout
         .centerYEqualToView(self.yingJiaoLabel)
         .rightSpaceToView(self.bigContainerView, 5)
         .leftSpaceToView(line, 5)
         .heightIs(17);
         
          self.shiJiaoMoneyLabel.sd_layout
          .centerYEqualToView(self.yingJiaoMoneyLabel)
          .rightSpaceToView(self.bigContainerView, 5)
          .leftSpaceToView(line, 5)
          .heightIs(20);
        
    }
    return _paymentDtailTableHeaderView;
}

-(UIView *)bigContainerView{
    if (!_bigContainerView) {
        _bigContainerView = [[UIView alloc] init];
        _bigContainerView.backgroundColor = [UIColor whiteColor];
    }
    return _bigContainerView;
}

-(UILabel *)yingJiaoLabel{
    if (!_yingJiaoLabel) {
        _yingJiaoLabel = [[UILabel alloc] init];
        _yingJiaoLabel.textAlignment = NSTextAlignmentCenter;
        _yingJiaoLabel.font = HXFont(12);
        _yingJiaoLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        _yingJiaoLabel.text = @"应缴合计";
    }
    return _yingJiaoLabel;
}

-(UILabel *)yingJiaoMoneyLabel{
    if (!_yingJiaoMoneyLabel) {
        _yingJiaoMoneyLabel = [[UILabel alloc] init];
        _yingJiaoMoneyLabel.textAlignment = NSTextAlignmentCenter;
        _yingJiaoMoneyLabel.font = HXFont(12);
        _yingJiaoMoneyLabel.textColor = COLOR_WITH_ALPHA(0x5699FF, 1);
    }
    return _yingJiaoMoneyLabel;
}



-(UILabel *)shiJiaoLabel{
    if (!_shiJiaoLabel) {
        _shiJiaoLabel = [[UILabel alloc] init];
        _shiJiaoLabel.textAlignment = NSTextAlignmentCenter;
        _shiJiaoLabel.font = HXFont(12);
        _shiJiaoLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        _shiJiaoLabel.text = @"实缴合计";
    }
    return _shiJiaoLabel;
}

-(UILabel *)shiJiaoMoneyLabel{
    if (!_shiJiaoMoneyLabel) {
        _shiJiaoMoneyLabel = [[UILabel alloc] init];
        _shiJiaoMoneyLabel.textAlignment = NSTextAlignmentCenter;
        _shiJiaoMoneyLabel.font = HXFont(12);
        _shiJiaoMoneyLabel.textColor = COLOR_WITH_ALPHA(0xFE664B, 1);
    }
    return _shiJiaoMoneyLabel;
}






-(HXNoDataTipView *)noDataTipView{
    if (!_noDataTipView) {
        _noDataTipView = [[HXNoDataTipView alloc] initWithFrame:self.mainTableView.bounds];
        _noDataTipView.tipTitle = @"暂无数据~";
    }
    return _noDataTipView;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
