//
//  HXKeChengRiLiViewController.m
//  HXMinedu
//
//  Created by mac on 2022/8/11.
//

#import "HXKeChengRiLiViewController.h"
#import "HXCommonWebViewController.h"
#import "HXLeaveApplyViewController.h"
#import "HXDianPingSuccessViewController.h"
#import "HXRiLiKeJieCell.h"
#import "HXModifyRiLiKeJieCell.h"
#import "HXDayCell.h"
#import "HXOnLiveDianPingView.h"
#import "HXCommentModel.h"

@interface HXKeChengRiLiViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,HXModifyRiLiKeJieCellDelegate>

@property(strong,nonatomic) UIView *riLiTableHeaderView;
@property(strong,nonatomic) UIView *topLine;
@property(strong,nonatomic) UILabel *yearMonthLabel;
@property(strong,nonatomic) UIButton *lastMonthBtn;
@property(strong,nonatomic) UIButton *nextMonthBtn;
@property(strong,nonatomic) UIButton *todayBtn;
@property(strong,nonatomic) UIView *weekContainerView;
@property(strong,nonatomic) UICollectionView *monthCollectionView;

@property(strong,nonatomic) UIView *headerSectionView;
@property(strong,nonatomic) UILabel *selectRiQiLabel;
@property(strong,nonatomic) UILabel *numLabel;

@property(strong,nonatomic) UIView *noDataView;

@property(strong,nonatomic) NSMutableArray <HXKejieCalendarModel*>*dataArray;
@property(strong,nonatomic) NSMutableArray *keJieArray;

@property(strong,nonatomic) HXKejieCalendarModel *selectKejieCalendarModel;
@property (nonatomic, strong) NSString *dateTime;          //获取获取直播日历详情的日期
@property (nonatomic, strong) NSString *todayDateTime;    //今天日期
@property(nonatomic,assign) NSInteger pageIndex;

@property (nonatomic, assign) NSInteger year;            //年
@property (nonatomic, assign) NSInteger month;           //月
@property (nonatomic, assign) NSInteger day;             //日

@property(strong,nonatomic)  NSArray *weeks;
@end

@implementation HXKeChengRiLiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //
    [self createUI];
    //
    self.weeks = @[@"星期天",@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六"];
    //计算当前天
    [self computeDateToday];
    
    
    
}


#pragma mark - 计算今天
- (void)computeDateToday {
    
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentDate = [formatter stringFromDate:date];
    self.dateTime = currentDate;
    self.todayDateTime = currentDate;
    
    NSArray *yearMonthDay = [currentDate componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"-"]];
    self.year = [yearMonthDay[0] integerValue];
    self.month = [yearMonthDay[1] integerValue];
    self.day = [yearMonthDay[2] integerValue];
    self.selectKejieCalendarModel = [HXKejieCalendarModel new];
    self.selectKejieCalendarModel.Date = currentDate;
    self.selectKejieCalendarModel.IsMonth = 1;
    
    self.yearMonthLabel.text = [currentDate substringToIndex:7];
    //获取直播日历
    [self getOnliveCalendar];
   
}


#pragma mark - 获取直播日历
-(void)getOnliveCalendar{
    
    NSDictionary *dic = @{
        @"dateTime":HXSafeString(self.dateTime)
    };
    
    [HXBaseURLSessionManager postDataWithNSString:HXPOST_GetOnliveCalendar  withDictionary:dic success:^(NSDictionary * _Nonnull dictionary) {
        
        [self.mainTableView.mj_header endRefreshing];
        BOOL success = [dictionary boolValueForKey:@"Success"];
        if (success) {
            NSArray *array = [HXKejieCalendarModel mj_objectArrayWithKeyValuesArray:[dictionary objectForKey:@"Data"]];
            
            [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                HXKejieCalendarModel *model = obj;
                if ([model.Date isEqualToString:self.dateTime]) {
                    model.IsSelect= YES;
                    //获取直播日历详情
                    self.selectKejieCalendarModel = model;
                    [self getOnliveCalendarInfo];
                    *stop = YES;
                    return;
                }
            }];
            
            [self.dataArray removeAllObjects];
            [self.dataArray addObjectsFromArray:array];
            [self.monthCollectionView reloadData];
            
        }
    } failure:^(NSError * _Nonnull error) {
        
        
    }];
    
}

