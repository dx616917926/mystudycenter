//
//  HXSignInShowView.m
//  HXMinedu
//
//  Created by mac on 2022/9/20.
//

#import "HXSignInShowView.h"

@interface HXSignInShowView ()
@property(nonatomic,strong) UIView *maskView;
@property(nonatomic,strong) UIImageView *bgImageView;

@property(nonatomic,strong) UILabel *titleLabel;
@property(nonatomic,strong) UILabel *keJieNameLabel;
@property(nonatomic,strong) UILabel *timeLabel;
@property(nonatomic,strong) UILabel *teacherNameLabel;
@property(nonatomic,strong) UILabel *roomNameLabel;
@property(nonatomic,strong) UIButton *signInBtn;

@property(nonatomic,strong) UIButton *closeBtn;

@end

@implementation HXSignInShowView

-(instancetype)init{
    self = [super init];
    if (self) {
        [self createUI];
    }
    return self;
}

#pragma mark - Setter
-(void)setQRCodeSignInModel:(HXQRCodeSignInModel *)qRCodeSignInModel{
    _qRCodeSignInModel = qRCodeSignInModel;
    
    self.titleLabel.text = [NSString stringWithFormat:@"课程名称：%@",qRCodeSignInModel.MealName];
    self.keJieNameLabel.text = [NSString stringWithFormat:@"课节名称：%@",qRCodeSignInModel.ClassName];
    self.timeLabel.text = [NSString stringWithFormat:@"上课时间：%@",qRCodeSignInModel.ClassBeginTime];
    self.teacherNameLabel.text = [NSString stringWithFormat:@"上课老师：%@",qRCodeSignInModel.TeacherName];
    self.roomNameLabel.text = [NSString stringWithFormat:@"上课教室：%@",qRCodeSignInModel.RoomName];
    
    [self.signInBtn setTitle:(qRCodeSignInModel.IsSign==0? @"确认签到":@"已签到")forState:UIControlStateNormal];
}


#pragma mark - UI
-(void)createUI{
    [self.maskView addSubview:self];
    [self addSubview:self.bgImageView];
    [self addSubview:self.closeBtn];
    [self.bgImageView addSubview:self.titleLabel];
    [self.bgImageView addSubview:self.keJieNameLabel];
    [self.bgImageView addSubview:self.timeLabel];
    [self.bgImageView addSubview:self.teacherNameLabel];
    [self.bgImageView addSubview:self.roomNameLabel];
    [self.bgImageView addSubview:self.signInBtn];
    
    
    self.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    self.bgImageView.sd_layout
    .centerXEqualToView(self)
    .centerYEqualToView(self).offset(-kNavigationBarHeight)
    .widthIs(260)
    .heightIs(408);
    
    
    self.closeBtn.sd_layout
    .centerXEqualToView(self)
    .topSpaceToView(self.bgImageView, 30)
    .widthIs(70)
    .heightIs(30);
    
    self.closeBtn.imageView.sd_layout
    .centerXEqualToView(self.closeBtn)
    .centerYEqualToView(self.closeBtn)
    .widthIs(30)
    .heightEqualToWidth();
    
    
    self.titleLabel.sd_layout
    .topSpaceToView(self.bgImageView, 178)
    .leftSpaceToView(self.bgImageView, 17)
    .rightSpaceToView(self.bgImageView, 17)
    .heightIs(21);
    
    
    self.keJieNameLabel.sd_layout
    .topSpaceToView(self.titleLabel, 15)
    .leftEqualToView(self.titleLabel)
    .rightEqualToView(self.titleLabel)
    .heightIs(18);
    
    self.timeLabel.sd_layout
    .topSpaceToView(self.keJieNameLabel, 8)
    .leftEqualToView(self.titleLabel)
    .rightEqualToView(self.titleLabel)
    .heightRatioToView(self.keJieNameLabel, 1);
    
    self.teacherNameLabel.sd_layout
    .topSpaceToView(self.timeLabel, 8)
    .leftEqualToView(self.titleLabel)
    .rightEqualToView(self.titleLabel)
    .heightRatioToView(self.keJieNameLabel, 1);
    
    self.roomNameLabel.sd_layout
    .topSpaceToView(self.teacherNameLabel, 8)
    .leftEqualToView(self.titleLabel)
    .rightEqualToView(self.titleLabel)
    .heightRatioToView(self.keJieNameLabel, 1);
    
    self.signInBtn.sd_layout
    .bottomSpaceToView(self.bgImageView, 20)
    .centerXEqualToView(self.bgImageView)
    .widthIs(130)
    .heightIs(36);
    self.signInBtn.sd_cornerRadiusFromHeightRatio =@0.5;
    
    
    
}

-(void)show{
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskView];
}

-(void)signIn{
    [self dismiss];
    if (self.signInBlock&&self.qRCodeSignInModel.IsSign==0) {
        self.signInBlock();
    }
}

-(void)dismiss{
    [self.maskView removeFromSuperview];
    self.maskView = nil;
}

-(UIView *)maskView{
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
        _maskView.backgroundColor = COLOR_WITH_ALPHA(0x000000, 0.36);
    }
    return _maskView;
}

-(UIView *)bgImageView{
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] init];
        _bgImageView.image =[UIImage imageNamed:@"signin_bg"];
        _bgImageView.clipsToBounds = YES;
        _bgImageView.userInteractionEnabled = YES;
    }
    return _bgImageView;
}


-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = HXBoldFont(15);
        _titleLabel.textColor = COLOR_WITH_ALPHA(0x4988FD, 1);
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.numberOfLines = 1;
    }
    return _titleLabel;
}

-(UILabel *)keJieNameLabel{
    if (!_keJieNameLabel) {
        _keJieNameLabel = [[UILabel alloc] init];
        _keJieNameLabel.font = HXFont(13);
        _keJieNameLabel.textColor = COLOR_WITH_ALPHA(0x666666, 1);
        _keJieNameLabel.textAlignment = NSTextAlignmentLeft;

    }
    return _keJieNameLabel;
}

-(UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = HXFont(13);
        _timeLabel.textColor = COLOR_WITH_ALPHA(0x666666, 1);
        _timeLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _timeLabel;
}

-(UILabel *)teacherNameLabel{
    if (!_teacherNameLabel) {
        _teacherNameLabel = [[UILabel alloc] init];
        _teacherNameLabel.font = HXFont(13);
        _teacherNameLabel.textColor = COLOR_WITH_ALPHA(0x666666, 1);
        _teacherNameLabel.textAlignment = NSTextAlignmentLeft;
        
    }
    return _teacherNameLabel;
}

-(UILabel *)roomNameLabel{
    if (!_roomNameLabel) {
        _roomNameLabel = [[UILabel alloc] init];
        _roomNameLabel.font = HXFont(13);
        _roomNameLabel.textColor = COLOR_WITH_ALPHA(0x666666, 1);
        _roomNameLabel.textAlignment = NSTextAlignmentLeft;
       
    }
    return _roomNameLabel;
}

-(UIButton *)signInBtn{
    if (!_signInBtn) {
        _signInBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _signInBtn.backgroundColor = COLOR_WITH_ALPHA(0x618EFF, 1);
        _signInBtn.titleLabel.font = HXFont(15);
        [_signInBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_signInBtn addTarget:self action:@selector(signIn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _signInBtn;
}


-(UIButton *)closeBtn{
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setImage:[UIImage imageNamed:@"signinclose_icon"] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

@end


