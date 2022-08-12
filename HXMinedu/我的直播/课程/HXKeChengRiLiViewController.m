//
//  HXKeChengRiLiViewController.m
//  HXMinedu
//
//  Created by mac on 2022/8/11.
//

#import "HXKeChengRiLiViewController.h"
#import "HXRiLiKeJieCell.h"
#import "HXDayCell.h"

@interface HXKeChengRiLiViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource>

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

@end

@implementation HXKeChengRiLiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //
    [self createUI];
}
#pragma mark - <UITableViewDelegate,UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 76;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 85;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.headerSectionView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *riLiKeJieCellIdentifier = @"HXRiLiKeJieCellIdentifier";
    HXRiLiKeJieCell *cell = [tableView dequeueReusableCellWithIdentifier:riLiKeJieCellIdentifier];
    if (!cell) {
        cell = [[HXRiLiKeJieCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:riLiKeJieCellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - <UICollectionViewDataSource,UICollectionViewDelegate>
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return 30;
    
    
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HXDayCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HXDayCell class]) forIndexPath:indexPath];
    cell.dayLabel.text = [NSString stringWithFormat:@"%02ld",(indexPath.row+1)];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    

    
}

#pragma mark - UI
-(void)createUI{

    [self.view addSubview:self.mainTableView];
    self.mainTableView.sd_layout
    .topSpaceToView(self.view, 0)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomSpaceToView(self.view, 0);
    
    
//    // 下拉刷新
//    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(pullDownRefrsh)];
//    // 设置自动切换透明度(在导航栏下面自动隐藏)
//    header.automaticallyChangeAlpha = YES;
//    //设置header
//    self.mainTableView.mj_header = header;
//
//    MJRefreshAutoNormalFooter * footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
//    self.mainTableView.mj_footer = footer;
//    self.mainTableView.mj_footer.hidden = YES;
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
        _riLiTableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 400)];
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
        NSArray *weeks = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
        for (int i=0;i<weeks.count;i++ ) {
            UILabel *label = [[UILabel alloc] init];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = HXFont(12);
            label.textColor = COLOR_WITH_ALPHA(0x9F9F9F, 1);
            label.text = weeks[i];
            if(i==0||i==weeks.count-1){
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
        .bottomSpaceToView(_riLiTableHeaderView, 10);
        
        
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
        _yearMonthLabel.text = @"2022-07";
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
        [_todayBtn addTarget:self action:@selector(nextMonth:) forControlEvents:UIControlEventTouchUpInside];
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
        _selectRiQiLabel.text = @"07/18 星期二";
    }
    return _selectRiQiLabel;
}

-(UILabel *)numLabel{
    if(!_numLabel){
        _numLabel = [[UILabel alloc] init];
        _numLabel.font = HXFont(15);
        _numLabel.textColor = COLOR_WITH_ALPHA(0x181414, 1);
        _numLabel.textAlignment = NSTextAlignmentLeft;
        _numLabel.text = @"直播课节(3)";
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
