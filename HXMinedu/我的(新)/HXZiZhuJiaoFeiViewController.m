//
//  HXZiZhuJiaoFeiViewController.m
//  HXMinedu
//
//  Created by mac on 2021/12/8.
//

#import "HXZiZhuJiaoFeiViewController.h"
#import "HXOrderDetailsViewController.h"
#import "HXZiZhuOrderDetailsViewController.h"
#import "HXYinJiaoHeaderView.h"
#import "HXZiZhuJiaoFeiCell.h"
#import "HXCommonSelectView.h"
#import "HXNoDataTipView.h"
#import "HXPaymentModel.h"



@interface HXZiZhuJiaoFeiViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(strong,nonatomic) HXBarButtonItem *rightBarButtonItem;
@property(strong,nonatomic) UITableView *mainTableView;

@property(strong,nonatomic) UIView *bottomView;
@property(strong,nonatomic) UIButton *payBtn;

@property(nonatomic,strong) HXCommonSelectView *commonSelectView;

@property(nonatomic,strong) HXNoDataTipView *noDataTipView;

///应缴明细数组
@property(nonatomic,strong) NSArray *yinJiaoDetailsList;
///选择的缴费专业
@property(nonatomic,strong) HXPaymentModel *selectPaymentModel;
@property(nonatomic,strong) NSMutableArray *majorArray;
@property(nonatomic,strong) NSString *majorTitle;
@end

@implementation HXZiZhuJiaoFeiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //UI
    [self createUI];
    //获取应缴明细
    [self getPayableDetails:self.isStandardFee];
}

#pragma mark - Setter
-(void)setIsStandardFee:(NSInteger)isStandardFee{
    _isStandardFee = isStandardFee;
}

#pragma mark - Event
///切换专业
-(void)switchMajor{
    [self.commonSelectView show];
    [self.majorArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        HXCommonSelectModel *model = obj;
        if ([model.content isEqualToString:self.majorTitle]) {
            model.isSelected = YES;
        }else{
            model.isSelected = NO;
        }
    }];
    self.commonSelectView.dataArray = self.majorArray;
    self.commonSelectView.title = @"选择专业";
    WeakSelf(weakSelf);
    self.commonSelectView.seletConfirmBlock = ^(HXCommonSelectModel * _Nonnull selectModel) {
        StrongSelf(strongSelf);
        strongSelf.majorTitle = selectModel.content;
        ///筛选出专业
        [strongSelf.majorArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            HXCommonSelectModel *model = obj;
            if ([model.content isEqualToString:strongSelf.majorTitle]) {
                strongSelf.selectPaymentModel = strongSelf.yinJiaoDetailsList[idx];
                *stop = YES;
                return;
            }
        }];
        //重置每个费项的选中状态
        [strongSelf.selectPaymentModel.payableTypeList enumerateObjectsUsingBlock:^(HXPaymentDetailsInfoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj.payableDetailsInfoList enumerateObjectsUsingBlock:^(HXPaymentDetailModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj.isSeleted = NO;
            }];
        }];
        [strongSelf.mainTableView reloadData];
    };
}


#pragma mark - 下拉刷新
-(void)loadNewData{
    //获取应缴明细
    [self getPayableDetails:self.isStandardFee];
}

#pragma mark -  获取应缴明细
-(void)getPayableDetails:(NSInteger)isStandardFee{
    //0应缴明细 1其他服务
    NSDictionary *dic = @{@"isStandardFee":((isStandardFee==0||isStandardFee==2)?@0:@1)};
    [HXBaseURLSessionManager postDataWithNSString:HXPOST_Get_PayableDetails withDictionary:dic success:^(NSDictionary * _Nonnull dictionary) {
        [self.mainTableView.mj_header endRefreshing];
        BOOL success = [dictionary boolValueForKey:@"Success"];
        if (success) {
            //刷新数据
            self.yinJiaoDetailsList = [HXPaymentModel mj_objectArrayWithKeyValuesArray:[dictionary objectForKey:@"Data"]];
            if (self.yinJiaoDetailsList.count == 0) {
                [self.view addSubview:self.noDataTipView];
            }else{
                [self.noDataTipView removeFromSuperview];
                //处理数据
                [self handleData];
            }
        }
    } failure:^(NSError * _Nonnull error) {
        [self.mainTableView.mj_header endRefreshing];

    }];
}

