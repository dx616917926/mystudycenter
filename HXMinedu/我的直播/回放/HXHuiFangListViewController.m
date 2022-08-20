//
//  HXHuiFangListViewController.m
//  HXMinedu
//
//  Created by mac on 2022/8/11.
//

#import "HXHuiFangListViewController.h"
#import "HXDianPingSuccessViewController.h"
#import "HXCommonWebViewController.h"
#import "HXHuiFangKeJieCell.h"
#import "HXOnLiveDianPingView.h"
#import "HXCommentModel.h"

@interface HXHuiFangListViewController ()<UITableViewDelegate,UITableViewDataSource,HXHuiFangKeJieCellDelegate>

@property(nonatomic,strong) UITableView *mainTableView;

@property(nonatomic,strong) NSMutableArray *dataArray;

@end

@implementation HXHuiFangListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //
    [self createUI];
    //获取直播课程详情
    [self loadData];
}

#pragma mark - Setter
- (void)setMealName:(NSString *)MealName{
    _MealName = MealName;
}

- (void)setMealGuid:(NSString *)mealGuid{
    _mealGuid = mealGuid;
}

#pragma mark - 获取直播课程详情
-(void)loadData{
    NSDictionary *dic = @{
        @"mealGuid":HXSafeString(self.mealGuid),
        @"type":@(2)//1全部课程 2回放
    };
    
    [HXBaseURLSessionManager postDataWithNSString:HXPOST_GetOnliveMealInfo  withDictionary:dic success:^(NSDictionary * _Nonnull dictionary) {
        
        [self.mainTableView.mj_header endRefreshing];
        BOOL success = [dictionary boolValueForKey:@"Success"];
        if (success) {
            NSArray *array = [HXKeJieModel mj_objectArrayWithKeyValuesArray:[dictionary objectForKey:@"Data"]];
            [self.dataArray removeAllObjects];
            [self.dataArray addObjectsFromArray:array];
            [self.mainTableView reloadData];
            
        }
    } failure:^(NSError * _Nonnull error) {
        [self.mainTableView.mj_header endRefreshing];
    }];
    
}

