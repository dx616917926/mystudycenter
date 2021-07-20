//
//  HXOriginalPaymentInfoCell.m
//  HXMinedu
//
//  Created by mac on 2021/7/8.
//

#import "HXOriginalPaymentInfoCell.h"

@interface HXOriginalPaymentInfoCell ()
@property(nonatomic,strong) UIImageView *bigBackGroundView;
@property(nonatomic,strong) UIView *topContainerView;
@property(nonatomic,strong) UILabel *paymentNameLabel;//缴费类别
@property(nonatomic,strong) UILabel *yingjiaoLabel;//应缴金额
@property(nonatomic,strong) UILabel *shijiaoLabel;//结转金额
@property(nonatomic,strong) UIImageView *typeImageView;//标准
@property(nonatomic,strong) UILabel *typeLabel;
@property(nonatomic,strong) UIImageView *dashLine1;//分割线
@property(nonatomic,strong) UIImageView *dashLine2;//分割线
@property(nonatomic,strong) UIView *middleContainerView;//记录每一项



@end

@implementation HXOriginalPaymentInfoCell

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

#pragma mark - 赋值刷新
-(void)setPaymentDetailsInfoModel:(HXPaymentDetailsInfoModel *)paymentDetailsInfoModel{
  
    _paymentDetailsInfoModel = paymentDetailsInfoModel;
    //1-标准 2-补录 3-报考
    if (paymentDetailsInfoModel.ftype == 1) {
        self.typeImageView.image = [UIImage imageNamed:@"biaozhun"];
    }else if (paymentDetailsInfoModel.ftype == 2) {
        self.typeImageView.image = [UIImage imageNamed:@"bulu"];
    }else if (paymentDetailsInfoModel.ftype == 3) {
        self.typeImageView.image = [UIImage imageNamed:@"baokao"];
    }else{
        self.typeImageView.image = [UIImage imageNamed:@"qitaleixing"];
    }
    self.typeLabel.text = HXSafeString(paymentDetailsInfoModel.ftypeName);
    [self.middleContainerView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
        obj = nil;
    }];
    
    UIView *lastView = self.middleContainerView;
    ///创建条目
    for (int i = 0; i < paymentDetailsInfoModel.stopStudyByZzyAndZcpFeeInfoList.count; i++) {
        HXPaymentDetailModel *paymentDetailModel = paymentDetailsInfoModel.stopStudyByZzyAndZcpFeeInfoList[i];
        UIView *itemView = [[UIView alloc] init];
        itemView.backgroundColor = [UIColor clearColor];
        [self.middleContainerView addSubview:itemView];
        itemView.sd_layout
        .topSpaceToView(lastView, 0)
        .leftEqualToView(self.middleContainerView)
        .rightEqualToView(self.middleContainerView)
        .heightIs(40);
        
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.font = HXFont(12);
        nameLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        nameLabel.text =HXSafeString(paymentDetailModel.feeType_Name);
        [itemView addSubview:nameLabel];
        
        UILabel *yingjiaolabel = [[UILabel alloc] init];
        yingjiaolabel.textAlignment = NSTextAlignmentCenter;
        yingjiaolabel.font = HXFont(12);
        yingjiaolabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        yingjiaolabel.text = [NSString stringWithFormat:@"¥%.2f",paymentDetailModel.fee];
        [itemView addSubview:yingjiaolabel];
        
        UILabel *shijiaoLabel = [[UILabel alloc] init];
        shijiaoLabel.textAlignment = NSTextAlignmentCenter;
        shijiaoLabel.font = HXFont(12);
        shijiaoLabel.textColor = COLOR_WITH_ALPHA(0x5699FF, 1);
        shijiaoLabel.text =  [NSString stringWithFormat:@"¥%.2f",paymentDetailModel.payMoney];
        [itemView addSubview:shijiaoLabel];
       
        nameLabel.sd_layout
        .centerYEqualToView(itemView)
        .leftSpaceToView(itemView, 5)
        .heightIs(17)
        .widthRatioToView(itemView, 0.3);
        
        yingjiaolabel.sd_layout
        .centerYEqualToView(itemView)
        .leftSpaceToView(nameLabel, 5)
        .heightIs(17)
        .widthRatioToView(itemView, 0.3);
        
        shijiaoLabel.sd_layout
        .centerYEqualToView(itemView)
        .leftSpaceToView(yingjiaolabel, 5)
        .heightIs(17)
        .widthRatioToView(itemView, 0.3);
        
        lastView = itemView;
    }
    
    self.middleContainerView.sd_layout.heightIs(40*paymentDetailsInfoModel.stopStudyByZzyAndZcpFeeInfoList.count);
    [self.middleContainerView updateLayout];
   
}

