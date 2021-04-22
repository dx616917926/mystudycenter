
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
#import "HXStudyCourseCell.h"
#import "HXTeachPlanHeaderView.h"
#import "HXStudyTableHeaderView.h"
#import "HXStudyGuideView.h"
#import "HXCourseModel.h"
#import "HXBannerLogoModel.h"
#import "SDWebImage.h"

@interface HXStudyViewController ()<UITableViewDelegate,UITableViewDataSource,HXStudyTableHeaderViewDelegate,HXCourseLearnCellDelegate>

@property(nonatomic,strong) HXCustommNavView *custommNavView;
@property (nonatomic, strong) HXVersionModel *selectVersionModel;


@property(strong,nonatomic) UITableView *mainTableView;
@property(strong,nonatomic) HXStudyTableHeaderView *studyTableHeaderView;

@property(strong,nonatomic) UIView *lastLearnView;
@property(strong,nonatomic) UIView *todayView;
@property(strong,nonatomic) UIView *yesterdayView;

@property(strong,nonatomic) UIView *studyTableFooterView;
@property(strong,nonatomic) UIImageView *logoImageView;

@property(strong,nonatomic) HXStudyGuideView *studyGuideView;

//课程数组
@property (nonatomic, strong) NSArray *courseList;
///是否有分组头
@property(assign,nonatomic) BOOL isHaveHeader;

//bannerLogo模型
@property (nonatomic, strong) HXBannerLogoModel *bannerLogoModel;




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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //解决viewWillAppear时出现时轮播图卡在一半的问题，在控制器viewWillAppear时调用此方法
    [self.studyTableHeaderView.bannerView adjustWhenControllerViewWillAppera];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //引导视图
    if (![HXUserDefaults boolForKey:@"ShowStudyGuideView"]) {
        [self.studyGuideView show];
        [HXUserDefaults setBool:YES forKey:@"ShowStudyGuideView"];
        [HXUserDefaults synchronize];
    }
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

