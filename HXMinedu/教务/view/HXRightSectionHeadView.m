//
//  HXRightSectionHeadView.m
//  HXMinedu
//
//  Created by mac on 2021/3/31.
//

#import "HXRightSectionHeadView.h"

@interface HXRightSectionHeadView ()

@property(nonatomic,strong) UILabel *titleLabel;
@property(nonatomic,strong) UIImageView *leftImageView;
@property(nonatomic,strong) UIImageView *rightImageView;

@end

@implementation HXRightSectionHeadView
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self){
        [self createUI];
    }
    return self;
}
-(void)createUI{
    [self addSubview:self.titleLabel];
    [self addSubview:self.leftImageView];
    [self addSubview:self.rightImageView];
    
    self.titleLabel.sd_layout
    .centerYEqualToView(self)
    .centerXEqualToView(self)
    .heightIs(20);
    [self.titleLabel setSingleLineAutoResizeWithMaxWidth:80];
    
    
    self.leftImageView.sd_layout
    .centerYEqualToView(self)
    .rightSpaceToView(self.titleLabel, 10)
    .widthIs(20)
    .heightIs(8);
    
    self.rightImageView.sd_layout
    .centerYEqualToView(self)
    .leftSpaceToView(self.titleLabel, 10)
    .widthRatioToView(self.leftImageView, 1)
    .heightRatioToView(self.leftImageView, 1);
    
    
    
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = COLOR_WITH_ALPHA(0xAFAFAF, 1);
        _titleLabel.font = HXFont(14);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = @"类型";
    }
    return _titleLabel;
}

-(UIImageView *)leftImageView{
    if (!_leftImageView) {
        _leftImageView = [[UIImageView alloc] init];
        _leftImageView.image = [UIImage imageNamed:@"double_triangle"];
    }
    return _leftImageView;
}

-(UIImageView *)rightImageView{
    if (!_rightImageView) {
        _rightImageView = [[UIImageView alloc] init];
        _rightImageView.image = [UIImage imageNamed:@"double_triangle"];
    }
    return _rightImageView;
}

@end
