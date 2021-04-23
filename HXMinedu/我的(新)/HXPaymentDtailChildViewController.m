//
//  HXPaymentDtailChildViewController.m
//  HXMinedu
//
//  Created by mac on 2021/4/8.
//

#import "HXPaymentDtailChildViewController.h"
#import "HXPaymentDetailCell.h"
#import "HXPaidDetailCell.h"
#import "HXUnPaidDetailCell.h"
#import "HXNoDataTipView.h"
#import "HXPaymentModel.h"
#import "MJRefresh.h"

@interface HXPaymentDtailChildViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(strong,nonatomic) UITableView *mainTableView;
@property(strong,nonatomic) UIView *paymentDtailTableFooterView;
@property(nonatomic,strong) UILabel *totalPriceLabel;//总价
@property(nonatomic,strong) UILabel *heJiPriceLabel;//合计
@property(nonatomic,strong) HXNoDataTipView *noDataTipView;

//应缴模型
@property(nonatomic,strong) HXPaymentModel *yinJiaopaymentModel;
//未缴模型
@property(nonatomic,strong) HXPaymentModel *weiJiaopaymentModel;
//已缴费数组
@property(nonatomic,strong) NSArray *paidDetailsList;

@end

@implementation HXPaymentDtailChildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
    
    if (self.flag == 2) {
        //获取已缴明细
        [self getPaidDetails];
    }else{
        //获取应缴和未缴明细
        [self getPayableAndUnpaidDetails];
    }
}

#pragma mark - 下拉刷新
-(void)loadNewData{
    if (self.flag == 2) {
        //获取已缴明细
        [self getPaidDetails];
    }else{
        //获取应缴和未缴明细
        [self getPayableAndUnpaidDetails];
    }
}

#pragma mark -  获取应缴和未缴明细
-(void)getPayableAndUnpaidDetails{
    HXMajorModel *selectMajorModel = [HXPublicParamTool sharedInstance].selectMajorModel;
    NSDictionary *dic = @{
        @"version_id":HXSafeString(selectMajorModel.versionId),
        @"major_id":HXSafeString(selectMajorModel.major_id),
        @"type":@(selectMajorModel.type),
        @"payStatus":(self.flag == 1?@"-1":@"1"),
    };
    
    [HXBaseURLSessionManager postDataWithNSString:HXPOST_Get_PayableAndUnpaidDetails withDictionary:dic success:^(NSDictionary * _Nonnull dictionary) {
        [self.mainTableView.mj_header endRefreshing];
        BOOL success = [dictionary boolValueForKey:@"Success"];
        if (success) {
            //刷新数据
            if (self.flag == 1) {
                self.yinJiaopaymentModel = [HXPaymentModel mj_objectWithKeyValues:[dictionary objectForKey:@"Data"]];
                self.totalPriceLabel.text = [NSString stringWithFormat:@"¥%.2f",self.yinJiaopaymentModel.total];
                if (self.yinJiaopaymentModel.payableAndUnpaidDetailsInfoList.count == 0) {
                    [self.view addSubview:self.noDataTipView];
                }else{
                    [self.noDataTipView removeFromSuperview];
                }
            }else if (self.flag == 3){
                self.weiJiaopaymentModel = [HXPaymentModel mj_objectWithKeyValues:[dictionary objectForKey:@"Data"]];
                self.totalPriceLabel.text = [NSString stringWithFormat:@"¥%.2f",self.weiJiaopaymentModel.total];
                if (self.weiJiaopaymentModel.payableAndUnpaidDetailsInfoList.count == 0) {
                    [self.view addSubview:self.noDataTipView];
                }else{
                    [self.noDataTipView removeFromSuperview];
                }
            }
            [self.mainTableView reloadData];
        }else{
            [self.view showErrorWithMessage:[dictionary stringValueForKey:@"Message"]];
        }
    } failure:^(NSError * _Nonnull error) {
        [self.mainTableView.mj_header endRefreshing];
    }];
}

#pragma mark -  获取已缴明细
-(void)getPaidDetails{
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
            [self.mainTableView reloadData];
            if (self.paidDetailsList.count == 0) {
                [self.view addSubview:self.noDataTipView];
            }else{
                [self.noDataTipView removeFromSuperview];
            }
        }else{
            [self.view showErrorWithMessage:[dictionary stringValueForKey:@"Message"]];
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
    
    if (self.flag == 1 || self.flag == 3) {
        self.mainTableView.tableFooterView = self.paymentDtailTableFooterView;
    }else{
        self.mainTableView.tableFooterView = nil;
    }
}