#pragma mark -  保存直播点评
-(void)dianPing:(NSInteger)fenGeStarScore contentStarScore:(NSInteger)contentStarScore tiYanStarScore:(NSInteger)tiYanStarScore jianYiContent:(NSString *)jianYiContent keJieModel:(HXKeJieModel *)keJieModel{
    
    NSDictionary *dic = @{
        @"classGuid":HXSafeString(keJieModel.ClassGuid),
        @"enrollId":HXSafeString(keJieModel.EnrollId),
        @"SkfgSatisfactionScore":@(fenGeStarScore),
        @"SknrSatisfactionScore":@(contentStarScore),
        @"ZbtySatisfactionScore":@(tiYanStarScore),
        @"Suggestion":HXSafeString(jianYiContent)
    };
    
    [HXBaseURLSessionManager postDataWithNSString:HXPOST_SavaComment  withDictionary:dic success:^(NSDictionary * _Nonnull dictionary) {
        
        BOOL success = [dictionary boolValueForKey:@"Success"];
        if (success) {
            HXDianPingSuccessViewController *vc = [[HXDianPingSuccessViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    } failure:^(NSError * _Nonnull error) {
       
    }];
}

#pragma mark - 获取直播点评详情
-(void)checkDianPing:(HXKeJieModel *)keJieModel{
    
    NSDictionary *dic = @{
        @"classGuid":HXSafeString(keJieModel.ClassGuid),
        @"enrollId":HXSafeString(keJieModel.EnrollId),
    };
    
    [HXBaseURLSessionManager postDataWithNSString:HXPOST_GetOnliveStudentSatisfactionInfo  withDictionary:dic success:^(NSDictionary * _Nonnull dictionary) {
        
        BOOL success = [dictionary boolValueForKey:@"Success"];
        if (success) {
            HXCommentModel *model = [HXCommentModel mj_objectWithKeyValues:[dictionary objectForKey:@"Data"]];
            HXOnLiveDianPingView *onLiveDianPingView = [[HXOnLiveDianPingView alloc] init];
            onLiveDianPingView.type = OnLiveDianPingViewTypeShow;
            onLiveDianPingView.fenGeStarScore =[model.SkfgSatisfactionScore integerValue];
            onLiveDianPingView.contentStarScore =[model.SknrSatisfactionScore integerValue];
            onLiveDianPingView.tiYanStarScore =[model.ZbtySatisfactionScore integerValue];
            onLiveDianPingView.suggestion = model.Suggestion;  
            [onLiveDianPingView show];
        }
    } failure:^(NSError * _Nonnull error) {
       
    }];
    
   
}

#pragma mark - <HXHuiFangKeJieCellDelegate>点评
/// 点评/查看点评
- (void)dianPingWithModel:(HXKeJieModel *)keJieModel{
    ///是否评价 0否 1是
    if (keJieModel.IsEvaluate==1) {
        [self checkDianPing:keJieModel];
    }else{
        HXOnLiveDianPingView *onLiveDianPingView = [[HXOnLiveDianPingView alloc] init];
        onLiveDianPingView.type = OnLiveDianPingViewTypeeSelect;
        [onLiveDianPingView show];
        WeakSelf(weakSelf);
        onLiveDianPingView.dianPingCallBack = ^(NSInteger fenGeStarScore, NSInteger contentStarScore, NSInteger tiYanStarScore, NSString * _Nonnull jianYiContent) {
            NSLog(@"授课风格:%ld   授课内容:%ld   直播体验:%ld  其他建议:%@",fenGeStarScore,contentStarScore,tiYanStarScore,jianYiContent);
            [weakSelf dianPing:fenGeStarScore contentStarScore:contentStarScore tiYanStarScore:tiYanStarScore jianYiContent:jianYiContent keJieModel:keJieModel];
        };
    }
}

-(void)checkDianPingWithModel{
    
}

#pragma mark - <UITableViewDelegate,UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *huiFangKeJieCellIdentifier = @"HXHuiFangKeJieCellIdentifier";
    HXHuiFangKeJieCell *cell = [tableView dequeueReusableCellWithIdentifier:huiFangKeJieCellIdentifier];
    if (!cell) {
        cell = [[HXHuiFangKeJieCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:huiFangKeJieCellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    cell.keJieModel = self.dataArray[indexPath.row];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HXKeJieModel *keJieModel = self.dataArray[indexPath.row];
    HXCommonWebViewController *webViewVC = [[HXCommonWebViewController alloc] init];
    webViewVC.urlString =keJieModel.liveUrl;
    webViewVC.cuntomTitle = keJieModel.ClassName;
    [self.navigationController pushViewController:webViewVC animated:YES];
}

#pragma mark - UI
-(void)createUI{
    self.sc_navigationBar.title = self.MealName;
    [self.view addSubview:self.mainTableView];
    self.mainTableView.sd_layout
        .topSpaceToView(self.view, kNavigationBarHeight)
        .leftEqualToView(self.view)
        .rightEqualToView(self.view)
        .bottomSpaceToView(self.view, 0);
    [self.mainTableView updateLayout];
    
    // 下拉刷新
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    header.automaticallyChangeAlpha = YES;
    //设置header
    self.mainTableView.mj_header = header;
    
}


#pragma mark - LazyLaod
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (UITableView *)mainTableView {
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _mainTableView.showsVerticalScrollIndicator = NO;
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.bounces = YES;
        _mainTableView.backgroundColor = COLOR_WITH_ALPHA(0xFFFFFF, 1);
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if ([_mainTableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_mainTableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
        self.extendedLayoutIncludesOpaqueBars = YES;
        if (@available(iOS 11.0, *)) {
            _mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _mainTableView.estimatedRowHeight = 0;
            _mainTableView.estimatedSectionHeaderHeight = 0.0;
            _mainTableView.estimatedSectionFooterHeight = 0.0;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        _mainTableView.contentInset = UIEdgeInsetsMake(0, 0, kScreenBottomMargin, 0);
        _mainTableView.scrollIndicatorInsets = _mainTableView.contentInset;
        
    }
    return _mainTableView;
}

@end
