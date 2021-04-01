//
//  HXCustommNavView.m
//  HXMinedu
//
//  Created by mac on 2021/3/26.
//

#import "HXCustommNavView.h"

@interface HXCustommNavView ()

@property(nonatomic,strong) UIControl *firstControl;///成人高考
@property(nonatomic,strong) UILabel *firstLabel;
@property(nonatomic,strong) UIImageView *firstImageView;

@property(nonatomic,strong) UILabel *detailLabel;///专升本


@property(nonatomic,strong) UIControl *secondControl;///汉语言文学
@property(nonatomic,strong) UILabel *secondLabel;
@property(nonatomic,strong) UIImageView *secondImageView;
@property(nonatomic,strong) UIButton *addresstBtn;///湖南涉外经济学院

@property(nonatomic,strong) UIButton *calendarBtn;///日历
@property(nonatomic,strong) UIButton *messageBtn;///消息
@property(nonatomic,strong) UIView *redDot;///消息红点


@end

@implementation HXCustommNavView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

-(void)setSelectVersionModel:(HXVersionModel *)selectVersionModel{
    _selectVersionModel = selectVersionModel;
    self.firstLabel.text = HXSafeString(selectVersionModel.versionName);
    [selectVersionModel.majorList enumerateObjectsUsingBlock:^(HXMajorModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.isSelected) {
            self.detailLabel.text = HXSafeString(obj.educationName);
            self.secondLabel.text = HXSafeString(obj.majorName);
            [self.addresstBtn setTitle:HXSafeString(obj.bkSchool) forState:UIControlStateNormal];
            *stop = YES;
            return;
        }
    }];
}
    
    

#pragma mark - Event
-(void)selectType:(UIControl *)sender{
    if (self.selectTypeCallBack) {
        self.selectTypeCallBack();
    }
}



#pragma mark - UI
- (void)createUI{
    
    [self sd_addSubviews:@[self.firstControl,self.secondControl,self.detailLabel,self.addresstBtn,self.calendarBtn,self.messageBtn]];
    
    self.secondControl.sd_layout
    .centerXEqualToView(self)
    .topSpaceToView(self, 0)
    .widthIs(kScreenWidth/3)
    .heightIs(22);
    
    self.secondLabel.sd_layout
    .centerXEqualToView(self.secondControl).offset(-4)
    .centerYEqualToView(self.secondControl)
    .heightRatioToView(self.secondControl, 1);
    [self.secondLabel setSingleLineAutoResizeWithMaxWidth:_kpw(kScreenWidth/3-10)];
    
    self.secondImageView.sd_layout
    .leftSpaceToView(self.secondLabel, 3)
    .bottomEqualToView(self.secondControl).offset(-2)
    .widthIs(6)
    .heightEqualToWidth();
    
    
    self.firstControl.sd_layout
    .centerYEqualToView(self.secondControl)
    .leftSpaceToView(self, 16)
    .widthIs(kScreenWidth/3)
    .heightIs(22);
    
    
    self.firstLabel.sd_layout
    .leftEqualToView(self.firstControl)
    .centerYEqualToView(self.firstControl)
    .heightRatioToView(self.firstControl, 1);
    [self.firstLabel setSingleLineAutoResizeWithMaxWidth:_kpw(kScreenWidth/3-10)];
    
    self.firstImageView.sd_layout
    .leftSpaceToView(self.firstLabel, 3)
    .bottomEqualToView(self.firstControl).offset(-2)
    .widthIs(6)
    .heightEqualToWidth();
    
    self.detailLabel.sd_layout
    .leftEqualToView(self.firstControl)
    .topSpaceToView(self.firstControl, 5)
    .widthRatioToView(self.firstControl, 1)
    .heightIs(13);
    
    self.addresstBtn.sd_layout
    .centerXEqualToView(self)
    .topEqualToView(self.detailLabel)
    .heightRatioToView(self.detailLabel, 1)
    .widthIs(kScreenWidth/3);
    
    self.addresstBtn.titleLabel.sd_layout
    .centerXEqualToView(self.addresstBtn)
    .heightRatioToView(self.addresstBtn, 1);
    [self.addresstBtn.titleLabel setSingleLineAutoResizeWithMaxWidth:(kScreenWidth/3-15)];
    
    self.addresstBtn.imageView.sd_layout
    .rightSpaceToView(self.addresstBtn.titleLabel, 4)
    .centerYEqualToView(self.addresstBtn)
    .widthIs(12)
    .heightEqualToWidth();
    
    self.messageBtn.sd_layout
    .centerYEqualToView(self.secondControl)
    .rightSpaceToView(self, 20)
    .heightIs(30)
    .widthIs(40);
    
    self.redDot.sd_layout
    .topSpaceToView(self.messageBtn, 5)
    .rightSpaceToView(self.messageBtn, -2)
    .widthIs(6)
    .heightEqualToWidth();
    self.redDot.sd_cornerRadiusFromWidthRatio = @0.5;
    
    self.calendarBtn.sd_layout
    .centerYEqualToView(self.messageBtn)
    .rightSpaceToView(self.messageBtn, 10)
    .heightIs(30)
    .widthIs(40);
}