//获取Banner和Logo
-(void)getBannerAndLogo{
    HXMajorModel *selectMajorModel = [HXPublicParamTool sharedInstance].selectMajorModel;
    NSDictionary *dic = @{
        @"version_id":HXSafeString(selectMajorModel.versionId),
        @"type":@(selectMajorModel.type),
        @"major_id":HXSafeString(selectMajorModel.major_id)
    };
    
    [HXBaseURLSessionManager postDataWithNSString:HXPOST_Get_BannerAndLogo withDictionary:dic success:^(NSDictionary * _Nonnull dictionary) {

        BOOL success = [dictionary boolValueForKey:@"Success"];
        if (success) {
            self.bannerLogoModel = [HXBannerLogoModel mj_objectWithKeyValues:[dictionary objectForKey:@"Data"]];
            [HXPublicParamTool sharedInstance].jiGouLogoUrl = HXSafeString(self.bannerLogoModel.logoUrl);
            //刷新banner数据和底部logo
            NSMutableArray *imageURLStringsGroup = [NSMutableArray array];
            [self.bannerLogoModel.bannerList enumerateObjectsUsingBlock:^(HXBannerModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [imageURLStringsGroup addObject:HXSafeString(obj.titleLink)];
            }];
            self.studyTableHeaderView.bannerView.imageURLStringsGroup = imageURLStringsGroup;
            [self.logoImageView sd_setImageWithURL:[NSURL URLWithString:HXSafeString(self.bannerLogoModel.logoUrl)] placeholderImage:[UIImage imageNamed:@"xuexi_logo"] options:SDWebImageRefreshCached];
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
        HXVersionModel *versionModel = obj;
        if (versionModel.isSelected) {
            self.custommNavView.selectVersionModel = versionModel;
            [versionModel.majorList enumerateObjectsUsingBlock:^(HXMajorModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.isSelected) {
                    [HXPublicParamTool sharedInstance].selectMajorModel = obj;
                    NSString *title = [NSString stringWithFormat:@"%@  %@",versionModel.versionName,obj.educationName];
                    [self.studyTableHeaderView.versionBtn setTitle:title forState:UIControlStateNormal];
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
    //获取Banner和Logo
    [self getBannerAndLogo];
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
    }else if(flag == 3){//切换类型
        [self  selectStudyType];
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
    if (section == 0) {
        return  self.courseList.count;
    }else if (section == 1) {
        return  2;
    }else{
        return  4;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        HXCourseModel *courseModel = self.courseList[indexPath.row];
        CGFloat rowHeight = [tableView cellHeightForIndexPath:indexPath
                                                             model:courseModel keyPath:@"courseModel"
                                                         cellClass:([HXCourseLearnCell class])
                                                  contentViewWidth:kScreenWidth];
        return rowHeight;
    }else{
        return 160;
    }
    return 0;
    

}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return self.todayView;
    }else if(section == 2){
        return self.yesterdayView;
    }else{
        return nil;
    }
}

//-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    if (section == 0) {
//        return self.lastLearnView;
//    }
//    return nil;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return  0.01;
    }else{
        return  40;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 0.01;
    }
    return 0.01;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
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
    }else{
        static NSString *studyCourseCellIdentifier = @"HXStudyCourseCellIdentifier";
        HXStudyCourseCell *cell = [tableView dequeueReusableCellWithIdentifier:studyCourseCellIdentifier];
        if (!cell) {
            cell = [[HXStudyCourseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:studyCourseCellIdentifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
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
        _mainTableView.tableFooterView = self.studyTableFooterView;
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

-(UIView *)studyTableFooterView{
    if (!_studyTableFooterView) {
        _studyTableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 80)];
        [_studyTableFooterView addSubview:self.logoImageView];
        self.logoImageView.sd_layout
        .centerYEqualToView(_studyTableFooterView)
        .centerXEqualToView(_studyTableFooterView)
        .widthIs(kScreenWidth)
        .heightIs(48);
    }
    return _studyTableFooterView;
}

-(UIImageView *)logoImageView{
    if (!_logoImageView) {
        _logoImageView = [[UIImageView alloc] init];
        _logoImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _logoImageView;
}

- (UIView *)lastLearnView{
    if (!_lastLearnView) {
        _lastLearnView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
        UILabel *label = [[UILabel alloc] init];
        label.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        [_lastLearnView addSubview:label];
        label.sd_layout
        .centerYEqualToView(_lastLearnView)
        .leftSpaceToView(_lastLearnView, _kpw(23))
        .rightSpaceToView(_lastLearnView, _kpw(23))
        .heightIs(25);
        label.font = HXBoldFont(18);
        label.text = @"上次学到哪";
    }
    return _lastLearnView;
}

- (UIView *)todayView{
    if (!_todayView) {
        _todayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
        UILabel *label = [[UILabel alloc] init];
        label.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        [_todayView addSubview:label];
        label.sd_layout
        .centerYEqualToView(_todayView)
        .leftSpaceToView(_todayView, _kpw(23))
        .rightSpaceToView(_todayView, _kpw(23))
        .heightIs(22);
        label.font = HXFont(16);
        label.text = @"今天";
    }
    return _todayView;
}

- (UIView *)yesterdayView{
    if (!_yesterdayView) {
        _yesterdayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
        UILabel *label = [[UILabel alloc] init];
        label.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        [_yesterdayView addSubview:label];
        label.sd_layout
        .centerYEqualToView(_yesterdayView)
        .leftSpaceToView(_yesterdayView, _kpw(23))
        .rightSpaceToView(_yesterdayView, _kpw(23))
        .heightIs(22);
        label.font = HXFont(16);
        label.text = @"昨天";
    }
    return _yesterdayView;
}

-(HXStudyGuideView *)studyGuideView{
    if (!_studyGuideView) {
        [self.studyTableHeaderView.versionBtn updateLayout];
        CGRect rect = [self.studyTableHeaderView convertRect:self.studyTableHeaderView.versionBtn.frame toView:[UIApplication sharedApplication].keyWindow];
        _studyGuideView = [[HXStudyGuideView alloc] initWithFrame:[UIScreen mainScreen].bounds WithRect:rect];
    }
    return _studyGuideView;
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
