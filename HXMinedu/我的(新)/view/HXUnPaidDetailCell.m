//
//  HXUnPaidDetailCell.m
//  HXMinedu
//
//  Created by mac on 2021/4/22.
//

#import "HXUnPaidDetailCell.h"

@interface HXUnPaidDetailCell ()
@property(nonatomic,strong) UIImageView *bigTopGroundImageView;
@property(nonatomic,strong) UILabel *titleLabel;
@property(nonatomic,strong) UILabel *paymentNameLabel;
@property(nonatomic,strong) UILabel *paymentStateLabel;
@property(nonatomic,strong) UIImageView *divisionLine;

//支付金额
@property(nonatomic,strong) UILabel *paymentAmountLabel;
@property(nonatomic,strong) UILabel *paymentAmountContentLabel;
//订单编号
@property(nonatomic,strong) UILabel *orderNumberLabel;
@property(nonatomic,strong) UILabel *orderNumberContentLabel;
//订单时间
@property(nonatomic,strong) UILabel *orderTimeLabel;
@property(nonatomic,strong) UILabel *orderTimeContentLabel;


@property(nonatomic,strong) UIImageView *smallBottomImageView;
@property(nonatomic,strong) UIButton *payBtn;//确认并支付
@property(nonatomic,strong) UIButton *checkJiaoYiBtn;//查看交易凭证
@property(nonatomic,strong) UIButton *deleteBtn;//删除订单

@end

@implementation HXUnPaidDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        [self createUI];
    }
    return self;
}


#pragma mark - Setter
-(void)setPaymentDetailModel:(HXPaymentDetailModel *)paymentDetailModel{
    _paymentDetailModel = paymentDetailModel;
    ///订单类型  1待完成     2已完成    -1待审核    -2驳回      0未完成
    if (paymentDetailModel.orderStatus==1&&![HXCommonUtil isNull:paymentDetailModel.proofUrl]) {
        self.checkJiaoYiBtn.sd_layout.rightSpaceToView(self.payBtn, 10).widthIs(100);
    }else{
        self.checkJiaoYiBtn.sd_layout.rightSpaceToView(self.payBtn, 0).widthIs(0);
    }
    
    self.paymentStateLabel.text = (paymentDetailModel.orderStatus==1?@"待完成":@"未完成");
    ///订单属性 1报名  2结转  3自助缴费  4导入 其它续缴  为自助缴费时才可删除订单
    self.deleteBtn.hidden = (paymentDetailModel.isMb==3?NO:YES);
    self.titleLabel.text = HXSafeString(paymentDetailModel.title);
    self.paymentNameLabel.text = HXSafeString(paymentDetailModel.feeType_Names);
    self.paymentAmountContentLabel.text = [NSString stringWithFormat:@"¥%.2f",paymentDetailModel.fee];
    self.orderNumberContentLabel.text = HXSafeString(paymentDetailModel.orderNum);
    self.orderTimeContentLabel.text = HXSafeString(paymentDetailModel.createDate);
    
    
}

#pragma mark - Event
-(void)delete:(UIButton *)sender{
    if(self.delegate &&[self.delegate respondsToSelector:@selector(deleteOrderNum:)]){
        [self.delegate deleteOrderNum:self.paymentDetailModel];
    }
}

-(void)checkPingZheng:(UIButton *)sender{
    if(self.delegate &&[self.delegate respondsToSelector:@selector(deleteOrderNum:)]){
        [self.delegate checkJiaoYiVoucher:self.paymentDetailModel];
    }
}