#pragma mark - lazyload

-(UIControl *)firstControl{
    if (!_firstControl) {
        _firstControl = [[UIControl alloc] init];
        [_firstControl addSubview:self.firstLabel];
        [_firstControl addSubview:self.firstImageView];
        [_firstControl addTarget:self action:@selector(selectType:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _firstControl;
}

-(UILabel *)firstLabel{
    if (!_firstLabel) {
        _firstLabel = [[UILabel alloc] init];
        _firstLabel.font = [UIFont boldSystemFontOfSize:16];
        _firstLabel.textColor = [UIColor whiteColor];
        
        _firstLabel.numberOfLines = 1;
    }
    return _firstLabel;
}

-(UIImageView *)firstImageView{
    if (!_firstImageView) {
        _firstImageView = [[UIImageView alloc] init];
        _firstImageView.image = [UIImage imageNamed:@"white_triangle"];
    }
    return _firstImageView;
}

-(UIControl *)secondControl{
    if (!_secondControl) {
        _secondControl = [[UIControl alloc] init];
        [_secondControl addSubview:self.secondLabel];
        [_secondControl addSubview:self.secondImageView];
    }
    return _secondControl;
}

-(UILabel *)secondLabel{
    if (!_secondLabel) {
        _secondLabel = [[UILabel alloc] init];
        _secondLabel.font = [UIFont boldSystemFontOfSize:18];
        _secondLabel.textColor = [UIColor whiteColor];
        _secondLabel.textAlignment = NSTextAlignmentCenter;
        _secondLabel.numberOfLines = 1;
    }
    return _secondLabel;
}

-(UIImageView *)secondImageView{
    if (!_secondImageView) {
        _secondImageView = [[UIImageView alloc] init];
        _secondImageView.image = [UIImage imageNamed:@"white_triangle"];
    }
    return _secondImageView;
}


-(UILabel *)detailLabel{
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.textColor = [UIColor whiteColor];
        _detailLabel.font = [UIFont systemFontOfSize:12];
        
    }
    return _detailLabel;
}



-(UIButton *)addresstBtn{
    if (!_addresstBtn) {
        _addresstBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _addresstBtn.userInteractionEnabled = NO;
        _addresstBtn.titleLabel.font = [UIFont systemFontOfSize:10];
        [_addresstBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_addresstBtn setImage:[UIImage imageNamed:@"school_icon"] forState:UIControlStateNormal];
    }
    return _addresstBtn;
}

-(UIButton *)calendarBtn{
    if (!_calendarBtn) {
        _calendarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_calendarBtn setTitle:@"日历" forState:UIControlStateNormal];
        [_calendarBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _calendarBtn.hidden = YES;
    }
    return _calendarBtn;
}

-(UIButton *)messageBtn{
    if (!_messageBtn) {
        _messageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_messageBtn setTitle:@"消息" forState:UIControlStateNormal];
        [_messageBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_messageBtn addSubview:self.redDot];
        _messageBtn.hidden = YES;
    }
    return _messageBtn;
}

- (UIView *)redDot{
    if (!_redDot) {
        _redDot =[[UIView alloc] init];
        _redDot.backgroundColor =[UIColor redColor];
    }
    return _redDot;
}



@end
