//
//  HXApplyCoursesViewController.m
//  HXMinedu
//
//  Created by mac on 2021/3/29.
//

#import "HXApplyCoursesViewController.h"
#import "HXSelectDateHeaderView.h"
#import "HXDateHeaderView.h"
#import "HXCourseCell.h"

@interface HXApplyCoursesViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(strong,nonatomic) UITableView *mainTableView;
@property(strong,nonatomic) HXSelectDateHeaderView *selectDateHeaderView;
@property(strong,nonatomic) NSMutableArray *dataArray;

@end

@implementation HXApplyCoursesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadData];
    [self.view addSubview:self.selectDateHeaderView];
    [self.view addSubview:self.mainTableView];
}

-(void)loadData{
    
    
    
}

#pragma mark - <UITableViewDelegate,UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arc4random()%5+1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString * dateHeaderViewIdentifier = @"HXDateHeaderViewIdentifier";
    HXDateHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:dateHeaderViewIdentifier];
    if (!headerView) {
        headerView = [[HXDateHeaderView alloc] initWithReuseIdentifier:dateHeaderViewIdentifier];
    }
    headerView.isFirst = section==0?YES:NO;
    headerView.isLast = section==4?YES:NO;
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *courseCellIdentifier = @"HXCourseCellIdentifier";
    HXCourseCell *cell = [tableView dequeueReusableCellWithIdentifier:courseCellIdentifier];
    if (!cell) {
        cell = [[HXCourseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:courseCellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.isLast = indexPath.section == 4?YES:NO;
    return cell;
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}




#pragma mark - lazyload
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
-(UITableView *)mainTableView{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 60, kScreenWidth, kScreenHeight-kNavigationBarHeight-kTabBarHeight-58-60) style:UITableViewStyleGrouped];
        _mainTableView.bounces = NO;
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
-(HXSelectDateHeaderView *)selectDateHeaderView{
    if (!_selectDateHeaderView) {
        _selectDateHeaderView = [[HXSelectDateHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
    }
    return _selectDateHeaderView;
}
@end
