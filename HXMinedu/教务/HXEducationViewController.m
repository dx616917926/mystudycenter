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

//报考类型数组
@property (nonatomic, strong) NSArray *versionList;
@property (nonatomic, strong) HXVersionModel *selectVersionModel;
@property (nonatomic, strong) HXMajorModel *selectMajorModel;

//课程分类数组
@property (nonatomic, strong) NSArray *courseTypeList;


@end

@implementation HXEducationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    //布局UI
    [self createUI];

    //获取报考类型专业列表
    [self getVersionandMajorList];
    //登录成功的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getVersionandMajorList) name:LOGINSUCCESS object:nil];
}



#pragma mark - 网络请求
//获取报考类型专业列表
-(void)getVersionandMajorList{
    [self.view showLoading];
    [HXBaseURLSessionManager postDataWithNSString:HXPOST_Get_Version_Major_List withDictionary:nil success:^(NSDictionary * _Nonnull dictionary) {
        [self.view hideLoading];
        BOOL success = [dictionary boolValueForKey:@"Success"];
        if (success) {
            self.versionList = [HXVersionModel mj_objectArrayWithKeyValuesArray:[dictionary objectForKey:@"Data"]];
            ///刷新导航数据
            [self refreshNavBarData];
        }else{
            [self.view showErrorWithMessage:[dictionary stringValueForKey:@"Message"]];
        }
    } failure:^(NSError * _Nonnull error) {
        [self.view hideLoading];
    }];
}

//获取教学计划列表
-(void)getCourseScoreInfoList{
    NSDictionary *dic = @{
        @"version_id":HXSafeString(self.selectMajorModel.versionId),
        @"type":@(self.selectMajorModel.type),
        @"major_id":HXSafeString(self.selectMajorModel.major_id)
    };
    
    [HXBaseURLSessionManager postDataWithNSString:HXPOST_Get_CourseScoreIn_List withDictionary:dic success:^(NSDictionary * _Nonnull dictionary) {

        BOOL success = [dictionary boolValueForKey:@"Success"];
        if (success) {
            self.courseTypeList = [HXCourseTypeModel mj_objectArrayWithKeyValuesArray:[dictionary objectForKey:@"Data"]];
            ///初始化子视图控制器
            [self initPageViewController];
        }else{
            [self.view showErrorWithMessage:[dictionary stringValueForKey:@"Message"]];
        }
    } failure:^(NSError * _Nonnull error) {
    
    }];
}

///刷新导航数据
-(void)refreshNavBarData{
    //默认选中第一个类型里的第一个专业
    self.selectVersionModel = self.versionList.firstObject;
    self.selectVersionModel.isSelected = YES;
    self.selectMajorModel = self.selectVersionModel.majorList.firstObject;
    self.selectMajorModel.isSelected = YES;
    self.custommNavView.selectVersionModel = self.selectVersionModel;
    ///获取取教学计划列表数据
    [self getCourseScoreInfoList];
    
}

#pragma mark - event
-(void)selectStudyType{
    HXSelectStudyTypeViewController *vc =[[HXSelectStudyTypeViewController alloc] init];
    vc.versionList = self.versionList;
    //选择完成回调
    WeakSelf(weakSelf)
    vc.selectFinishCallBack = ^(NSArray * _Nonnull versionList, HXVersionModel * _Nonnull selectVersionModel, HXMajorModel * _Nonnull selectMajorModel) {
        weakSelf.versionList = versionList;
        weakSelf.selectVersionModel = selectVersionModel;
        weakSelf.selectMajorModel = selectMajorModel;
        weakSelf.custommNavView.selectVersionModel = selectVersionModel;
        ///重新拉取教学计划列表数据
        [weakSelf getCourseScoreInfoList];
    };
    [self presentViewController:vc animated:YES completion:nil];
}


#pragma mark - UI
-(void)createUI{
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



#pragma mark TableViewDelegate&DataSource
- (UIViewController *)pageViewController:(XLPageViewController *)pageViewController viewControllerForIndex:(NSInteger)index {
    if (index==0) {
        HXTeachPlanViewController *vc = [[HXTeachPlanViewController alloc] init];
        vc.courseTypeList = self.courseTypeList;
        return vc;
    }else if (index==1) {
        HXApplyCoursesViewController *vc = [[HXApplyCoursesViewController alloc] init];
        return vc;
    }else if (index==2) {
        HXExaminationResultsViewController *vc = [[HXExaminationResultsViewController alloc] init];
        return vc;
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
    NSLog(@"切换到");
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
