//
//  HXTeachPlanHeaderView.m
//  HXMinedu
//
//  Created by mac on 2021/3/29.
//

#import "HXTeachPlanHeaderView.h"

@interface HXTeachPlanHeaderView ()
@property(nonatomic,strong) UIView *shadowBackgroundView;
@property(nonatomic,strong) UIControl *bigBackgroundControl;
@property(nonatomic,strong) UILabel *titleLabel;
@property(nonatomic,strong) UILabel *numLabel;
@property(nonatomic,strong) UIImageView *arrowImageView;

@end

@implementation HXTeachPlanHeaderView

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


-(void)setModel:(HXCourseTypeModel *)model{
    _model = model;
    _titleLabel.text = HXSafeString(model.courseTypeName);
    _numLabel.text = [NSString stringWithFormat:@"(%ld)",(long)model.count];
    
    self.arrowImageView.transform = CGAffineTransformIdentity;
    [UIView animateWithDuration:0.5 animations:^{
        if (self.model.isExpand) {
            self.arrowImageView.transform = CGAffineTransformMakeRotation(-M_PI);
        }else{
            self.arrowImageView.transform = CGAffineTransformIdentity;
        }
    } completion:^(BOOL finished) {
        
    }];
}


#pragma mark - event
-(void)expend{
    self.model.isExpand = !self.model.isExpand;
    
    self.arrowImageView.transform = CGAffineTransformIdentity;
    if (self.model.isExpand) {
        self.arrowImageView.transform = CGAffineTransformRotate(self.arrowImageView.transform,-M_PI);
    }else{
        self.arrowImageView.transform = CGAffineTransformRotate(self.arrowImageView.transform,-M_PI);
    }
    [UIView animateWithDuration:0.25 animations:^{
        
    } completion:^(BOOL finished) {
        
    }];
    
    
    
    if (self.expandCallBack) {
        self.expandCallBack();
    }
}

-(void)createUI{
    [self.contentView addSubview:self.shadowBackgroundView];
    [self.contentView addSubview:self.bigBackgroundControl];
    [self.bigBackgroundControl addSubview:self.titleLabel];
    [self.bigBackgroundControl addSubview:self.numLabel];
    [self.bigBackgroundControl addSubview:self.arrowImageView];
    
    self.shadowBackgroundView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(10, _kpw(23), 10, _kpw(23)));
    self.shadowBackgroundView.layer.cornerRadius = 5;
    
    self.bigBackgroundControl.sd_layout.spaceToSuperView(UIEdgeInsetsMake(10, _kpw(23), 10, _kpw(23)));
    self.bigBackgroundControl.layer.cornerRadius = 5;
    
    self.titleLabel.sd_layout
    .leftSpaceToView(self.bigBackgroundControl, _kpw(24))
    .centerYEqualToView(self.bigBackgroundControl)
    .heightIs(22);
    [self.titleLabel setSingleLineAutoResizeWithMaxWidth:150];
    
    self.numLabel.sd_layout
    .leftSpaceToView(self.titleLabel, 7)
    .centerYEqualToView(self.bigBackgroundControl)
    .heightIs(22);
    [self.numLabel setSingleLineAutoResizeWithMaxWidth:150];
    
    self.arrowImageView.sd_layout
    .centerYEqualToView(self.bigBackgroundControl)
    .rightSpaceToView(self.bigBackgroundControl,_kpw(17))
    .widthIs(10)
    .heightIs(7);
    
}

#pragma mark - lazyload

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
-(UIControl *)bigBackgroundControl{
    if (!_bigBackgroundControl) {
        _bigBackgroundControl = [[UIControl alloc] init];
        _bigBackgroundControl.backgroundColor = [UIColor clearColor];
        [_bigBackgroundControl addTarget:self action:@selector(expend) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bigBackgroundControl;
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        _titleLabel.font = [UIFont systemFontOfSize:16];
        
    }
    return _titleLabel;;
}

-(UILabel *)numLabel{
    if (!_numLabel) {
        _numLabel = [[UILabel alloc] init];
        _numLabel.textColor = COLOR_WITH_ALPHA(0xAFAFAF, 1);
        _numLabel.font = [UIFont systemFontOfSize:14];
        
    }
    return _numLabel;;
}

-(UIImageView *)arrowImageView{
    if (!_arrowImageView) {
        _arrowImageView = [[UIImageView alloc] init];
        _arrowImageView.image = [UIImage imageNamed:@"down_arrow"];
        _arrowImageView.layer.anchorPoint = CGPointMake(0.5,0.5);
    }
    return _arrowImageView;
}

@end