#pragma mark - UI
-(void)createUI{
    [self.contentView addSubview:self.bigTopGroundImageView];
    [self.bigTopGroundImageView addSubview:self.titleLabel];
    [self.bigTopGroundImageView addSubview:self.paymentNameLabel];
    [self.bigTopGroundImageView addSubview:self.paymentStateLabel];
    [self.bigTopGroundImageView addSubview:self.divisionLine];
    [self.bigTopGroundImageView addSubview:self.paymentAmountLabel];
    [self.bigTopGroundImageView addSubview:self.paymentAmountContentLabel];
    [self.bigTopGroundImageView addSubview:self.orderNumberLabel];
    [self.bigTopGroundImageView addSubview:self.orderNumberContentLabel];
    [self.bigTopGroundImageView addSubview:self.orderTimeLabel];
    [self.bigTopGroundImageView addSubview:self.orderTimeContentLabel];
    
    [self.contentView addSubview:self.smallBottomImageView];
    [self.smallBottomImageView addSubview:self.payBtn];
    [self.smallBottomImageView addSubview:self.checkJiaoYiBtn];
    [self.smallBottomImageView addSubview:self.deleteBtn];
    
    self.bigTopGroundImageView.sd_layout
    .topEqualToView(self.contentView)
    .leftSpaceToView(self.contentView, 10)
    .rightSpaceToView(self.contentView, 10)
    .heightIs(186);
    
    self.titleLabel.sd_layout
    .topSpaceToView(self.bigTopGroundImageView , 13)
    .leftSpaceToView(self.bigTopGroundImageView, _kpw(22))
    .rightSpaceToView(self.bigTopGroundImageView , _kpw(14))
    .heightIs(17);
    
    self.paymentStateLabel.sd_layout
    .topSpaceToView(self.titleLabel , 8)
    .rightSpaceToView(self.bigTopGroundImageView , _kpw(14))
    .heightIs(22);
    [self.paymentStateLabel setSingleLineAutoResizeWithMaxWidth:120];
    
    self.paymentNameLabel.sd_layout
    .centerYEqualToView(self.paymentStateLabel)
    .leftEqualToView(self.titleLabel)
    .rightSpaceToView(self.paymentStateLabel , _kpw(14))
    .heightIs(22);
    
    self.divisionLine.sd_layout
    .topSpaceToView(self.bigTopGroundImageView, 70)
    .leftSpaceToView(self.bigTopGroundImageView, _kpw(14))
    .rightSpaceToView(self.bigTopGroundImageView, _kpw(14))
    .heightIs(1);
    
    
    self.paymentAmountLabel.sd_layout
    .topSpaceToView(self.divisionLine, 16)
    .leftSpaceToView(self.bigTopGroundImageView, _kpw(22))
    .widthIs(100)
    .heightIs(20);
    
    self.paymentAmountContentLabel.sd_layout
    .centerYEqualToView(self.paymentAmountLabel)
    .leftSpaceToView(self.paymentAmountLabel, 5)
    .rightSpaceToView(self.bigTopGroundImageView, _kpw(22))
    .heightIs(20);
    
    self.orderNumberLabel.sd_layout
    .topSpaceToView(self.paymentAmountLabel, 10)
    .leftEqualToView(self.paymentAmountLabel)
    .rightEqualToView(self.paymentAmountLabel)
    .heightIs(20);
    
    self.orderNumberContentLabel.sd_layout
    .centerYEqualToView(self.orderNumberLabel)
    .leftEqualToView(self.paymentAmountContentLabel)
    .rightEqualToView(self.paymentAmountContentLabel)
    .heightIs(20);
    
    self.orderTimeLabel.sd_layout
    .topSpaceToView(self.orderNumberLabel, 10)
    .leftEqualToView(self.paymentAmountLabel)
    .rightEqualToView(self.paymentAmountLabel)
    .heightIs(20);
    
    self.orderTimeContentLabel.sd_layout
    .centerYEqualToView(self.orderTimeLabel)
    .leftEqualToView(self.paymentAmountContentLabel)
    .rightEqualToView(self.paymentAmountContentLabel)
    .heightIs(20);
    
    
    
    self.smallBottomImageView.sd_layout
    .topSpaceToView(self.bigTopGroundImageView, 0)
    .leftSpaceToView(self.contentView, 10)
    .rightSpaceToView(self.contentView, 10)
    .heightIs(64);
    
    
   
    self.payBtn.sd_layout
    .centerYEqualToView(self.smallBottomImageView)
    .rightSpaceToView(self.smallBottomImageView, 22);
    [self.payBtn setupAutoSizeWithHorizontalPadding:20 buttonHeight:36];
    self.payBtn.sd_cornerRadiusFromHeightRatio = @0.5;
    
    self.checkJiaoYiBtn.sd_layout
    .centerYEqualToView(self.smallBottomImageView)
    .rightSpaceToView(self.payBtn, 10)
    .widthIs(100)
    .heightIs(36);
    self.checkJiaoYiBtn.sd_cornerRadiusFromHeightRatio = @0.5;
    
    self.deleteBtn.sd_layout
    .centerYEqualToView(self.payBtn)
    .rightSpaceToView(self.checkJiaoYiBtn, 10);
    [self.deleteBtn setupAutoSizeWithHorizontalPadding:20 buttonHeight:36];
    self.deleteBtn.sd_cornerRadiusFromHeightRatio = @0.5;
    
    
}

