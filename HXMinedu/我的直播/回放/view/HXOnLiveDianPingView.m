//
//  HXOnLiveDianPingView.m
//  HXMinedu
//
//  Created by mac on 2022/8/11.
//

#import "HXOnLiveDianPingView.h"
#import <YYStarView.h>
#import "IQTextView.h"

@interface HXOnLiveDianPingView ()<UITextViewDelegate>

@property(nonatomic,strong) UIView *maskView;
@property(nonatomic,strong) UIView *whiteView;

@property(nonatomic,strong) UILabel *titleLabel;
@property(nonatomic,strong) UIButton *closeBtn;

//授课风格
@property(nonatomic,strong) UILabel *fenGeLabel;
@property(nonatomic,strong) YYStarView *fenGeStarView;

//授课内容
@property(nonatomic,strong) UILabel *contentLabel;
@property(nonatomic,strong) YYStarView *contentStarView;

//直播体验
@property(nonatomic,strong) UILabel *tiYanLabel;
@property(nonatomic,strong) YYStarView *tiYanStarView;


@property(nonatomic,strong) IQTextView *textView;

@property(nonatomic,strong) UIButton *submitBtn;


@end

@implementation HXOnLiveDianPingView

-(instancetype)init{
    self = [super init];
    if (self) {
        [self createUI];
    }
    return self;
}

-(void)dealloc{
    [HXNotificationCenter removeObserver:self];
}

#pragma mark  - Setter
-(void)setType:(OnLiveDianPingViewType)type{
    _type = type;
    self.fenGeStarView.type = self.contentStarView.type = self.tiYanStarView.type = (type==OnLiveDianPingViewTypeeSelect? StarViewTypeSelect:StarViewTypeShow);
    self.textView.editable = (type==OnLiveDianPingViewTypeeSelect? YES:NO);
    [self.submitBtn setTitle:(type==OnLiveDianPingViewTypeeSelect? @"提交评价":@"关闭") forState:UIControlStateNormal];
}

-(void)setFenGeStarScore:(CGFloat)fenGeStarScore{
    _fenGeStarScore = fenGeStarScore;
    self.fenGeStarView.starScore = fenGeStarScore;
}

-(void)setContentStarScore:(CGFloat)contentStarScore{
    _contentStarScore = contentStarScore;
    self.contentStarView.starScore = contentStarScore;
}

-(void)setTiYanStarScore:(CGFloat)tiYanStarScore{
    _tiYanStarScore = tiYanStarScore;
    self.tiYanStarView.starScore = tiYanStarScore;
}

-(void)setSuggestion:(NSString *)suggestion{
    _suggestion = suggestion;
    self.textView.text = suggestion;
}

#pragma mark -NSNotification
-(void)keyboardWillShow:(NSNotification*)note{
   
    self.whiteView.sd_layout.centerYEqualToView(self).offset(-kStatusBarHeight-70);
    [self.whiteView updateLayout];
}

-(void)keyboardWillHide:(NSNotification*)note{
    
    self.whiteView.sd_layout.centerYEqualToView(self).offset(-kStatusBarHeight);
    [self.whiteView updateLayout];
}


#pragma mark - <UITextViewDelegate>
- (void)textViewDidChange:(UITextView *)textView{
    [HXCommonUtil limitIncludeChineseTextView:textView Length:100];
}

