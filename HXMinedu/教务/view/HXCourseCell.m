//
//  HXCourseCell.m
//  HXMinedu
//
//  Created by 邓雄 on 2021/3/30.
//

#import "HXCourseCell.h"

@interface HXCourseCell ()
@property(nonatomic,strong) UIImageView *dashImageView;
@property(nonatomic,strong) UIView *blueDotView;
@property(nonatomic,strong) UILabel *timeLabel;
@property(nonatomic,strong) UILabel *courseNameLabel;

@end

@implementation HXCourseCell

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

-(void)setIsLast:(BOOL)isLast{
    _isLast = isLast;
    self.dashImageView.hidden = isLast;
}

-(void)createUI{
    [self addSubview:self.dashImageView];
    [self addSubview:self.blueDotView];
    [self addSubview:self.timeLabel];
    [self addSubview:self.courseNameLabel];
    
    
    self.dashImageView.sd_layout
    .topEqualToView(self)
    .bottomEqualToView(self)
    .leftSpaceToView(self, _kpw(23)-0.5)
    .widthIs(1);
    
    self.blueDotView.sd_layout
    .leftSpaceToView(self.dashImageView, 10)
    .topSpaceToView(self, 16)
    .widthIs(6)
    .heightEqualToWidth();
    self.blueDotView.sd_cornerRadiusFromHeightRatio = @0.5;
    
    self.timeLabel.sd_layout
    .topSpaceToView(self, 8)
    .leftSpaceToView(self.blueDotView, 10)
    .heightIs(20)
    .widthIs(100);
    
    self.courseNameLabel.sd_layout
    .topSpaceToView(self, 8)
    .leftSpaceToView(self.timeLabel, 10)
    .rightSpaceToView(self, _kpw(23))
    .heightIs(20);
    
}

-(UIImageView *)dashImageView{
    if (!_dashImageView) {
        _dashImageView = [[UIImageView alloc] init];
        _dashImageView.backgroundColor = COLOR_WITH_ALPHA(0xffc156, 1);
    }
    return _dashImageView;
}


#pragma mark - lazyLoad
-(UIView *)blueDotView{
    if (!_blueDotView) {
        _blueDotView = [[UIView alloc] init];
        _blueDotView.backgroundColor = COLOR_WITH_ALPHA(0x4BA4FE, 1);
    }
    return _blueDotView;
}

-(UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        _timeLabel.textColor = COLOR_WITH_ALPHA(0x4BA4FE, 1);
        _timeLabel.font = HXFont(13);
        _timeLabel.text = @"09:00-12:00";
    }
    return _timeLabel;;
}

-(UILabel *)courseNameLabel{
    if (!_courseNameLabel) {
        _courseNameLabel = [[UILabel alloc] init];
        _courseNameLabel.textAlignment = NSTextAlignmentLeft;
        _courseNameLabel.textColor = COLOR_WITH_ALPHA(0x333333, 1);
        _courseNameLabel.font = HXFont(14);
        _courseNameLabel.text = @"计算机应用基础";
    }
    return _courseNameLabel;
}


@end
