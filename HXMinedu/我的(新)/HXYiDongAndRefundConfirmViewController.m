//
//  HXYiDongConfirmViewController.m
//  HXMinedu
//
//  Created by mac on 2021/6/3.
//

#import "HXYiDongAndRefundConfirmViewController.h"
#import "HXRefundDetailsViewController.h"
#import "HXChangeMajorYiDongDetailsViewController.h"
#import "HXTuiXueYiDongDetailsViewController.h"
#import "HXNoDataTipView.h"
#import "MJRefresh.h"
@interface HXYiDongAndRefundConfirmViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *mainTableView;
@property(nonatomic,strong) HXNoDataTipView *noDataTipView;
@property (nonatomic, strong) NSArray *dataList;

@end

@implementation HXYiDongAndRefundConfirmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //UI
    [self createUI];
    
    if (self.confirmType== HXRefundConfirmType) {
        //获取学生退费信息
        [self getStudentRefundList];
    }else{
        //获取学生异动信息
        [self getStopStudyInfoList];
    }
   ///监听异动确认/驳回通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getStopStudyInfoList) name:@"ConfirmOrRejectYiDongNotification" object:nil];
}

#pragma mark - 获取学生退费信息
-(void)getStudentRefundList{
    
    [HXBaseURLSessionManager postDataWithNSString:HXPOST_GetStudentRefundList withDictionary:nil success:^(NSDictionary * _Nonnull dictionary) {
        [self.mainTableView.mj_header endRefreshing];
        BOOL success = [dictionary boolValueForKey:@"Success"];
        if (success) {
            //刷新数据
            self.dataList = [HXStudentRefundModel mj_objectArrayWithKeyValuesArray:[dictionary objectForKey:@"Data"]];
            if (self.dataList.count == 0) {
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

#pragma mark - 获取学生异动信息
-(void)getStopStudyInfoList{
    
    [HXBaseURLSessionManager postDataWithNSString:HXPOST_GetStopStudyInfoList withDictionary:nil success:^(NSDictionary * _Nonnull dictionary) {
        [self.mainTableView.mj_header endRefreshing];
        BOOL success = [dictionary boolValueForKey:@"Success"];
        if (success) {
            //刷新数据
            self.dataList = [HXStudentYiDongModel mj_objectArrayWithKeyValuesArray:[dictionary objectForKey:@"Data"]];
            if (self.dataList.count == 0) {
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

#pragma mark - UI
-(void)createUI{
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.sc_navigationBar.title =(self.confirmType== HXYiDongConfirmType?@"异动确认":@"退费确认");
    [self.view addSubview:self.mainTableView];
    self.mainTableView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(kNavigationBarHeight, 0, kScreenBottomMargin, 0));
    // 下拉刷新
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:(self.confirmType== HXRefundConfirmType?@selector(getStudentRefundList):@selector(getStopStudyInfoList))];
    header.automaticallyChangeAlpha = YES;
    self.mainTableView.mj_header = header;
}

#pragma mark - <UITableViewDelegate,UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 240;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *yiDongAndRefundConfirmCellIdentifier = @"HXYiDongAndRefundConfirmCellIdentifier";
    HXYiDongAndRefundConfirmCell *cell = [tableView dequeueReusableCellWithIdentifier:yiDongAndRefundConfirmCellIdentifier];
    if (!cell) {
        cell = [[HXYiDongAndRefundConfirmCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:yiDongAndRefundConfirmCellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.confirmType = self.confirmType;
    if (self.confirmType== HXRefundConfirmType) {//退费
        HXStudentRefundModel *studentRefundModel = self.dataList[indexPath.row];
        cell.studentRefundModel = studentRefundModel;
    }else{//异动
        HXStudentYiDongModel *studentYiDongModel = self.dataList[indexPath.row];
        cell.studentYiDongModel = studentYiDongModel;
    }
   
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.confirmType == HXRefundConfirmType) {//退费
        HXStudentRefundModel *studentRefundModel = self.dataList[indexPath.row];
        HXRefundDetailsViewController*refundDetailsVC = [[HXRefundDetailsViewController alloc] init];
        refundDetailsVC.refundId = studentRefundModel.refundId;
        //回调刷新
        refundDetailsVC.refundRefreshCallBack = ^{
            [self getStudentRefundList];
        };
        [self.navigationController pushViewController:refundDetailsVC animated:YES];
    }else{//异动
        //stopType_id异动代码  8001-休学  8002-退学   8005-转专业   8006-转产品
        HXStudentYiDongModel *studentYiDongModel = self.dataList[indexPath.row];
        if (studentYiDongModel.stopType_id == 8001||studentYiDongModel.stopType_id == 8002) {
            HXTuiXueYiDongDetailsViewController *tuiXueYiDongDetailsVc = [[HXTuiXueYiDongDetailsViewController alloc] init];
            tuiXueYiDongDetailsVc.stopStudyId = studentYiDongModel.stopStudyId;
            tuiXueYiDongDetailsVc.refundRefreshCallBack = ^{
                [self getStopStudyInfoList];
            };
            [self.navigationController pushViewController:tuiXueYiDongDetailsVc animated:YES];
        }else{
            HXChangeMajorYiDongDetailsViewController *changeMajorYiDongDetailsVc = [[HXChangeMajorYiDongDetailsViewController alloc] init];
            changeMajorYiDongDetailsVc.stopStudyId = studentYiDongModel.stopStudyId;
            //0-待确认 1-已确认 2-审核中 3-待终审 4-已同意 5-已驳回
            changeMajorYiDongDetailsVc.isconfirm = (studentYiDongModel.reviewStatus==0?NO:YES);
            [self.navigationController pushViewController:changeMajorYiDongDetailsVc animated:YES];
        }
    }
}

#pragma mark - Setter
-(void)setConfirmType:(HXConfirmType)confirmType{
    _confirmType = confirmType;
}


#pragma mark - lazylaod

-(UITableView *)mainTableView{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _mainTableView.bounces = YES;
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.backgroundColor = [UIColor whiteColor];
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
        _mainTableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
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
