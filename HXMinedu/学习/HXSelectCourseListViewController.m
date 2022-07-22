//
//  HXSelectListViewController.m
//  HXMinedu
//
//  Created by mac on 2022/2/15.
//

#import "HXSelectCourseListViewController.h"
#import "HXSelectCourseCell.h"
#import "HXMoocViewController.h"
#import <TXMoviePlayer/TXMoviePlayerController.h>

@interface HXSelectCourseListViewController ()<UITableViewDelegate,UITableViewDataSource,HXSelectCourseCellDelegate>

@property(strong,nonatomic) UITableView *mainTableView;
//课程课件学习数组
@property (nonatomic, strong) NSArray *courseList;
@end

@implementation HXSelectCourseListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //UI
    [self createUI];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //获取课程考试列表
    [self pullDownRefrsh];
}

-(void)setType:(HXClickType)type{
    _type = type;
}

#pragma mark -  下拉刷新
-(void)pullDownRefrsh{
    
    HXMajorModel *selectMajorModel = [HXPublicParamTool sharedInstance].selectMajorModel;
    NSDictionary *dic = @{
        @"version_id":HXSafeString(selectMajorModel.versionId),
        @"type":@(selectMajorModel.type),
        @"major_id":HXSafeString(selectMajorModel.major_id),
        @"course_id":HXSafeString(self.course_id)
        
    };
    
    [HXBaseURLSessionManager postDataWithNSString:HXPOST_GetCourseKjList withDictionary:dic success:^(NSDictionary * _Nonnull dictionary) {
        [self.mainTableView.mj_header endRefreshing];
        BOOL success = [dictionary boolValueForKey:@"Success"];
        if (success) {
            NSArray *list = [HXCourseModel mj_objectArrayWithKeyValuesArray:[dictionary objectForKey:@"Data"]];
            self.courseList = list;
            [self.mainTableView reloadData];
        }
    } failure:^(NSError * _Nonnull error) {
        [self.mainTableView.mj_header endRefreshing];
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

//修改学习次数
-(void)changeWatchVideoNum{
    HXMajorModel *selectMajorModel = [HXPublicParamTool sharedInstance].selectMajorModel;
    NSDictionary *dic = @{
        @"studentCourseID":HXSafeString(self.studentCourseID),
        @"type":@(selectMajorModel.type)
    };
    
    [HXBaseURLSessionManager postDataWithNSString:HXPOST_ChangeWatchVideoNum withDictionary:dic success:^(NSDictionary * _Nonnull dictionary) {
    
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

#pragma mark - <HXSelectCourseCellDelegate>
-(void)handleItem:(HXModelItem *)item{
    //课件学习模块,先判断登陆状态
    WeakSelf(weakSelf);
    [self getLoginStatus:^(BOOL status) {
        StrongSelf(strongSelf);
        if (status) {
            if ([item.StemCode isEqualToString:@"MOOC"]) {//慕课
                HXMoocViewController *vc = [[HXMoocViewController alloc] init];
                vc.titleName = item.courseName;
                vc.moocUrl = [item.mooc_param stringValueForKey:@"coursewareHtmlUrl"];
                vc.hidesBottomBarWhenPushed = YES;
                [strongSelf.navigationController pushViewController:vc animated:YES];
                
            }else{
                TXMoviePlayerController *playerVC = [[TXMoviePlayerController alloc] init];
                if (@available(iOS 13.0, *)) {
                    playerVC.barStyle = UIStatusBarStyleDarkContent;
                } else {
                    playerVC.barStyle = UIStatusBarStyleDefault;
                }
                playerVC.cws_param = item.cws_param;
                playerVC.barStyle = UIStatusBarStyleDefault;
                playerVC.showLearnFinishStyle = YES;
                playerVC.hidesBottomBarWhenPushed = YES;
                [strongSelf.navigationController pushViewController:playerVC animated:YES];
            }
            //修改学习次数
            [strongSelf changeWatchVideoNum];
            
        }
    }];
    
}
#pragma mark - <UITableViewDelegate,UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.courseList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 180;
    
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *selectCourseCellIdentifier = @"HXSelectCourseCellIdentifier";
    HXSelectCourseCell *cell = [tableView dequeueReusableCellWithIdentifier:selectCourseCellIdentifier];
    if (!cell) {
        cell = [[HXSelectCourseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:selectCourseCellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.type = self.type;
    cell.delegate = self;
    HXCourseModel *courseModel = self.courseList[indexPath.row];
    cell.courseModel = courseModel;
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UI
-(void)createUI{
    
    switch (self.type) {
        case HXKeJianXueXiClickType:
            self.sc_navigationBar.title = @"选择课件学习";
            break;
        case HXPingShiZuoYeClickType:
            self.sc_navigationBar.title = @"选择平时作业";
            break;
        case HXQiMoKaoShiClickType:
            self.sc_navigationBar.title = @"选择期末考试";
            break;
        case HXLiNianZhenTiClickType:
            self.sc_navigationBar.title = @"选择历年真题";
            break;
        default:
            break;
    }
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_14_5
    if (@available(iOS 15.0, *)) {
        self.mainTableView.sectionHeaderTopPadding = 0;
    }
#endif
    [self.view addSubview:self.mainTableView];
    
    // 下拉刷新
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(pullDownRefrsh)];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    header.automaticallyChangeAlpha = YES;
    //设置header
    self.mainTableView.mj_header = header;
           
}

#pragma mark - lazyload
-(UITableView *)mainTableView{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavigationBarHeight, kScreenWidth, kScreenHeight-kNavigationBarHeight) style:UITableViewStylePlain];
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
    }
    return _mainTableView;
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
