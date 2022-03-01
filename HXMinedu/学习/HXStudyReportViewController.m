//
//  HXStudyReportViewController.m
//  HXMinedu
//
//  Created by mac on 2021/4/7.
//

#import "HXStudyReportViewController.h"
#import "HXHistoryStudyReportViewController.h"
#import "HXStudyReportTableHeaderView.h"
#import "HXStudyReportHeaderView.h"
#import "HXStudyReportCell.h"
#import "HXStudyReportModel.h"
#import "HXHistoryTimeModel.h"
#import "HXNoDataTipView.h"

@interface HXStudyReportViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(strong,nonatomic) NSMutableArray *sectionArray;
@property(strong,nonatomic) UITableView *mainTableView;
@property(strong,nonatomic) HXStudyReportTableHeaderView *studyReportTableHeaderView;
@property(strong,nonatomic) HXStudyReportModel *studyReportModel;
@property(strong,nonatomic) HXNoDataTipView *noDataTipView;
//历史时间数组
@property(strong,nonatomic) NSMutableArray *historyTimeList;

@end

@implementation HXStudyReportViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //UI
    [self createUI];
    //获取学习报告
    [self getLearnReport];
    //获取历史版本时间
    [self getStuHisVersionTime];
}

#pragma mark - 查看历史学习报告
-(void)checkHistoryStudyReport:(UIButton *)sender{
    
    HXHistoryStudyReportViewController *vc = [[HXHistoryStudyReportViewController alloc] init];
    vc.sc_navigationBarHidden = YES;//隐藏导航栏
    vc.historyTimeList = self.historyTimeList;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -  获取学习报告
-(void)getLearnReport{
    HXMajorModel *selectMajorModel = [HXPublicParamTool sharedInstance].selectMajorModel;
    NSDictionary *dic = @{
        @"version_id":HXSafeString(selectMajorModel.versionId),
        @"major_id":HXSafeString(selectMajorModel.major_id),
        @"type":@(selectMajorModel.type)
    };
    [self.view showLoading];
    [HXBaseURLSessionManager postDataWithNSString:HXPOST_Get_LearnReport  withDictionary:dic success:^(NSDictionary * _Nonnull dictionary) {
        [self.view hideLoading];
        BOOL success = [dictionary boolValueForKey:@"Success"];
        if (success) {
            self.studyReportModel = [HXStudyReportModel mj_objectWithKeyValues:[dictionary objectForKey:@"Data"]];
            [self refreshUI];
        }
    } failure:^(NSError * _Nonnull error) {
        [self.view hideLoading];
    }];
}

#pragma mark -  获取历史版本时间
-(void)getStuHisVersionTime{
    HXMajorModel *selectMajorModel = [HXPublicParamTool sharedInstance].selectMajorModel;
    NSDictionary *dic = @{
        @"version_id":HXSafeString(selectMajorModel.versionId),
        @"major_id":HXSafeString(selectMajorModel.major_id),
        @"type":@(selectMajorModel.type)
    };
    
    [HXBaseURLSessionManager postDataWithNSString:HXPOST_Get_StuHisVersionTime  withDictionary:dic success:^(NSDictionary * _Nonnull dictionary) {
        [self.view hideLoading];
        BOOL success = [dictionary boolValueForKey:@"Success"];
        if (success) {
            NSArray *array = [HXHistoryTimeModel mj_objectArrayWithKeyValuesArray:[dictionary objectForKey:@"Data"]];
            [self.historyTimeList removeAllObjects];
            [self.historyTimeList addObjectsFromArray:array];
            //默认选择第一个
            HXHistoryTimeModel *model = self.historyTimeList.firstObject;
            model.isSelected = YES;
        }
    } failure:^(NSError * _Nonnull error) {
        
    }];
}



#pragma mark - 刷新数据
-(void)refreshUI{
    self.sc_navigationBar.title =HXSafeString(self.studyReportModel.name);
    //头部数据
    self.studyReportTableHeaderView.studyReportModel = self.studyReportModel;
    
    [self.sectionArray removeAllObjects];
    if (self.studyReportModel.kjxxCourseList.count>0) {
        [self.sectionArray addObject:@{@"sectionTitle":@"课件学习",@"sectionImageName":@"kejianxuexi_icon",@"cellType":@(HXKeJianXueXiType),@"list":self.studyReportModel.kjxxCourseList}];
    }
//    if (self.studyReportModel.zscpCourseList.count>0) {
//        [self.sectionArray addObject:@{@"sectionTitle":@"知识测评",@"sectionImageName":@"zhishidianping_icon",@"cellType":@(HXZhiShiDianPingType),@"list":self.studyReportModel.zscpCourseList}];
//    }
    if (self.studyReportModel.pszyCourseList.count>0) {
        [self.sectionArray addObject:@{@"sectionTitle":@"平时作业",@"sectionImageName":@"pinshizuoye_icon",@"cellType":@(HXPingShiZuoYeType),@"list":self.studyReportModel.pszyCourseList}];
    }
    if (self.studyReportModel.qmcjCourseList.count>0) {
        [self.sectionArray addObject:@{@"sectionTitle":@"期末考试",@"sectionImageName":@"qimokaoshi_icon",@"cellType":@(HXQiMoKaoShiType),@"list":self.studyReportModel.qmcjCourseList}];
    }
    
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
   
    self.view.backgroundColor = COLOR_WITH_ALPHA(0xf5f6fa, 1);
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setSc_NavigationBarAnimateInvalid:YES];
    self.sc_navigationBar.leftBarButtonItem = self.leftBarItem;
   
    [self.view addSubview:self.mainTableView];

}

#pragma mark - lazyLoad
-(NSMutableArray *)sectionArray{
    if (!_sectionArray) {
        _sectionArray = [NSMutableArray array];
    }
    return _sectionArray;
}

-(NSMutableArray *)historyTimeList{
    if (!_historyTimeList) {
        _historyTimeList = [NSMutableArray array];
    }
    return _historyTimeList;
}



-(UITableView *)mainTableView{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavigationBarHeight, kScreenWidth, kScreenHeight-kNavigationBarHeight) style:UITableViewStyleGrouped];
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
        _mainTableView.tableHeaderView = self.studyReportTableHeaderView;
    }
    return _mainTableView;
}

-(HXStudyReportTableHeaderView *)studyReportTableHeaderView{
    if (!_studyReportTableHeaderView) {
        _studyReportTableHeaderView = [[HXStudyReportTableHeaderView alloc] initWithFrame:CGRectZero];
        [_studyReportTableHeaderView.checkHistoryBtn addTarget:self action:@selector(checkHistoryStudyReport:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _studyReportTableHeaderView;
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
