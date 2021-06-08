//
//  HXCostDetailsCell.m
//  HXMinedu
//
//  Created by mac on 2021/6/7.
//

#import "HXCostDetailsCell.h"

@interface  HXCostDetailsCell()

@property(nonatomic,strong) UIImageView *dashLine1;//分割线
@property(nonatomic,strong) UILabel *nameLabel;//姓名
@property(nonatomic,strong) UIView *shadowBackgroundView;
@property(nonatomic,strong) UIView *bigBackgroundView;
@property(nonatomic,strong) UIView *headContainerView;
@property(nonatomic,strong) UILabel *costCategoryLabel;//费用类别
@property(nonatomic,strong) UILabel *shijiaoLabel;//实缴金额
@property(nonatomic,strong) UILabel *refundLabel;//退费金额
@property(nonatomic,strong) UIImageView *dashLine2;//分割线
@property(nonatomic,strong) UIView *costContainerView;//记录每一项
@property(nonatomic,strong) UILabel *totalRefundLabel;//合计退费金额：

@end

@implementation HXCostDetailsCell

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
    [self addSubview:self.dashLine1];
    [self addSubview:self.nameLabel];
    
    [self addSubview:self.shadowBackgroundView];
    [self addSubview:self.bigBackgroundView];
    
    [self.bigBackgroundView addSubview:self.headContainerView];
    [self.headContainerView addSubview:self.costCategoryLabel];
    [self.headContainerView addSubview:self.shijiaoLabel];
    [self.headContainerView addSubview:self.refundLabel];
    
    [self.bigBackgroundView addSubview:self.costContainerView];
    [self.bigBackgroundView addSubview:self.dashLine2];
    [self.bigBackgroundView addSubview:self.totalRefundLabel];
    
    self.dashLine1.sd_layout
    .topSpaceToView(self, 0)
    .leftSpaceToView(self, 16)
    .rightSpaceToView(self, 16)
    .heightIs(1);
    
    self.nameLabel.sd_layout
    .topSpaceToView(self.dashLine1, 12)
    .leftSpaceToView(self, 24)
    .rightSpaceToView(self, 24)
    .heightIs(20);
    
    self.bigBackgroundView.sd_layout
    .topSpaceToView(self.nameLabel, 12)
    .leftSpaceToView(self, 10)
    .rightSpaceToView(self, 10);
    self.bigBackgroundView.sd_cornerRadius = @6;
    
    self.headContainerView.sd_layout
    .topEqualToView(self.bigBackgroundView)
    .leftEqualToView(self.bigBackgroundView)
    .rightEqualToView(self.bigBackgroundView);
    
    self.costCategoryLabel.sd_layout.heightIs(48);
    self.shijiaoLabel.sd_layout.heightIs(48);
    self.refundLabel.sd_layout.heightIs(48);
    
    [self.headContainerView setupAutoWidthFlowItems:@[self.costCategoryLabel,self.shijiaoLabel,self.refundLabel] withPerRowItemsCount:3 verticalMargin:0 horizontalMargin:10 verticalEdgeInset:0 horizontalEdgeInset:30];
    
    self.costContainerView.sd_layout
    .topSpaceToView(self.headContainerView, 0)
    .leftEqualToView(self.bigBackgroundView)
    .rightEqualToView(self.bigBackgroundView);
    
    UIView *lastView = self.costContainerView;
    ///创建条目
    for (int i = 0; i < 2; i++) {

        UIView *itemView = [[UIView alloc] init];
        itemView.backgroundColor = [UIColor clearColor];
        [self.costContainerView addSubview:itemView];
        itemView.sd_layout
        .topSpaceToView(lastView, 0)
        .leftEqualToView(self.costContainerView)
        .rightEqualToView(self.costContainerView)
        .heightIs(42);
        
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.textAlignment = NSTextAlignmentRight;
        nameLabel.font = HXFont(14);
        nameLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        nameLabel.text = @"代毕业信息采集";
        [itemView addSubview:nameLabel];
        
        UILabel *shijiaolabel = [[UILabel alloc] init];
        shijiaolabel.textAlignment = NSTextAlignmentCenter;
        shijiaolabel.font = HXFont(14);
        shijiaolabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        shijiaolabel.text = @"100.0";
        [itemView addSubview:shijiaolabel];
        
        UILabel *refundlabel = [[UILabel alloc] init];
        refundlabel.textAlignment = NSTextAlignmentCenter;
        refundlabel.font = HXFont(14);
        refundlabel.text =  @"100.0";
        [itemView addSubview:refundlabel];
       
        
        nameLabel.sd_layout
        .centerYEqualToView(itemView)
        .leftSpaceToView(itemView, 5)
        .heightIs(20)
        .widthRatioToView(itemView, 0.3);
        
        shijiaolabel.sd_layout
        .centerYEqualToView(itemView)
        .leftSpaceToView(nameLabel, 5)
        .heightIs(20)
        .widthRatioToView(itemView, 0.3);
        
        refundlabel.sd_layout
        .centerYEqualToView(itemView)
        .leftSpaceToView(shijiaolabel, 5)
        .heightIs(20)
        .widthRatioToView(itemView, 0.3);
        
        lastView = itemView;
    }
    
    [self.costContainerView setupAutoHeightWithBottomView:lastView bottomMargin:5];
    [self.costContainerView updateLayout];
    
    self.dashLine2.sd_layout
    .topSpaceToView(self.costContainerView, 0)
    .leftEqualToView(self.bigBackgroundView)
    .rightEqualToView(self.bigBackgroundView)
    .heightIs(1);
    
    self.totalRefundLabel.sd_layout
    .topSpaceToView(self.dashLine2, 15)
    .rightSpaceToView(self.bigBackgroundView, _kpw(58))
    .leftSpaceToView(self.bigBackgroundView, _kpw(58))
    .heightIs(20);
    
    [self.bigBackgroundView setupAutoHeightWithBottomView:self.totalRefundLabel bottomMargin:15];
    self.shadowBackgroundView.sd_layout
    .topEqualToView(self.bigBackgroundView)
    .rightEqualToView(self.bigBackgroundView)
    .leftEqualToView(self.bigBackgroundView)
    .bottomEqualToView(self.bigBackgroundView);
    self.shadowBackgroundView.layer.cornerRadius = 6;
    ///设置cell高度自适应
    [self setupAutoHeightWithBottomView:self.bigBackgroundView bottomMargin:5];
    
}


