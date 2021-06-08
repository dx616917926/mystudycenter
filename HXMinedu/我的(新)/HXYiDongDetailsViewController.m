//
//  HXYiDongDetailsViewController.m
//  HXMinedu
//
//  Created by mac on 2021/6/4.
//

#import "HXYiDongDetailsViewController.h"
#import "HXYiDongHeadInfoCell.h"
#import "HXMajorInfoCell.h"
#import "HXSuggestionCell.h"
#import "HXToastSuggestionView.h"
#import "HXCustomToastView.h"

@interface HXYiDongDetailsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) UITableView *mainTableView;
@property(nonatomic,strong) UIView *bottomView;
@property(nonatomic,strong) UIView *bottomShadowView;
@property(nonatomic,strong) UIButton *rejectBtn;//驳回
@property(nonatomic,strong) UIButton *confirmBtn;//确认异动
@end

@implementation HXYiDongDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
}

#pragma mark - Event
-(void)reject:(UIButton *)sender{
    HXToastSuggestionView *toastSuggestionView = [[HXToastSuggestionView alloc] init];
    [toastSuggestionView showRejecttoastWithCallBack:^(NSString * _Nonnull cotent) {
        [self loadRejectData];
    }];
}

-(void)confirm:(UIButton *)sender{
    HXToastSuggestionView *toastSuggestionView = [[HXToastSuggestionView alloc] init];
    [toastSuggestionView showConfirmToastWithCallBack:^(NSString * _Nonnull cotent) {
        [self loadConfirmData];
    }];
}


-(void)loadRejectData{
    HXCustomToastView *toastView = [[HXCustomToastView alloc] init];
    [toastView showRejectToastHideAfter:2];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.bottomView.hidden = self.bottomShadowView.hidden = YES;
    });
    
}

-(void)loadConfirmData{
    HXCustomToastView *toastView = [[HXCustomToastView alloc] init];
    [toastView showConfirmToastHideAfter:2];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.bottomView.hidden = self.bottomShadowView.hidden = YES;
    });
}

#pragma mark - <UITableViewDelegate,UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            return 104;
            break;
        case 1:
            return 204;
            break;
        case 2:
            return 204;
            break;
        case 3:
            return 110;
            break;
        case 4:
            return 110;
            break;
        default:
            return 0;
            break;
    };

}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *yiDongHeadInfoCellIdentifier = @"HXYiDongHeadInfoCellIdentifier";
    static NSString *majorInfoCellIdentifier = @"HXMajorInfoCellIdentifier";
    static NSString *suggestionCellIdentifier = @"HXSuggestionCellIdentifier";
    switch (indexPath.row) {
        case 0:
        {
            
            HXYiDongHeadInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:yiDongHeadInfoCellIdentifier];
            if (!cell) {
                cell = [[HXYiDongHeadInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:yiDongHeadInfoCellIdentifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
        case 1:
        {
           
            HXMajorInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:majorInfoCellIdentifier];
            if (!cell) {
                cell = [[HXMajorInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:majorInfoCellIdentifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
        case 2:
        {
            HXMajorInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:majorInfoCellIdentifier];
            if (!cell) {
                cell = [[HXMajorInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:majorInfoCellIdentifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
        case 3:
        {
            HXSuggestionCell *cell = [tableView dequeueReusableCellWithIdentifier:suggestionCellIdentifier];
            if (!cell) {
                cell = [[HXSuggestionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:suggestionCellIdentifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
        case 4:
        {
            HXSuggestionCell *cell = [tableView dequeueReusableCellWithIdentifier:suggestionCellIdentifier];
            if (!cell) {
                cell = [[HXSuggestionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:suggestionCellIdentifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
            
        default:
            return nil;
            break;
    }
    
}

#pragma mark - UI
-(void)createUI{
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.sc_navigationBar.title = @"异动详情";
    [self.view addSubview:self.mainTableView];
    [self.view addSubview:self.bottomShadowView];
    [self.view addSubview:self.bottomView];
    [self.bottomView addSubview:self.rejectBtn];
    [self.bottomView addSubview:self.confirmBtn];
    
    self.mainTableView.sd_layout
    .topSpaceToView(self.view, kNavigationBarHeight)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomEqualToView(self.view);
    
    self.bottomView.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomEqualToView(self.view)
    .heightIs(120);
    [self.bottomView updateLayout];
    
    UIBezierPath * bPath = [UIBezierPath bezierPathWithRoundedRect:self.bottomView.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(24, 24)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.path = bPath.CGPath;
    self.bottomView.layer.mask = maskLayer;
    
    self.bottomShadowView.sd_layout
    .leftEqualToView(self.bottomView)
    .rightEqualToView(self.bottomView)
    .bottomEqualToView(self.bottomView)
    .heightRatioToView(self.bottomView, 1);
    self.bottomShadowView.layer.cornerRadius = 24;
    
    self.rejectBtn.sd_layout
    .topSpaceToView(self.bottomView, 28)
    .leftSpaceToView(self.bottomView, 28)
    .widthIs(145)
    .heightIs(44);
    self.rejectBtn.sd_cornerRadiusFromHeightRatio = @0.5;
    
    self.confirmBtn.sd_layout
    .topSpaceToView(self.bottomView, 28)
    .rightSpaceToView(self.bottomView, 28)
    .widthIs(145)
    .heightIs(44);
    self.confirmBtn
    .sd_cornerRadiusFromHeightRatio = @0.5;
}

#pragma mark - lazyLoad
-(UITableView *)mainTableView{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _mainTableView.bounces = YES;
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
        _mainTableView.contentInset = UIEdgeInsetsMake(0, 0, 150, 0);
        _mainTableView.scrollIndicatorInsets = _mainTableView.contentInset;
        _mainTableView.showsVerticalScrollIndicator = NO;
    }
    return _mainTableView;
}


-(UIView *)bottomShadowView{
    if (!_bottomShadowView) {
        _bottomShadowView = [[UIView alloc] init];
        _bottomShadowView.backgroundColor = [UIColor whiteColor];
        _bottomShadowView.layer.shadowColor = COLOR_WITH_ALPHA(0x000000, 0.15).CGColor;
        _bottomShadowView.layer.shadowOffset = CGSizeMake(0, -2);
        _bottomShadowView.layer.shadowRadius = 4;
        _bottomShadowView.layer.shadowOpacity = 1;
    }
    return _bottomShadowView;
}

-(UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = [UIColor whiteColor];
        _bottomView.clipsToBounds = YES;
    }
    return _bottomView;
}

-(UIButton *)rejectBtn{
    if (!_rejectBtn) {
        _rejectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rejectBtn.titleLabel.font = HXBoldFont(16);
        _rejectBtn.backgroundColor = COLOR_WITH_ALPHA(0xFE664B, 1);
        [_rejectBtn setTitle:@"驳 回" forState:UIControlStateNormal];
        [_rejectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_rejectBtn addTarget:self action:@selector(reject:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rejectBtn;
}

-(UIButton *)confirmBtn{
    if (!_confirmBtn) {
        _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _confirmBtn.titleLabel.font = HXBoldFont(16);
        _confirmBtn.backgroundColor = COLOR_WITH_ALPHA(0x4DC656, 1);
        [_confirmBtn setTitle:@"确认异动" forState:UIControlStateNormal];
        [_confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_confirmBtn addTarget:self action:@selector(confirm:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmBtn;
}
@end
