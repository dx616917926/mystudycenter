
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
#import "HXNoDataTipView.h"
#import "HXCourseLearnRecordModel.h"
#import "HXCourseModel.h"
#import "HXBannerLogoModel.h"
#import "SDWebImage.h"
#import "HXCourseToastView.h"


@interface HXStudyViewController ()<UITableViewDelegate,UITableViewDataSource,HXStudyTableHeaderViewDelegate,HXCourseLearnCellDelegate>

@property(nonatomic,strong) HXCustommNavView *custommNavView;
@property (nonatomic, strong) HXVersionModel *selectVersionModel;


@property(strong,nonatomic) UITableView *mainTableView;
@property(strong,nonatomic) HXStudyTableHeaderView *studyTableHeaderView;

@property(strong,nonatomic) UIView *lastLearnView;
@property(strong,nonatomic) UIView *todayView;
@property(strong,nonatomic) UIView *yesterdayView;

@property(strong,nonatomic) UIView *studyTableFooterView;
@property(strong,nonatomic) HXNoDataTipView *noDataTipView;
@property(strong,nonatomic) UIImageView *logoImageView;

@property(strong,nonatomic) HXStudyGuideView *studyGuideView;

@property(strong,nonatomic) HXKJCXXCourseListModel *kjxxCourseListtModel;
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
    [self.mainTableView setContentOffset:CGPointZero animated:NO];
    [self.view showLoading];
    [HXBaseURLSessionManager postDataWithNSString:HXPOST_Get_Version_Major_List withDictionary:nil success:^(NSDictionary * _Nonnull dictionary) {
        [self.mainTableView.mj_header endRefreshing];
        [self.view hideLoading];
        BOOL success = [dictionary boolValueForKey:@"Success"];
        if (success) {
            
            //            if ([HXPublicParamTool sharedInstance].versionList.count>0) {//原来有值
            //                //保持原来选中的
            //                __block HXVersionModel *selectVersionModel;
            //                __block HXMajorModel *selectMajorModel;
            //                [[HXPublicParamTool sharedInstance].versionList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            //                    HXVersionModel *versionModel = obj;
            //                    if (versionModel.isSelected) {
            //                        selectVersionModel = versionModel;
            //                        [versionModel.majorList enumerateObjectsUsingBlock:^(HXMajorModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            //                            if (obj.isSelected) {
            //                                selectMajorModel = obj;
            //                                *stop = YES;
            //                                return;
            //                            }
            //                        }];
            //                        *stop = YES;
            //                        return;
            //                    }
            //                }];
            //                //重新赋值
            //                [HXPublicParamTool sharedInstance].versionList = [HXVersionModel mj_objectArrayWithKeyValuesArray:[dictionary objectForKey:@"Data"]];
            //                [[HXPublicParamTool sharedInstance].versionList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            //                    HXVersionModel *versionModel = obj;
            //                    if ([versionModel.versionId isEqualToString:selectVersionModel.versionId]&&[versionModel.versionName isEqualToString:selectVersionModel.versionName]&&versionModel.type==selectVersionModel.type) {
            //                        versionModel.isSelected = YES;
            //                        [versionModel.majorList enumerateObjectsUsingBlock:^(HXMajorModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            //                            if ([obj.major_id isEqualToString:selectMajorModel.major_id]&&[obj.versionId isEqualToString:selectMajorModel.versionId]&&obj.type==selectMajorModel.type) {
            //                                obj.isSelected = YES;
            //                                *stop = YES;
            //                                return;
            //                            }
            //                        }];
            //                        *stop = YES;
            //                        return;
            //                    }
            //                }];
            //            }else{
            //                //////由于报考类型数据多处用到，避免频繁获取，此处保存在单例中
            //                [HXPublicParamTool sharedInstance].versionList = [HXVersionModel mj_objectArrayWithKeyValuesArray:[dictionary objectForKey:@"Data"]];
            //                ///默认选择第一个
            //                HXVersionModel *model = [HXPublicParamTool sharedInstance].versionList.firstObject;
            //                model.isSelected = YES;
            //                HXMajorModel *majorModel = model.majorList.firstObject;
            //                majorModel.isSelected = YES;
            //            }
            
            
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
            HXCourseLearnRecordModel *courseLearnRecordModel = [HXCourseLearnRecordModel mj_objectWithKeyValues:[dictionary objectForKey:@"Data"]];
            self.courseList = courseLearnRecordModel.courseInfoList;
            self.kjxxCourseListtModel = courseLearnRecordModel.kjxxCourseListModel;
            if (self.courseList.count == 0 && self.kjxxCourseListtModel.nowadaysList.count == 0 && self.kjxxCourseListtModel.yesterdayList.count == 0) {
                self.noDataTipView.sd_layout.heightIs(_kpw(280));
            }else{
                self.noDataTipView.sd_layout.heightIs(0);
            }
            [self.noDataTipView updateLayout];
            [self.mainTableView reloadData];
            
            //遍历,是否有新课件
            __block BOOL showToast = NO;
            [self.courseList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                HXCourseModel *model = obj;
                NSString *courseIdKey = [NSString stringWithFormat:@"course_id+%@",model.course_id];
                BOOL hasKey = [HXUserDefaults boolForKey:courseIdKey];
                if (model.isHisVersion == 1 && !hasKey) {
                    [HXUserDefaults setBool:YES forKey:courseIdKey];
                    showToast = YES;
                }
            }];
            
            if (showToast) {
                HXCourseToastView *toastView = [[HXCourseToastView alloc] init];
                [toastView showToastHideAfter:3];
            }
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
                NSString *encodeStr = [HXCommonUtil stringEncoding:HXSafeString(obj.titleLink)];
                [imageURLStringsGroup addObject:encodeStr];
            }];
            self.studyTableHeaderView.bannerView.imageURLStringsGroup = imageURLStringsGroup;
            [self.logoImageView sd_setImageWithURL:[NSURL URLWithString:[HXCommonUtil stringEncoding:self.bannerLogoModel.logoUrl]] placeholderImage:[UIImage imageNamed:@"xuexi_logo"] options:SDWebImageRefreshCached];
        }
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

