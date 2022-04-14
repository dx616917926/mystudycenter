//
//  HXLearnReportDetailViewController.m
//  HXMinedu
//
//  Created by mac on 2022/3/24.
//

#import "HXLearnReportDetailViewController.h"
#import "HXMoocViewController.h"
#import <TXMoviePlayer/TXMoviePlayerController.h>
#import "HXLearnReportDetailCell.h"
#import "HXHistoryLearnReportDetailCell.h"
#import "HXLearnReportDetailHeadView.h"
#import "HXHistoryLearnReportDetailHeadView.h"
#import "HXLearnReportCourseDetailModel.h"
@interface HXLearnReportDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) UITableView *mainTableView;
@property(nonatomic,strong) HXLearnReportDetailHeadView *learnReportDetailHeadView;
@property(nonatomic,strong) HXHistoryLearnReportDetailHeadView *historyLearnReportDetailHeadView;

@property(nonatomic,strong) NSMutableArray *dataArray;

@property(nonatomic,strong) HXLearnReportCourseDetailModel *learnReportCourseDetailModel;

@end

@implementation HXLearnReportDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //UI
    [self createUI];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self pullDownRefrsh];
}

#pragma mark - Setter
-(void)setIsHistory:(BOOL)isHistory{
    _isHistory = isHistory;
}

-(void)setCreateDate:(NSString *)createDate{
    _createDate = createDate;
}

-(void)setCellType:(HXLearnReportCellType)cellType{
    _cellType = cellType;
}

-(void)setModuleName:(NSString *)ModuleName{
    _ModuleName = ModuleName;
}

-(void)setLearnCourseItemModel:(HXLearnCourseItemModel *)learnCourseItemModel{
    _learnCourseItemModel = learnCourseItemModel;
}

#pragma mark - 刷新
-(void)pullDownRefrsh{
    if (self.cellType == HXKeJianXueXiReportType) {
        //获取学习报告课件详情
        [self getLearnReportKjInfo];
    }else{
        //获取学习报告考试详情
        [self getLearnReportExamInfo];
    }
}

-(void)loadMoreData{
    [self.mainTableView.mj_footer endRefreshing];
}

//修改学习次数
-(void)changeWatchVideoNum:(NSString *)studentCourseID{
    HXMajorModel *selectMajorModel = [HXPublicParamTool sharedInstance].selectMajorModel;
    NSDictionary *dic = @{
        @"studentCourseID":HXSafeString(studentCourseID),
        @"type":@(selectMajorModel.type)
    };
    
    [HXBaseURLSessionManager postDataWithNSString:HXPOST_ChangeWatchVideoNum withDictionary:dic success:^(NSDictionary * _Nonnull dictionary) {
    
    } failure:^(NSError * _Nonnull error) {
        
    }];
}


//获取学习报告课件详情
-(void)getLearnReportKjInfo{
    HXMajorModel *selectMajorModel = [HXPublicParamTool sharedInstance].selectMajorModel;
    NSDictionary *dic = @{
        @"version_id":HXSafeString(selectMajorModel.versionId),
        @"major_id":HXSafeString(selectMajorModel.major_id),
        @"type":@(selectMajorModel.type),
        @"course_id":HXSafeString(self.learnCourseItemModel.course_id),
        @"courseCode":HXSafeString(self.learnCourseItemModel.courseCode),
        @"createDate":(self.isHistory?HXSafeString(self.createDate):@"")
    };
    [self.view showLoading];
    [HXBaseURLSessionManager postDataWithNSString:HXPOST_GetLearnReportKjInfo  withDictionary:dic success:^(NSDictionary * _Nonnull dictionary) {
        [self.mainTableView.mj_header endRefreshing];
        [self.view hideLoading];
        BOOL success = [dictionary boolValueForKey:@"Success"];
        if (success) {
            self.learnReportCourseDetailModel = [HXLearnReportCourseDetailModel mj_objectWithKeyValues:[dictionary objectForKey:@"Data"]];
            [self refreshUI];
        }
    } failure:^(NSError * _Nonnull error) {
        [self.mainTableView.mj_header endRefreshing];
        [self.view hideLoading];
    }];
}