#pragma mark - <UITableViewDelegate,UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.flag == 2){
        return self.paidDetailsList.count;
    }else{
        return 1;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.flag == 1) {
        return self.yinJiaopaymentModel.payableAndUnpaidDetailsInfoList.count;
    }else if (self.flag == 3){
        return self.weiJiaopaymentModel.payableAndUnpaidDetailsInfoList.count;
    }else{
        return 1;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (self.flag == 2) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 16)];
        view.backgroundColor = [UIColor clearColor];
        return view;
    }else{
        return nil;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (self.flag == 2) {
        return 16;
    }else{
        return 0;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.flag == 2) {
        return 184;
    }else if(self.flag ==1){
        return 92;
    }else{
        return 51;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.flag == 1) {
        static NSString *paymentDetailCellIdentifier = @"HXPaymentDetailCellIdentifier";
        HXPaymentDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:paymentDetailCellIdentifier];
        if (!cell) {
            cell = [[HXPaymentDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:paymentDetailCellIdentifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        HXPaymentDetailModel *paymentDetailModel = self.yinJiaopaymentModel.payableAndUnpaidDetailsInfoList[indexPath.row];
        cell.paymentDetailModel = paymentDetailModel;
        return cell;
    }else if (self.flag == 3){
        static NSString *unPaidDetailCellIdentifier = @"HXUnPaidDetailCellIdentifier";
        HXUnPaidDetailCell *unPaidCell = [tableView dequeueReusableCellWithIdentifier:unPaidDetailCellIdentifier];
        if (!unPaidCell) {
            unPaidCell = [[HXUnPaidDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:unPaidDetailCellIdentifier];
        }
        unPaidCell.selectionStyle = UITableViewCellSelectionStyleNone;
        HXPaymentDetailModel *paymentDetailModel = self.weiJiaopaymentModel.payableAndUnpaidDetailsInfoList[indexPath.row];
        unPaidCell.paymentDetailModel = paymentDetailModel;
        return unPaidCell;
    }else{
        static NSString *paidDetailCellIdentifier = @"HXPaidDetailCellIdentifier";
        HXPaidDetailCell *paidCell = [tableView dequeueReusableCellWithIdentifier:paidDetailCellIdentifier];
        if (!paidCell) {
            paidCell = [[HXPaidDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:paidDetailCellIdentifier];
        }
        paidCell.selectionStyle = UITableViewCellSelectionStyleNone;
        paidCell.paymentDetailModel = self.paidDetailsList[indexPath.section];
        return paidCell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
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


-(UIView *)paymentDtailTableFooterView{
    if (!_paymentDtailTableFooterView) {
        _paymentDtailTableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 73)];
        _paymentDtailTableFooterView.backgroundColor = [UIColor whiteColor];
        [_paymentDtailTableFooterView addSubview:self.totalPriceLabel];
        [_paymentDtailTableFooterView addSubview:self.heJiPriceLabel];
        
        self.totalPriceLabel.sd_layout
        .centerYEqualToView(_paymentDtailTableFooterView)
        .rightSpaceToView(_paymentDtailTableFooterView, _kpw(30))
        .heightIs(22);
        [self.totalPriceLabel setSingleLineAutoResizeWithMaxWidth:200];
    
        self.heJiPriceLabel.sd_layout
        .centerYEqualToView(_paymentDtailTableFooterView)
        .rightSpaceToView(self.totalPriceLabel, 5)
        .heightIs(20)
        .widthIs(45);
        
    }
    return _paymentDtailTableFooterView;
}



-(UILabel *)totalPriceLabel{
    if (!_totalPriceLabel) {
        _totalPriceLabel = [[UILabel alloc] init];
        _totalPriceLabel.textAlignment = NSTextAlignmentRight;
        _totalPriceLabel.font = HXBoldFont(14);
        _totalPriceLabel.textColor = COLOR_WITH_ALPHA(0xFE664B, 1);
       
    }
    return _totalPriceLabel;
}



-(UILabel *)heJiPriceLabel{
    if (!_heJiPriceLabel) {
        _heJiPriceLabel = [[UILabel alloc] init];
        _heJiPriceLabel.textAlignment = NSTextAlignmentRight;
        _heJiPriceLabel.font = HXFont(14);
        _heJiPriceLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        _heJiPriceLabel.text = @"合计：";
    }
    return _heJiPriceLabel;
}


-(HXNoDataTipView *)noDataTipView{
    if (!_noDataTipView) {
        _noDataTipView = [[HXNoDataTipView alloc] initWithFrame:self.mainTableView.bounds];
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
