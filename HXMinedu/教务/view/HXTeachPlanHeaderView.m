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
@property(nonatomic,strong) UIView *timeView;
@property(nonatomic,strong) UILabel *timeLabel;
@property(nonatomic,strong) UIImageView *fireImageView;
@property(nonatomic,strong) UIImageView *foldImageView;

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
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        [self createUI];
    }
    return self;
}


-(void)setModel:(HXCourseTypeModel *)model{
    _model = model;
    _titleLabel.text = HXSafeString(model.courseTypeName);
    _timeLabel.text = [NSString stringWithFormat:@"(%ld)",(long)model.count];
    
    self.foldImageView.transform = CGAffineTransformIdentity;
    [UIView animateWithDuration:0.5 animations:^{
        if (self.model.isExpand) {
            self.foldImageView.transform = CGAffineTransformMakeRotation(-M_PI);
        }else{
            self.foldImageView.transform = CGAffineTransformIdentity;
        }
    } completion:^(BOOL finished) {
        
    }];
}


#pragma mark - event
-(void)expend{
    self.model.isExpand = !self.model.isExpand;
    
    self.foldImageView.transform = CGAffineTransformIdentity;
    if (self.model.isExpand) {
        self.foldImageView.transform = CGAffineTransformRotate(self.foldImageView.transform,-M_PI);
    }else{
        self.foldImageView.transform = CGAffineTransformRotate(self.foldImageView.transform,-M_PI);
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
    [self.bigBackgroundControl addSubview:self.timeView];
    [self.timeView addSubview:self.timeLabel];
    [self.bigBackgroundControl addSubview:self.fireImageView];
    [self.bigBackgroundControl addSubview:self.foldImageView];
    
    
    
    self.bigBackgroundControl.sd_layout.spaceToSuperView(UIEdgeInsetsMake(5, 15, 5, 15));
    self.shadowBackgroundView.sd_layout
    .topEqualToView(self.bigBackgroundControl)
    .leftEqualToView(self.bigBackgroundControl)
    .rightEqualToView(self.bigBackgroundControl)
    .bottomEqualToView(self.bigBackgroundControl);
    self.shadowBackgroundView.layer.cornerRadius = 6;
    
    self.titleLabel.sd_layout
    .leftSpaceToView(self.bigBackgroundControl, 16)
    .centerYEqualToView(self.bigBackgroundControl)
    .heightIs(22);
    [self.titleLabel setSingleLineAutoResizeWithMaxWidth:150];
    
    self.timeLabel.sd_layout
    .leftSpaceToView(self.titleLabel, 7)
    .centerYEqualToView(self.bigBackgroundControl)
    .heightIs(22);
    [self.timeLabel setSingleLineAutoResizeWithMaxWidth:150];
    
    self.foldImageView.sd_layout
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
        _shadowBackgroundView.layer.shadowColor = COLOR_WITH_ALPHA(0x000000, 0.10).CGColor;
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

-(UIView *)timeView{
    if (!_timeView) {
        _timeView = [[UIView alloc] init];
        _timeView.backgroundColor = [UIColor clearColor];
    }
    return _timeView;
}

-(UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = COLOR_WITH_ALPHA(0xAFAFAF, 1);
        _timeLabel.font = [UIFont systemFontOfSize:14];
        
    }
    return _timeLabel;;
}

-(UIImageView *)foldImageView{
    if (!_foldImageView) {
        _foldImageView = [[UIImageView alloc] init];
        _foldImageView.image = [UIImage imageNamed:@"down_arrow"];
        _foldImageView.layer.anchorPoint = CGPointMake(0.5,0.5);
    }
    return _foldImageView;
}

@end
