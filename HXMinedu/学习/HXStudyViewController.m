
//
//  HXStudyViewController.m
//  HXMinedu
//
//  Created by mac on 2021/3/26.
//

#import "HXStudyViewController.h"
#import "HXSelectStudyTypeViewController.h"
#import "HXExaminationResultsViewController.h"
#import "HXStudyReportViewController.h"
#import "HXSystemNotificationViewController.h"
#import "HXExamListViewController.h"
#import <TXMoviePlayer/TXMoviePlayerController.h>
#import "HXCustommNavView.h"
#import "HXCourseLearnCell.h"
#import "HXTeachPlanHeaderView.h"
#import "HXStudyTableHeaderView.h"
#import "HXCourseModel.h"


@interface HXStudyViewController ()<UITableViewDelegate,UITableViewDataSource,HXStudyTableHeaderViewDelegate,HXCourseLearnCellDelegate>

@property(nonatomic,strong) HXCustommNavView *custommNavView;
@property (nonatomic, strong) HXVersionModel *selectVersionModel;


@property(strong,nonatomic) UITableView *mainTableView;
@property(strong,nonatomic) HXStudyTableHeaderView *studyTableHeaderView;
//课程数组
@property (nonatomic, strong) NSArray *courseList;


///是否有分组头
@property(assign,nonatomic) BOOL isHaveHeader;


@end

@implementation HXStudyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //布局UI
    [self createUI];
    //获取报考类型专业列表
    [self getVersionandMajorList];
    
    //登录成功的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getVersionandMajorList) name:LOGINSUCCESS object:nil];
    ///监听<<报考类型专业改变>>通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(versionAndMajorChangeNotification:) name:VersionAndMajorChangeNotification object:nil];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

-(void)viewDidDisappear:(BOOL)animated{
    
}

#pragma mark -  监听<<报考类型专业改变>>通知
-(void)versionAndMajorChangeNotification:(NSNotification *)nonifi{
    if (nonifi.object != self) {///不接收自己发出的<<报考类型专业改变>>通知
        [self refreshNavBarData];
    }
}

#pragma mark - event
-(void)selectStudyType{
    if ([HXPublicParamTool sharedInstance].versionList.count == 0) {
        [self getVersionandMajorList];
    }
    HXSelectStudyTypeViewController *vc =[[HXSelectStudyTypeViewController alloc] init];
    //选择完成回调
    WeakSelf(weakSelf)
    vc.selectFinishCallBack = ^(HXVersionModel * _Nonnull selectVersionModel, HXMajorModel * _Nonnull selectMajorModel) {
        weakSelf.selectVersionModel = selectVersionModel;
        [HXPublicParamTool sharedInstance].selectMajorModel = selectMajorModel;
    };
    [self presentViewController:vc animated:YES completion:nil];
}



#pragma mark - 网络请求
//获取报考类型专业列表
-(void)getVersionandMajorList{
    [self.view showLoading];
    [HXBaseURLSessionManager postDataWithNSString:HXPOST_Get_Version_Major_List withDictionary:nil success:^(NSDictionary * _Nonnull dictionary) {
        [self.mainTableView.mj_header endRefreshing];
        [self.view hideLoading];
        BOOL success = [dictionary boolValueForKey:@"Success"];
        if (success) {
            //////由于报考类型数据多处用到，避免频繁获取，此处保存在单例中
            [HXPublicParamTool sharedInstance].versionList = [HXVersionModel mj_objectArrayWithKeyValuesArray:[dictionary objectForKey:@"Data"]];
            ///默认选择第一个
            HXVersionModel *model = [HXPublicParamTool sharedInstance].versionList.firstObject;
            model.isSelected = YES;
            HXMajorModel *majorModel = model.majorList.firstObject;
            majorModel.isSelected = YES;
            ///刷新导航数据
            [self refreshNavBarData];
            ///发出<<报考类型专业改变>>通知
            [[NSNotificationCenter defaultCenter] postNotificationName:VersionAndMajorChangeNotification object:self];
        }else{
            [self.view showErrorWithMessage:[dictionary stringValueForKey:@"Message"]];
        }
    } failure:^(NSError * _Nonnull error) {
        [self.mainTableView.mj_header endRefreshing];
        [self.view hideLoading];
    }];
}

//获取课程列表
-(void)getCourseList{
    HXMajorModel *selectMajorModel = [HXPublicParamTool sharedInstance].selectMajorModel;
    NSDictionary *dic = @{
        @"version_id":HXSafeString(selectMajorModel.versionId),
        @"type":@(selectMajorModel.type),
        @"major_id":HXSafeString(selectMajorModel.major_id)
    };
    
    [HXBaseURLSessionManager postDataWithNSString:HXPOST_Get_Course_List withDictionary:dic success:^(NSDictionary * _Nonnull dictionary) {

        BOOL success = [dictionary boolValueForKey:@"Success"];
        if (success) {
            self.courseList = [HXCourseModel mj_objectArrayWithKeyValuesArray:[dictionary objectForKey:@"Data"]];
            [self.mainTableView reloadData];
           
        }else{
            [self.view showErrorWithMessage:[dictionary stringValueForKey:@"Message"]];
        }
    } failure:^(NSError * _Nonnull error) {
    
    }];
}