#pragma mark - 获取直播日历详情
-(void)getOnliveCalendarInfo{
    
    self.pageIndex = 1;
    NSDictionary *dic = @{
        @"pageIndex":@(self.pageIndex),
        @"pageSize":@(15),
        @"dateTime":HXSafeString(self.selectKejieCalendarModel.Date)
    };
    
   
    [HXBaseURLSessionManager postDataWithNSString:HXPOST_GetOnliveCalendarInfo  withDictionary:dic success:^(NSDictionary * _Nonnull dictionary) {
        
        [self.mainTableView.mj_header endRefreshing];
        BOOL success = [dictionary boolValueForKey:@"Success"];
        NSDictionary *data = [dictionary objectForKey:@"Data"];
        if (success) {
            NSInteger rowCount = [[data stringValueForKey:@"rowCount"] integerValue];
            NSArray *array = [HXKeJieModel mj_objectArrayWithKeyValuesArray:[data objectForKey:@"t_LiveInfo_app"]];
            [self.keJieArray removeAllObjects];
            [self.keJieArray addObjectsFromArray:array];

            [self.mainTableView reloadData];
            if (array.count == 15) {
                self.mainTableView.mj_footer.hidden = NO;
            }else{
                self.mainTableView.mj_footer.hidden = YES;
            }
            if (array.count>0) {
                HXKeJieModel *model = self.keJieArray.firstObject;
                if (model.ClassBeginDate.length>=5) {
                    NSString *date = [model.ClassBeginDate substringFromIndex:5];
                    NSString *week = self.weeks[model.Week];
                    self.selectRiQiLabel.text = [NSString stringWithFormat:@"%@ %@",date,week];
                }
                self.numLabel.text = [NSString stringWithFormat:@"课节(%lu)",(unsigned long)rowCount];
                self.mainTableView.tableFooterView = nil;
            }else{
                self.mainTableView.tableFooterView = self.noDataView;
            }
        }
    } failure:^(NSError * _Nonnull error) {
        
        [self.mainTableView.mj_header endRefreshing];
    }];
    
}