//获取登录状态
-(void)getLoginStatus:(void (^)(BOOL status))finishBlock{
    [HXBaseURLSessionManager postDataWithNSString:HXPOST_GetLoginStatus withDictionary:nil success:^(NSDictionary * _Nonnull dictionary) {
        BOOL success = [dictionary boolValueForKey:@"Success"];
        if (success) {
            finishBlock(YES);
        }else{
            finishBlock(NO);
        }
    } failure:^(NSError * _Nonnull error) {
        finishBlock(NO);
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
        [self.tabBarController.tabBar.items enumerateObjectsUsingBlock:^(UITabBarItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.title isEqualToString:@"直播"]) {
                [self.tabBarController setSelectedIndex:idx];
                *stop = YES;
                return;;
            }
        }];
    }else if(flag == 3){//切换类型
        [self  selectStudyType];
    }
    
}

#pragma mark - <HXCourseLearnCellDelegate>
-(void)handleType:(HXClickType)type withItem:(HXModelItem *)item{
    switch (type) {
        case HXKeJianXueXiClickType://课件学习
        {
            if ([item.Type isEqualToString:@"1"]) {
                //课件学习模块,先判断登陆状态
                [self getLoginStatus:^(BOOL status) {
                    if (status) {
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
                }];
                
                
            }else if ([item.Type isEqualToString:@"2"]) {
                //考试模块
                HXExamListViewController *listVC = [[HXExamListViewController alloc] init];
                listVC.authorizeUrl = item.ExamUrl;
                listVC.title = item.ModuleName;
                listVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:listVC animated:YES];
            }else{
                [self.view showTostWithMessage:@"暂不支持此模块"];
            }
            
        }
            break;
        case HXPingShiZuoYeClickType://平时作业
        case HXQiMoKaoShiClickType://期末考试
        case HXLiNianZhenTiClickType://历年真题
        {
            if ([item.Type isEqualToString:@"1"]) {
                //课件学习模块,先判断登陆状态
                [self getLoginStatus:^(BOOL status) {
                    if (status) {
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
                }];
                
                
            }else if ([item.Type isEqualToString:@"2"]) {
                //考试模块
                HXExamListViewController *listVC = [[HXExamListViewController alloc] init];
                listVC.authorizeUrl = item.ExamUrl;
                listVC.title = item.ModuleName;
                listVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:listVC animated:YES];
            }else{
                [self.view showTostWithMessage:@"暂不支持此模块"];
            }
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - <UITableViewDelegate,UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return  self.courseList.count;
    }else if (section == 1) {
        return  self.kjxxCourseListtModel.nowadaysList.count;
    }else{
        return  self.kjxxCourseListtModel.yesterdayList.count;
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
    if (section == 1 && self.kjxxCourseListtModel.nowadaysList.count>0) {
        return self.todayView;
    }else if(section == 2 && self.kjxxCourseListtModel.yesterdayList.count>0){
        return self.yesterdayView;
    }else{
        return nil;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 0 && (self.kjxxCourseListtModel.nowadaysList.count>0||self.kjxxCourseListtModel.yesterdayList.count>0) ) {
        return self.lastLearnView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 1 && self.kjxxCourseListtModel.nowadaysList.count>0) {
        return 40;
    }else if(section == 2 && self.kjxxCourseListtModel.yesterdayList.count>0){
        return 40;
    }else{
        return 0.01;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0 && (self.kjxxCourseListtModel.nowadaysList.count>0||self.kjxxCourseListtModel.yesterdayList.count>0)) {
        return 40;
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
        if (indexPath.section == 1) {
            cell.learnRecordModel = self.kjxxCourseListtModel.nowadaysList[indexPath.row];
        }else{
            cell.learnRecordModel = self.kjxxCourseListtModel.yesterdayList[indexPath.row];
        }
        return cell;
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //课件学习模块,先判断登陆状态
    [self getLoginStatus:^(BOOL status) {
        if (status) {
            TXMoviePlayerController *playerVC = [[TXMoviePlayerController alloc] init];
            if (@available(iOS 13.0, *)) {
                playerVC.barStyle = UIStatusBarStyleDarkContent;
            } else {
                playerVC.barStyle = UIStatusBarStyleDefault;
            }
            playerVC.barStyle = UIStatusBarStyleDefault;
            playerVC.hidesBottomBarWhenPushed = YES;
            if (indexPath.section == 1) {
                HXLearnRecordModel *learnRecordModel = self.kjxxCourseListtModel.nowadaysList[indexPath.row];
                if ([HXCommonUtil isNull:learnRecordModel.cws_param]) return;
                playerVC.cws_param = learnRecordModel.cws_param;
                [self.navigationController pushViewController:playerVC animated:YES];
            }else if(indexPath.section == 2){
                HXLearnRecordModel *learnRecordModel = self.kjxxCourseListtModel.yesterdayList[indexPath.row];
                if ([HXCommonUtil isNull:learnRecordModel.cws_param]) return;
                playerVC.cws_param = learnRecordModel.cws_param;
                [self.navigationController pushViewController:playerVC animated:YES];
            }
        }
    }];
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
        _studyTableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _studyTableFooterView.clipsToBounds = YES;
        [_studyTableFooterView addSubview:self.noDataTipView];
        [_studyTableFooterView addSubview:self.logoImageView];
        
        self.noDataTipView.sd_layout
        .topEqualToView(_studyTableFooterView)
        .leftEqualToView(_studyTableFooterView)
        .rightEqualToView(_studyTableFooterView)
        .heightIs(0);
        
        self.logoImageView.sd_layout
        .topSpaceToView(self.noDataTipView, 10)
        .centerXEqualToView(_studyTableFooterView)
        .widthIs(kScreenWidth)
        .heightIs(48);
        
        [_studyTableFooterView setupAutoHeightWithBottomView:self.logoImageView bottomMargin:30];
        
    }
    return _studyTableFooterView;
}

-(HXNoDataTipView *)noDataTipView{
    if (!_noDataTipView) {
        _noDataTipView = [[HXNoDataTipView alloc] initWithFrame:CGRectZero];
        _noDataTipView.backgroundColor = [UIColor whiteColor];
        _noDataTipView.tipTitle = @"暂无数据~";
        _noDataTipView.tipImageViewOffset = 10;
    }
    return _noDataTipView;
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