//获取学习报告考试详情
-(void)getLearnReportExamInfo{
    HXMajorModel *selectMajorModel = [HXPublicParamTool sharedInstance].selectMajorModel;
    NSDictionary *dic = @{
        @"version_id":HXSafeString(selectMajorModel.versionId),
        @"major_id":HXSafeString(selectMajorModel.major_id),
        @"type":@(selectMajorModel.type),
        @"examType":@(self.learnCourseItemModel.examType),
        @"courseCode":HXSafeString(self.learnCourseItemModel.courseCode)
    };
    [self.view showLoading];
    [HXBaseURLSessionManager postDataWithNSString:HXPOST_GetLearnReportExamInfo  withDictionary:dic success:^(NSDictionary * _Nonnull dictionary) {
        [self.mainTableView.mj_header endRefreshing];
        [self.view hideLoading];
        BOOL success = [dictionary boolValueForKey:@"Success"];
        if (success) {
            self.learnReportCourseDetailModel = [HXLearnReportCourseDetailModel mj_objectWithKeyValues:[dictionary objectForKey:@"Data"]];
            [self refreshUI];
        }
    } failure:^(NSError * _Nonnull error) {
        [self.mainTableView.mj_header endRefreshing];
        [self.view hideLoading];
    }];
}



-(void)refreshUI{
    self.learnReportCourseDetailModel.courseName = self.learnCourseItemModel.courseName;
    if (self.isHistory) {
        self.historyLearnReportDetailHeadView.learnReportCourseDetailModel = self.learnReportCourseDetailModel;
    }else{
        self.learnReportDetailHeadView.learnReportCourseDetailModel = self.learnReportCourseDetailModel;
    }
    [self.mainTableView reloadData];
}