-(void)loadMoreData{
    self.pageIndex++;
    
    NSDictionary *dic = @{
        @"pageIndex":@(self.pageIndex),
        @"pageSize":@(15),
        @"dateTime":HXSafeString(self.selectKejieCalendarModel.Date)
    };
    
    [HXBaseURLSessionManager postDataWithNSString:HXPOST_GetOnliveCalendarInfo  withDictionary:dic success:^(NSDictionary * _Nonnull dictionary) {
        [self.mainTableView.mj_footer endRefreshing];
        BOOL success = [dictionary boolValueForKey:@"Success"];
        NSDictionary *data = [dictionary objectForKey:@"Data"];
        if (success) {
            NSArray *array = [HXKeJieModel mj_objectArrayWithKeyValuesArray:[data objectForKey:@"t_LiveInfo_app"]];
            if (array.count == 15) {
                self.mainTableView.mj_footer.hidden = NO;
            }else{
                self.mainTableView.mj_footer.hidden = YES;
            }
            [self.keJieArray addObjectsFromArray:array];
            [self.mainTableView reloadData];
        }
    } failure:^(NSError * _Nonnull error) {
        [self.mainTableView.mj_footer endRefreshing];
        self.pageIndex--;
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
            [self.view showSuccessWithMessage:@"点评成功"] ;
            //点评成功，刷新数据
            [self getOnliveCalendarInfo];
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

#pragma mark - Event
-(void)lastMonth:(UIButton *)sender{
    if (self.month == 1) {
        self.month = 12 ;
        self.year --;
    }else {
        self.month -- ;
    }
    self.dateTime = [NSString stringWithFormat:@"%ld-%02ld-01",(long)self.year,self.month];
    self.yearMonthLabel.text = [self.dateTime substringToIndex:7];
    //获取直播日历
    [self getOnliveCalendar];
}

-(void)nextMonth:(UIButton *)sender{
    if (self.month == 12) {
        self.month = 1 ;
        self.year ++;
    }else {
        self.month ++ ;
    }
    self.dateTime = [NSString stringWithFormat:@"%ld-%02ld-01",(long)self.year,self.month];
    self.yearMonthLabel.text = [self.dateTime substringToIndex:7];
    //获取直播日历
    [self getOnliveCalendar];
}

-(void)backToday:(UIButton *)sender{
    [self computeDateToday];
}



#pragma mark - <HXModifyRiLiKeJieCellDelegate>
-(void)zhanKaiCell:(HXModifyRiLiKeJieCell *)cell{
    
    NSIndexPath *indexPath = [self.mainTableView indexPathForCell:cell];
    cell.keJieModel.IsZhanKai = !cell.keJieModel.IsZhanKai;
    [self.mainTableView reloadData];
    
}


#pragma mark - <UITableViewDelegate,UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.keJieArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    return 76;
    HXKeJieModel *keJieModel = self.keJieArray[indexPath.row];
    CGFloat rowHeight = [tableView cellHeightForIndexPath:indexPath
                                                    model:keJieModel keyPath:@"keJieModel"
                                                cellClass:([HXModifyRiLiKeJieCell class])
                                         contentViewWidth:kScreenWidth];
    return rowHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return self.keJieArray.count>0?85:0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.keJieArray.count>0?self.headerSectionView:nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *modifyRiLiKeJieCellIdentifier = @"HXModifyRiLiKeJieCellIdentifier";
    HXModifyRiLiKeJieCell *cell = [tableView dequeueReusableCellWithIdentifier:modifyRiLiKeJieCellIdentifier];
    if (!cell) {
        cell = [[HXModifyRiLiKeJieCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:modifyRiLiKeJieCellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    cell.isFirst = (indexPath.row==0);
    cell.isLast = (indexPath.row==self.keJieArray.count-1);
    cell.keJieModel = self.keJieArray[indexPath.row];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    HXKeJieModel *keJieModel = self.keJieArray[indexPath.row];
    //直播类型 1ClassIn    2保利威    3面授课程    面授课程只展示不做任何操作
    if (keJieModel.LiveType==1) {//ClassIn
        //ClassIn的回放跳出去
        if (keJieModel.LiveState==2) {
            if (@available(iOS 10.0, *)) {
                [[UIApplication sharedApplication] openURL:HXSafeURL(keJieModel.liveUrl) options:@{} completionHandler:nil];
            } else {
                [[UIApplication sharedApplication] openURL:HXSafeURL(keJieModel.liveUrl)];
            }
        }else{
            HXCommonWebViewController *webViewVC = [[HXCommonWebViewController alloc] init];
            webViewVC.urlString = keJieModel.liveUrl;
            webViewVC.cuntomTitle = keJieModel.ClassName;
            webViewVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:webViewVC animated:YES];
        }
    }else if (keJieModel.LiveType==2) {//保利威
        HXCommonWebViewController *webViewVC = [[HXCommonWebViewController alloc] init];
        webViewVC.urlString = keJieModel.liveUrl;
        webViewVC.cuntomTitle = keJieModel.ClassName;
        webViewVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:webViewVC animated:YES];
        
    }else if (keJieModel.LiveType==3) {//面授课程
        if (keJieModel.AuditState==0&&keJieModel.LiveState==0&&keJieModel.Status==-1) {//请假
            HXLeaveApplyViewController *vc = [[HXLeaveApplyViewController alloc] init];
            vc.ClassGuid = keJieModel.ClassGuid;
            vc.hidesBottomBarWhenPushed = YES;
            WeakSelf(weakSelf);
            vc.qingJiaSuccessCallBack = ^{
                //重新获取直播日历详情
                [weakSelf getOnliveCalendarInfo];
            };
            [self.navigationController pushViewController:vc animated:YES];
        }else if (keJieModel.LiveState==2) {//点评
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
        
    }
}



#pragma mark - <UICollectionViewDataSource,UICollectionViewDelegate>
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.dataArray.count;
    
    
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HXDayCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HXDayCell class]) forIndexPath:indexPath];
    
    cell.kejieCalendarModel = self.dataArray[indexPath.row];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    HXKejieCalendarModel *model = self.dataArray[indexPath.row];
    if (model.IsMonth==1) {
        [self.dataArray enumerateObjectsUsingBlock:^(HXKejieCalendarModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.IsSelect = NO;
        }];
        model.IsSelect = YES;
        self.selectKejieCalendarModel = model;
        [collectionView reloadData];
        //获取直播日历详情
        [self getOnliveCalendarInfo];
    }
}