-(void)handleData{
    //筛选出可用的数据
    [self.majorArray removeAllObjects];
    __block NSMutableArray *tempArray = [NSMutableArray array];
    [self.yinJiaoDetailsList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        HXPaymentModel *model = obj;
        ///8005和8006置灰其他正常
        if (model.studentStateId!=8005&&model.studentStateId!=8006) {
            HXCommonSelectModel *tempModel = [HXCommonSelectModel new];
            tempModel.content = model.title;
            [self.majorArray addObject:tempModel];
            [tempArray addObject:model];
        }
    }];
    if (tempArray.count>0) {
        HXPaymentModel *model = tempArray.firstObject;
        self.majorTitle = model.title;
        self.selectPaymentModel = model;
    }
    //是否显示右侧 切换专业按钮
    self.sc_navigationBar.rightBarButtonItem = (self.majorArray.count>1?self.rightBarButtonItem:nil);
    [self.mainTableView reloadData];
}

#pragma mark - Event
//去支付
-(void)pushZiZhuOrderDetailsVc:(UIButton *)sender{
    //暂无需要缴费的费项
    __block BOOL canSeleted = NO;
    //标准，补录数组
    __block NSMutableArray *payableTypeList = [NSMutableArray array];
    [self.selectPaymentModel.payableTypeList enumerateObjectsUsingBlock:^(HXPaymentDetailsInfoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        HXPaymentDetailsInfoModel *tempModel = [HXPaymentDetailsInfoModel new];
        tempModel.ftype = obj.ftype;
        tempModel.ftypeName = obj.ftypeName;
        
        //单项缴费条目数组
        __block NSMutableArray *payableDetailsInfoList = [NSMutableArray array];
        [obj.payableDetailsInfoList enumerateObjectsUsingBlock:^(HXPaymentDetailModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.isSeleted) {
                [payableDetailsInfoList addObject:obj];
            }
            //暂无需要缴费的费项
            if (obj.IsFee) {
                canSeleted = YES;
            }
        }];
        if (payableDetailsInfoList.count>0) {
            tempModel.payableDetailsInfoList = payableDetailsInfoList;
            [payableTypeList addObject:tempModel];
        }
    }];
    
    
    if (!canSeleted) {
        [self.view showTostWithMessage:@"暂无需要缴费的费项"];
        return;
    }
    if (payableTypeList.count==0) {
        [self.view showTostWithMessage:@"请选择缴费项目"];
        return;
    }
    HXZiZhuOrderDetailsViewController *vc = [[HXZiZhuOrderDetailsViewController alloc] init];
    HXPaymentModel *paidDetailsInfoModel  = [HXPaymentModel new];
    paidDetailsInfoModel.type = self.selectPaymentModel.type;
    paidDetailsInfoModel.version_id = self.selectPaymentModel.version_id;
    paidDetailsInfoModel.major_id = self.selectPaymentModel.major_id;
    paidDetailsInfoModel.payMode_id = self.selectPaymentModel.payMode_id;
    paidDetailsInfoModel.orderNum = self.selectPaymentModel.orderNum;
    paidDetailsInfoModel.createDate = self.selectPaymentModel.createDate;
    paidDetailsInfoModel.payableTypeList = payableTypeList;
    vc.paidDetailsInfoModel = paidDetailsInfoModel;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 布局子视图
