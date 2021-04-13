//
//  HXExaminationResultsViewController.m
//  HXMinedu
//
//  Created by mac on 2021/3/29.
//

#import "HXExaminationResultsViewController.h"
#import "HXSelectDateHeaderView.h"
#import "HXExaminationResultsCell.h"
#import "HXShowExamDateView.h"
#import "HXNoDataTipView.h"
@interface HXExaminationResultsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(strong,nonatomic) UITableView *mainTableView;
@property(strong,nonatomic) HXSelectDateHeaderView *selectDateHeaderView;
@property(strong,nonatomic) HXShowExamDateView *showExamDateView;
@property(strong,nonatomic) HXNoDataTipView *noDataTipView;

@property(strong,nonatomic) NSArray *examDateList;
@property(strong,nonatomic) HXExamDateModel *selectExamDateModel;


@end

@implementation HXExaminationResultsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //UI
    [self createUI];
    //获取报考课程分数列表
    [self getExamDateCourseScoreInfoList];
    
}



#pragma mark -  获取报考课程分数列表
-(void)getExamDateCourseScoreInfoList{
    NSDictionary *dic = @{
        @"major_id":HXSafeString(self.selectMajorModel.major_id)
    };
    
    [HXBaseURLSessionManager postDataWithNSString:HXPOST_Get_ExamDateCourseScoreInfo_List  withDictionary:dic success:^(NSDictionary * _Nonnull dictionary) {

        BOOL success = [dictionary boolValueForKey:@"Success"];
        if (success) {
            self.examDateList = [HXExamDateModel mj_objectArrayWithKeyValuesArray:[dictionary objectForKey:@"Data"]];
            self.selectExamDateModel = self.examDateList.firstObject;
            self.selectExamDateModel.isSelected = YES;
            [self refreshUI];
        }else{
            [self.view showErrorWithMessage:[dictionary stringValueForKey:@"Message"]];
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
    NSString *examDate = [NSString stringWithFormat:@"%@考期",self.selectExamDateModel.examDate];
    [self.selectDateHeaderView.selectDateBtn setTitle:examDate forState:UIControlStateNormal];
    [self.mainTableView reloadData];
}

#pragma mark - <UITableViewDelegate,UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.selectExamDateModel.examDateCourseScoreInfoList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *examinationResultsCellIdentifier = @"HXExaminationResultsCellIdentifier";
    HXExaminationResultsCell *cell = [tableView dequeueReusableCellWithIdentifier:examinationResultsCellIdentifier];
    if (!cell) {
        cell = [[HXExaminationResultsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:examinationResultsCellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    HXExamDateCourseScoreModel *examDateCourseScoreModel = self.selectExamDateModel.examDateCourseScoreInfoList[indexPath.row];
    cell.examDateCourseScoreModel = examDateCourseScoreModel;
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


-(void)createUI{
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.selectDateHeaderView];
    [self.view addSubview:self.mainTableView];
}

#pragma mark - lazyload
-(UITableView *)mainTableView{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 68, kScreenWidth, kScreenHeight-kNavigationBarHeight-kTabBarHeight-58-68) style:UITableViewStylePlain];
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
        _selectDateHeaderView.hidden = YES;
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
        _noDataTipView.tipTitle = @"暂无成绩~";
    }
    return _noDataTipView;
}

@end
