//
//  HXSelectTimeView.m
//  HXMinedu
//
//  Created by mac on 2022/3/25.
//

#import "HXSelectTimeView.h"
#import "HXSelectTimeCell.h"

@interface HXSelectTimeView ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>

@property(nonatomic,strong) UIView *maskView;
@property(nonatomic,strong) UILabel *titleLabel;
@property(nonatomic,strong) UIView *bigBackGroundView;
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) UIButton *cancelBtn;
@property(nonatomic,strong) UIButton *confirmBtn;

//记录初始选择
@property(nonatomic,assign) NSInteger selectIndex;
@property(nonatomic,assign) BOOL isRefresh;
@property(nonatomic,strong) HXHistoryTimeModel *dateModel;

@end

@implementation HXSelectTimeView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self creatUI];
    }
    return self;
}

-(void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    [dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        HXHistoryTimeModel *model = obj;
        if (model.isSelected) {
            self.selectIndex = idx;
            self.dateModel = model;
            *stop = YES;
            return;
        }
    }];
}

-(void)show{
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskView];
   
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.bigBackGroundView.sd_layout.bottomSpaceToView(self.maskView, 0);
        [self.bigBackGroundView updateLayout];
    } completion:^(BOOL finished) {
        
    }];
    [self.tableView reloadData];
    
    ///滑动到选择的项中间
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.selectIndex inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
}

-(void)dismiss{
    
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.bigBackGroundView.sd_layout.bottomSpaceToView(self.maskView, -270-kScreenBottomMargin);
        [self.bigBackGroundView updateLayout];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self.maskView removeFromSuperview];
    }];
    
}

-(void)confirm:(UIButton *)sender{
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.bigBackGroundView.sd_layout.bottomSpaceToView(self.maskView, -270-kScreenBottomMargin);
        [self.bigBackGroundView updateLayout];
    } completion:^(BOOL finished) {
        if (self.selectTimeCallBack) {
            self.selectTimeCallBack(self.isRefresh,self.dateModel);
        }
        [self removeFromSuperview];
        [self.maskView removeFromSuperview];
    }];
}

-(void)creatUI{
    [self addSubview:self.maskView];
    [self.maskView addSubview:self.bigBackGroundView];
    [self.bigBackGroundView addSubview:self.titleLabel];
    [self.bigBackGroundView addSubview:self.cancelBtn];
    [self.bigBackGroundView addSubview:self.confirmBtn];
    [self.bigBackGroundView addSubview:self.tableView];
    
    self.bigBackGroundView.sd_layout
    .leftEqualToView(self.maskView)
    .rightEqualToView(self.maskView)
    .bottomSpaceToView(self.maskView, -270-kScreenBottomMargin)
    .heightIs(270+kScreenBottomMargin);
    [self.bigBackGroundView updateLayout];
    
    //圆角
   UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bigBackGroundView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(16 ,16)];
   CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
   maskLayer.frame =self.bigBackGroundView.bounds;
   maskLayer.path = maskPath.CGPath;
   self.bigBackGroundView.layer.mask = maskLayer;
    
    self.titleLabel.sd_layout
    .topSpaceToView(self.bigBackGroundView, 24)
    .centerXEqualToView(self.bigBackGroundView)
    .widthIs(80)
    .heightIs(25);
    
    self.cancelBtn.sd_layout
    .centerYEqualToView(self.titleLabel)
    .leftEqualToView(self.bigBackGroundView)
    .widthIs(74)
    .heightIs(32);
    
    self.cancelBtn.imageView.sd_layout
    .centerYEqualToView(self.cancelBtn)
    .centerXEqualToView(self.cancelBtn)
    .widthIs(14)
    .heightEqualToWidth();
    
    self.confirmBtn.sd_layout
    .centerYEqualToView(self.titleLabel)
    .rightSpaceToView(self.bigBackGroundView, 20)
    .widthIs(62)
    .heightIs(32);
    self.confirmBtn.sd_cornerRadiusFromHeightRatio = @0.5;
    
    self.tableView.sd_layout
    .topSpaceToView(self.titleLabel, 20)
    .leftEqualToView(self.bigBackGroundView)
    .rightEqualToView(self.bigBackGroundView)
    .bottomSpaceToView(self.bigBackGroundView, kScreenBottomMargin);
    
    [self.bigBackGroundView updateLayout];
   
}



#pragma mark - <UITableViewDelegate,UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *selectTimeCellIdentifier = @"HXSelectTimeCellldentifier";
    HXSelectTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:selectTimeCellIdentifier];
    if (!cell) {
        cell = [[HXSelectTimeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:selectTimeCellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    HXHistoryTimeModel *dateModel = self.dataArray[indexPath.row];
    cell.dateModel = dateModel;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    ///重置选择
    [self.dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        HXHistoryTimeModel *model = obj;
        if (indexPath.row == idx) {
            self.selectIndex = idx;
            model.isSelected = YES;
            self.dateModel = model;
        }else{
            model.isSelected = NO;
        }
    }];
    self.isRefresh = (self.selectIndex!= indexPath.row);
    [self.tableView reloadData];
}
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.bounces = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _tableView.estimatedRowHeight = 0;
        }
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.scrollIndicatorInsets = _tableView.contentInset;
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
    
}
-(UIView *)maskView{
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _maskView.backgroundColor = COLOR_WITH_ALPHA(0x000000, 0.24);
    }
    return _maskView;
}

-(UIView *)bigBackGroundView{
    if (!_bigBackGroundView) {
        _bigBackGroundView = [[UIView alloc] init];
        _bigBackGroundView.backgroundColor = [UIColor whiteColor];
    }
    return _bigBackGroundView;
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        _titleLabel.font = HXBoldFont(18);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = @"选择时间";
    }
    return _titleLabel;
}

-(UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn setImage:[UIImage imageNamed:@"close_icon"] forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

-(UIButton *)confirmBtn{
    if (!_confirmBtn) {
        _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _confirmBtn.backgroundColor = COLOR_WITH_ALPHA(0x39A0FB, 1);
        _confirmBtn.titleLabel.font = HXBoldFont(14);
        [_confirmBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_confirmBtn addTarget:self action:@selector(confirm:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmBtn;
}

@end