#pragma mark - lazyLoad

-(UIImageView *)bigTopGroundImageView{
    if (!_bigTopGroundImageView) {
        _bigTopGroundImageView = [[UIImageView alloc] init];
        _bigTopGroundImageView.contentMode = UIViewContentModeScaleToFill;
        _bigTopGroundImageView.clipsToBounds = YES;
        _bigTopGroundImageView.backgroundColor = [UIColor clearColor];
        _bigTopGroundImageView.image = [UIImage resizedImageWithName:@"bigtop"];
    }
    return _bigTopGroundImageView;
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = COLOR_WITH_ALPHA(0xAFAFAF, 1);
        _titleLabel.font = HXBoldFont(12);
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        
    }
    return _titleLabel;
}

-(UILabel *)paymentNameLabel{
    if (!_paymentNameLabel) {
        _paymentNameLabel = [[UILabel alloc] init];
        _paymentNameLabel.textColor = COLOR_WITH_ALPHA(0xFE664B, 1);
        _paymentNameLabel.font = HXBoldFont(16);
        _paymentNameLabel.textAlignment = NSTextAlignmentLeft;
        _paymentNameLabel.numberOfLines = 1;
    }
    return _paymentNameLabel;
}

-(UILabel *)paymentStateLabel{
    if (!_paymentStateLabel) {
        _paymentStateLabel = [[UILabel alloc] init];
        _paymentStateLabel.textColor = COLOR_WITH_ALPHA(0xFE664B, 1);
        _paymentStateLabel.font = HXBoldFont(16);
        _paymentStateLabel.textAlignment = NSTextAlignmentRight;
        _paymentStateLabel.clipsToBounds = YES;
    }
    return _paymentStateLabel;
}


-(UIImageView *)divisionLine{
    if (!_divisionLine) {
        _divisionLine = [[UIImageView alloc] init];
        _divisionLine.image = [UIImage imageNamed:@"short_dashline"];
    }
    return _divisionLine;
}

-(UILabel *)paymentAmountLabel{
    if (!_paymentAmountLabel) {
        _paymentAmountLabel = [[UILabel alloc] init];
        _paymentAmountLabel.textColor = COLOR_WITH_ALPHA(0xAFAFAF, 1);
        _paymentAmountLabel.font = HXFont(14);
        _paymentAmountLabel.textAlignment = NSTextAlignmentLeft;
        _paymentAmountLabel.text = @"应缴金额：";
    }
    return _paymentAmountLabel;
}

-(UILabel *)paymentAmountContentLabel{
    if (!_paymentAmountContentLabel) {
        _paymentAmountContentLabel = [[UILabel alloc] init];
        _paymentAmountContentLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        _paymentAmountContentLabel.font = HXFont(14);
        _paymentAmountContentLabel.textAlignment = NSTextAlignmentRight;
        
    }
    return _paymentAmountContentLabel;
}

-(UILabel *)orderNumberLabel{
    if (!_orderNumberLabel) {
        _orderNumberLabel = [[UILabel alloc] init];
        _orderNumberLabel.textColor = COLOR_WITH_ALPHA(0xAFAFAF, 1);
        _orderNumberLabel.font = HXFont(14);
        _orderNumberLabel.textAlignment = NSTextAlignmentLeft;
        _orderNumberLabel.text = @"订单编号：";
    }
    return _orderNumberLabel;
}

