//
//  HXPaidDetailCell.m
//  HXMinedu
//
//  Created by mac on 2021/4/21.
//

#import "HXPaidDetailCell.h"

@interface HXPaidDetailCell ()
@property(nonatomic,strong) UIImageView *bigTopGroundImageView;
@property(nonatomic,strong) UILabel *titleLabel;
@property(nonatomic,strong) UILabel *paymentNameLabel;
@property(nonatomic,strong) UILabel *paymentStateLabel;
@property(nonatomic,strong) UIImageView *divisionLine;
@property(nonatomic,strong) UIImageView *finishImageView;//已完成
//支付金额
@property(nonatomic,strong) UILabel *paymentAmountLabel;
@property(nonatomic,strong) UILabel *paymentAmountContentLabel;
//订单编号
@property(nonatomic,strong) UILabel *orderNumberLabel;
@property(nonatomic,strong) UILabel *orderNumberContentLabel;
//订单时间
@property(nonatomic,strong) UILabel *orderTimeLabel;
@property(nonatomic,strong) UILabel *orderTimeContentLabel;
//支付时间
@property(nonatomic,strong) UILabel *paymentTimeLabel;
@property(nonatomic,strong) UILabel *paymentTimeContentLabel;

@property(nonatomic,strong) UIImageView *smallBottomImageView;
@property(nonatomic,strong) UILabel *shijiaoLabel;
@property(nonatomic,strong) UILabel *shijiaoMoneyLabel;
@property(nonatomic,strong) UIButton *checkJiaoYiBtn;
@property(nonatomic,strong) UIButton *checkShouKuanBtn;
@property(nonatomic,strong) UIButton *checkFaPiaoBtn;

@end

@implementation HXPaidDetailCell

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

-(void)setPaymentDetailModel:(HXPaymentDetailModel *)paymentDetailModel{
    _paymentDetailModel = paymentDetailModel;
    self.titleLabel.text = HXSafeString(paymentDetailModel.title);
    self.paymentNameLabel.text = HXSafeString(paymentDetailModel.feeType_Names);
    self.paymentAmountContentLabel.text = [NSString stringWithFormat:@"¥%.2f",paymentDetailModel.fee];
    self.orderNumberContentLabel.text = HXSafeString(paymentDetailModel.orderNum);
    self.orderTimeContentLabel.text = HXSafeString(paymentDetailModel.createDate);
    self.paymentTimeContentLabel.text = HXSafeString(paymentDetailModel.feeDate);
    self.shijiaoMoneyLabel.text = [NSString stringWithFormat:@"¥%.2f",paymentDetailModel.payMoney];
    
    self.checkFaPiaoBtn.hidden = self.checkShouKuanBtn.hidden = self.checkJiaoYiBtn.hidden = YES;
    //订单类型  1待完成        2已完成     -1待审核    -2驳回      0未完成
    if (paymentDetailModel.orderStatus == 2) {//已完成
        self.paymentStateLabel.text = @"";
        self.paymentNameLabel.sd_layout.rightSpaceToView(self.paymentStateLabel , 0);
        self.paymentNameLabel.textColor = COLOR_WITH_ALPHA(0xAFAFAF, 1);
        self.paymentAmountContentLabel.textColor = COLOR_WITH_ALPHA(0xAFAFAF, 1);
        self.orderNumberContentLabel.textColor = COLOR_WITH_ALPHA(0xAFAFAF, 1);
        self.orderTimeContentLabel.textColor = COLOR_WITH_ALPHA(0xAFAFAF, 1);
        self.paymentTimeContentLabel.textColor = COLOR_WITH_ALPHA(0xAFAFAF, 1);
        self.shijiaoLabel.hidden = self.shijiaoMoneyLabel.hidden = self.finishImageView.hidden = NO;
        self.finishImageView.image = [UIImage imageNamed:(paymentDetailModel.isMb==2?@"yijiezhuan":@"finishpayment")];
        self.checkFaPiaoBtn.hidden = self.checkShouKuanBtn.hidden = self.checkJiaoYiBtn.hidden = NO;
        if ([HXCommonUtil isNull:paymentDetailModel.invoiceurl]) {
            self.checkFaPiaoBtn.sd_layout.widthIs(0);
        }else{
            self.checkFaPiaoBtn.sd_layout.widthIs(90);
        }
        
        if ([HXCommonUtil isNull:paymentDetailModel.receiptUrl]) {
            self.checkShouKuanBtn.sd_layout.widthIs(0).rightSpaceToView(self.checkFaPiaoBtn, 0);
        }else{
            self.checkShouKuanBtn.sd_layout.widthIs(90).rightSpaceToView(self.checkFaPiaoBtn, 10);
        }
        
        if ([HXCommonUtil isNull:paymentDetailModel.proofUrl]) {
            self.checkJiaoYiBtn.sd_layout.widthIs(0).rightSpaceToView(self.checkShouKuanBtn, 0);
        }else{
            self.checkJiaoYiBtn.sd_layout.widthIs(90).rightSpaceToView(self.checkShouKuanBtn, 10);
        }
       
    }else if (paymentDetailModel.orderStatus == -1||paymentDetailModel.orderStatus == -2){
        self.paymentStateLabel.text = (paymentDetailModel.orderStatus == -1?@"待审核":@"已驳回");
        self.paymentNameLabel.sd_layout.rightSpaceToView(self.paymentStateLabel , 14);
        self.paymentNameLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        self.paymentAmountContentLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        self.orderNumberContentLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        self.orderTimeContentLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        self.paymentTimeContentLabel.textColor =COLOR_WITH_ALPHA(0x2C2C2E, 1);
        self.shijiaoLabel.hidden = self.shijiaoMoneyLabel.hidden = self.finishImageView.hidden = YES;
        self.checkFaPiaoBtn.hidden = self.checkShouKuanBtn.hidden = self.checkJiaoYiBtn.hidden = YES;
    }
}

