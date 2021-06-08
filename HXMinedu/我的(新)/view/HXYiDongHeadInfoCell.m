//
//  HXYiDongHeadInfoCell.m
//  HXMinedu
//
//  Created by mac on 2021/6/4.
//

#import "HXYiDongHeadInfoCell.h"

@interface HXYiDongHeadInfoCell ()
@property(nonatomic,strong) UILabel *timeTitleLabel;
@property(nonatomic,strong) UILabel *timeContentLabel;
@property(nonatomic,strong) UILabel *typeTitleLabel;
@property(nonatomic,strong) UILabel *typeContentLabel;
@property(nonatomic,strong) UILabel *reasonsTitleLabel;
@property(nonatomic,strong) UILabel *reasonsContentLabel;
@property(nonatomic,strong) UIButton *markBtn1;
@property(nonatomic,strong) UIButton *markBtn2;
@property(nonatomic,strong) UIButton *markBtn3;
@end

@implementation HXYiDongHeadInfoCell

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
#pragma mark - UI
-(void)createUI{
    
    [self addSubview:self.timeTitleLabel];
    [self addSubview:self.timeContentLabel];
    [self addSubview:self.typeTitleLabel];
    [self addSubview:self.typeContentLabel];
    [self addSubview:self.reasonsTitleLabel];
    [self addSubview:self.reasonsContentLabel];
    [self addSubview:self.markBtn1];
    [self addSubview:self.markBtn2];
    [self addSubview:self.markBtn3];
    
    self.timeTitleLabel.sd_layout
    .topSpaceToView(self, 20)
    .leftSpaceToView(self, 24)
    .widthIs(76)
    .heightIs(20);
    
    self.timeContentLabel.sd_layout
    .leftSpaceToView(self.timeTitleLabel, 5)
    .centerYEqualToView(self.timeTitleLabel)
    .rightSpaceToView(self, 24)
    .heightIs(20);
    
    self.typeTitleLabel.sd_layout
    .topSpaceToView(self.timeTitleLabel, 8)
    .leftEqualToView(self.timeTitleLabel)
    .rightEqualToView(self.timeTitleLabel)
    .heightRatioToView(self.timeTitleLabel, 1);
    
    
    self.typeContentLabel.sd_layout
    .leftSpaceToView(self.typeTitleLabel, 5)
    .centerYEqualToView(self.typeTitleLabel)
    .heightRatioToView(self.timeTitleLabel, 1);
    [self.typeContentLabel setSingleLineAutoResizeWithMaxWidth:120];
    
    self.markBtn1.sd_layout
    .leftSpaceToView(self.typeContentLabel, 8)
    .centerYEqualToView(self.typeContentLabel);
    [self.markBtn1 setupAutoSizeWithHorizontalPadding:8 buttonHeight:22];
    self.markBtn1.sd_cornerRadius = @2;
    
    self.markBtn2.sd_layout
    .leftSpaceToView(self.markBtn1, 8)
    .centerYEqualToView(self.typeContentLabel);
    [self.markBtn2 setupAutoSizeWithHorizontalPadding:8 buttonHeight:22];
    self.markBtn2.sd_cornerRadius = @2;
    
    self.markBtn3.sd_layout
    .leftSpaceToView(self.markBtn2, 8)
    .centerYEqualToView(self.typeContentLabel);
    [self.markBtn3 setupAutoSizeWithHorizontalPadding:8 buttonHeight:22];
    self.markBtn3.sd_cornerRadius = @2;
    
    self.reasonsTitleLabel.sd_layout
    .topSpaceToView(self.typeTitleLabel, 8)
    .leftEqualToView(self.timeTitleLabel)
    .rightEqualToView(self.timeTitleLabel)
    .heightRatioToView(self.timeTitleLabel, 1);
    
    self.reasonsContentLabel.sd_layout
    .leftSpaceToView(self.reasonsTitleLabel, 5)
    .centerYEqualToView(self.reasonsTitleLabel)
    .rightSpaceToView(self, 24)
    .heightRatioToView(self.timeTitleLabel, 1);
    
    
    
}