#pragma mark - UI
-(void)createUI{
    
    [self.view addSubview:self.mainTableView];
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view);
        make.left.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
    }];

    
        // 下拉刷新
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getOnliveCalendarInfo)];
        // 设置自动切换透明度(在导航栏下面自动隐藏)
        header.automaticallyChangeAlpha = YES;
        //设置header
        self.mainTableView.mj_header = header;
    
        MJRefreshAutoNormalFooter * footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        self.mainTableView.mj_footer = footer;
        self.mainTableView.mj_footer.hidden = YES;
}


#pragma mark - LazyLoad
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

-(NSMutableArray *)keJieArray{
    if (!_keJieArray) {
        _keJieArray = [NSMutableArray array];
    }
    return _keJieArray;
}

- (UITableView *)mainTableView {
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _mainTableView.showsVerticalScrollIndicator = NO;
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.bounces = YES;
        _mainTableView.backgroundColor = [UIColor whiteColor];
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
        _mainTableView.tableHeaderView = self.riLiTableHeaderView;
        
    }
    return _mainTableView;
}

-(UIView *)riLiTableHeaderView{
    if(!_riLiTableHeaderView){
        _riLiTableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 385)];
        _riLiTableHeaderView.backgroundColor = UIColor.whiteColor;
        [_riLiTableHeaderView addSubview:self.topLine];
        [_riLiTableHeaderView addSubview:self.yearMonthLabel];
        [_riLiTableHeaderView addSubview:self.nextMonthBtn];
        [_riLiTableHeaderView addSubview:self.lastMonthBtn];
        [_riLiTableHeaderView addSubview:self.todayBtn];
        [_riLiTableHeaderView addSubview:self.weekContainerView];
        [_riLiTableHeaderView addSubview:self.monthCollectionView];
        
        self.topLine.sd_layout
            .topEqualToView(_riLiTableHeaderView)
            .leftEqualToView(_riLiTableHeaderView)
            .rightEqualToView(_riLiTableHeaderView)
            .heightIs(10);
        
        
        self.yearMonthLabel.sd_layout
            .topSpaceToView(self.topLine, 25)
            .centerXEqualToView(_riLiTableHeaderView)
            .widthIs(80)
            .heightIs(22);
        
        self.lastMonthBtn.sd_layout
            .centerYEqualToView(self.yearMonthLabel)
            .rightSpaceToView(self.yearMonthLabel, 5)
            .widthIs(40)
            .heightIs(20);
        
        self.nextMonthBtn.sd_layout
            .centerYEqualToView(self.yearMonthLabel)
            .leftSpaceToView(self.yearMonthLabel, 5)
            .widthRatioToView(self.lastMonthBtn, 1)
            .heightRatioToView(self.lastMonthBtn, 1);
        
        self.todayBtn.sd_layout
            .centerYEqualToView(self.yearMonthLabel)
            .rightSpaceToView(_riLiTableHeaderView, 14)
            .widthIs(54)
            .heightIs(27);
        
        self.todayBtn.sd_cornerRadius = @4;
        
        self.weekContainerView.sd_layout
            .topSpaceToView(self.yearMonthLabel, 20)
            .leftEqualToView(_riLiTableHeaderView)
            .rightEqualToView(_riLiTableHeaderView)
            .heightIs(30);
        float width = (kScreenWidth-80)/7;
        NSArray *weeks = @[@"一",@"二",@"三",@"四",@"五",@"六",@"日"];
        for (int i=0;i<weeks.count;i++ ) {
            UILabel *label = [[UILabel alloc] init];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = HXFont(12);
            label.textColor = COLOR_WITH_ALPHA(0x9F9F9F, 1);
            label.text = weeks[i];
            if(i==weeks.count-2||i==weeks.count-1){
                label.textColor = COLOR_WITH_ALPHA(0xEE1F1F, 1);
            }
            [self.weekContainerView addSubview:label];
            label.sd_layout
                .centerYEqualToView(self.weekContainerView)
                .leftSpaceToView(self.weekContainerView, 10+i*(width+10))
                .widthIs(width)
                .heightIs(30);
        }
        
        self.monthCollectionView.sd_layout
            .topSpaceToView(self.weekContainerView, 5)
            .leftEqualToView(_riLiTableHeaderView)
            .rightEqualToView(_riLiTableHeaderView)
            .bottomSpaceToView(_riLiTableHeaderView, 0);
        
        
    }
    return _riLiTableHeaderView;
}