-(void)createUI{
    self.sc_navigationBar.title = @"自助缴费";
    self.rightBarButtonItem = [[HXBarButtonItem alloc] initWithTitle:@"切换专业" style:HXBarButtonItemStylePlain handler:^(id sender) {
        [self switchMajor];
    }];
    [self.view addSubview:self.mainTableView];
    [self.view addSubview:self.bottomView];
    [self.bottomView addSubview:self.payBtn];
    
    self.bottomView.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomEqualToView(self.view)
    .heightIs(70+kScreenBottomMargin);
    
    self.payBtn.sd_layout
    .topSpaceToView(self.bottomView, 5)
    .centerXEqualToView(self.bottomView)
    .widthIs(kScreenWidth-24)
    .heightIs(50);
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
    
    // 下拉刷新
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    header.automaticallyChangeAlpha = YES;
    self.mainTableView.mj_header = header;
    
   
}



#pragma mark - <UITableViewDelegate,UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    return self.selectPaymentModel.payableTypeList.count;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString * yinJiaoHeaderViewIdentifier = @"HXYinJiaoHeaderViewIdentifier";
    HXYinJiaoHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:yinJiaoHeaderViewIdentifier];
    if (!headerView) {
        headerView = [[HXYinJiaoHeaderView alloc] initWithReuseIdentifier:yinJiaoHeaderViewIdentifier];
    }
   
    HXPaymentModel *paymentModel = self.selectPaymentModel;
    headerView.headerViewType = (paymentModel.studentStateId == 8005||paymentModel.studentStateId == 8006) ?HXHistoricalDetailsType:HXYingJiaoDetailsType;
    headerView.paymentModel = paymentModel;
    return headerView;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 102;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 16;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HXPaymentModel *paymentModel = self.selectPaymentModel;
    HXPaymentDetailsInfoModel *paymentDetailsInfoModel = paymentModel.payableTypeList[indexPath.row];
    CGFloat rowHeight = [tableView cellHeightForIndexPath:indexPath
                                                    model:paymentDetailsInfoModel keyPath:@"paymentDetailsInfoModel"
                                                cellClass:([HXZiZhuJiaoFeiCell class])
                                         contentViewWidth:kScreenWidth];
    return rowHeight;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ziZhuJiaoFeiCellIdentifier = @"HXZiZhuJiaoFeiCellIdentifier";
    HXZiZhuJiaoFeiCell *cell = [tableView dequeueReusableCellWithIdentifier:ziZhuJiaoFeiCellIdentifier];
    if (!cell) {
        cell = [[HXZiZhuJiaoFeiCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ziZhuJiaoFeiCellIdentifier];
    }
    HXPaymentModel *paymentModel = self.selectPaymentModel;
    HXPaymentDetailsInfoModel *paymentDetailsInfoModel = paymentModel.payableTypeList[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    cell.paymentDetailsInfoModel = paymentDetailsInfoModel;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

}


#pragma mark - lazyLoad
-(NSMutableArray *)majorArray{
    if (!_majorArray) {
        _majorArray = [NSMutableArray array];
    }
    return _majorArray;
}

-(UITableView *)mainTableView{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
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
        _mainTableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
        _mainTableView.scrollIndicatorInsets = _mainTableView.contentInset;
        _mainTableView.showsVerticalScrollIndicator = NO;
    }
    return _mainTableView;
}

-(UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = UIColor.whiteColor;
    }
    return _bottomView;
}

-(UIButton *)payBtn{
    if (!_payBtn) {
        _payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _payBtn.titleLabel.font = HXFont(16);
        [_payBtn setTitle:@"去支付" forState:UIControlStateNormal];
        [_payBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_payBtn addTarget:self action:@selector(pushZiZhuOrderDetailsVc:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _payBtn;
}


-(HXNoDataTipView *)noDataTipView{
    if (!_noDataTipView) {
        _noDataTipView = [[HXNoDataTipView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight, kScreenWidth, kScreenHeight-kNavigationBarHeight)];
        _noDataTipView.tipTitle = @"暂无数据~";
    }
    return _noDataTipView;
}

-(HXCommonSelectView *)commonSelectView{
    if (!_commonSelectView) {
        _commonSelectView = [[HXCommonSelectView alloc] init];
    }
    return _commonSelectView;
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
