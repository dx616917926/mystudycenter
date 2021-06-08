//
//  HXToastSuggestionView.m
//  HXMinedu
//
//  Created by mac on 2021/6/7.
//

#import "HXToastSuggestionView.h"
#import "IQTextView.h"

@interface HXToastSuggestionView ()
@property(nonatomic,strong) UIView *maskView;
@property(nonatomic,strong) UIView *whiteView;
@property(nonatomic,strong) UILabel *titleLabel;
@property(nonatomic,strong) IQTextView *textView;
@property(nonatomic,strong) UIButton *eventBtn;
@property(nonatomic,copy)  void(^callback)(NSString *cotent);
@property(nonatomic,assign) BOOL isRequired;//是否必填
@end

@implementation HXToastSuggestionView

-(instancetype)init{
    self = [super init];
    if (self) {
        [self createUI];
    }
    return self;
}


#pragma mark - Event
-(void)clickEventBtn:(UIButton *)sender{
    if (self.isRequired&&[HXCommonUtil isNull:self.textView.text]) {
        [self showTostWithMessage:@"驳回理由不能为空"];
        return;
    }
    [self dismiss];
}
-(void)dismiss{
    if (self.callback) {
        self.callback(self.textView.text);
    }
    [self.maskView removeFromSuperview];
    self.maskView = nil;
}

-(void)createUI{
   
    [self.maskView addSubview:self];
    [self addSubview:self.whiteView];
    [self.whiteView addSubview:self.titleLabel];
    [self.whiteView addSubview:self.textView];
    [self.whiteView addSubview:self.eventBtn];
    
    self.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    self.whiteView.sd_layout
    .centerXEqualToView(self.maskView)
    .centerYEqualToView(self.maskView).offset(-kNavigationBarHeight)
    .widthIs(kScreenWidth-_kpw(40)*2)
    .heightIs(242);
    self.whiteView.sd_cornerRadius = @10;

    
    self.titleLabel.sd_layout
    .topSpaceToView(self.whiteView, 20)
    .leftSpaceToView(self.whiteView, _kpw(32))
    .rightSpaceToView(self.whiteView, _kpw(32))
    .heightIs(22);
    
    self.textView.sd_layout
    .topSpaceToView(self.titleLabel, 12)
    .leftSpaceToView(self.whiteView, _kpw(16))
    .rightSpaceToView(self.whiteView, _kpw(16))
    .heightIs(120);
    self.textView.sd_cornerRadius = @8;
    
    self.eventBtn.sd_layout
    .bottomSpaceToView(self.whiteView, 16)
    .centerXEqualToView(self.whiteView)
    .widthIs(124)
    .heightIs(36);
    self.eventBtn.sd_cornerRadiusFromHeightRatio = @0.5;
}

-(void)showConfirmToastWithCallBack:(void(^)(NSString *cotent))callback{
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskView];
    self.textView.placeholder = @"请在此输入您的确认意见（非必填）";
    self.textView.placeholderTextColor = COLOR_WITH_ALPHA(0xAFAFAF, 1);
    [self.eventBtn setTitle:@"确 认" forState:UIControlStateNormal];
    self.callback = callback;
}

-(void)showRejecttoastWithCallBack:(void(^)(NSString *cotent))callback{
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskView];
    self.textView.placeholder = @"请在此输入您的驳回理由（必填）";
    self.textView.placeholderTextColor = COLOR_WITH_ALPHA(0xAFAFAF, 1);
    [self.eventBtn setTitle:@"驳 回" forState:UIControlStateNormal];
    self.isRequired = YES;
    self.callback = callback;
}

#pragma mark - lazyLoad
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
        _titleLabel.text = @"确认意见";
    }
    return _titleLabel;
}

-(IQTextView *)textView{
    if (!_textView) {
        _textView = [[IQTextView alloc] init];
        _textView.font = HXFont(14);
        _textView.layer.borderWidth = 0.5;
        _textView.layer.borderColor = COLOR_WITH_ALPHA(0x979797, 0.5).CGColor;
    }
    return _textView;
}

-(UIButton *)eventBtn{
    if (!_eventBtn) {
        _eventBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _eventBtn.backgroundColor = COLOR_WITH_ALPHA(0x5699FF, 1);
        _eventBtn.titleLabel.font = HXFont(16);
        [_eventBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_eventBtn addTarget:self action:@selector(clickEventBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _eventBtn;
}

@end
