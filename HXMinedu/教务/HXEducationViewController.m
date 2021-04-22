//
//  HXEducationViewController.m
//  HXMinedu
//
//  Created by mac on 2021/3/29.
//

#import "HXEducationViewController.h"
#import "XLPageViewController.h"
#import "HXTeachPlanViewController.h"
#import "HXApplyCoursesViewController.h"
#import "HXExaminationResultsViewController.h"
#import "HXSelectStudyTypeViewController.h"
#import "HXCustommNavView.h"
#import "HXVersionModel.h"
#import "HXCourseTypeModel.h"

@interface HXEducationViewController ()<XLPageViewControllerDelegate,XLPageViewControllerDataSrouce>
//配置信息
@property (nonatomic, strong) XLPageViewControllerConfig *config;
@property (nonatomic, strong) XLPageViewController *pageViewController;
@property (nonatomic, strong) NSArray *titles;
@property(nonatomic,strong) HXCustommNavView *custommNavView;

@property (nonatomic, strong) HXVersionModel *selectVersionModel;


//课程分类数组
@property (nonatomic, strong) NSArray *courseTypeList;

@property (nonatomic, assign) BOOL isFirst;

@end

@implementation HXEducationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //布局UI
    [self createUI];
    
    self.isFirst = YES;
    
    //登录成功的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getVersionandMajorList) name:LOGINSUCCESS object:nil];
    ///监听<<报考类型专业改变>>通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshNavBarData) name:VersionAndMajorChangeNotification object:nil];
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    if (self.isFirst) {
        self.isFirst = NO;
        [self refreshNavBarData];
    }
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}


#pragma mark -  获取教学计划列表
//获取报考类型专业列表
-(void)getVersionandMajorList{
    [self.view showLoading];
    [HXBaseURLSessionManager postDataWithNSString:HXPOST_Get_Version_Major_List withDictionary:nil success:^(NSDictionary * _Nonnull dictionary) {
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
        }else{
            [self.view showErrorWithMessage:[dictionary stringValueForKey:@"Message"]];
        }
    } failure:^(NSError * _Nonnull error) {
        [self.view hideLoading];
    }];
}
-(void)getCourseScoreInfoList{
    [self.view showLoading];
    HXMajorModel *selectMajorModel = [HXPublicParamTool sharedInstance].selectMajorModel;
    NSDictionary *dic = @{
        @"version_id":HXSafeString(selectMajorModel.versionId),
        @"type":@(selectMajorModel.type),
        @"major_id":HXSafeString(selectMajorModel.major_id)
    };
    
    [HXBaseURLSessionManager postDataWithNSString:HXPOST_Get_CourseScoreIn_List withDictionary:dic success:^(NSDictionary * _Nonnull dictionary) {
        [self.view hideLoading];
        BOOL success = [dictionary boolValueForKey:@"Success"];
        if (success) {
            self.courseTypeList = [HXCourseTypeModel mj_objectArrayWithKeyValuesArray:[dictionary objectForKey:@"Data"]];
            ///初始化子视图控制器
            [self initPageViewController];
        }else{
            [self.view showErrorWithMessage:[dictionary stringValueForKey:@"Message"]];
        }
    } failure:^(NSError * _Nonnull error) {
        [self.view hideLoading];
    }];
}

///刷新导航数据
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
            return;
        }
    }];
    ///获取取教学计划列表数据
    [self getCourseScoreInfoList];
}

#pragma mark - event
-(void)selectStudyType{
    HXSelectStudyTypeViewController *vc =[[HXSelectStudyTypeViewController alloc] init];
    //选择完成回调
    WeakSelf(weakSelf)
    vc.selectFinishCallBack = ^(HXVersionModel * _Nonnull selectVersionModel, HXMajorModel * _Nonnull selectMajorModel) {
        weakSelf.selectVersionModel = selectVersionModel;
        [HXPublicParamTool sharedInstance].selectMajorModel = selectMajorModel;
    };
    [self presentViewController:vc animated:YES completion:nil];
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
}

