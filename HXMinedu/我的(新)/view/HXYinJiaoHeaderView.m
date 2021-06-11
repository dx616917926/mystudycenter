//
//  HXYinJiaoHeaderView.m
//  HXMinedu
//
//  Created by mac on 2021/6/8.
//

#import "HXYinJiaoHeaderView.h"

@interface HXYinJiaoHeaderView ()
@property(strong,nonatomic) UIView *bigContainerView;
@property(nonatomic,strong) UILabel *titleLabel;//标题
@property(nonatomic,strong) UILabel *stateLabel;//在籍
@property(nonatomic,strong) UILabel *yingJiaoLabel;//应缴合计
@property(nonatomic,strong) UILabel *yingJiaoMoneyLabel;
@property(nonatomic,strong) UILabel *shiJiaoLabel;//实缴合计
@property(nonatomic,strong) UILabel *shiJiaoMoneyLabel;
@end

@implementation HXYinJiaoHeaderView

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        [self createUI];
    }
    return self;
}

-(void)setHeaderViewType:(HXHeaderViewType)headerViewType{
    _headerViewType = headerViewType;
    if (headerViewType == HXYingJiaoDetailsType) {
        self.bigContainerView.backgroundColor = [UIColor whiteColor];
        self.stateLabel.textColor = COLOR_WITH_ALPHA(0x5699FF, 1);
        self.yingJiaoMoneyLabel.textColor = COLOR_WITH_ALPHA(0x5699FF, 1);
        self.shiJiaoMoneyLabel.textColor = COLOR_WITH_ALPHA(0xFE664B, 1);
    }else{
        self.bigContainerView.backgroundColor = COLOR_WITH_ALPHA(0xEFEFEF, 1);
        self.stateLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        self.yingJiaoMoneyLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        self.yingJiaoMoneyLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
    }
    
}

-(void)setPaymentModel:(HXPaymentModel *)paymentModel{
    _paymentModel = paymentModel;
    self.titleLabel.text = HXSafeString(paymentModel.title);
    self.stateLabel.text = HXSafeString(paymentModel.studentStateName);
    self.yingJiaoMoneyLabel.text = [NSString stringWithFormat:@"¥%.2f",paymentModel.feeTotal];
    self.shiJiaoMoneyLabel.text = [NSString stringWithFormat:@"¥%.2f",paymentModel.payMoneyTotal];
    
}

-(void)createUI{
    [self.contentView addSubview:self.bigContainerView];
    [self.bigContainerView addSubview:self.titleLabel];
    [self.bigContainerView addSubview:self.stateLabel];
    [self.bigContainerView addSubview:self.yingJiaoLabel];
    [self.bigContainerView addSubview:self.yingJiaoMoneyLabel];
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = COLOR_WITH_ALPHA(0x979797, 1);
    [self.bigContainerView addSubview:line];
    [self.bigContainerView addSubview:self.shiJiaoLabel];
    [self.bigContainerView addSubview:self.shiJiaoMoneyLabel];
    
    self.bigContainerView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 10, 0, 10));
    self.bigContainerView.sd_cornerRadius = @6;
    
    self.stateLabel.sd_layout
    .topSpaceToView(self.bigContainerView, 16)
    .rightSpaceToView(self.bigContainerView, 16)
    .heightIs(17);
    [self.stateLabel setSingleLineAutoResizeWithMaxWidth:100];
    
    self.titleLabel.sd_layout
    .topSpaceToView(self.bigContainerView, 16)
    .leftSpaceToView(self.bigContainerView, 16)
    .rightSpaceToView(self.stateLabel, 16)
    .heightIs(17);
    
    line.sd_layout
    .topSpaceToView(self.titleLabel, 24)
    .centerXEqualToView(self.bigContainerView)
    .widthIs(1)
    .heightIs(28);
    
    self.yingJiaoLabel.sd_layout
    .topSpaceToView(self.titleLabel, 21)
    .leftSpaceToView(self.bigContainerView, 5)
    .rightSpaceToView(line, 5)
    .heightIs(17);
    
     self.yingJiaoMoneyLabel.sd_layout
     .topSpaceToView(self.yingJiaoLabel, 3)
     .leftSpaceToView(self.bigContainerView, 5)
     .rightSpaceToView(line, 5)
     .heightIs(20);
    
     self.shiJiaoLabel.sd_layout
     .centerYEqualToView(self.yingJiaoLabel)
     .rightSpaceToView(self.bigContainerView, 5)
     .leftSpaceToView(line, 5)
     .heightIs(17);
     
      self.shiJiaoMoneyLabel.sd_layout
      .centerYEqualToView(self.yingJiaoMoneyLabel)
      .rightSpaceToView(self.bigContainerView, 5)
      .leftSpaceToView(line, 5)
      .heightIs(20);
    
}

-(UIView *)bigContainerView{
    if (!_bigContainerView) {
        _bigContainerView = [[UIView alloc] init];
        _bigContainerView.backgroundColor = [UIColor whiteColor];
    }
    return _bigContainerView;
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = HXBoldFont(12);
        _titleLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        
    }
    return _titleLabel;
}

-(UILabel *)stateLabel{
    if (!_stateLabel) {
        _stateLabel = [[UILabel alloc] init];
        _stateLabel.textAlignment = NSTextAlignmentRight;
        _stateLabel.font = HXBoldFont(12);
        _stateLabel.textColor = COLOR_WITH_ALPHA(0x5699FF, 1);
        
    }
    return _stateLabel;
}

-(UILabel *)yingJiaoLabel{
    if (!_yingJiaoLabel) {
        _yingJiaoLabel = [[UILabel alloc] init];
        _yingJiaoLabel.textAlignment = NSTextAlignmentCenter;
        _yingJiaoLabel.font = HXFont(12);
        _yingJiaoLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        _yingJiaoLabel.text = @"应缴合计";
    }
    return _yingJiaoLabel;
}

-(UILabel *)yingJiaoMoneyLabel{
    if (!_yingJiaoMoneyLabel) {
        _yingJiaoMoneyLabel = [[UILabel alloc] init];
        _yingJiaoMoneyLabel.textAlignment = NSTextAlignmentCenter;
        _yingJiaoMoneyLabel.font = HXFont(12);
        _yingJiaoMoneyLabel.textColor = COLOR_WITH_ALPHA(0x5699FF, 1);
    }
    return _yingJiaoMoneyLabel;
}



-(UILabel *)shiJiaoLabel{
    if (!_shiJiaoLabel) {
        _shiJiaoLabel = [[UILabel alloc] init];
        _shiJiaoLabel.textAlignment = NSTextAlignmentCenter;
        _shiJiaoLabel.font = HXFont(12);
        _shiJiaoLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        _shiJiaoLabel.text = @"实缴合计";
    }
    return _shiJiaoLabel;
}

-(UILabel *)shiJiaoMoneyLabel{
    if (!_shiJiaoMoneyLabel) {
        _shiJiaoMoneyLabel = [[UILabel alloc] init];
        _shiJiaoMoneyLabel.textAlignment = NSTextAlignmentCenter;
        _shiJiaoMoneyLabel.font = HXFont(12);
        _shiJiaoMoneyLabel.textColor = COLOR_WITH_ALPHA(0xFE664B, 1);
    }
    return _shiJiaoMoneyLabel;
}

@end
