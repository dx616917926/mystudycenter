//
//  HXSelectDateHeaderView.m
//  HXMinedu
//
//  Created by mac on 2021/3/30.
//

#import "HXSelectDateHeaderView.h"

@interface HXSelectDateHeaderView ()
@property(nonatomic,strong) UIButton *selectDateBtn;
@end

@implementation HXSelectDateHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

-(void)createUI{
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.selectDateBtn];
    
    self.selectDateBtn.sd_layout
    .centerXEqualToView(self)
    .centerYEqualToView(self)
    .widthIs(kScreenWidth/3+40)
    .heightIs(30);
    self.selectDateBtn.sd_cornerRadiusFromHeightRatio = @0.5;
    
    self.selectDateBtn.titleLabel.sd_layout
    .centerYEqualToView(self.selectDateBtn)
    .centerXEqualToView(self.selectDateBtn).offset(-10)
    .heightRatioToView(self.selectDateBtn, 1);
    
    [self.selectDateBtn.titleLabel setSingleLineAutoResizeWithMaxWidth:kScreenWidth/3];
    
    self.selectDateBtn.imageView.sd_layout
    .centerYEqualToView(self.selectDateBtn)
    .leftSpaceToView(self.selectDateBtn.titleLabel, 14)
    .widthIs(6)
    .heightEqualToWidth();
    
    
    
}

#pragma mark - lazyLoad
-(UIButton *)selectDateBtn{
    if (!_selectDateBtn) {
        _selectDateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectDateBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_selectDateBtn setImage:[UIImage imageNamed:@"down_arrow"] forState:UIControlStateNormal];
        [_selectDateBtn setTitleColor:COLOR_WITH_ALPHA(0x4BA4FE, 1) forState:UIControlStateNormal];
        _selectDateBtn.backgroundColor = COLOR_WITH_ALPHA(0xffffff, 0.2);
        _selectDateBtn.layer.borderWidth = 1;
        _selectDateBtn.layer.borderColor = COLOR_WITH_ALPHA(0x4BA4FE, 1).CGColor;
        [_selectDateBtn setTitle:@"2021-04考期" forState:UIControlStateNormal];
    }
    return _selectDateBtn;
}

@end