#pragma mark - lazyLooad

-(UIImageView *)dashLine1{
    if (!_dashLine1) {
        _dashLine1 = [[UIImageView alloc] init];
        _dashLine1.image = [UIImage imageNamed:@"long_dashline"];
    }
    return _dashLine1;
}

-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.font = HXBoldFont(14);
        _nameLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        _nameLabel.text = @"李丽丽  4309551998121921788";
    }
    return _nameLabel;
}

-(UIView *)shadowBackgroundView{
    if (!_shadowBackgroundView) {
        _shadowBackgroundView = [[UIView alloc] init];
        _shadowBackgroundView.backgroundColor = [UIColor whiteColor];
        _shadowBackgroundView.layer.shadowColor = COLOR_WITH_ALPHA(0x000000, 0.15).CGColor;
        _shadowBackgroundView.layer.shadowOffset = CGSizeMake(0, 2);
        _shadowBackgroundView.layer.shadowRadius = 4;
        _shadowBackgroundView.layer.shadowOpacity = 1;
    }
    return _shadowBackgroundView;
}

-(UIView *)bigBackgroundView{
    if (!_bigBackgroundView) {
        _bigBackgroundView = [[UIView alloc] init];
        _bigBackgroundView.backgroundColor = [UIColor whiteColor];
        _bigBackgroundView.clipsToBounds = YES;
    }
    return _bigBackgroundView;
}


-(UIView *)headContainerView{
    if (!_headContainerView) {
        _headContainerView = [[UIView alloc] init];
        _headContainerView.backgroundColor = COLOR_WITH_ALPHA(0xD8D8D8, 0.43);
        _headContainerView.clipsToBounds = YES;
    }
    return _headContainerView;
}

-(UILabel *)costCategoryLabel{
    if (!_costCategoryLabel) {
        _costCategoryLabel = [[UILabel alloc] init];
        _costCategoryLabel.textAlignment = NSTextAlignmentCenter;
        _costCategoryLabel.font = HXBoldFont(14);
        _costCategoryLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        _costCategoryLabel.text = @"费用类别";
    }
    return _costCategoryLabel;
}



-(UILabel *)shijiaoLabel{
    if (!_shijiaoLabel) {
        _shijiaoLabel = [[UILabel alloc] init];
        _shijiaoLabel.textAlignment = NSTextAlignmentCenter;
        _shijiaoLabel.font = HXBoldFont(14);
        _shijiaoLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        _shijiaoLabel.text = @"实缴金额";
    }
    return _shijiaoLabel;
}

-(UILabel *)refundLabel{
    if (!_refundLabel) {
        _refundLabel = [[UILabel alloc] init];
        _refundLabel.textAlignment = NSTextAlignmentCenter;
        _refundLabel.font = HXBoldFont(14);
        _refundLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        _refundLabel.text = @"退费金额";
    }
    return _refundLabel;
}

-(UIView *)costContainerView{
    if (!_costContainerView) {
        _costContainerView = [[UIView alloc] init];
        _costContainerView.backgroundColor = [UIColor whiteColor];
    }
    return _costContainerView;
}

-(UIImageView *)dashLine2{
    if (!_dashLine2) {
        _dashLine2 = [[UIImageView alloc] init];
        _dashLine2.image = [UIImage imageNamed:@"long_dashline"];
    }
    return _dashLine2;
}

-(UILabel *)totalRefundLabel{
    if (!_totalRefundLabel) {
        _totalRefundLabel = [[UILabel alloc] init];
        _totalRefundLabel.textAlignment = NSTextAlignmentRight;
        _totalRefundLabel.font = HXBoldFont(14);
        _totalRefundLabel.textColor = COLOR_WITH_ALPHA(0xFE664B, 1);
        _totalRefundLabel.text = @"合计退费金额：¥220";
    }
    return _totalRefundLabel;
}


@end