#pragma mark - show
-(void)show{
    //监听键盘将要升起的通知
    [HXNotificationCenter addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    //监听键盘回收的通知
    [HXNotificationCenter addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskView];
}

#pragma mark - UI
-(void)createUI{
    [self.maskView addSubview:self];
    [self addSubview:self.whiteView];
    [self addSubview:self.whiteView];
    [self.whiteView addSubview:self.titleLabel];
    [self.whiteView addSubview:self.closeBtn];
    [self.whiteView addSubview:self.fenGeLabel];
    [self.whiteView addSubview:self.fenGeStarView];
    [self.whiteView addSubview:self.contentLabel];
    [self.whiteView addSubview:self.contentStarView];
    [self.whiteView addSubview:self.tiYanLabel];
    [self.whiteView addSubview:self.tiYanStarView];
    [self.whiteView addSubview:self.textView];
    [self.whiteView addSubview:self.submitBtn];
    
    self.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    self.whiteView.sd_layout
    .centerXEqualToView(self)
    .centerYEqualToView(self).offset(-kStatusBarHeight)
    .widthIs(300)
    .heightIs(380);
    self.whiteView.sd_cornerRadius = @8;
    

    self.titleLabel.sd_layout
    .topSpaceToView(self.whiteView, 14)
    .leftSpaceToView(self.whiteView, 50)
    .rightSpaceToView(self.whiteView, 50)
    .heightIs(22);
    
    self.closeBtn.sd_layout
    .centerYEqualToView(self.titleLabel)
    .rightSpaceToView(self.whiteView, 0)
    .widthIs(50)
    .heightIs(30);
    
    self.fenGeLabel.sd_layout
    .topSpaceToView(self.titleLabel, 30)
    .leftSpaceToView(self.whiteView, 20)
    .widthIs(55)
    .heightIs(16);
    
    self.fenGeStarView.sd_layout
    .centerYEqualToView(self.fenGeLabel)
    .leftSpaceToView(self.fenGeLabel, 20)
    .rightSpaceToView(self.whiteView, 25)
    .heightIs(22);
    
    
    self.contentLabel.sd_layout
    .topSpaceToView(self.fenGeLabel, 23)
    .leftEqualToView(self.fenGeLabel)
    .widthRatioToView(self.fenGeLabel, 1)
    .heightRatioToView(self.fenGeLabel, 1);
    
    self.contentStarView.sd_layout
    .centerYEqualToView(self.contentLabel)
    .leftEqualToView(self.fenGeStarView)
    .rightEqualToView(self.fenGeStarView)
    .heightRatioToView(self.fenGeStarView, 1);
    
    self.tiYanLabel.sd_layout
    .topSpaceToView(self.contentLabel, 23)
    .leftEqualToView(self.fenGeLabel)
    .widthRatioToView(self.fenGeLabel, 1)
    .heightRatioToView(self.fenGeLabel, 1);
    
    self.tiYanStarView.sd_layout
    .centerYEqualToView(self.tiYanLabel)
    .leftEqualToView(self.fenGeStarView)
    .rightEqualToView(self.fenGeStarView)
    .heightRatioToView(self.fenGeStarView, 1);
    
    
    self.textView.sd_layout
    .topSpaceToView(self.tiYanLabel, 30)
    .leftSpaceToView(self.whiteView, 25)
    .rightSpaceToView(self.whiteView, 25)
    .heightIs(120);
    self.textView.sd_cornerRadius = @4;
    
    self.submitBtn.sd_layout
    .topSpaceToView(self.textView, 15)
    .centerXEqualToView(self.whiteView)
    .widthIs(160)
    .heightIs(35);
    self.submitBtn.sd_cornerRadiusFromHeightRatio = @0.5;
    
}



#pragma mark - Event
-(void)submit:(UIButton *)sender{
    if (self.dianPingCallBack&&self.type==OnLiveDianPingViewTypeeSelect) {
        self.dianPingCallBack((NSInteger)self.fenGeStarView.starScore,(NSInteger)self.contentStarView.starScore,(NSInteger)self.tiYanStarView.starScore,self.textView.text);
    }
    [self.maskView removeFromSuperview];
    self.maskView = nil;
}

-(void)close:(UIButton *)sender{
    [self.maskView removeFromSuperview];
     self.maskView = nil;
}

#pragma mark - LazyLoad
-(UIView *)maskView{
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
        _maskView.backgroundColor = COLOR_WITH_ALPHA(0x000000, 0.36);
    }
    return _maskView;
}

-(UIView *)whiteView{
    if (!_whiteView) {
        _whiteView = [[UIView alloc] init];
        _whiteView.backgroundColor = COLOR_WITH_ALPHA(0xffffff, 1);
        _whiteView.clipsToBounds = YES;
    }
    return _whiteView;
}



-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = HXFont(16);
        _titleLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.numberOfLines = 1;
        _titleLabel.text = @"直播点评";
    }
    return _titleLabel;
}

