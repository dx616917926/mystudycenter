//
//  HXUnPaidDetailCell.m
//  HXMinedu
//
//  Created by mac on 2021/4/22.
//

#import "HXUnPaidDetailCell.h"

@interface HXUnPaidDetailCell ()

@property(nonatomic,strong) UIView *bottomLine;
@property(nonatomic,strong) UILabel *paymentNameLabel;
@property(nonatomic,strong) UILabel *upPaidLabel;//未付金额

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
        [self createUI];
    }
    return self;
}

-(void)setPaymentDetailModel:(HXPaymentDetailModel *)paymentDetailModel{
    _paymentDetailModel = paymentDetailModel;
    self.paymentNameLabel.text = HXSafeString(paymentDetailModel.feeType_Name);
    self.upPaidLabel.text = [NSString stringWithFormat:@"¥%.2f",paymentDetailModel.notPay];
}

-(void)createUI{
    [self addSubview:self.bottomLine];
    [self addSubview:self.paymentNameLabel];
    [self addSubview:self.upPaidLabel];

    
    self.bottomLine.sd_layout
    .bottomEqualToView(self)
    .leftSpaceToView(self, _kpw(23))
    .rightSpaceToView(self, _kpw(23))
    .heightIs(1);
    
    self.paymentNameLabel.sd_layout
    .leftEqualToView(self.bottomLine).offset(8)
    .centerYEqualToView(self)
    .heightIs(20);
    [self.paymentNameLabel setSingleLineAutoResizeWithMaxWidth:200];
   
    self.upPaidLabel.sd_layout
    .centerYEqualToView(self)
    .rightEqualToView(self.bottomLine).offset(-8)
    .heightIs(22);
    [self.upPaidLabel setSingleLineAutoResizeWithMaxWidth:150];
    
}

#pragma mark - lazyLoad

-(UIView *)bottomLine{
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = COLOR_WITH_ALPHA(0x979797, 0.5);
    }
    return _bottomLine;
}

-(UILabel *)paymentNameLabel{
    if (!_paymentNameLabel) {
        _paymentNameLabel = [[UILabel alloc] init];
        _paymentNameLabel.textAlignment = NSTextAlignmentLeft;
        _paymentNameLabel.font = HXFont(14);
        _paymentNameLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        _paymentNameLabel.numberOfLines = 2;

    }
    return _paymentNameLabel;
}


-(UILabel *)upPaidLabel{
    if (!_upPaidLabel) {
        _upPaidLabel = [[UILabel alloc] init];
        _upPaidLabel.textAlignment = NSTextAlignmentRight;
        _upPaidLabel.font = HXBoldFont(14);
        _upPaidLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        
    }
    return _upPaidLabel;
}

@end