#pragma mark -  下拉刷新,重新获取报考类型专业列表
-(void)pullDownRefrsh{
    [self getVersionandMajorList];
}

#pragma mark - 刷新导航栏数据
-(void)refreshNavBarData{
    //筛选出选中类型
    [[HXPublicParamTool sharedInstance].versionList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        HXVersionModel *model = obj;
        if (model.isSelected) {
            self.custommNavView.selectVersionModel = model;
            [model.majorList enumerateObjectsUsingBlock:^(HXMajorModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.isSelected) {
                    [HXPublicParamTool sharedInstance].selectMajorModel = obj;
                    *stop = YES;
                    return;
                }
            }];
            *stop = YES;
            return;;
        }
    }];
    //获取教学计划列表
    [self getCourseList];
}

#pragma mark - HXStudyTableHeaderViewDelegate
-(void)handleEventWithFlag:(NSInteger)flag{
    if (flag == 0) {//学习报告
        HXStudyReportViewController *studyReportVc = [[HXStudyReportViewController alloc] init];
        studyReportVc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:studyReportVc animated:YES];
    }else if(flag == 1){//公告
        HXSystemNotificationViewController *systemNotificationVc = [[HXSystemNotificationViewController alloc] init];
        systemNotificationVc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:systemNotificationVc animated:YES];
    }else if(flag == 2){//直播
        [self.tabBarController setSelectedIndex:2];
    }
    
}

#pragma mark - <HXCourseLearnCellDelegate>
-(void)handleType:(HXClickType)type withItem:(HXModelItem *)item{
    switch (type) {
        case HXKeJianXueXiClickType://课件学习
        {
            TXMoviePlayerController *playerVC = [[TXMoviePlayerController alloc] init];
            if (@available(iOS 13.0, *)) {
                playerVC.barStyle = UIStatusBarStyleDarkContent;
            } else {
                playerVC.barStyle = UIStatusBarStyleDefault;
            }
            playerVC.cws_param = item.cws_param;
            playerVC.barStyle = UIStatusBarStyleDefault;
            playerVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:playerVC animated:YES];
        }
            break;
        case HXPingShiZuoYeClickType://平时作业
        case HXQiMoKaoShiClickType://期末考试
        {
            HXExamListViewController *listVC = [[HXExamListViewController alloc] init];
            listVC.authorizeUrl = item.ExamUrl;
            listVC.title = item.ModuleName;
            listVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:listVC animated:YES];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - <UITableViewDelegate,UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return  self.courseList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    HXCourseModel *courseModel = self.courseList[indexPath.row];
    CGFloat rowHeight = [tableView cellHeightForIndexPath:indexPath
                                                         model:courseModel keyPath:@"courseModel"
                                                     cellClass:([HXCourseLearnCell class])
                                              contentViewWidth:kScreenWidth];
    return rowHeight;

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *courseLearnCellIdentifier = @"HXCourseLearnCellIdentifier";
    HXCourseLearnCell *cell = [tableView dequeueReusableCellWithIdentifier:courseLearnCellIdentifier];
    if (!cell) {
        cell = [[HXCourseLearnCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:courseLearnCellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    HXCourseModel *courseModel = self.courseList[indexPath.row];
    cell.courseModel = courseModel;
    return cell;
    
    
}

#pragma mark - UI
-(void)createUI{
    self.sc_navigationBar.leftBarButtonItem = nil;
    self.sc_navigationBar.backGroundImage = [UIImage imageNamed:@"navbar_bg"];
    self.sc_navigationBar.titleView = self.custommNavView;
    __weak __typeof(self) weakSelf = self;
    self.custommNavView.selectTypeCallBack = ^{
        [weakSelf selectStudyType];
    };
    
    [self.view addSubview:self.mainTableView];
    
    // 下拉刷新
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(pullDownRefrsh)];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    header.automaticallyChangeAlpha = YES;
     //设置header
    self.mainTableView.mj_header = header;
    
}


#pragma mark - lazyload
-(HXCustommNavView *)custommNavView{
    if (!_custommNavView) {
        _custommNavView = [[HXCustommNavView alloc] initWithFrame:CGRectMake(0, kStatusBarHeight, kScreenWidth, kNavigationBarHeight-kStatusBarHeight)];
    }
    return _custommNavView;
}

-(UITableView *)mainTableView{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavigationBarHeight, kScreenWidth, kScreenHeight-kNavigationBarHeight-kTabBarHeight) style:UITableViewStyleGrouped];
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
        _mainTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _mainTableView.scrollIndicatorInsets = _mainTableView.contentInset;
        _mainTableView.showsVerticalScrollIndicator = NO;
        _mainTableView.tableHeaderView = self.studyTableHeaderView;
    }
    return _mainTableView;
}

-(HXStudyTableHeaderView *)studyTableHeaderView{
    if (!_studyTableHeaderView) {
        _studyTableHeaderView = [[HXStudyTableHeaderView alloc] initWithFrame:CGRectZero];
        _studyTableHeaderView.delegate = self;
    }
    return _studyTableHeaderView;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]  removeObserver:self];
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