#pragma mark - Event
///查看凭证 PDFType: 1、收款凭证     2、交易凭证    3、发票凭证
-(void)checkJiaoYiVoucher:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(paidDetailCell:checkVoucher:pDFType:)]) {
        [self.delegate paidDetailCell:self checkVoucher:self.paymentDetailModel.proofUrl pDFType:2];
    }
}

-(void)checkShouKuanVoucher:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(paidDetailCell:checkVoucher:pDFType:)]) {
        [self.delegate paidDetailCell:self checkVoucher:self.paymentDetailModel.receiptUrl pDFType:1];
    }
}

-(void)checkFaPiaoVoucher:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(paidDetailCell:checkVoucher:pDFType:)]) {
        [self.delegate paidDetailCell:self checkVoucher:self.paymentDetailModel.invoiceurl pDFType:3];
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
    [self.bigTopGroundImageView addSubview:self.paymentTimeLabel];
    [self.bigTopGroundImageView addSubview:self.paymentTimeContentLabel];
    [self.bigTopGroundImageView addSubview:self.finishImageView];
    
    [self.contentView addSubview:self.smallBottomImageView];
    [self.smallBottomImageView addSubview:self.shijiaoLabel];
    [self.smallBottomImageView addSubview:self.shijiaoMoneyLabel];
    [self.smallBottomImageView addSubview:self.checkJiaoYiBtn];
    [self.smallBottomImageView addSubview:self.checkShouKuanBtn];
    [self.smallBottomImageView addSubview:self.checkFaPiaoBtn];
    
    
    self.bigTopGroundImageView.sd_layout
    .topEqualToView(self.contentView)
    .leftSpaceToView(self.contentView, 10)
    .rightSpaceToView(self.contentView, 10)
    .heightIs(210);
    
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
    .topSpaceToView(self.titleLabel , 8)
    .leftEqualToView(self.titleLabel)
    .rightSpaceToView(self.paymentStateLabel , _kpw(14))
    .heightIs(22);
    
    self.divisionLine.sd_layout
    .topSpaceToView(self.bigTopGroundImageView, 70)
    .leftSpaceToView(self.bigTopGroundImageView, _kpw(14))
    .rightSpaceToView(self.bigTopGroundImageView, _kpw(14))
    .heightIs(1);
    
    
    self.finishImageView.sd_layout
    .topSpaceToView(self.divisionLine, 10)
    .centerXEqualToView(self.bigTopGroundImageView)
    .widthIs(139)
    .heightIs(132);
    
    
    self.paymentAmountLabel.sd_layout
    .topSpaceToView(self.divisionLine, 18)
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
    
    self.paymentTimeLabel.sd_layout
    .topSpaceToView(self.orderTimeLabel, 10)
    .leftEqualToView(self.paymentAmountLabel)
    .rightEqualToView(self.paymentAmountLabel)
    .heightIs(20);
    
    self.paymentTimeContentLabel.sd_layout
    .centerYEqualToView(self.paymentTimeLabel)
    .leftEqualToView(self.paymentAmountContentLabel)
    .rightEqualToView(self.paymentAmountContentLabel)
    .heightIs(20);
    
    self.smallBottomImageView.sd_layout
    .topSpaceToView(self.bigTopGroundImageView, 0)
    .leftSpaceToView(self.contentView, 10)
    .rightSpaceToView(self.contentView, 10)
    .heightIs(100);
    
    
    self.shijiaoLabel.sd_layout
    .topSpaceToView(self.smallBottomImageView,20)
    .leftSpaceToView(self.smallBottomImageView, 22)
    .heightIs(20);
    [self.shijiaoLabel setSingleLineAutoResizeWithMaxWidth:100];
    
    self.shijiaoMoneyLabel.sd_layout
    .centerYEqualToView(self.shijiaoLabel)
    .leftSpaceToView(self.shijiaoLabel, 5)
    .rightSpaceToView(self.smallBottomImageView, 22)
    .heightIs(20);
    
    self.checkFaPiaoBtn.sd_layout
    .topSpaceToView(self.shijiaoLabel,10)
    .rightSpaceToView(self.smallBottomImageView, 10)
    .widthIs(90)
    .heightIs(36);
    self.checkFaPiaoBtn.sd_cornerRadiusFromHeightRatio = @0.5;
    
    self.checkShouKuanBtn.sd_layout
    .centerYEqualToView(self.checkFaPiaoBtn)
    .rightSpaceToView(self.checkFaPiaoBtn, 10)
    .widthIs(90)
    .heightIs(36);
    self.checkShouKuanBtn.sd_cornerRadiusFromHeightRatio = @0.5;
    
    self.checkJiaoYiBtn.sd_layout
    .centerYEqualToView(self.checkFaPiaoBtn)
    .rightSpaceToView(self.checkShouKuanBtn, 10)
    .widthIs(90)
    .heightIs(36);
    self.checkJiaoYiBtn.sd_cornerRadiusFromHeightRatio = @0.5;
    
    
    
}