-(UIButton *)closeBtn{
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setImage:[UIImage imageNamed:@"close_icon"] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

-(UILabel *)fenGeLabel{
    if (!_fenGeLabel) {
        _fenGeLabel = [[UILabel alloc] init];
        _fenGeLabel.font = HXFont(12);
        _fenGeLabel.textColor = COLOR_WITH_ALPHA(0x474747, 1);
        _fenGeLabel.textAlignment = NSTextAlignmentLeft;
        _fenGeLabel.text = @"授课风格";
    }
    return _fenGeLabel;
}

- (YYStarView *)fenGeStarView{
    if (!_fenGeStarView) {
        _fenGeStarView = [[YYStarView alloc] init];
        //星的个数，如果不设置，则默认为5颗
        _fenGeStarView.starCount = 5;
        //星级评分，如果不设置，默认为0分（一般只有在展示时会设置这个属性）
        _fenGeStarView.starScore = 5;
        //星与星之间的间距，如果不设置，则默认为0
        _fenGeStarView.starSpacing = 20;
        //每颗星的大小，如果不设置，则按照图片大小自适应
        _fenGeStarView.starSize = CGSizeMake(20, 20);
        //StarView的类型，如果不设置，默认为Select类型
        _fenGeStarView.type = StarViewTypeSelect;
        //亮色星图片名称，如果不设置，则使用默认图片
        _fenGeStarView.starBrightImageName = @"star_light_icon";
        //暗色星图片名称，如果不设置，则使用默认图片
        _fenGeStarView.starDarkImageName = @"star_dark_icon";
    }
    return _fenGeStarView;
}


-(UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = HXFont(12);
        _contentLabel.textColor = COLOR_WITH_ALPHA(0x474747, 1);
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        _contentLabel.text = @"授课内容";
    }
    return _contentLabel;
}

- (YYStarView *)contentStarView{
    if (!_contentStarView) {
        _contentStarView = [[YYStarView alloc] init];
        //星的个数，如果不设置，则默认为5颗
        _contentStarView.starCount = 5;
        //星级评分，如果不设置，默认为0分（一般只有在展示时会设置这个属性）
        _contentStarView.starScore = 5;
        //星与星之间的间距，如果不设置，则默认为0
        _contentStarView.starSpacing = 20;
        //每颗星的大小，如果不设置，则按照图片大小自适应
        _contentStarView.starSize = CGSizeMake(20, 20);
        //StarView的类型，如果不设置，默认为Select类型
        _contentStarView.type = StarViewTypeSelect;
        //亮色星图片名称，如果不设置，则使用默认图片
        _contentStarView.starBrightImageName = @"star_light_icon";
        //暗色星图片名称，如果不设置，则使用默认图片
        _contentStarView.starDarkImageName = @"star_dark_icon";
    }
    return _contentStarView;
}


-(UILabel *)tiYanLabel{
    if (!_tiYanLabel) {
        _tiYanLabel = [[UILabel alloc] init];
        _tiYanLabel.font = HXFont(12);
        _tiYanLabel.textColor = COLOR_WITH_ALPHA(0x474747, 1);
        _tiYanLabel.textAlignment = NSTextAlignmentLeft;
        _tiYanLabel.text = @"直播体验";
    }
    return _tiYanLabel;
}

- (YYStarView *)tiYanStarView{
    if (!_tiYanStarView) {
        _tiYanStarView = [[YYStarView alloc] init];
        //星的个数，如果不设置，则默认为5颗
        _tiYanStarView.starCount = 5;
        //星级评分，如果不设置，默认为0分（一般只有在展示时会设置这个属性）
        _tiYanStarView.starScore = 5;
        //星与星之间的间距，如果不设置，则默认为0
        _tiYanStarView.starSpacing = 20;
        //每颗星的大小，如果不设置，则按照图片大小自适应
        _tiYanStarView.starSize = CGSizeMake(20, 20);
        //StarView的类型，如果不设置，默认为Select类型
        _tiYanStarView.type = StarViewTypeSelect;
        //亮色星图片名称，如果不设置，则使用默认图片
        _tiYanStarView.starBrightImageName = @"star_light_icon";
        //暗色星图片名称，如果不设置，则使用默认图片
        _tiYanStarView.starDarkImageName = @"star_dark_icon";
    }
    return _tiYanStarView;
}

-(IQTextView *)textView{
    if (!_textView) {
        _textView = [[IQTextView alloc] init];
        _textView.font = HXFont(14);
        _textView.layer.borderWidth = 1;
        _textView.layer.borderColor = COLOR_WITH_ALPHA(0xECECEC, 1).CGColor;
        _textView.delegate = self;
        _textView.placeholder = @"请在此输入您的其他建议";
        _textView.placeholderTextColor = COLOR_WITH_ALPHA(0xB1B1B1, 1);
    }
    return _textView;
}

-(UIButton *)submitBtn{
    if (!_submitBtn) {
        _submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _submitBtn.backgroundColor =COLOR_WITH_ALPHA(0x5699FF, 1);
        _submitBtn.titleLabel.font = HXFont(13);
        [_submitBtn setTitle:@"提交评价" forState:UIControlStateNormal];
        [_submitBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_submitBtn addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitBtn;
}

@end

