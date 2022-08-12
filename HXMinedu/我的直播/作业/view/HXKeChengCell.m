//
//  HXKeChengCell.m
//  HXMinedu
//
//  Created by mac on 2022/8/11.
//

#import "HXKeChengCell.h"

@interface HXKeChengCell ()

@property(nonatomic,strong) UIView *bigBackgroundView;
@property(nonatomic,strong) UIImageView *coverImageView;
@property(nonatomic,strong) UIView *fenGeLine;
@property(nonatomic,strong) UILabel *keChengNameLabel;
@property(nonatomic,strong) UILabel *shiYongTypeLabel;
@property(nonatomic,strong) UILabel *totalNumLabel;
@property(nonatomic,strong) UILabel *unfinishNumLabel;
@property(nonatomic,strong) UIView *bottomLine;

@end

@implementation HXKeChengCell

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

#pragma mark - Seeter


#pragma mark - UI
-(void)createUI{
    [self.contentView addSubview:self.bigBackgroundView];
    [self.bigBackgroundView addSubview:self.coverImageView];
    [self.bigBackgroundView addSubview:self.fenGeLine];
    [self.bigBackgroundView addSubview:self.keChengNameLabel];
    [self.bigBackgroundView addSubview:self.shiYongTypeLabel];
    [self.bigBackgroundView addSubview:self.totalNumLabel];
    [self.bigBackgroundView addSubview:self.unfinishNumLabel];
    [self.bigBackgroundView addSubview:self.bottomLine];
    



    self.bigBackgroundView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    
    self.coverImageView.sd_layout
    .leftSpaceToView(self.bigBackgroundView, 20)
    .topSpaceToView(self.bigBackgroundView, 20)
    .widthIs(92)
    .heightIs(62);
    self.coverImageView.sd_cornerRadius = @4;
    
    self.fenGeLine.sd_layout
    .leftSpaceToView(self.coverImageView, 20)
    .centerYEqualToView(self.coverImageView)
    .widthIs(1)
    .heightIs(50);
    
    
    self.keChengNameLabel.sd_layout
    .topSpaceToView(self.bigBackgroundView, 12)
    .leftSpaceToView(self.fenGeLine, 20)
    .rightSpaceToView(self.bigBackgroundView, 10)
    .heightIs(20);
    
    self.shiYongTypeLabel.sd_layout
    .topSpaceToView(self.keChengNameLabel, 5)
    .leftEqualToView(self.keChengNameLabel)
    .rightEqualToView(self.keChengNameLabel)
    .heightIs(14);
    
    self.totalNumLabel.sd_layout
    .topSpaceToView(self.shiYongTypeLabel, 5)
    .leftEqualToView(self.keChengNameLabel)
    .rightEqualToView(self.keChengNameLabel)
    .heightRatioToView(self.shiYongTypeLabel, 1);
    
    self.unfinishNumLabel.sd_layout
    .topSpaceToView(self.totalNumLabel, 5)
    .leftEqualToView(self.keChengNameLabel)
    .rightEqualToView(self.keChengNameLabel)
    .heightRatioToView(self.shiYongTypeLabel, 1);
    
    self.bottomLine.sd_layout
    .bottomEqualToView(self.bigBackgroundView)
    .leftSpaceToView(self.bigBackgroundView, 10)
    .rightSpaceToView(self.bigBackgroundView, 10)
    .heightIs(1);
    
}



#pragma mark - LazyLoad

-(UIView *)bigBackgroundView{
    if (!_bigBackgroundView) {
        _bigBackgroundView = [[UIView alloc] init];
        _bigBackgroundView.backgroundColor = [UIColor whiteColor];
        _bigBackgroundView.clipsToBounds = YES;
    }
    return _bigBackgroundView;
}

-(UIImageView *)coverImageView{
    if (!_coverImageView) {
        _coverImageView = [[UIImageView alloc] init];
        _coverImageView.image = [UIImage imageNamed:@"kechengzhanwei_bg"];
        _coverImageView.clipsToBounds = YES;
    }
    return _coverImageView;
}

-(UIView *)fenGeLine{
    if (!_fenGeLine) {
        _fenGeLine = [[UIView alloc] init];
        _fenGeLine.backgroundColor = COLOR_WITH_ALPHA(0xE5E5E5, 1);
    }
    return _fenGeLine;
}


-(UILabel *)keChengNameLabel{
    if (!_keChengNameLabel) {
        _keChengNameLabel = [[UILabel alloc] init];
        _keChengNameLabel.textAlignment = NSTextAlignmentLeft;
        _keChengNameLabel.font = HXBoldFont(14);
        _keChengNameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _keChengNameLabel.textColor = COLOR_WITH_ALPHA(0x181414, 1);
        _keChengNameLabel.text = @"自学考试大学语文公开课";
    }
    return _keChengNameLabel;
}

-(UILabel *)shiYongTypeLabel{
    if (!_shiYongTypeLabel) {
        _shiYongTypeLabel = [[UILabel alloc] init];
        _shiYongTypeLabel.textAlignment = NSTextAlignmentLeft;
        _shiYongTypeLabel.font = HXFont(11);
        _shiYongTypeLabel.textColor = COLOR_WITH_ALPHA(0x9F9F9F, 1);
        _shiYongTypeLabel.text = @"适用类型：自学考试；成人考试";
    }
    return _shiYongTypeLabel;
}

-(UILabel *)totalNumLabel{
    if (!_totalNumLabel) {
        _totalNumLabel = [[UILabel alloc] init];
        _totalNumLabel.textAlignment = NSTextAlignmentLeft;
        _totalNumLabel.font = HXFont(11);
        _totalNumLabel.textColor = COLOR_WITH_ALPHA(0x9F9F9F, 1);
        _totalNumLabel.text = @"总课节数：5节";
    }
    return _totalNumLabel;
}

-(UILabel *)unfinishNumLabel{
    if (!_unfinishNumLabel) {
        _unfinishNumLabel = [[UILabel alloc] init];
        _unfinishNumLabel.textAlignment = NSTextAlignmentLeft;
        _unfinishNumLabel.font = HXFont(11);
        _unfinishNumLabel.textColor = COLOR_WITH_ALPHA(0x9F9F9F, 1);
        _unfinishNumLabel.text = @"待完成课节数：3节";
    }
    return _unfinishNumLabel;
}

-(UIView *)bottomLine{
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = COLOR_WITH_ALPHA(0xEBEBEB, 1);
    }
    return _bottomLine;
}

@end