#pragma mark - lazyLoad

-(UIImageView *)bigTopGroundImageView{
    if (!_bigTopGroundImageView) {
        _bigTopGroundImageView = [[UIImageView alloc] init];
        _bigTopGroundImageView.userInteractionEnabled = YES;
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
        _paymentNameLabel.textColor = COLOR_WITH_ALPHA(0xAFAFAF, 1);
        _paymentNameLabel.font = HXBoldFont(16);
        _paymentNameLabel.textAlignment = NSTextAlignmentLeft;
        _paymentNameLabel.numberOfLines = 1;
    }
    return _paymentNameLabel;
}

-(UILabel *)paymentStateLabel{
    if (!_paymentStateLabel) {
        _paymentStateLabel = [[UILabel alloc] init];
        _paymentStateLabel.textColor = COLOR_WITH_ALPHA(0x4BA4FE, 1);
        _paymentStateLabel.font = HXBoldFont(16);
        _paymentStateLabel.textAlignment = NSTextAlignmentRight;
        _paymentStateLabel.clipsToBounds = YES;
    }
    return _paymentStateLabel;
}

-(UIImageView *)finishImageView{
    if (!_finishImageView) {
        _finishImageView = [[UIImageView alloc] init];
        _finishImageView.image = [UIImage imageNamed:@"finishpayment"];
    }
    return _finishImageView;
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
        _paymentAmountContentLabel.textColor = COLOR_WITH_ALPHA(0xAFAFAF, 1);
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
        _orderNumberContentLabel.textColor = COLOR_WITH_ALPHA(0xAFAFAF, 1);
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
        _orderTimeContentLabel.textColor = COLOR_WITH_ALPHA(0xAFAFAF, 1);
        _orderTimeContentLabel.font = HXFont(14);
        _orderTimeContentLabel.textAlignment = NSTextAlignmentRight;
        
    }
    return _orderTimeContentLabel;
}

-(UILabel *)paymentTimeLabel{
    if (!_paymentTimeLabel) {
        _paymentTimeLabel = [[UILabel alloc] init];
        _paymentTimeLabel.textColor = COLOR_WITH_ALPHA(0xAFAFAF, 1);
        _paymentTimeLabel.font = HXFont(14);
        _paymentTimeLabel.textAlignment = NSTextAlignmentLeft;
        _paymentTimeLabel.text = @"支付时间：";
    }
    return _paymentTimeLabel;
}