///初始化子视图控制器
- (void)initPageViewController {
    ///重新初始化子视图控制器,这里会多次调用，在调用之前先移除原先的，避免多次添加
    [self.pageViewController removeFromParentViewController];
    self.pageViewController = nil;
    self.pageViewController.delegate = nil;
    self.pageViewController.dataSource = nil;
    [self.pageViewController.view removeFromSuperview];
    
    self.titles = @[@"教学计划",@"报考课程",@"考试成绩"];
    self.pageViewController = [[XLPageViewController alloc] initWithConfig:self.config];
    self.pageViewController.bounces = NO;
    self.pageViewController.view.frame = CGRectMake(0, kNavigationBarHeight, kScreenWidth, kScreenHeight-kNavigationBarHeight-kTabBarHeight);
    self.pageViewController.delegate = self;
    self.pageViewController.dataSource = self;
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
}



#pragma mark -<XLPageViewControllerDelegate,XLPageViewControllerDataSrouce>
- (UIViewController *)pageViewController:(XLPageViewController *)pageViewController viewControllerForIndex:(NSInteger)index {
    HXMajorModel *selectMajorModel = [HXPublicParamTool sharedInstance].selectMajorModel;
    if (index==0) {
        HXTeachPlanViewController *teachPlanVc = [[HXTeachPlanViewController alloc] init];
        teachPlanVc.courseTypeList = self.courseTypeList;
        return teachPlanVc;
    }else if (index==1) {
        HXApplyCoursesViewController *applyCoursesVC = [[HXApplyCoursesViewController alloc] init];
        applyCoursesVC.selectMajorModel = selectMajorModel;
        return applyCoursesVC;
    }else if (index==2) {
        HXExaminationResultsViewController *examinationResultsVc = [[HXExaminationResultsViewController alloc] init];
        examinationResultsVc.selectMajorModel = selectMajorModel;
        return examinationResultsVc;
    }
    return nil;
}

- (NSString *)pageViewController:(XLPageViewController *)pageViewController titleForIndex:(NSInteger)index {
    return self.titles[index];
}

- (NSInteger)pageViewControllerNumberOfPage {
    return self.titles.count;
}

- (void)pageViewController:(XLPageViewController *)pageViewController didSelectedAtIndex:(NSInteger)index {
   
}




#pragma mark - lazyload
-(HXCustommNavView *)custommNavView{
    if (!_custommNavView) {
        _custommNavView = [[HXCustommNavView alloc] initWithFrame:CGRectMake(0, kStatusBarHeight, kScreenWidth, kNavigationBarHeight-kStatusBarHeight)];
    }
    return _custommNavView;
}


///显示配置
-(XLPageViewControllerConfig *)config{
    XLPageViewControllerConfig *config = [XLPageViewControllerConfig defaultConfig];
    config.titleViewHeight = 58;
    config.titleSpace = _kpw(24);
    config.titleViewInset = UIEdgeInsetsMake(0, _kpw(24), 0, _kpw(24));
    config.titleViewAlignment = XLPageTitleViewAlignmentLeft;
    config.titleViewShadowShow = YES;
    config.shadowLineWidth = _kpw(36);
    config.shadowLineHeight = 3;
    config.shadowLineAlignment = XLPageShadowLineAlignmentTitleBottom;
    config.isGradientColor = YES;
    config.separatorLineHidden =YES;
    config.titleNormalColor = COLOR_WITH_ALPHA(0xAFAFAF, 1);
    config.titleSelectedColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
    config.titleNormalFont = [UIFont systemFontOfSize:_kpAdaptationWidthFont(12)];
    config.titleSelectedFont =[UIFont boldSystemFontOfSize:_kpAdaptationWidthFont(16)];
    return config;
}



@end
