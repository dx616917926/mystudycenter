//
//  HXStudyReportHeaderView.m
//  HXMinedu
//
//  Created by 邓雄 on 2021/4/7.
//

#import "HXStudyReportHeaderView.h"

@interface HXStudyReportHeaderView ()
@property(nonatomic,strong) UIImageView *dashLineImageView;
@end

@implementation HXStudyReportHeaderView

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
        [self createUI];
    }
    return self;
}

-(void)createUI{
    [self addSubview:self.titleImageView];
    [self addSubview:self.contentLabel];
    [self addSubview:self.dashLineImageView];
    
    self.titleImageView.sd_layout
    .centerYEqualToView(self).offset(-5)
    .leftSpaceToView(self, 20)
    .widthIs(32)
    .heightEqualToWidth();
    self.titleImageView.sd_cornerRadiusFromHeightRatio = @0.5;
    
    self.contentLabel.sd_layout
    .centerYEqualToView(self.titleImageView)
    .leftSpaceToView(self.titleImageView, 15)
    .heightIs(22);
    [self.contentLabel setSingleLineAutoResizeWithMaxWidth:120];
    
    self.dashLineImageView.sd_layout
    .centerYEqualToView(self.titleImageView)
    .rightSpaceToView(self, 20)
    .widthIs(198)
    .heightIs(1);
    
}

-(UIImageView *)titleImageView{
    if (!_titleImageView) {
        _titleImageView = [[UIImageView alloc] init];
    }
    return _titleImageView;
}

-(UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        _contentLabel.font = HXBoldFont(16);
    }
    return _contentLabel;
}

-(UIImageView *)dashLineImageView{
    if (!_dashLineImageView) {
        _dashLineImageView = [[UIImageView alloc] init];
        _dashLineImageView.image =[UIImage imageNamed:@"carddashline"];
    }
    return _dashLineImageView;
}

@end