-(UILabel *)paymentTimeContentLabel{
    if (!_paymentTimeContentLabel) {
        _paymentTimeContentLabel = [[UILabel alloc] init];
        _paymentTimeContentLabel.textColor = COLOR_WITH_ALPHA(0xAFAFAF, 1);
        _paymentTimeContentLabel.font = HXFont(14);
        _paymentTimeContentLabel.textAlignment = NSTextAlignmentRight;
        
    }
    return _paymentTimeContentLabel;
}

-(UIImageView *)smallBottomImageView{
    if (!_smallBottomImageView) {
        _smallBottomImageView = [[UIImageView alloc] init];
        _smallBottomImageView.userInteractionEnabled = YES;
        _smallBottomImageView.image = [UIImage imageNamed:@"smallbottom"];
        _smallBottomImageView.contentMode = UIViewContentModeScaleToFill;
        _smallBottomImageView.clipsToBounds = YES;
    }
    return _smallBottomImageView;
}

-(UILabel *)shijiaoLabel{
    if (!_shijiaoLabel) {
        _shijiaoLabel = [[UILabel alloc] init];
        _shijiaoLabel.textColor = COLOR_WITH_ALPHA(0xAFAFAF, 1);
        _shijiaoLabel.font = HXFont(14);
        _shijiaoLabel.textAlignment = NSTextAlignmentLeft;
        _shijiaoLabel.text = @"实缴金额：";
    }
    return _shijiaoLabel;
}

-(UILabel *)shijiaoMoneyLabel{
    if (!_shijiaoMoneyLabel) {
        _shijiaoMoneyLabel = [[UILabel alloc] init];
        _shijiaoMoneyLabel.textColor = COLOR_WITH_ALPHA(0x4BA4FE, 1);
        _shijiaoMoneyLabel.font = HXFont(14);
        _shijiaoMoneyLabel.textAlignment = NSTextAlignmentLeft;
    
    }
    return _shijiaoMoneyLabel;
}

-(UIButton *)checkJiaoYiBtn{
    if (!_checkJiaoYiBtn) {
        _checkJiaoYiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _checkJiaoYiBtn.backgroundColor = [UIColor whiteColor];
        _checkJiaoYiBtn .titleLabel.font = HXFont(14);
        [_checkJiaoYiBtn setTitleColor:COLOR_WITH_ALPHA(0x4BA4FE, 1) forState:UIControlStateNormal];
        _checkJiaoYiBtn.layer.borderWidth = 1;
        _checkJiaoYiBtn.layer.borderColor = COLOR_WITH_ALPHA(0x4BA4FE, 1).CGColor;
        [_checkJiaoYiBtn addTarget:self action:@selector(checkJiaoYiVoucher:) forControlEvents:UIControlEventTouchUpInside];
        [_checkJiaoYiBtn setTitle:@"交易凭证" forState:UIControlStateNormal];
    }
    return _checkJiaoYiBtn;
}

-(UIButton *)checkShouKuanBtn{
    if (!_checkShouKuanBtn) {
        _checkShouKuanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _checkShouKuanBtn.backgroundColor = [UIColor whiteColor];
        _checkShouKuanBtn .titleLabel.font = HXFont(14);
        [_checkShouKuanBtn setTitleColor:COLOR_WITH_ALPHA(0x4BA4FE, 1) forState:UIControlStateNormal];
        _checkShouKuanBtn.layer.borderWidth = 1;
        _checkShouKuanBtn.layer.borderColor = COLOR_WITH_ALPHA(0x4BA4FE, 1).CGColor;
        [_checkShouKuanBtn addTarget:self action:@selector(checkShouKuanVoucher:) forControlEvents:UIControlEventTouchUpInside];
        [_checkShouKuanBtn setTitle:@"收款凭证" forState:UIControlStateNormal];
    }
    return _checkShouKuanBtn;
}


-(UIButton *)checkFaPiaoBtn{
    if (!_checkFaPiaoBtn) {
        _checkFaPiaoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _checkFaPiaoBtn.backgroundColor = [UIColor whiteColor];
        _checkFaPiaoBtn .titleLabel.font = HXFont(14);
        [_checkFaPiaoBtn setTitleColor:COLOR_WITH_ALPHA(0x4BA4FE, 1) forState:UIControlStateNormal];
        _checkFaPiaoBtn.layer.borderWidth = 1;
        _checkFaPiaoBtn.layer.borderColor = COLOR_WITH_ALPHA(0x4BA4FE, 1).CGColor;
        [_checkFaPiaoBtn setTitle:@"发票凭证" forState:UIControlStateNormal];
        [_checkFaPiaoBtn addTarget:self action:@selector(checkFaPiaoVoucher:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _checkFaPiaoBtn;
}

@end