-(UIView *)topLine{
    if(!_topLine){
        _topLine = [[UIView alloc] init];
        _topLine.backgroundColor = COLOR_WITH_ALPHA(0xF5F5F5, 1);
    }
    return _topLine;
}

-(UILabel *)yearMonthLabel{
    if(!_yearMonthLabel){
        _yearMonthLabel = [[UILabel alloc] init];
        _yearMonthLabel.font = HXFont(17);
        _yearMonthLabel.textColor = COLOR_WITH_ALPHA(0x181414, 1);
        _yearMonthLabel.textAlignment = NSTextAlignmentCenter;
        
    }
    return _yearMonthLabel;
}

-(UIButton *)lastMonthBtn{
    if(!_lastMonthBtn){
        _lastMonthBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_lastMonthBtn setImage:[UIImage imageNamed:@"lastmonth_icon"] forState:UIControlStateNormal];
        [_lastMonthBtn addTarget:self action:@selector(lastMonth:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _lastMonthBtn;
}

-(UIButton *)nextMonthBtn{
    if(!_nextMonthBtn){
        _nextMonthBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nextMonthBtn setImage:[UIImage imageNamed:@"nextmonth_icon"] forState:UIControlStateNormal];
        [_nextMonthBtn addTarget:self action:@selector(nextMonth:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextMonthBtn;
}

-(UIButton *)todayBtn{
    if(!_todayBtn){
        _todayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _todayBtn.titleLabel.font = HXFont(13);
        _todayBtn.backgroundColor = UIColor.whiteColor;
        _todayBtn.layer.borderWidth = 1;
        _todayBtn.layer.borderColor = COLOR_WITH_ALPHA(0x4988FD, 1).CGColor;
        [_todayBtn setTitleColor:COLOR_WITH_ALPHA(0x4988FD, 1) forState:UIControlStateNormal];
        [_todayBtn setTitle:@"今天" forState:UIControlStateNormal];
        [_todayBtn addTarget:self action:@selector(backToday:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _todayBtn;
}

-(UIView *)weekContainerView{
    if(!_weekContainerView){
        _weekContainerView = [[UIView alloc] init];
        _weekContainerView.backgroundColor = UIColor.whiteColor;
    }
    return _weekContainerView;
}

-(UICollectionView *)monthCollectionView{
    if (!_monthCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumLineSpacing = 5;
        layout.minimumInteritemSpacing = 10;
        float width = floorf((kScreenWidth-80)/7);
        layout.itemSize = CGSizeMake(width,50);
        _monthCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _monthCollectionView.backgroundColor = [UIColor clearColor];
        _monthCollectionView.scrollEnabled = NO;
        _monthCollectionView.delegate = self;
        _monthCollectionView.dataSource = self;
        _monthCollectionView.showsVerticalScrollIndicator = NO;
        _monthCollectionView.contentInset = UIEdgeInsetsMake(0, 10, 0, 10);
        _monthCollectionView.scrollIndicatorInsets = _monthCollectionView.contentInset;
        _monthCollectionView.showsVerticalScrollIndicator = NO;
        ///注册cell、段头
        [_monthCollectionView registerClass:[HXDayCell class]
                 forCellWithReuseIdentifier:NSStringFromClass([HXDayCell class])];
        
    }
    return _monthCollectionView;;
}

-(UIView *)headerSectionView{
    if(!_headerSectionView){
        _headerSectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 85)];
        _headerSectionView.backgroundColor = COLOR_WITH_ALPHA(0xF5F5F5, 1);
        [_headerSectionView addSubview:self.selectRiQiLabel];
        [_headerSectionView addSubview:self.numLabel];
        
        self.selectRiQiLabel.sd_layout
            .topSpaceToView(_headerSectionView, 18)
            .leftSpaceToView(_headerSectionView, 30)
            .rightSpaceToView(_headerSectionView, 30)
            .heightIs(24);
        
        self.numLabel.sd_layout
            .bottomSpaceToView(_headerSectionView, 10)
            .leftSpaceToView(_headerSectionView, 30)
            .rightSpaceToView(_headerSectionView, 30)
            .heightIs(22);
        
    }
    return _headerSectionView;
}


-(UILabel *)selectRiQiLabel{
    if(!_selectRiQiLabel){
        _selectRiQiLabel = [[UILabel alloc] init];
        _selectRiQiLabel.font = HXBoldFont(17);
        _selectRiQiLabel.textColor = COLOR_WITH_ALPHA(0x181414, 1);
        _selectRiQiLabel.textAlignment = NSTextAlignmentLeft;
        
    }
    return _selectRiQiLabel;
}

-(UILabel *)numLabel{
    if(!_numLabel){
        _numLabel = [[UILabel alloc] init];
        _numLabel.font = HXFont(15);
        _numLabel.textColor = COLOR_WITH_ALPHA(0x181414, 1);
        _numLabel.textAlignment = NSTextAlignmentLeft;
        
    }
    return _numLabel;
}


-(UIView *)noDataView{
    if(!_noDataView){
        _noDataView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 330)];
        _noDataView.backgroundColor = UIColor.whiteColor;
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"norecord_icon"];
        [_noDataView addSubview:imageView];
        
        UILabel *tipLabel = [[UILabel alloc] init];
        tipLabel.font = HXFont(16);
        tipLabel.textColor = COLOR_WITH_ALPHA(0x4988FD, 1);
        tipLabel.textAlignment = NSTextAlignmentCenter;
        tipLabel.text = @"今日无课，好好休息哟~";
        [_noDataView addSubview:tipLabel];
        
        imageView.sd_layout
            .topSpaceToView(_noDataView, 13)
            .centerXEqualToView(_noDataView)
            .widthIs(224)
            .heightIs(253);
        
        tipLabel.sd_layout
            .topSpaceToView(imageView, 10)
            .leftEqualToView(_noDataView)
            .rightEqualToView(_noDataView)
            .heightIs(22);
        
    }
    return _noDataView;
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
