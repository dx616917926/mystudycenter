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
#import "HXShowExamDateView.h"
#import "HXNoDataTipView.h"
#import "XLPageViewControllerUtil.h"
#import "HXExamDateModel.h"
@interface HXApplyCoursesViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(strong,nonatomic) UITableView *mainTableView;
@property(strong,nonatomic) HXSelectDateHeaderView *selectDateHeaderView;
@property(strong,nonatomic) NSArray *examDateList;
@property(strong,nonatomic) HXExamDateModel *selectExamDateModel;
@property(strong,nonatomic) HXShowExamDateView *showExamDateView;
@property(strong,nonatomic) HXNoDataTipView *noDataTipView;

@end

@implementation HXApplyCoursesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //UI
    [self createUI];
    //获取报考课程列表
    [self getExamDateSignInfoList];
    
}



#pragma mark -  获取报考课程列表
-(void)getExamDateSignInfoList{
    
    NSDictionary *dic = @{
        @"major_id":HXSafeString(self.selectMajorModel.major_id)
    };
    
    [HXBaseURLSessionManager postDataWithNSString:HXPOST_Get_ExamDateSignInfo_List withDictionary:dic success:^(NSDictionary * _Nonnull dictionary) {
        
        BOOL success = [dictionary boolValueForKey:@"Success"];
        if (success) {
            self.examDateList = [HXExamDateModel mj_objectArrayWithKeyValuesArray:[dictionary objectForKey:@"Data"]];
            self.selectExamDateModel = self.examDateList.firstObject;
            self.selectExamDateModel.isSelected = YES;
            [self refreshUI];
        }
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

#pragma mark - 选择考期
-(void)selectExamDate:(UIButton *)sender{
    if (self.examDateList.count<=0) return;
    self.showExamDateView.dataArray = self.examDateList;
    [self.showExamDateView show];
    ///选择日期回调
    WeakSelf(weakSelf);
    self.showExamDateView.selectExamDateCallBack = ^(BOOL isRefresh, HXExamDateModel * _Nonnull selectExamDateModel) {
        if (isRefresh){
            weakSelf.selectExamDateModel = selectExamDateModel;
            [weakSelf refreshUI];
        }
    };
}

#pragma mark - 刷新数据
-(void)refreshUI{
    if (self.examDateList.count == 0) {
        self.selectDateHeaderView.hidden = YES;
        [self.view addSubview:self.noDataTipView];
    }else{
        self.selectDateHeaderView.hidden = NO;
        [self.noDataTipView removeFromSuperview];
    }
    NSString *examDate = [NSString stringWithFormat:@"%@",self.selectExamDateModel.examDate];
    [self.selectDateHeaderView.selectDateBtn setTitle:examDate forState:UIControlStateNormal];
    [self.mainTableView reloadData];
}

#pragma mark - <UITableViewDelegate,UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.selectExamDateModel.examDayList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    HXExamDayModel *dayModel = self.selectExamDateModel.examDayList[section];
    return dayModel.examDateSignInfoList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HXExamDayModel *dayModel = self.selectExamDateModel.examDayList[indexPath.section];
    HXExamDateSignInfoModel *examDateSignInfoModel = dayModel.examDateSignInfoList[indexPath.row];
    CGFloat rowHeight = [tableView cellHeightForIndexPath:indexPath
                                                         model:examDateSignInfoModel keyPath:@"examDateSignInfoModel"
                                                     cellClass:([HXCourseCell class])
                                              contentViewWidth:kScreenWidth];
    return rowHeight;
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
    HXExamDayModel *dayModel = self.selectExamDateModel.examDayList[section];
    
    static NSString * dateHeaderViewIdentifier = @"HXDateHeaderViewIdentifier";
    HXDateHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:dateHeaderViewIdentifier];
    if (!headerView) {
        headerView = [[HXDateHeaderView alloc] initWithReuseIdentifier:dateHeaderViewIdentifier];
    }
    headerView.isFirst = section==0?YES:NO;
    headerView.isLast = (section == (self.selectExamDateModel.examDayList.count-1)?YES:NO);
    headerView.dayModel = dayModel;
    
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
    [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    //最后一组的cell隐藏虚线
    cell.isLast = (indexPath.section == (self.selectExamDateModel.examDayList.count-1)?YES:NO);
    HXExamDayModel *dayModel = self.selectExamDateModel.examDayList[indexPath.section];
    HXExamDateSignInfoModel *examDateSignInfoModel = dayModel.examDateSignInfoList[indexPath.row];
    cell.examDateSignInfoModel = examDateSignInfoModel;
    return cell;
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


-(void)setSelectMajorModel:(HXMajorModel *)selectMajorModel{
    _selectMajorModel = selectMajorModel;
}

-(void)createUI{
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.selectDateHeaderView];
    [self.view addSubview:self.mainTableView];
    [self.view bringSubviewToFront:self.selectDateHeaderView];
}

#pragma mark - lazyload

-(UITableView *)mainTableView{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 68, kScreenWidth, kScreenHeight-kNavigationBarHeight-kTabBarHeight-58-68) style:UITableViewStyleGrouped];
        _mainTableView.bounces = NO;
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.backgroundColor = COLOR_WITH_ALPHA(0xFCFCFC, 1);
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
        _selectDateHeaderView = [[HXSelectDateHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 68)];
        [_selectDateHeaderView.selectDateBtn addTarget:self action:@selector(selectExamDate:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectDateHeaderView;
}

-(HXShowExamDateView *)showExamDateView{
    if (!_showExamDateView) {
        _showExamDateView = [[HXShowExamDateView alloc] init];
    }
    return _showExamDateView;
}

-(HXNoDataTipView *)noDataTipView{
    if (!_noDataTipView) {
        _noDataTipView = [[HXNoDataTipView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kNavigationBarHeight-kTabBarHeight-58)];
        _noDataTipView.tipTitle = @"暂无报考课程~";
    }
    return _noDataTipView;
}
@end