-(UILabel *)orderNumberContentLabel{
    if (!_orderNumberContentLabel) {
        _orderNumberContentLabel = [[UILabel alloc] init];
        _orderNumberContentLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        _orderNumberContentLabel.font = HXFont(14);
        _orderNumberContentLabel.textAlignment = NSTextAlignmentRight;
        
    }
    return _orderNumberContentLabel;
}

-(UILabel *)orderTimeLabel{
    if (!_orderTimeLabel) {
        _orderTimeLabel = [[UILabel alloc] init];
        _orderTimeLabel.textColor = COLOR_WITH_ALPHA(0xAFAFAF, 1);
        _orderTimeLabel.font = HXFont(14);
        _orderTimeLabel.textAlignment = NSTextAlignmentLeft;
        _orderTimeLabel.text = @"订单时间：";
    }
    return _orderTimeLabel;
}

-(UILabel *)orderTimeContentLabel{
    if (!_orderTimeContentLabel) {
        _orderTimeContentLabel = [[UILabel alloc] init];
        _orderTimeContentLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        _orderTimeContentLabel.font = HXFont(14);
        _orderTimeContentLabel.textAlignment = NSTextAlignmentRight;
        
    }
    return _orderTimeContentLabel;
}



-(UIImageView *)smallBottomImageView{
    if (!_smallBottomImageView) {
        _smallBottomImageView = [[UIImageView alloc] init];
        _smallBottomImageView.image = [UIImage imageNamed:@"smallbottom"];
        _smallBottomImageView.contentMode = UIViewContentModeScaleToFill;
        _smallBottomImageView.clipsToBounds = YES;
        _smallBottomImageView.backgroundColor = [UIColor clearColor];
        _smallBottomImageView.userInteractionEnabled = YES;
    }
    return _smallBottomImageView;
}


-(UIButton *)payBtn{
    if (!_payBtn) {
        _payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _payBtn.userInteractionEnabled = NO;
        _payBtn.backgroundColor = COLOR_WITH_ALPHA(0xFE664B, 1);
        _payBtn .titleLabel.font = HXFont(14);
        [_payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_payBtn setTitle:@"确认并支付" forState:UIControlStateNormal];
    }
    return _payBtn;
}

-(UIButton *)checkJiaoYiBtn{
    if (!_checkJiaoYiBtn) {
        _checkJiaoYiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _checkJiaoYiBtn.backgroundColor = [UIColor whiteColor];
        _checkJiaoYiBtn .titleLabel.font = HXFont(14);
        [_checkJiaoYiBtn setTitleColor:COLOR_WITH_ALPHA(0x4BA4FE, 1) forState:UIControlStateNormal];
        _checkJiaoYiBtn.layer.borderWidth = 1;
        _checkJiaoYiBtn.layer.borderColor = COLOR_WITH_ALPHA(0x4BA4FE, 1).CGColor;
        [_checkJiaoYiBtn addTarget:self action:@selector(checkPingZheng:) forControlEvents:UIControlEventTouchUpInside];
        [_checkJiaoYiBtn setTitle:@"查看交易凭证" forState:UIControlStateNormal];
    }
    return _checkJiaoYiBtn;
}

-(UIButton *)deleteBtn{
    if (!_deleteBtn) {
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteBtn.backgroundColor = COLOR_WITH_ALPHA(0xFFFFFF, 1);
        _deleteBtn.layer.borderWidth = 1;
        _deleteBtn.layer.borderColor = COLOR_WITH_ALPHA(0x707070, 1).CGColor;
        _deleteBtn .titleLabel.font = HXFont(14);
        [_deleteBtn setTitleColor:COLOR_WITH_ALPHA(0x666666, 1) forState:UIControlStateNormal];
        [_deleteBtn setTitle:@"取消订单" forState:UIControlStateNormal];
        [_deleteBtn addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
        _deleteBtn.hidden = YES;
    }
    return _deleteBtn;
}

@end
