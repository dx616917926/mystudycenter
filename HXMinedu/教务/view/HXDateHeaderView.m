//
//  HXDateHeaderView.m
//  HXMinedu
//
//  Created by mac on 2021/3/30.
//

#import "HXDateHeaderView.h"

@interface HXDateHeaderView ()
@property(nonatomic,strong) UIImageView *circulImageView;
@property(nonatomic,strong) UIImageView *upDashImageView;
@property(nonatomic,strong) UIImageView *downDashImageView;
@property(nonatomic,strong) UILabel *dateLabel;


@end

@implementation HXDateHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *backgroundView = [[UIView alloc] init];
        backgroundView.backgroundColor = [UIColor whiteColor];
        self.backgroundView = backgroundView;
        [self createUI];
    }
    return self;
}
-(void)createUI{
    
    [self addSubview:self.upDashImageView];
    [self addSubview:self.downDashImageView];
    [self addSubview:self.circulImageView];
    [self addSubview:self.dateLabel];
    
    self.circulImageView.sd_layout
    .centerYEqualToView(self)
    .leftSpaceToView(self, _kpw(28)-5)
    .widthIs(10)
    .heightEqualToWidth();
    self.circulImageView.sd_cornerRadiusFromHeightRatio = @0.5;
    
    self.upDashImageView.sd_layout
    .centerXEqualToView(self.circulImageView)
    .topEqualToView(self)
    .bottomEqualToView(self.circulImageView)
    .widthIs(0.5);
    
    self.downDashImageView.sd_layout
    .centerXEqualToView(self.circulImageView)
    .topEqualToView(self.circulImageView)
    .bottomEqualToView(self)
    .widthIs(0.5);
    
    self.dateLabel.sd_layout
    .centerYEqualToView(self)
    .leftSpaceToView(self.circulImageView, 10)
    .rightSpaceToView(self, _kpw(23))
    .heightIs(20);
    
}

- (void)setIsFirst:(BOOL)isFirst{
    _isFirst = isFirst;
    self.upDashImageView.hidden = isFirst;
}

- (void)setIsLast:(BOOL)isLast{
    _isLast = isLast;
    self.downDashImageView.hidden = isLast;
}

-(void)setDayModel:(HXExamDayModel *)dayModel{
    _dayModel = dayModel;
    self.dateLabel.text = HXSafeString(dayModel.examDayText);
}

#pragma mark - lazyLoad
-(UIImageView *)circulImageView{
    if (!_circulImageView) {
        _circulImageView = [[UIImageView alloc] init];
        _circulImageView.backgroundColor = COLOR_WITH_ALPHA(0xfff7d1, 1);
        _circulImageView.layer.borderColor = COLOR_WITH_ALPHA(0xffc156, 1).CGColor;
        _circulImageView.layer.borderWidth = 1;
    }
    return _circulImageView;
}

-(UIImageView *)upDashImageView{
    if (!_upDashImageView) {
        _upDashImageView = [[UIImageView alloc] init];
        _upDashImageView.backgroundColor = COLOR_WITH_ALPHA(0xffc156, 1);
    }
    return _upDashImageView;
}

-(UIImageView *)downDashImageView{
    if (!_downDashImageView) {
        _downDashImageView = [[UIImageView alloc] init];
        _downDashImageView.backgroundColor = COLOR_WITH_ALPHA(0xffc156, 1);
    }
    return _downDashImageView;
}

-(UILabel *)dateLabel{
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        _dateLabel.textAlignment = NSTextAlignmentLeft;
        _dateLabel.font = HXBoldFont(14);
        
    }
    return _dateLabel;;
}

@end