-(UILabel *)timeTitleLabel{
    if (!_timeTitleLabel) {
        _timeTitleLabel = [[UILabel alloc] init];
        _timeTitleLabel.textAlignment = NSTextAlignmentLeft;
        _timeTitleLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        _timeTitleLabel.font = HXFont(14);
        _timeTitleLabel.text = @"异动时间：";
    }
    return _timeTitleLabel;
}
-(UILabel *)timeContentLabel{
    if (!_timeContentLabel) {
        _timeContentLabel = [[UILabel alloc] init];
        _timeContentLabel.textAlignment = NSTextAlignmentLeft;
        _timeContentLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        _timeContentLabel.font = HXBoldFont(14);
        _timeContentLabel.text = @"2021-05-02  11:50";
    }
    return _timeContentLabel;
}

-(UILabel *)typeTitleLabel{
    if (!_typeTitleLabel) {
        _typeTitleLabel = [[UILabel alloc] init];
        _typeTitleLabel.textAlignment = NSTextAlignmentLeft;
        _typeTitleLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        _typeTitleLabel.font = HXFont(14);
        _typeTitleLabel.text = @"异动类型：";
    }
    return _typeTitleLabel;
}

-(UILabel *)typeContentLabel{
    if (!_typeContentLabel) {
        _typeContentLabel = [[UILabel alloc] init];
        _typeContentLabel.textAlignment = NSTextAlignmentLeft;
        _typeContentLabel.textColor = COLOR_WITH_ALPHA(0x5699FF, 1);
        _typeContentLabel.font = HXBoldFont(14);
        _typeContentLabel.text = @"退学/休学";
    }
    return _typeContentLabel;
}

-(UILabel *)reasonsTitleLabel{
    if (!_reasonsTitleLabel) {
        _reasonsTitleLabel = [[UILabel alloc] init];
        _reasonsTitleLabel.textAlignment = NSTextAlignmentLeft;
        _reasonsTitleLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        _reasonsTitleLabel.font = HXFont(14);
        _reasonsTitleLabel.text = @"异动原因：";
    }
    return _reasonsTitleLabel;
}

-(UILabel *)reasonsContentLabel{
    if (!_reasonsContentLabel) {
        _reasonsContentLabel = [[UILabel alloc] init];
        _reasonsContentLabel.textAlignment = NSTextAlignmentLeft;
        _reasonsContentLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        _reasonsContentLabel.font = HXBoldFont(14);
        _reasonsContentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _reasonsContentLabel.text = @"身体原因";
    }
    return _reasonsContentLabel;
}

-(UIButton *)markBtn1{
    if (!_markBtn1) {
        _markBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        _markBtn1.titleLabel.font = HXBoldFont(12);
        _markBtn1.backgroundColor = COLOR_WITH_ALPHA(0xC8FACB, 1);
        [_markBtn1 setTitle:@"确认无误" forState:UIControlStateNormal];
        [_markBtn1 setTitleColor:COLOR_WITH_ALPHA(0x4DC656, 1) forState:UIControlStateNormal];
    }
    return _markBtn1;
}

-(UIButton *)markBtn2{
    if (!_markBtn2) {
        _markBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        _markBtn2.titleLabel.font = HXBoldFont(12);
        _markBtn2.backgroundColor = COLOR_WITH_ALPHA(0xC8FACB, 1);
        [_markBtn2 setTitle:@"已通过" forState:UIControlStateNormal];
        [_markBtn2 setTitleColor:COLOR_WITH_ALPHA(0x4DC656, 1) forState:UIControlStateNormal];
    }
    return _markBtn2;
}

-(UIButton *)markBtn3{
    if (!_markBtn3) {
        _markBtn3 = [UIButton buttonWithType:UIButtonTypeCustom];
        _markBtn3.titleLabel.font = HXBoldFont(12);
        _markBtn3.backgroundColor = COLOR_WITH_ALPHA(0xFFF5DA, 1);
        [_markBtn3 setTitle:@"审核中" forState:UIControlStateNormal];
        [_markBtn3 setTitleColor:COLOR_WITH_ALPHA(0xFE664B, 1) forState:UIControlStateNormal];
    }
    return _markBtn3;
}

@end
