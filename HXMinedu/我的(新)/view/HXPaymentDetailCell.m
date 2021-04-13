//
//  HXPaymentDetailCell.m
//  HXMinedu
//
//  Created by mac on 2021/4/8.
//

#import "HXPaymentDetailCell.h"

@interface HXPaymentDetailCell ()
@property(nonatomic,strong) UIView *topLine;
@property(nonatomic,strong) UILabel *paymentNameLabel;
@property(nonatomic,strong) UILabel *priceLabel;//单价
@property(nonatomic,strong) UILabel *numLabel;//数目
@property(nonatomic,strong) UILabel *originalPriceLabel;//原价
@property(nonatomic,strong) UILabel *totalPriceLabel;//总价


@end

@implementation HXPaymentDetailCell

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

-(void)createUI{
    [self addSubview:self.topLine];
    [self addSubview:self.paymentNameLabel];
    [self addSubview:self.priceLabel];
    [self addSubview:self.numLabel];
    [self addSubview:self.originalPriceLabel];
    [self addSubview:self.totalPriceLabel];
    
    self.topLine.sd_layout
    .topEqualToView(self)
    .leftSpaceToView(self, _kpw(23))
    .rightSpaceToView(self, _kpw(23))
    .heightIs(1);
    
    self.paymentNameLabel.sd_layout
    .leftEqualToView(self.topLine).offset(8)
    .topSpaceToView(self.topLine, 17)
    .heightIs(20);
    [self.paymentNameLabel setSingleLineAutoResizeWithMaxWidth:150];
    
    self.numLabel.sd_layout
    .topSpaceToView(self.topLine, 30)
    .rightEqualToView(self.topLine).offset(-8)
    .heightIs(17);
    [self.numLabel setSingleLineAutoResizeWithMaxWidth:80];
    
    self.priceLabel.sd_layout
    .topSpaceToView(self.topLine, 26)
    .leftSpaceToView(self.paymentNameLabel, 14)
    .rightSpaceToView(self.numLabel, 14)
    .heightIs(22);
    
    self.totalPriceLabel.sd_layout
    .topSpaceToView(self.numLabel, 10)
    .rightEqualToView(self.numLabel)
    .heightIs(22);
    [self.totalPriceLabel setSingleLineAutoResizeWithMaxWidth:150];
    
    self.originalPriceLabel.sd_layout
    .bottomEqualToView(self.totalPriceLabel)
    .rightSpaceToView(self.totalPriceLabel,20)
    .heightIs(17);
    [self.originalPriceLabel setSingleLineAutoResizeWithMaxWidth:150];
    
}

#pragma mark - lazyLoad

-(UIView *)topLine{
    if (!_topLine) {
        _topLine = [[UIView alloc] init];
        _topLine.backgroundColor = COLOR_WITH_ALPHA(0x979797, 0.4);
    }
    return _topLine;
}

-(UILabel *)paymentNameLabel{
    if (!_paymentNameLabel) {
        _paymentNameLabel = [[UILabel alloc] init];
        _paymentNameLabel.textAlignment = NSTextAlignmentLeft;
        _paymentNameLabel.font = HXFont(14);
        _paymentNameLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        _paymentNameLabel.text = @"培训学费";
    }
    return _paymentNameLabel;
}

-(UILabel *)priceLabel{
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.textAlignment = NSTextAlignmentRight;
        _priceLabel.font = HXFont(14);
        _priceLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        _priceLabel.text = @"¥2400.00";
    }
    return _priceLabel;
}

-(UILabel *)numLabel{
    if (!_numLabel) {
        _numLabel = [[UILabel alloc] init];
        _numLabel.textAlignment = NSTextAlignmentRight;
        _numLabel.font = HXFont(12);
        _numLabel.textColor = COLOR_WITH_ALPHA(0xAFAFAF, 1);
        _numLabel.text = @"x2.5年";
    }
    return _numLabel;
}

-(UILabel *)originalPriceLabel{
    if (!_originalPriceLabel) {
        _originalPriceLabel = [[UILabel alloc] init];
        _originalPriceLabel.textAlignment = NSTextAlignmentRight;
        _originalPriceLabel.font = HXFont(12);
        _originalPriceLabel.textColor = COLOR_WITH_ALPHA(0xAFAFAF, 1);
        NSMutableAttributedString *newPrice = [[NSMutableAttributedString alloc] initWithString:@"¥6000.00"];
        [newPrice addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, newPrice.length)];
        _originalPriceLabel.attributedText = newPrice;

    }
    return _originalPriceLabel;
}

-(UILabel *)totalPriceLabel{
    if (!_totalPriceLabel) {
        _totalPriceLabel = [[UILabel alloc] init];
        _totalPriceLabel.textAlignment = NSTextAlignmentRight;
        _totalPriceLabel.font = HXFont(12);
        _totalPriceLabel.textColor = COLOR_WITH_ALPHA(0x5699FF, 1);
        _totalPriceLabel.text = @"¥5800.00";
    }
    return _totalPriceLabel;
}

@end
