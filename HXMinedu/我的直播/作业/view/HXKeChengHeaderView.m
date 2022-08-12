//
//  HXKeChengHeaderView.m
//  HXMinedu
//
//  Created by mac on 2022/8/11.
//

#import "HXKeChengHeaderView.h"

@interface HXKeChengHeaderView ()
@property(nonatomic,strong) UIControl *bigBackgroundControl;
@property(nonatomic,strong) UILabel *titleLabel;
@property(nonatomic,strong) UILabel *numLabel;
@property(nonatomic,strong) UIImageView *foldImageView;
@property(nonatomic,strong) UIView *bottomLineView;

@end

@implementation HXKeChengHeaderView

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self createUI];
    }
    return self;
}


#pragma mark -UI
-(void)createUI{
    [self.contentView addSubview:self.bigBackgroundControl];
    [self.bigBackgroundControl addSubview:self.titleLabel];
    [self.bigBackgroundControl addSubview:self.numLabel];
    [self.bigBackgroundControl addSubview:self.foldImageView];
    [self.bigBackgroundControl addSubview:self.bottomLineView];
    
    self.bigBackgroundControl.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    
    self.titleLabel.sd_layout
    .centerYEqualToView(self.bigBackgroundControl)
    .leftSpaceToView(self.bigBackgroundControl, 20)
    .heightIs(20);
    [self.titleLabel setSingleLineAutoResizeWithMaxWidth:180];
    
    self.numLabel.sd_layout
    .centerYEqualToView(self.bigBackgroundControl)
    .leftSpaceToView(self.titleLabel, 3)
    .heightIs(20);
    [self.numLabel setSingleLineAutoResizeWithMaxWidth:80];
    
    self.foldImageView.sd_layout
    .centerYEqualToView(self.bigBackgroundControl)
    .rightSpaceToView(self.bigBackgroundControl, 30)
    .widthIs(12)
    .heightIs(6);
    
    self.bottomLineView.sd_layout
    .bottomEqualToView(self.bigBackgroundControl)
    .leftSpaceToView(self.bigBackgroundControl, 10)
    .rightSpaceToView(self.bigBackgroundControl, 10)
    .heightIs(1);
    
}


-(UIControl *)bigBackgroundControl{
    if (!_bigBackgroundControl) {
        _bigBackgroundControl = [[UIControl alloc] init];
        _bigBackgroundControl.backgroundColor = [UIColor clearColor];
//        [_bigBackgroundControl addTarget:self action:@selector(expend) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bigBackgroundControl;
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = HXFont(14);
        _titleLabel.textColor = COLOR_WITH_ALPHA(0x474747, 1);
        _titleLabel.text = @"我的课程";
    }
    return _titleLabel;
}

-(UILabel *)numLabel{
    if (!_numLabel) {
        _numLabel = [[UILabel alloc] init];
        _numLabel.textAlignment = NSTextAlignmentLeft;
        _numLabel.font = HXFont(14);
        _numLabel.textColor = COLOR_WITH_ALPHA(0x9F9F9F, 1);
        _numLabel.text = @"(3)";
    }
    return _numLabel;
}

-(UIImageView *)foldImageView{
    if (!_foldImageView) {
        _foldImageView = [[UIImageView alloc] init];
        _foldImageView.image = [UIImage imageNamed:@"unfold_icon"];
    }
    return _foldImageView;
}

-(UIView *)bottomLineView{
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc] init];
        _bottomLineView.backgroundColor = COLOR_WITH_ALPHA(0xEBEBEB, 1);
    }
    return _bottomLineView;
}


@end
