//
//  HXElectronicDataCell.m
//  HXMinedu
//
//  Created by mac on 2022/4/13.
//

#import "HXElectronicDataCell.h"

@interface HXElectronicDataCell ()

@property(strong,nonatomic) UIImageView *iconImageView;
@property(strong,nonatomic) UILabel *titleLabel;
@property(strong,nonatomic) UILabel *sizeLabel;
@property(strong,nonatomic) UILabel *timeLabel;

@end

@implementation HXElectronicDataCell

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


-(void)setElectronicDataModel:(HXElectronicDataModel *)electronicDataModel{
    
    _electronicDataModel = electronicDataModel;
    
    self.titleLabel.text = HXSafeString(electronicDataModel.FileName);
    self.sizeLabel.text = [NSString stringWithFormat:@"%.2fKB",electronicDataModel.FileSize*1.0/1024];
    self.timeLabel.text = [NSString stringWithFormat:@"  |  %@",electronicDataModel.AddTimeText];
}

#pragma mark - UI
-(void)createUI{
    
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.sizeLabel];
    [self.contentView addSubview:self.timeLabel];
    
    self.iconImageView.sd_layout
    .centerYEqualToView(self.contentView)
    .leftSpaceToView(self.contentView, 20)
    .widthIs(40)
    .heightEqualToWidth();
    self.iconImageView.sd_cornerRadius = @10;
    
    self.titleLabel.sd_layout
    .topEqualToView(self.iconImageView)
    .leftSpaceToView(self.iconImageView, 10)
    .rightSpaceToView(self.contentView, 22)
    .heightIs(22);
    
    self.sizeLabel.sd_layout
    .bottomEqualToView(self.iconImageView)
    .leftEqualToView(self.titleLabel)
    .heightIs(16);
    [self.sizeLabel setSingleLineAutoResizeWithMaxWidth:100];
    
    self.timeLabel.sd_layout
    .centerYEqualToView(self.sizeLabel)
    .leftSpaceToView(self.sizeLabel, 0)
    .heightRatioToView(self.sizeLabel, 1)
    .rightSpaceToView(self.contentView, 22);
    
}

#pragma mark - UI
-(UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.image = [UIImage imageNamed:@"pdf_icon"];
    }
    return _iconImageView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = HXFont(16);
        _titleLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
        
    }
    return _titleLabel;
}

- (UILabel *)sizeLabel{
    if (!_sizeLabel) {
        _sizeLabel = [[UILabel alloc] init];
        _sizeLabel.font = HXFont(11);
        _sizeLabel.textColor = COLOR_WITH_ALPHA(0x9E9E9E, 1);
        
    }
    return _sizeLabel;
}

- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = HXFont(11);
        _timeLabel.textColor = COLOR_WITH_ALPHA(0x9E9E9E, 1);
        
    }
    return _timeLabel;
}

@end
