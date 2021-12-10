//
//  HXInfoConfirmViewController.m
//  HXMinedu
//
//  Created by mac on 2021/4/9.
//

#import "HXInfoConfirmViewController.h"
#import "HXInfoConfirmChildViewController.h"
#import "XLPageViewController.h"
#import "HXStudentFileModel.h"
#import "HXNoDataTipView.h"

@interface HXInfoConfirmViewController ()<XLPageViewControllerDelegate,XLPageViewControllerDataSrouce>
@property (nonatomic, strong) XLPageViewControllerConfig *config;
@property (nonatomic, strong) XLPageViewController *pageViewController;
@property (nonatomic,strong)  NSMutableArray *dataList;

@property (nonatomic,strong) HXNoDataTipView *noDataTipView;

@end

@implementation HXInfoConfirmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //UI
    [self createUI];
    //获取学生图片信息
    [self getStudentFile];
}

#pragma mark -<XLPageViewControllerDelegate,XLPageViewControllerDataSrouce>
- (UIViewController *)pageViewController:(XLPageViewController *)pageViewController viewControllerForIndex:(NSInteger)index {
    HXInfoConfirmChildViewController *childVc = [[HXInfoConfirmChildViewController alloc] init];
    HXStudentFileModel *model = self.dataList[index];
    childVc.pictureInfoList = model.studentFileInfoList;
    return childVc;
}

- (NSString *)pageViewController:(XLPageViewController *)pageViewController titleForIndex:(NSInteger)index {
    HXStudentFileModel *model = self.dataList[index];
    return model.title;
}

- (NSInteger)pageViewControllerNumberOfPage {
    return self.dataList.count;
}

- (void)pageViewController:(XLPageViewController *)pageViewController didSelectedAtIndex:(NSInteger)index {
   
}


#pragma mark - 获取学生图片信息
-(void)getStudentFile{
    
    [self.view showLoading];
    [HXBaseURLSessionManager postDataWithNSString:HXPOST_Get_StudentFile  withDictionary:nil success:^(NSDictionary * _Nonnull dictionary) {
        [self.view hideLoading];
        BOOL success = [dictionary boolValueForKey:@"Success"];
        if (success) {
            [self.dataList removeAllObjects];
            NSArray *data = [HXStudentFileModel mj_objectArrayWithKeyValuesArray:[dictionary objectForKey:@"Data"]];
            [self.dataList addObjectsFromArray:data];
            if (self.dataList.count == 0) {
                [self.view addSubview:self.noDataTipView];
            }else{
                [self initPageViewController];
                [self.noDataTipView removeFromSuperview];
            }
        }
    } failure:^(NSError * _Nonnull error) {
        [self.view hideLoading];
    }];
}


#
#pragma mark - UI
-(void)createUI{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.sc_navigationBar.title = @"图片信息确认";

}

///初始化子视图控制器
- (void)initPageViewController {
    self.pageViewController = [[XLPageViewController alloc] initWithConfig:self.config];
    self.pageViewController.bounces = NO;
    self.pageViewController.view.frame = CGRectMake(0, kNavigationBarHeight, kScreenWidth, kScreenHeight-kNavigationBarHeight);
    self.pageViewController.delegate = self;
    self.pageViewController.dataSource = self;
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
}

///显示配置
-(XLPageViewControllerConfig *)config{
    XLPageViewControllerConfig *config = [XLPageViewControllerConfig defaultConfig];
    config.titleViewBackgroundColor = COLOR_WITH_ALPHA(0xffffff, 1);
    config.titleViewHeight = 58;
    config.titleSpace = _kpw(20);
    config.titleViewInset = UIEdgeInsetsMake(0, _kpw(24), 0, _kpw(24));
    config.titleViewAlignment = XLPageTitleViewAlignmentLeft;
    config.titleViewShadowShow = NO;
    config.shadowLineWidth = _kpw(36);
    config.shadowLineHeight = 3;
    config.shadowLineAlignment = XLPageShadowLineAlignmentTitleBottom;
    config.isGradientColor = YES;
    config.separatorLineHidden =YES;
    config.titleNormalColor = COLOR_WITH_ALPHA(0xAFAFAF, 1);
    config.titleSelectedColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
    config.titleNormalFont = [UIFont systemFontOfSize:_kpAdaptationWidthFont(14)];
    config.titleSelectedFont =[UIFont boldSystemFontOfSize:_kpAdaptationWidthFont(16)];
    return config;
}

-(NSMutableArray *)dataList{
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

-(HXNoDataTipView *)noDataTipView{
    if (!_noDataTipView) {
        _noDataTipView = [[HXNoDataTipView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight, kScreenWidth, kScreenHeight-kNavigationBarHeight)];

    }
    return _noDataTipView;
}

-(void)dealloc{
    ///重新初始化子视图控制器,这里会多次调用，在调用之前先移除原先的，避免多次添加
    [self.pageViewController removeFromParentViewController];
    self.pageViewController = nil;
    self.pageViewController.delegate = nil;
    self.pageViewController.dataSource = nil;
    [self.pageViewController.view removeFromSuperview];
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
