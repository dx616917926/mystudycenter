//
//  HXKeChengKeJieCell.m
//  HXMinedu
//
//  Created by mac on 2022/8/10.
//

#import "HXKeChengKeJieCell.h"

@interface HXKeChengKeJieCell ()
@property(nonatomic,strong) UIView *shadowBackgroundView;
@property(nonatomic,strong) UIView *bigBackgroundView;
@property(nonatomic,strong) UIImageView *coverImageView;
@property(nonatomic,strong) UIImageView *stateImageView;
@property(nonatomic,strong) UILabel *keJieNameLabel;
@property(nonatomic,strong) UILabel *teacherNameLabel;
@property(nonatomic,strong) UILabel *timeLabel;

@end

@implementation HXKeChengKeJieCell

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
    [self.contentView addSubview:self.shadowBackgroundView];
    [self.contentView addSubview:self.bigBackgroundView];
    [self.bigBackgroundView addSubview:self.coverImageView];
    [self.bigBackgroundView addSubview:self.stateImageView];
    [self.bigBackgroundView addSubview:self.keJieNameLabel];
    [self.bigBackgroundView addSubview:self.teacherNameLabel];
    [self.bigBackgroundView addSubview:self.timeLabel];
    



    
    self.bigBackgroundView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(5, 20, 5, 20));
    self.bigBackgroundView.sd_cornerRadius = @8;
    
    self.shadowBackgroundView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(5, 20, 5, 20));
    self.shadowBackgroundView.layer.cornerRadius = 5;
    
    self.coverImageView.sd_layout
    .leftSpaceToView(self.bigBackgroundView, 10)
    .topSpaceToView(self.bigBackgroundView, 15)
    .bottomSpaceToView(self.bigBackgroundView, 15)
    .widthIs(92);
    self.coverImageView.sd_cornerRadius = @8;
    
    self.stateImageView.sd_layout
    .topSpaceToView(self.bigBackgroundView, 0)
    .rightSpaceToView(self.bigBackgroundView, 0)
    .widthIs(57)
    .heightIs(34);
    
    self.keJieNameLabel.sd_layout
    .topEqualToView(self.coverImageView)
    .leftSpaceToView(self.coverImageView, 10)
    .rightSpaceToView(self.stateImageView, 10)
    .heightIs(20);
    
    self.teacherNameLabel.sd_layout
    .topSpaceToView(self.keJieNameLabel, 9)
    .leftEqualToView(self.keJieNameLabel)
    .rightSpaceToView(self.bigBackgroundView, 10)
    .heightIs(14);
    
    self.timeLabel.sd_layout
    .bottomEqualToView(self.coverImageView)
    .leftEqualToView(self.keJieNameLabel)
    .rightSpaceToView(self.bigBackgroundView, 10)
    .heightIs(14);
    
    
}



#pragma mark - LazyLoad
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

-(UIImageView *)coverImageView{
    if (!_coverImageView) {
        _coverImageView = [[UIImageView alloc] init];
        _coverImageView.image = [UIImage imageNamed:@"kechengzhanwei_bg"];
        _coverImageView.clipsToBounds = YES;
    }
    return _coverImageView;
}

-(UIImageView *)stateImageView{
    if (!_stateImageView) {
        _stateImageView = [[UIImageView alloc] init];
        _stateImageView.image = [UIImage imageNamed:@"onlive_icon"];
    }
    return _stateImageView;
}



-(UILabel *)keJieNameLabel{
    if (!_keJieNameLabel) {
        _keJieNameLabel = [[UILabel alloc] init];
        _keJieNameLabel.textAlignment = NSTextAlignmentLeft;
        _keJieNameLabel.font = HXBoldFont(14);
        _keJieNameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _keJieNameLabel.textColor = COLOR_WITH_ALPHA(0x181414, 1);
        _keJieNameLabel.text = @"自学考试大学语文公开课-1";
    }
    return _keJieNameLabel;
}

-(UILabel *)teacherNameLabel{
    if (!_teacherNameLabel) {
        _teacherNameLabel = [[UILabel alloc] init];
        _teacherNameLabel.textAlignment = NSTextAlignmentLeft;
        _teacherNameLabel.font = HXFont(11);
        _teacherNameLabel.textColor = COLOR_WITH_ALPHA(0x9F9F9F, 1);
        _teacherNameLabel.text = @"授课教师：李老师";
    }
    return _teacherNameLabel;
}

-(UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        _timeLabel.font = HXFont(11);
        _timeLabel.textColor = COLOR_WITH_ALPHA(0x9F9F9F, 1);
        _timeLabel.text = @"上课时间：2022/07/21 星期四 10:00 (40分钟)";
    }
    return _timeLabel;
}

@end

