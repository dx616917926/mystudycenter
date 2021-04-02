//
//  HXRightCollectionViewCell.m
//  HXMinedu
//
//  Created by mac on 2021/3/31.
//

#import "HXRightCollectionViewCell.h"

@interface HXRightCollectionViewCell ()

@property(nonatomic,strong) UIView *bigBackGroundView;
@property(nonatomic,strong) UILabel *titleLabel;

@end

@implementation HXRightCollectionViewCell


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = [UIColor clearColor];
        [self createUI];
    }
    return self;
}

-(void)setModel:(HXMajorModel *)model{
    _model = model;
    self.titleLabel.text = HXSafeString(model.majorName);
    self.titleLabel.textColor = model.isSelected?[UIColor whiteColor]:COLOR_WITH_ALPHA(0x2F2F31, 1);
    self.bigBackGroundView.backgroundColor = model.isSelected?COLOR_WITH_ALPHA(0x4BA4FE, 1):COLOR_WITH_ALPHA(0xF4F4F4, 1);
}



#pragma mark - UI布局
-(void)createUI{
    [self addSubview:self.bigBackGroundView];
    [self addSubview:self.titleLabel];
    
    self.bigBackGroundView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    self.bigBackGroundView.sd_cornerRadius = @6;
    
    self.titleLabel.sd_layout.spaceToSuperView(UIEdgeInsetsMake(5, 5, 5, 5));
}


-(UIView *)bigBackGroundView{
    if (!_bigBackGroundView) {
        _bigBackGroundView = [[UIView alloc] init];
        _bigBackGroundView.backgroundColor = COLOR_WITH_ALPHA(0xF4F4F4, 1);
    }
    return _bigBackGroundView;
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = COLOR_WITH_ALPHA(0x2F2F31, 1);
        _titleLabel.font = HXBoldFont(12);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.numberOfLines = 1;
    }
    return _titleLabel;
}

@end
