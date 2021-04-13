//
//  HXPaymentDtailChildViewController.m
//  HXMinedu
//
//  Created by mac on 2021/4/8.
//

#import "HXPaymentDtailChildViewController.h"
#import "HXPaymentDetailCell.h"

@interface HXPaymentDtailChildViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(strong,nonatomic) UITableView *mainTableView;
@property(strong,nonatomic) UIView *paymentDtailTableFooterView;
@property(nonatomic,strong) UIView *topLine;
@property(nonatomic,strong) UILabel *totalPriceLabel;//总价
@property(nonatomic,strong) UILabel *discountLabel;//优惠
@property(nonatomic,strong) UILabel *heJiPriceLabel;//合计
@property(nonatomic,strong) UILabel *remarksLabel;//备注

@end

@implementation HXPaymentDtailChildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
}

#pragma mark - 布局子视图
-(void)createUI{
    [self.view addSubview:self.mainTableView];
    
    self.mainTableView.tableFooterView = self.paymentDtailTableFooterView;
}

#pragma mark - <UITableViewDelegate,UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return  self.flag == 2? 7:2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
   
    return 92;

}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *paymentDetailCellIdentifier = @"HXPaymentDetailCellIdentifier";
    HXPaymentDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:paymentDetailCellIdentifier];
    if (!cell) {
        cell = [[HXPaymentDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:paymentDetailCellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


#pragma mark - lazyLoad
-(UITableView *)mainTableView{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kNavigationBarHeight-58) style:UITableViewStylePlain];
        _mainTableView.bounces = YES;
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.backgroundColor = [UIColor whiteColor];
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


-(UIView *)paymentDtailTableFooterView{
    if (!_paymentDtailTableFooterView) {
        _paymentDtailTableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
        [_paymentDtailTableFooterView addSubview:self.topLine];
        [_paymentDtailTableFooterView addSubview:self.totalPriceLabel];
        [_paymentDtailTableFooterView addSubview:self.discountLabel];
        [_paymentDtailTableFooterView addSubview:self.heJiPriceLabel];
        [_paymentDtailTableFooterView addSubview:self.remarksLabel];
        
        self.topLine.sd_layout
        .topEqualToView(_paymentDtailTableFooterView)
        .leftSpaceToView(_paymentDtailTableFooterView, _kpw(23))
        .rightSpaceToView(_paymentDtailTableFooterView, _kpw(23))
        .heightIs(1);
        
        self.discountLabel.sd_layout
        .topSpaceToView(self.topLine, 15)
        .rightEqualToView(self.topLine).offset(-8)
        .heightIs(22);
        [self.discountLabel setSingleLineAutoResizeWithMaxWidth:120];
        
        self.totalPriceLabel.sd_layout
        .centerYEqualToView(self.discountLabel)
        .rightSpaceToView(self.discountLabel, 4)
        .leftEqualToView(self.topLine).offset(8)
        .heightIs(22);
        
        self.heJiPriceLabel.sd_layout
        .topSpaceToView(self.discountLabel, 14)
        .rightEqualToView(self.discountLabel)
        .leftEqualToView(self.topLine).offset(8)
        .heightIs(22);
        
        self.remarksLabel.sd_layout
        .topSpaceToView(self.heJiPriceLabel, 12)
        .rightEqualToView(self.discountLabel)
        .leftEqualToView(self.topLine).offset(8)
        .autoHeightRatio(0);
        
        [_paymentDtailTableFooterView setupAutoHeightWithBottomView:self.remarksLabel bottomMargin:kScreenBottomMargin+20];
        [_paymentDtailTableFooterView setNeedsLayout];
        [_paymentDtailTableFooterView layoutIfNeeded];
    }
    return _paymentDtailTableFooterView;
}

-(UIView *)topLine{
    if (!_topLine) {
        _topLine = [[UIView alloc] init];
        _topLine.backgroundColor = COLOR_WITH_ALPHA(0x979797, 0.4);
    }
    return _topLine;
}

-(UILabel *)totalPriceLabel{
    if (!_totalPriceLabel) {
        _totalPriceLabel = [[UILabel alloc] init];
        _totalPriceLabel.textAlignment = NSTextAlignmentRight;
        _totalPriceLabel.font = HXFont(14);
        _totalPriceLabel.textColor = COLOR_WITH_ALPHA(0xAFAFAF, 1);
        _totalPriceLabel.text = @"总价：¥ 1200.00";
    }
    return _totalPriceLabel;
}

-(UILabel *)discountLabel{
    if (!_discountLabel) {
        _discountLabel = [[UILabel alloc] init];
        _discountLabel.textAlignment = NSTextAlignmentRight;
        _discountLabel.font = HXFont(14);
        _discountLabel.textColor = COLOR_WITH_ALPHA(0xAFAFAF, 1);
        _discountLabel.text = @"优惠¥ 0.00";
    }
    return _discountLabel;
}

-(UILabel *)heJiPriceLabel{
    if (!_heJiPriceLabel) {
        _heJiPriceLabel = [[UILabel alloc] init];
        _heJiPriceLabel.textAlignment = NSTextAlignmentRight;
        _heJiPriceLabel.font = HXFont(14);
        _heJiPriceLabel.textColor = COLOR_WITH_ALPHA(0xFE664B, 1);
        _heJiPriceLabel.text = @"合计: ¥1200.00";
    }
    return _heJiPriceLabel;
}

-(UILabel *)remarksLabel{
    if (!_remarksLabel) {
        _remarksLabel = [[UILabel alloc] init];
        _remarksLabel.textAlignment = NSTextAlignmentLeft;
        _remarksLabel.font = HXBoldFont(12);
        _remarksLabel.textColor = COLOR_WITH_ALPHA(0x4BA4FE, 1);
        _remarksLabel.numberOfLines = 0;
        _remarksLabel.text = @"备注:参加限时活动特惠400元，额度已计入已缴订单";
    }
    return _remarksLabel;
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
