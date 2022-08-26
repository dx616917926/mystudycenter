//
//  HXTouSuView.m
//  HXMinedu
//
//  Created by mac on 2022/8/24.
//

#import "HXTouSuView.h"
#import "HXTouSuPhoneCell.h"
@interface HXTouSuView ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UIView *maskView;
@property(nonatomic,strong) UIView *whiteView;
@property(nonatomic,strong) UIImageView *topImageView;
@property(nonatomic,strong) UILabel *titleLabel;
@property(nonatomic,strong) UITableView *mainTableView;
@property(nonatomic,strong) UIButton *cancelBtn;

@property (nonatomic, strong) HXContactDetailsModel *selectContactDetailsModel;


@end

@implementation HXTouSuView

-(instancetype)init{
    self = [super init];
    if (self) {
        [self createUI];
    }
    return self;
}

-(void)dealloc{
    [HXNotificationCenter removeObserver:self];
}

#pragma mark  - Setter



#pragma mark - show
-(void)show{
   
    self.selectContactDetailsModel = [HXPublicParamTool sharedInstance].selectContactDetailsModel;
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskView];
}

#pragma mark - UI
-(void)createUI{
    [self.maskView addSubview:self];
    [self addSubview:self.whiteView];
    [self addSubview:self.whiteView];
    [self.whiteView addSubview:self.topImageView];
    [self.whiteView addSubview:self.titleLabel];
    [self.whiteView addSubview:self.mainTableView];
    [self.whiteView addSubview:self.cancelBtn];

    
    self.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    self.whiteView.sd_layout
    .centerXEqualToView(self)
    .centerYEqualToView(self).offset(-kStatusBarHeight)
    .widthIs(220)
    .heightIs(270);
    self.whiteView.sd_cornerRadius = @8;
    
    self.topImageView.sd_layout
    .topEqualToView(self.whiteView)
    .leftEqualToView(self.whiteView)
    .rightEqualToView(self.whiteView)
    .heightIs(112);

    self.titleLabel.sd_layout
    .topSpaceToView(self.topImageView, 14)
    .leftSpaceToView(self.whiteView, 20)
    .rightSpaceToView(self.whiteView, 20)
    .heightIs(20);
    
    
    self.cancelBtn.sd_layout
    .bottomSpaceToView(self.whiteView, 10)
    .centerXEqualToView(self.whiteView)
    .widthIs(120)
    .heightIs(28);
    
    
    self.mainTableView.sd_layout
    .topSpaceToView(self.titleLabel, 5)
    .leftEqualToView(self.whiteView)
    .rightEqualToView(self.whiteView)
    .bottomSpaceToView(self.cancelBtn, 5);
    
}



#pragma mark - Event

-(void)close:(UIButton *)sender{
    [self.maskView removeFromSuperview];
     self.maskView = nil;
}


#pragma mark - <UITableViewDelegate,UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return  self.selectContactDetailsModel.complaintNumberList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *touSuPhoneCellIdentifier = @"HXTouSuPhoneCellIdentifier";
    HXTouSuPhoneCell *cell = [tableView dequeueReusableCellWithIdentifier:touSuPhoneCellIdentifier];
    if (!cell) {
        cell = [[HXTouSuPhoneCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:touSuPhoneCellIdentifier];
    }
    cell.contactModel = self.selectContactDetailsModel.complaintNumberList[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    HXContactModel *contactModel = self.selectContactDetailsModel.complaintNumberList[indexPath.row];
    
    NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",contactModel.value];
    NSURL *urlStr = [NSURL URLWithString:str];
    if ([[UIApplication sharedApplication] canOpenURL:urlStr]) {
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:urlStr options:@{} completionHandler:nil];
        } else {// iOS 10.0 之前
            [[UIApplication sharedApplication] openURL:urlStr];
        }
    }
  
}


#pragma mark - LazyLoad
-(UIView *)maskView{
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
        _maskView.backgroundColor = COLOR_WITH_ALPHA(0x000000, 0.36);
    }
    return _maskView;
}

-(UIView *)whiteView{
    if (!_whiteView) {
        _whiteView = [[UIView alloc] init];
        _whiteView.backgroundColor = COLOR_WITH_ALPHA(0xffffff, 1);
        _whiteView.clipsToBounds = YES;
    }
    return _whiteView;
}

-(UIImageView *)topImageView{
    if (!_topImageView) {
        _topImageView = [[UIImageView alloc] init];
        _topImageView.image = [UIImage imageNamed:@"kefu_icon"];
    }
    return _topImageView;
}


-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = HXFont(14);
        _titleLabel.textColor = COLOR_WITH_ALPHA(0x333333, 1);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.numberOfLines = 1;
        _titleLabel.text = @"请把您的问题反馈给我们";
    }
    return _titleLabel;
}

-(UITableView *)mainTableView{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _mainTableView.bounces = NO;
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.backgroundColor = [UIColor whiteColor];
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if ([_mainTableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_mainTableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
       
        if (@available(iOS 11.0, *)) {
            _mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _mainTableView.estimatedRowHeight = 0;
            _mainTableView.estimatedSectionHeaderHeight = 0;
            _mainTableView.estimatedSectionFooterHeight = 0;
        }
        _mainTableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
        _mainTableView.scrollIndicatorInsets = _mainTableView.contentInset;
        _mainTableView.showsVerticalScrollIndicator = NO;
    }
    return _mainTableView;
}

-(UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBtn.titleLabel.font = HXFont(12);
        _cancelBtn.backgroundColor = UIColor.clearColor;
        [_cancelBtn setTitleColor:COLOR_WITH_ALPHA(0x4188FE, 1) forState:UIControlStateNormal];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}


@end

