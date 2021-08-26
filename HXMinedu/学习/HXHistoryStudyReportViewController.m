//
//  HXHistoryStudyReportViewController.m
//  HXMinedu
//
//  Created by mac on 2021/7/29.
//

#import "HXHistoryStudyReportViewController.h"
#import "HXSelectHistoryTimeViewController.h"
#import "HXHistoryStudyReportTableHeaderView.h"
#import "HXStudyReportHeaderView.h"
#import "HXStudyReportCell.h"
#import "HXStudyReportModel.h"
#import "HXNoDataTipView.h"
#import "HXHistoryTimeModel.h"

@interface HXHistoryStudyReportViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(strong,nonatomic) NSMutableArray *sectionArray;



@property(strong,nonatomic) UITableView *mainTableView;
@property(strong,nonatomic) HXHistoryStudyReportTableHeaderView *historyStudyReportTableHeaderView;

@property(strong,nonatomic) HXStudyReportModel *studyReportModel;
@property(strong,nonatomic) HXNoDataTipView *noDataTipView;

///选择的历史时间
@property(strong,nonatomic) NSString *selectHistoryTime;

@end

@implementation HXHistoryStudyReportViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //UI
    [self createUI];
    //获取历史学习报告
    [self gethisLearnReport];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    if (@available(iOS 13.0, *)) {
        return UIStatusBarStyleLightContent;
    } else {
        return UIStatusBarStyleDefault;
    }
}

#pragma mark - Setter
-(void)setHistoryTimeList:(NSArray *)historyTimeList{
    _historyTimeList = historyTimeList;
    [historyTimeList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        HXHistoryTimeModel *model = obj;
        if (model.isSelected) {
            self.selectHistoryTime = model.createDate;
            *stop = YES;
            return;
        }
    }];
    
}

#pragma mark - Event
-(void)popBack:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

///选择历史时间
-(void)selectHistoryTime:(UIButton *)sender{
    
    HXSelectHistoryTimeViewController *vc = [[HXSelectHistoryTimeViewController alloc] init];
    vc.historyTimeList = self.historyTimeList;
    WeakSelf(weakSelf);
    vc.selectFinishCallBack = ^(NSString * _Nonnull time) {
        StrongSelf(strongSelf);
        strongSelf.selectHistoryTime = time;
        //重新获取历史学习报告
        [strongSelf gethisLearnReport];
    };
    [self presentViewController:vc animated:YES completion:nil];
}



#pragma mark -  获取历史学习报告
-(void)gethisLearnReport{
    HXMajorModel *selectMajorModel = [HXPublicParamTool sharedInstance].selectMajorModel;
    NSDictionary *dic = @{
        @"version_id":HXSafeString(selectMajorModel.versionId),
        @"major_id":HXSafeString(selectMajorModel.major_id),
        @"type":@(selectMajorModel.type),
        @"createDate":HXSafeString(self.selectHistoryTime)
    };
    [self.view showLoading];
    [HXBaseURLSessionManager postDataWithNSString:HXPOST_Get_HistoryLearnReport  withDictionary:dic success:^(NSDictionary * _Nonnull dictionary) {
        [self.view hideLoading];
        BOOL success = [dictionary boolValueForKey:@"Success"];
        if (success) {
            self.studyReportModel = [HXStudyReportModel mj_objectWithKeyValues:[dictionary objectForKey:@"Data"]];
            self.studyReportModel.historyTime = self.selectHistoryTime;
            [self refreshUI];
        }
    } failure:^(NSError * _Nonnull error) {
        [self.view hideLoading];
    }];
}

#pragma mark - 刷新数据
-(void)refreshUI{
    self.sc_navigationBar.title =HXSafeString(self.studyReportModel.name);
    //头部数据
    self.historyStudyReportTableHeaderView.studyReportModel = self.studyReportModel;
    
    [self.sectionArray removeAllObjects];
    if (self.studyReportModel.kjxxCourseList.count>0) {
        [self.sectionArray addObject:@{@"sectionTitle":@"课件学习",@"sectionImageName":@"kejianxuexi_icon",@"cellType":@(HXKeJianXueXiType),@"list":self.studyReportModel.kjxxCourseList}];
    }
//    if (self.studyReportModel.zscpCourseList.count>0) {
//        [self.sectionArray addObject:@{@"sectionTitle":@"知识测评",@"sectionImageName":@"zhishidianping_icon",@"cellType":@(HXZhiShiDianPingType),@"list":self.studyReportModel.zscpCourseList}];
//    }
//    if (self.studyReportModel.pszyCourseList.count>0) {
//        [self.sectionArray addObject:@{@"sectionTitle":@"平时作业",@"sectionImageName":@"pinshizuoye_icon",@"cellType":@(HXPingShiZuoYeType),@"list":self.studyReportModel.pszyCourseList}];
//    }
//    if (self.studyReportModel.qmcjCourseList.count>0) {
//        [self.sectionArray addObject:@{@"sectionTitle":@"期末考试",@"sectionImageName":@"qimokaoshi_icon",@"cellType":@(HXQiMoKaoShiType),@"list":self.studyReportModel.qmcjCourseList}];
//    }
    
    [self.mainTableView reloadData];
    
    //无数据
    if (self.studyReportModel.kjxxCourseList.count == 0&&self.studyReportModel.pszyCourseList.count == 0&&self.studyReportModel.qmcjCourseList.count == 0) {
        [self.view addSubview:self.noDataTipView];
    }else{
        [self.noDataTipView removeFromSuperview];
    }
    
}