#pragma mark - <UITableViewDelegate,UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  (self.cellType == HXKeJianXueXiReportType?self.learnReportCourseDetailModel.learnItemDetailList.count:self.learnReportCourseDetailModel.learnExamItemDetailList.count);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isHistory) {
        static NSString *historyLearnReportDetailCellIdentifier = @"HXHistoryLearnReportDetailCellIdentifier";
        HXHistoryLearnReportDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:historyLearnReportDetailCellIdentifier];
        if (!cell) {
            cell = [[HXHistoryLearnReportDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:historyLearnReportDetailCellIdentifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.cellType = self.cellType;
        if (self.cellType == HXKeJianXueXiReportType) {
            if (indexPath.row<self.self.learnReportCourseDetailModel.learnItemDetailList.count) {
                cell.learnItemDetailModel = self.self.learnReportCourseDetailModel.learnItemDetailList[indexPath.row];
            }
        }else{
            if (indexPath.row<self.self.learnReportCourseDetailModel.learnExamItemDetailList.count) {
                cell.learnItemDetailModel = self.self.learnReportCourseDetailModel.learnExamItemDetailList[indexPath.row];
            }
        }
        return cell;
    }else{
        static NSString *learnReportDetailCellIdentifier = @"HXLearnReportDetailCellIdentifier";
        HXLearnReportDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:learnReportDetailCellIdentifier];
        if (!cell) {
            cell = [[HXLearnReportDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:learnReportDetailCellIdentifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.cellType = self.cellType;
        if (self.cellType == HXKeJianXueXiReportType) {
            if (indexPath.row<self.self.learnReportCourseDetailModel.learnItemDetailList.count) {
                cell.learnItemDetailModel = self.self.learnReportCourseDetailModel.learnItemDetailList[indexPath.row];
            }
        }else{
            if (indexPath.row<self.self.learnReportCourseDetailModel.learnExamItemDetailList.count) {
                cell.learnItemDetailModel = self.self.learnReportCourseDetailModel.learnExamItemDetailList[indexPath.row];
            }
        }
        return cell;
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.cellType == HXKeJianXueXiReportType&&!self.isHistory) {
        if (indexPath.row<self.self.learnReportCourseDetailModel.learnItemDetailList.count) {
            HXLearnItemDetailModel *learnItemDetailModel = self.self.learnReportCourseDetailModel.learnItemDetailList[indexPath.row];
            if ([learnItemDetailModel.stemCode isEqualToString:@"MOOC"]) {
                HXMoocViewController *moocVc = [[HXMoocViewController alloc] init];
                moocVc.titleName = self.learnCourseItemModel.courseName;
                moocVc.moocUrl = [learnItemDetailModel.mooc_param stringValueForKey:@"coursewareHtmlUrl"];
                moocVc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:moocVc animated:YES];
            }else{
                TXMoviePlayerController *playerVC = [[TXMoviePlayerController alloc] init];
                if (@available(iOS 13.0, *)) {
                    playerVC.barStyle = UIStatusBarStyleDarkContent;
                } else {
                    playerVC.barStyle = UIStatusBarStyleDefault;
                }
                playerVC.barStyle = UIStatusBarStyleDefault;
                playerVC.showLearnFinishStyle = YES;
                playerVC.hidesBottomBarWhenPushed = YES;
                if ([HXCommonUtil isNull:learnItemDetailModel.cws_param]) return;
                playerVC.cws_param = learnItemDetailModel.cws_param;
                [self.navigationController pushViewController:playerVC animated:YES];
            }
            [self changeWatchVideoNum:self.learnReportCourseDetailModel.studentCourseID];
        }
    }
}


#pragma mark - UI
-(void)createUI{
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_14_5
    if (@available(iOS 15.0, *)) {
        self.mainTableView.sectionHeaderTopPadding = 0;
    }
#endif
    
    [self.view addSubview:self.mainTableView];
    if (self.isHistory) {
        self.sc_navigationBar.title = [NSString stringWithFormat:@"%@历史学习报告",self.learnCourseItemModel.courseName];
        self.mainTableView.tableHeaderView = self.historyLearnReportDetailHeadView;
        self.historyLearnReportDetailHeadView.cellType = self.cellType;
    
    }else{
        self.sc_navigationBar.title = [NSString stringWithFormat:@"%@学习报告",self.learnCourseItemModel.courseName];
        self.mainTableView.tableHeaderView = self.learnReportDetailHeadView;
        self.learnReportDetailHeadView.cellType = self.cellType;
    }
  
    // 下拉刷新
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(pullDownRefrsh)];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    header.automaticallyChangeAlpha = YES;
    //设置header
    self.mainTableView.mj_header = header;
//
//    MJRefreshAutoNormalFooter * footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
//    self.mainTableView.mj_footer = footer;
//    self.mainTableView.mj_footer.hidden = YES;
}

#pragma mark - LazyLoad
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (UITableView *)mainTableView {
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight, kScreenWidth, kScreenHeight-kNavigationBarHeight) style:UITableViewStylePlain];
        _mainTableView.showsVerticalScrollIndicator = NO;
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.bounces = YES;
        _mainTableView.backgroundColor = [UIColor whiteColor];
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if ([_mainTableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_mainTableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
        self.extendedLayoutIncludesOpaqueBars = YES;
        if (@available(iOS 11.0, *)) {
            _mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _mainTableView.estimatedRowHeight = 0;
            _mainTableView.estimatedSectionHeaderHeight = 0.0;
            _mainTableView.estimatedSectionFooterHeight = 0.0;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        _mainTableView.contentInset = UIEdgeInsetsMake(0, 0, kScreenBottomMargin, 0);
        _mainTableView.scrollIndicatorInsets = _mainTableView.contentInset;
        
    }
    return _mainTableView;
}

- (HXLearnReportDetailHeadView *)learnReportDetailHeadView{
    if (!_learnReportDetailHeadView) {
        _learnReportDetailHeadView = [[HXLearnReportDetailHeadView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 130)];
    }
    return _learnReportDetailHeadView;
}

-(HXHistoryLearnReportDetailHeadView *)historyLearnReportDetailHeadView{
    if (!_historyLearnReportDetailHeadView) {
        _historyLearnReportDetailHeadView = [[HXHistoryLearnReportDetailHeadView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 130)];
    }
    return _historyLearnReportDetailHeadView;
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
