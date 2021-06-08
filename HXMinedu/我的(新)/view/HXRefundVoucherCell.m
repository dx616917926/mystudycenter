//
//  HXRefundVoucherCell.m
//  HXMinedu
//
//  Created by mac on 2021/6/8.
//

#import "HXRefundVoucherCell.h"

@interface HXRefundVoucherCell ()
@property(nonatomic,nonnull) UILabel *refundVoucherLabel;//退费凭证：
@property(nonatomic,nonnull) UIImageView *refundVoucherImageView;

@end

@implementation HXRefundVoucherCell

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
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        [self createUI];
        
    }
    return self;
}

-(void)createUI{
    [self addSubview:self.refundVoucherLabel];
    [self addSubview:self.refundVoucherImageView];
    
    self.refundVoucherLabel.sd_layout
    .topSpaceToView(self, 8)
    .leftSpaceToView(self, 24)
    .widthIs(76)
    .heightIs(20);
    
    self.refundVoucherImageView.sd_layout
    .topEqualToView(self.refundVoucherLabel).offset(-2)
    .leftSpaceToView(self.refundVoucherLabel, 5)
    .widthIs(164)
    .heightIs(100);
}


-(UILabel *)refundVoucherLabel{
    if (!_refundVoucherLabel) {
        _refundVoucherLabel = [[UILabel alloc] init];
        _refundVoucherLabel.font = HXFont(14);
        _refundVoucherLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        _refundVoucherLabel.textAlignment = NSTextAlignmentLeft;
        _refundVoucherLabel.text = @"退费凭证：";
    }
    return _refundVoucherLabel;
}

-(UIImageView *)refundVoucherImageView{
    if (!_refundVoucherImageView) {
        _refundVoucherImageView = [[UIImageView alloc] init];
        _refundVoucherImageView.image = [UIImage imageNamed:@"add_pingzheng"];
    }
    return _refundVoucherImageView;
}


@end
