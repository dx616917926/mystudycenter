//
//  HXSelectHistoryTimeViewController.m
//  HXMinedu
//
//  Created by mac on 2021/7/29.
//

#import "HXSelectHistoryTimeViewController.h"
#import "HXSelectHistoryTimeCell.h"


@interface HXSelectHistoryTimeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) UIView *bigNavBackGroundView;
@property(nonatomic,strong) UIButton *closeBtn;
@property(nonatomic,strong) UILabel *titleLabel;

@property(nonatomic,strong) UIView *timeView;
@property(nonatomic,strong) UILabel *timeLabel;
@property(nonatomic,strong) UIImageView *leftImageView;
@property(nonatomic,strong) UIImageView *rightImageView;

@property(nonatomic,strong) UITableView *mainTableView;

@property(nonatomic,strong) HXHistoryTimeModel *selectModel;


@end

@implementation HXSelectHistoryTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = COLOR_WITH_ALPHA(0xFCFCFC, 1);
    //UI
    [self createUI];

}





-(UIStatusBarStyle)preferredStatusBarStyle{
    if (@available(iOS 13.0, *)) {
        return UIStatusBarStyleDarkContent;
    } else {
        return UIStatusBarStyleDefault;
    }
}



-(void)setHistoryTimeList:(NSArray *)historyTimeList{
    _historyTimeList = historyTimeList;
    [historyTimeList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        HXHistoryTimeModel *model = obj;
        if (model.isSelected) {
            self.selectModel = model;
            *stop = YES;
            return;
        }
    }];
}

#pragma mark - Event
-(void)clickCloseBtn{
    
    [self dismissViewControllerAnimated:YES completion:nil];

}


#pragma mark - <UITableViewDelegate,UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.historyTimeList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 36;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *selectHistoryTimeCellIdentifier = @"HXSelectHistoryTimeCellIdentifier";
    HXSelectHistoryTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:selectHistoryTimeCellIdentifier];
    if (!cell) {
        cell = [[HXSelectHistoryTimeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:selectHistoryTimeCellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.timeModel = self.historyTimeList[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    HXHistoryTimeModel *model = self.historyTimeList[indexPath.row];
    if (model.isSelected) {
        [self clickCloseBtn];
        return;
    }
    model.isSelected = YES;
    self.selectModel.isSelected = NO;
    self.selectModel = model;
    
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.selectFinishCallBack) {
            self.selectFinishCallBack(model.createDate);
        }
    }];
}




#pragma mark - UI
-(void)createUI{
    [self.view addSubview:self.bigNavBackGroundView];
    [self.bigNavBackGroundView addSubview:self.closeBtn];
    [self.bigNavBackGroundView addSubview:self.titleLabel];
    [self.view addSubview:self.timeView];
    [self.timeView addSubview:self.timeLabel];
    [self.timeView addSubview:self.leftImageView];
    [self.timeView addSubview:self.rightImageView];
    [self.view addSubview:self.mainTableView];
    ///调整一下顺序，不然阴影被遮挡了
    [self.view bringSubviewToFront:self.bigNavBackGroundView];
    
    self.bigNavBackGroundView.sd_layout
    .topEqualToView(self.view)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .heightIs(kNavigationBarHeight);
    
    self.closeBtn.sd_layout
    .centerYIs(kStatusBarHeight+22)
    .leftEqualToView(self.bigNavBackGroundView)
    .heightIs(44)
    .widthIs(70);
    
    self.closeBtn.imageView.sd_layout
    .leftSpaceToView(self.closeBtn, _kpw(23))
    .centerYEqualToView(self.closeBtn)
    .widthIs(20)
    .heightEqualToWidth();
    
    self.titleLabel.sd_layout
    .centerYEqualToView(self.closeBtn)
    .centerXEqualToView(self.bigNavBackGroundView)
    .heightRatioToView(self.closeBtn, 1)
    .widthIs(kScreenHeight/2);
    
    self.timeView.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .topSpaceToView(self.bigNavBackGroundView,0)
    .heightIs(60);
    
    self.timeLabel.sd_layout
    .centerYEqualToView(self.timeView)
    .centerXEqualToView(self.timeView)
    .heightIs(20);
    [self.timeLabel setSingleLineAutoResizeWithMaxWidth:80];
    
    
    self.leftImageView.sd_layout
    .centerYEqualToView(self.timeView)
    .rightSpaceToView(self.timeLabel, 10)
    .widthIs(20)
    .heightIs(8);
    
    self.rightImageView.sd_layout
    .centerYEqualToView(self.timeView)
    .leftSpaceToView(self.timeLabel, 10)
    .widthRatioToView(self.leftImageView, 1)
    .heightRatioToView(self.leftImageView, 1);
    
    self.mainTableView.sd_layout
    .topSpaceToView(self.timeView,0)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomSpaceToView(self.view,0);
   
    
}


#pragma mark - lazyLoad
-(UIView *)bigNavBackGroundView{
    if (!_bigNavBackGroundView) {
        _bigNavBackGroundView = [[UIView alloc] init];
        _bigNavBackGroundView.backgroundColor = [UIColor whiteColor];
        _bigNavBackGroundView.layer.shadowColor = COLOR_WITH_ALPHA(0x000000, 0.15).CGColor;
        _bigNavBackGroundView.layer.shadowOffset = CGSizeMake(0, 1);
        _bigNavBackGroundView.layer.shadowRadius = 6;
        _bigNavBackGroundView.layer.shadowOpacity = 1;
    }
    return _bigNavBackGroundView;
}

-(UIButton *)closeBtn{
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setImage:[UIImage imageNamed:@"close_icon"] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(clickCloseBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        _titleLabel.font = HXBoldFont(18);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = @"选择时间";
    }
    return _titleLabel;
}

-(UITableView *)mainTableView{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _mainTableView.bounces = NO;
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
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

-(UIView *)timeView{
    if (!_timeView) {
        _timeView = [[UIView alloc] init];
        _timeView.backgroundColor = [UIColor whiteColor];
    }
    return _timeView;
}

-(UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = COLOR_WITH_ALPHA(0xAFAFAF, 1);
        _timeLabel.font = HXFont(14);
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.text = @"时间";
    }
    return _timeLabel;
}

-(UIImageView *)leftImageView{
    if (!_leftImageView) {
        _leftImageView = [[UIImageView alloc] init];
        _leftImageView.image = [UIImage imageNamed:@"double_triangle"];
    }
    return _leftImageView;
}

-(UIImageView *)rightImageView{
    if (!_rightImageView) {
        _rightImageView = [[UIImageView alloc] init];
        _rightImageView.image = [UIImage imageNamed:@"double_triangle"];
    }
    return _rightImageView;
}

@end

