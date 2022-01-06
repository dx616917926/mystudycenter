//
//  HXHistoricalDetailsViewController.m
//  HXMinedu
//
//  Created by mac on 2021/6/9.
//

#import "HXHistoricalDetailsViewController.h"
#import "HXYinJiaoHeaderView.h"
#import "HXHistoricalDetailsCell.h"
#import "HXNoDataTipView.h"
#import "HXPaymentModel.h"


@interface HXHistoricalDetailsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(strong,nonatomic) UITableView *mainTableView;
@property(nonatomic,strong) HXNoDataTipView *noDataTipView;
///历史明细数组
@property(nonatomic,strong) NSArray *historicalDetailsList;

@end

@implementation HXHistoricalDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
    //获取历史明细
    [self getHistoricalDetails];
        
}


#pragma mark - 下拉刷新
-(void)loadNewData{
    [self getHistoricalDetails];
}

#pragma mark -  获取历史明细
-(void)getHistoricalDetails{
    [HXBaseURLSessionManager postDataWithNSString:HXPOST_Get_PayableDetails withDictionary:nil success:^(NSDictionary * _Nonnull dictionary) {
        [self.mainTableView.mj_header endRefreshing];
        BOOL success = [dictionary boolValueForKey:@"Success"];
        if (success) {
            //刷新数据
            self.historicalDetailsList = [HXPaymentModel mj_objectArrayWithKeyValuesArray:[dictionary objectForKey:@"Data"]];
            if (self.historicalDetailsList.count == 0) {
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
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.sc_navigationBar.title = @"历史明细";
    [self.view addSubview:self.mainTableView];
    self.mainTableView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(kNavigationBarHeight, 0, 0, 0));
    
    // 下拉刷新
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    header.automaticallyChangeAlpha = YES;
    self.mainTableView.mj_header = header;
    
   
}


#pragma mark - <UITableViewDelegate,UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.historicalDetailsList.count;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    HXPaymentModel *paymentModel = self.historicalDetailsList[section];
    return paymentModel.payableTypeList.count;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    static NSString * yinJiaoHeaderViewIdentifier = @"HXYinJiaoHeaderViewIdentifier";
    HXYinJiaoHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:yinJiaoHeaderViewIdentifier];
    if (!headerView) {
        headerView = [[HXYinJiaoHeaderView alloc] initWithReuseIdentifier:yinJiaoHeaderViewIdentifier];
    }
    headerView.headerViewType = HXHistoricalDetailsType;
    HXPaymentModel *paymentModel = self.historicalDetailsList[section];
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
    
    HXPaymentModel *paymentModel = self.historicalDetailsList[indexPath.section];
    HXPaymentDetailsInfoModel *paymentDetailsInfoModel = paymentModel.payableTypeList[indexPath.row];
    return 90+paymentDetailsInfoModel.payableDetailsInfoList.count*40;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *historicalDetailsCellIdentifier = @"HXHistoricalDetailsCellIdentifier";
    HXHistoricalDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:historicalDetailsCellIdentifier];
    if (!cell) {
        cell = [[HXHistoricalDetailsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:historicalDetailsCellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    HXPaymentModel *paymentModel = self.historicalDetailsList[indexPath.section];
    HXPaymentDetailsInfoModel *paymentDetailsInfoModel = paymentModel.payableTypeList[indexPath.row];
    cell.paymentDetailsInfoModel = paymentDetailsInfoModel;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


#pragma mark - lazyLoad

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
        _mainTableView.contentInset = UIEdgeInsetsMake(20, 0, kScreenBottomMargin, 0);
        _mainTableView.scrollIndicatorInsets = _mainTableView.contentInset;
        _mainTableView.showsVerticalScrollIndicator = NO;
    }
    return _mainTableView;
}



-(HXNoDataTipView *)noDataTipView{
    if (!_noDataTipView) {
        _noDataTipView = [[HXNoDataTipView alloc] initWithFrame:self.mainTableView.bounds];
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
