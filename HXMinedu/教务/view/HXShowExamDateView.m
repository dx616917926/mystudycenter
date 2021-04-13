//
//  HXShowExamDateView.m
//  HXMinedu
//
//  Created by mac on 2021/4/8.
//

#import "HXShowExamDateView.h"
#import "HXExamDateCell.h"

@interface HXShowExamDateView ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>

@property(nonatomic,strong) UIView *maskView;
@property(nonatomic,strong) UILabel *titleLabel;
@property(nonatomic,strong) UIView *bigBackGroundView;
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) UIButton *cancelBtn;

//记录初始选择
@property(nonatomic,assign) NSInteger selectIndex;
@property(nonatomic,assign) BOOL isRefresh;
@property(nonatomic,strong) HXExamDateModel *selectExamDateModel;

@end

@implementation HXShowExamDateView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

//- (instancetype)showToView:(UIView *)view upView:(UIView *)upView  dataSource:(NSArray *)dataSource
//{
//    
//}

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
        HXExamDateModel *model = obj;
        if (model.isSelected) {
            self.selectIndex = idx;
            self.selectExamDateModel = model;
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
        self.bigBackGroundView.sd_layout.bottomSpaceToView(self.maskView, -256-kScreenBottomMargin);
        [self.bigBackGroundView updateLayout];
    } completion:^(BOOL finished) {
        if (self.selectExamDateCallBack) {
            self.selectExamDateCallBack(self.isRefresh,self.selectExamDateModel);
        }
        [self removeFromSuperview];
        [self.maskView removeFromSuperview];
    }];
    
}

-(void)creatUI{
    [self addSubview:self.maskView];
    [self.maskView addSubview:self.bigBackGroundView];
    [self.bigBackGroundView addSubview:self.titleLabel];
    [self.bigBackGroundView addSubview:self.tableView];
    [self.bigBackGroundView addSubview:self.cancelBtn];
    
    self.bigBackGroundView.sd_layout
    .leftEqualToView(self.maskView)
    .rightEqualToView(self.maskView)
    .bottomSpaceToView(self.maskView, -256-kScreenBottomMargin)
    .heightIs(256+kScreenBottomMargin);
    [self.bigBackGroundView updateLayout];
    
    //圆角
   UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bigBackGroundView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10 ,10)];
   CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
   maskLayer.frame =self.bigBackGroundView.bounds;
   maskLayer.path = maskPath.CGPath;
   self.bigBackGroundView.layer.mask = maskLayer;
    
    self.titleLabel.sd_layout
    .topEqualToView(self.bigBackGroundView)
    .leftEqualToView(self.bigBackGroundView)
    .rightEqualToView(self.bigBackGroundView)
    .heightIs(56);
    
    self.cancelBtn.sd_layout
    .bottomEqualToView(self.bigBackGroundView)
    .leftEqualToView(self.bigBackGroundView)
    .rightEqualToView(self.bigBackGroundView)
    .heightIs(56+kScreenBottomMargin);
    
    self.cancelBtn.titleLabel.sd_layout
    .centerYEqualToView(self.cancelBtn).offset(-kScreenBottomMargin/2);
    
    self.tableView.sd_layout
    .topSpaceToView(self.titleLabel, 0)
    .leftEqualToView(self.bigBackGroundView)
    .rightEqualToView(self.bigBackGroundView)
    .bottomSpaceToView(self.cancelBtn, 0);
    
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
    return 50;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *examDateCellIdentifier = @"HXExamDateCellldentifier";
    HXExamDateCell *cell = [tableView dequeueReusableCellWithIdentifier:examDateCellIdentifier];
    if (!cell) {
        cell = [[HXExamDateCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:examDateCellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    HXExamDateModel *examDateModel = self.dataArray[indexPath.row];
    cell.examDateModel = examDateModel;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    ///重置选择
    [self.dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        HXExamDateModel *model = obj;
        if (indexPath.row == idx) {
            self.selectIndex = idx;
            model.isSelected = YES;
            self.selectExamDateModel = model;
        }else{
            model.isSelected = NO;
        }
    }];
    self.isRefresh = (self.selectIndex == indexPath.row);
    [self dismiss];
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
        _titleLabel.font = HXBoldFont(14);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = @"选择考期";
    }
    return _titleLabel;
}

-(UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBtn.titleLabel.font = HXFont(16);
        _cancelBtn.backgroundColor = COLOR_WITH_ALPHA(0xD8D8D8, 0.32);
        [_cancelBtn setTitleColor:COLOR_WITH_ALPHA(0x2C2C2E, 1) forState:UIControlStateNormal];
        [_cancelBtn setTitle:@"取 消" forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

@end