-(void)createUI{
    [self.contentView addSubview:self.bigBackGroundView];
    [self.bigBackGroundView addSubview:self.topContainerView];
    
    [self.topContainerView addSubview:self.paymentNameLabel];
    [self.topContainerView addSubview:self.yingjiaoLabel];
    [self.topContainerView addSubview:self.shijiaoLabel];
    [self.topContainerView addSubview:self.typeImageView];
    [self.typeImageView addSubview:self.typeLabel];
    [self.topContainerView addSubview:self.dashLine1];
    
    [self.bigBackGroundView addSubview:self.middleContainerView];
    [self.bigBackGroundView addSubview:self.dashLine2];
   
    self.bigBackGroundView.sd_layout
    .topSpaceToView(self.contentView, 0)
    .leftSpaceToView(self.contentView, 10)
    .rightSpaceToView(self.contentView, 10);
    
    self.topContainerView.sd_layout
    .topEqualToView(self.bigBackGroundView)
    .leftEqualToView(self.bigBackGroundView)
    .rightEqualToView(self.bigBackGroundView)
    .heightIs(60);
    
    self.paymentNameLabel.sd_layout
    .topSpaceToView(self.topContainerView, 32)
    .leftSpaceToView(self.topContainerView, 5)
    .heightIs(17)
    .widthRatioToView(self.topContainerView, 0.3);
    
    self.yingjiaoLabel.sd_layout
    .centerYEqualToView(self.paymentNameLabel)
    .leftSpaceToView(self.paymentNameLabel, 5)
    .heightIs(17)
    .widthRatioToView(self.topContainerView, 0.3);
    
    self.shijiaoLabel.sd_layout
    .centerYEqualToView(self.paymentNameLabel)
    .leftSpaceToView(self.yingjiaoLabel, 5)
    .heightIs(17)
    .widthRatioToView(self.topContainerView, 0.3);
    
    self.typeImageView.sd_layout
    .topEqualToView(self.topContainerView).offset(15)
    .rightEqualToView(self.topContainerView)
    .widthIs(60)
    .heightIs(36);
    
    self.dashLine1.sd_layout
    .bottomSpaceToView(self.topContainerView, 0)
    .leftSpaceToView(self.topContainerView, 14)
    .rightSpaceToView(self.topContainerView, 14)
    .heightIs(1);
    
    self.middleContainerView.sd_layout
    .topSpaceToView(self.topContainerView, 0)
    .leftEqualToView(self.bigBackGroundView)
    .rightEqualToView(self.bigBackGroundView)
    .heightIs(0);
    
    self.dashLine2.sd_layout
    .topSpaceToView(self.middleContainerView, 0)
    .leftSpaceToView(self.bigBackGroundView, 14)
    .rightSpaceToView(self.bigBackGroundView, 14)
    .heightIs(1);
    
    [self.bigBackGroundView setupAutoHeightWithBottomView:self.dashLine2 bottomMargin:0];
    
    ///设置cell高度自适应
    [self setupAutoHeightWithBottomView:self.bigBackGroundView bottomMargin:0];
    
    
   
}

#pragma mark - lazyLoad

-(UIImageView *)bigBackGroundView{
    if (!_bigBackGroundView) {
        _bigBackGroundView = [[UIImageView alloc] init];
        _bigBackGroundView.clipsToBounds = YES;
        _bigBackGroundView.image = [UIImage resizedImageWithName:@"middle_radius"];
    }
    return _bigBackGroundView;
}

-(UIView *)topContainerView{
    if (!_topContainerView) {
        _topContainerView = [[UIView alloc] init];
        _topContainerView.backgroundColor = [UIColor clearColor];
        _topContainerView.clipsToBounds = YES;
    }
    return _topContainerView;
}

-(UILabel *)paymentNameLabel{
    if (!_paymentNameLabel) {
        _paymentNameLabel = [[UILabel alloc] init];
        _paymentNameLabel.textAlignment = NSTextAlignmentCenter;
        _paymentNameLabel.font = HXFont(12);
        _paymentNameLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        _paymentNameLabel.text = @"缴费类别";
    }
    return _paymentNameLabel;
}

-(UILabel *)yingjiaoLabel{
    if (!_yingjiaoLabel) {
        _yingjiaoLabel = [[UILabel alloc] init];
        _yingjiaoLabel.textAlignment = NSTextAlignmentCenter;
        _yingjiaoLabel.font = HXFont(12);
        _yingjiaoLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        _yingjiaoLabel.text = @"应缴金额";
    }
    return _yingjiaoLabel;
}

-(UILabel *)shijiaoLabel{
    if (!_shijiaoLabel) {
        _shijiaoLabel = [[UILabel alloc] init];
        _shijiaoLabel.textAlignment = NSTextAlignmentCenter;
        _shijiaoLabel.font = HXFont(12);
        _shijiaoLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        _shijiaoLabel.text = @"实缴金额";
    }
    return _shijiaoLabel;
}

-(UIImageView *)typeImageView{
    if (!_typeImageView) {
        _typeImageView = [[UIImageView alloc] init];
        _typeImageView.image = [UIImage imageNamed:@"biaozhun"];
    }
    return _typeImageView;
}

-(UILabel *)typeLabel{
    if (!_typeLabel) {
        _typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 16,60, 20)];
        _typeLabel.textColor = COLOR_WITH_ALPHA(0xffffff, 1);
        _typeLabel.textAlignment = NSTextAlignmentCenter;
        _typeLabel.font = HXFont(12);
        _typeLabel.backgroundColor = [UIColor clearColor];
        _typeLabel.transform = CGAffineTransformMakeRotation(M_PI/5.45);
        _typeLabel.transform = CGAffineTransformTranslate(_typeLabel.transform ,0, -16);
        _typeLabel.text = @"标准";
    }
    return _typeLabel;
}

-(UIImageView *)dashLine1{
    if (!_dashLine1) {
        _dashLine1 = [[UIImageView alloc] init];
        _dashLine1.image = [UIImage imageNamed:@"short_dashline"];
    }
    return _dashLine1;
}

-(UIImageView *)dashLine2{
    if (!_dashLine2) {
        _dashLine2 = [[UIImageView alloc] init];
        _dashLine2.image = [UIImage imageNamed:@"short_dashline"];
    }
    return _dashLine2;
}



-(UIView *)middleContainerView{
    if (!_middleContainerView) {
        _middleContainerView = [[UIView alloc] init];
        _middleContainerView.backgroundColor = [UIColor clearColor];
        _middleContainerView.clipsToBounds = YES;
    }
    return _middleContainerView;
}


@end

