//
//  HXPaidDetailCell.m
//  HXMinedu
//
//  Created by mac on 2021/4/21.
//

#import "HXPaidDetailCell.h"

@interface HXPaidDetailCell ()

@property(nonatomic,strong) UILabel *paymentNameLabel;
@property(nonatomic,strong) UILabel *priceLabel;//单价
@property(nonatomic,strong) UILabel *numLabel;//数目
@property(nonatomic,strong) UILabel *totalPriceLabel;//总价
@property(nonatomic,strong) UIView *divisionLine;
//支付金额
@property(nonatomic,strong) UILabel *paymentAmountLabel;
@property(nonatomic,strong) UILabel *paymentAmountContentLabel;
//订单编号
@property(nonatomic,strong) UILabel *orderNumberLabel;
@property(nonatomic,strong) UILabel *orderNumberContentLabel;
//支付时间
@property(nonatomic,strong) UILabel *paymentTimeLabel;
@property(nonatomic,strong) UILabel *paymentTimeContentLabel;

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
        self.backgroundColor = [UIColor whiteColor];
        [self createUI];
    }
    return self;
}

-(void)setPaymentDetailModel:(HXPaymentDetailModel *)paymentDetailModel{
    _paymentDetailModel = paymentDetailModel;
    self.paymentNameLabel.text = HXSafeString(paymentDetailModel.feeType_Name);
    self.priceLabel.text = [NSString stringWithFormat:@"¥%.2f",paymentDetailModel.fee];
    self.numLabel.text = HXSafeString(paymentDetailModel.feeYearName);;
    self.totalPriceLabel.text = [NSString stringWithFormat:@"¥%.2f",paymentDetailModel.payMoney];
    self.paymentAmountContentLabel.text = [NSString stringWithFormat:@"¥%.2f",paymentDetailModel.payMoney];
    self.orderNumberContentLabel.text = HXSafeString(paymentDetailModel.orderNum);
    self.paymentTimeContentLabel.text = HXSafeString(paymentDetailModel.feeDate);
    
}


#pragma mark - UI
-(void)createUI{
    [self addSubview:self.paymentNameLabel];
    [self addSubview:self.priceLabel];
    [self addSubview:self.numLabel];
    [self addSubview:self.totalPriceLabel];
    [self addSubview:self.divisionLine];
    [self addSubview:self.paymentAmountLabel];
    [self addSubview:self.paymentAmountContentLabel];
    [self addSubview:self.orderNumberLabel];
    [self addSubview:self.orderNumberContentLabel];
    [self addSubview:self.paymentTimeLabel];
    [self addSubview:self.paymentTimeContentLabel];
    
    self.paymentNameLabel.sd_layout
    .topSpaceToView(self, 28)
    .leftSpaceToView(self, _kpw(30))
    .autoHeightRatio(0);
    [self.paymentNameLabel setSingleLineAutoResizeWithMaxWidth:kScreenWidth/2-40];
    
    
    
    self.numLabel.sd_layout
    .topSpaceToView(self, 44)
    .rightSpaceToView(self, _kpw(24))
    .heightIs(17);
    [self.numLabel setSingleLineAutoResizeWithMaxWidth:100];
    
    self.priceLabel.sd_layout
    .topSpaceToView(self, 40)
    .leftSpaceToView(self, kScreenWidth/2+20)
    .rightSpaceToView(self.numLabel, 15)
    .heightIs(20);
    
    
    self.totalPriceLabel.sd_layout
    .topSpaceToView(self.numLabel, 10)
    .rightSpaceToView(self, _kpw(24))
    .widthIs(100)
    .heightIs(22);
    
    self.divisionLine.sd_layout
    .topSpaceToView(self.totalPriceLabel, 12)
    .leftSpaceToView(self, _kpw(24))
    .rightSpaceToView(self, _kpw(24))
    .heightIs(1);
    
    
    self.paymentAmountLabel.sd_layout
    .topSpaceToView(self.divisionLine, 24)
    .leftEqualToView(self.paymentNameLabel)
    .widthIs(kScreenWidth/2-60)
    .heightIs(20);
    
    self.paymentAmountContentLabel.sd_layout
    .centerYEqualToView(self.paymentAmountLabel)
    .leftEqualToView(self.priceLabel)
    .rightSpaceToView(self, _kpw(24))
    .heightIs(20);
    
    self.orderNumberLabel.sd_layout
    .topSpaceToView(self.paymentAmountLabel, 10)
    .leftEqualToView(self.paymentAmountLabel)
    .rightEqualToView(self.paymentAmountLabel)
    .heightIs(20);
    
    self.orderNumberContentLabel.sd_layout
    .centerYEqualToView(self.orderNumberLabel)
    .leftEqualToView(self.priceLabel)
    .rightSpaceToView(self, _kpw(24))
    .heightIs(20);
    
    self.paymentTimeLabel.sd_layout
    .topSpaceToView(self.orderNumberContentLabel, 10)
    .leftEqualToView(self.paymentAmountLabel)
    .rightEqualToView(self.paymentAmountLabel)
    .heightIs(20);
    
    self.paymentTimeContentLabel.sd_layout
    .centerYEqualToView(self.paymentTimeLabel)
    .leftEqualToView(self.priceLabel)
    .rightSpaceToView(self, _kpw(24))
    .heightIs(20);
    
    
}

#pragma mark - lazyLoad
-(UILabel *)paymentNameLabel{
    if (!_paymentNameLabel) {
        _paymentNameLabel = [[UILabel alloc] init];
        _paymentNameLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        _paymentNameLabel.font = HXBoldFont(16);
        _paymentNameLabel.textAlignment = NSTextAlignmentLeft;
        _paymentNameLabel.numberOfLines = 2;
    }
    return _paymentNameLabel;
}

-(UILabel *)priceLabel{
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        _priceLabel.font = HXFont(14);
        _priceLabel.textAlignment = NSTextAlignmentRight;
       
    }
    return _priceLabel;
}

-(UILabel *)numLabel{
    if (!_numLabel) {
        _numLabel = [[UILabel alloc] init];
        _numLabel.textColor = COLOR_WITH_ALPHA(0xAFAFAF, 1);
        _numLabel.font = HXFont(12);
        _numLabel.textAlignment = NSTextAlignmentRight;
        
    }
    return _numLabel;
}

-(UILabel *)totalPriceLabel{
    if (!_totalPriceLabel) {
        _totalPriceLabel = [[UILabel alloc] init];
        _totalPriceLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        _totalPriceLabel.font = HXBoldFont(12);
        _totalPriceLabel.textAlignment = NSTextAlignmentRight;
        
    }
    return _totalPriceLabel;
}

-(UIView *)divisionLine{
    if (!_divisionLine) {
        _divisionLine = [[UIView alloc] init];
        _divisionLine.backgroundColor = COLOR_WITH_ALPHA(0x979797, 0.5);
    }
    return _divisionLine;
}

-(UILabel *)paymentAmountLabel{
    if (!_paymentAmountLabel) {
        _paymentAmountLabel = [[UILabel alloc] init];
        _paymentAmountLabel.textColor = COLOR_WITH_ALPHA(0xAFAFAF, 1);
        _paymentAmountLabel.font = HXFont(14);
        _paymentAmountLabel.textAlignment = NSTextAlignmentLeft;
        _paymentAmountLabel.text = @"支付金额：";
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
        _paymentTimeContentLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        _paymentTimeContentLabel.font = HXFont(14);
        _paymentTimeContentLabel.textAlignment = NSTextAlignmentRight;
        
    }
    return _paymentTimeContentLabel;
}

@end