#pragma mark - <UITableViewDelegate,UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.sectionArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSDictionary *dic = self.sectionArray[section];
    NSArray *list = [dic objectForKey:@"list"];
    return  list.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 82;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 80;
}



- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    static NSString * studyReportHeaderViewIdentifier = @"HXStudyReportHeaderViewIdentifier";
    HXStudyReportHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:studyReportHeaderViewIdentifier];
    if (!headerView) {
        headerView = [[HXStudyReportHeaderView alloc] initWithReuseIdentifier:studyReportHeaderViewIdentifier];
    }
    NSDictionary *dic = self.sectionArray[section];
    headerView.contentLabel.text = [dic objectForKey:@"sectionTitle"];
    headerView.titleImageView.image = [UIImage imageNamed:[dic objectForKey:@"sectionImageName"]];
    return headerView;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *studyReportCellIdentifier = @"HXStudyReportCellIdentifier";
    HXStudyReportCell *cell = [tableView dequeueReusableCellWithIdentifier:studyReportCellIdentifier];
    if (!cell) {
        cell = [[HXStudyReportCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:studyReportCellIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dic = self.sectionArray[indexPath.section];
    NSArray *list = [dic objectForKey:@"list"];
    cell.cellType = [[dic objectForKey:@"cellType"] integerValue];
    HXCourseDetailModel *courseDetailModel = list[indexPath.row];
    cell.courseDetailModel = courseDetailModel;
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    HXStudyReportCell * studyReportCell = (HXStudyReportCell *)cell;
    NSDictionary *dic = self.sectionArray[indexPath.section];
    NSArray *list = [dic objectForKey:@"list"];
    studyReportCell.cellType = HXNoneCornerRadiusType;
    if (indexPath.row == 0 && indexPath.row == list.count-1) {
        studyReportCell.cornerRadiusType = HXBothCornerRadiusType;
    }else if (indexPath.row == 0) {
        studyReportCell.cornerRadiusType = HXTopCornerRadiusType;
    }else if (indexPath.row == list.count-1) {
        studyReportCell.cornerRadiusType = HXBottomCornerRadiusType;
    }
}

#pragma mark - UI
-(void)createUI{
   
    self.view.backgroundColor = COLOR_WITH_ALPHA(0xFCFCFC, 1);
    
    [self.view addSubview:self.mainTableView];
   
    self.mainTableView.sd_layout
    .topSpaceToView(self.view, 0)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomEqualToView(self.view);
    
    
}

#pragma mark - lazyLoad
-(NSMutableArray *)sectionArray{
    if (!_sectionArray) {
        _sectionArray = [NSMutableArray array];
    }
    return _sectionArray;
}




-(UITableView *)mainTableView{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _mainTableView.bounces = NO;
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.backgroundColor = [UIColor clearColor];
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
        _mainTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _mainTableView.scrollIndicatorInsets = _mainTableView.contentInset;
        _mainTableView.showsVerticalScrollIndicator = NO;
        _mainTableView.tableHeaderView = self.historyStudyReportTableHeaderView;
    }
    return _mainTableView;
}

-(HXHistoryStudyReportTableHeaderView *)historyStudyReportTableHeaderView{
    if (!_historyStudyReportTableHeaderView) {
        _historyStudyReportTableHeaderView = [[HXHistoryStudyReportTableHeaderView alloc] initWithFrame:CGRectZero];
        [_historyStudyReportTableHeaderView.backBtn addTarget:self action:@selector(popBack:) forControlEvents:UIControlEventTouchUpInside];
        [_historyStudyReportTableHeaderView.titleControl addTarget:self action:@selector(selectHistoryTime:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _historyStudyReportTableHeaderView;
}

-(HXNoDataTipView *)noDataTipView{
    if (!_noDataTipView) {
        _noDataTipView = [[HXNoDataTipView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight, kScreenWidth, kScreenHeight-kNavigationBarHeight)];
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

