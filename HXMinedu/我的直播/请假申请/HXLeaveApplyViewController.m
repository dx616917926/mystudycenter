//
//  HXLeaveApplyViewController.m
//  HXMinedu
//
//  Created by mac on 2022/9/21.
//

#import "HXLeaveApplyViewController.h"
#import "IQTextView.h"
#import "YBPopupMenu.h"

@interface HXLeaveApplyViewController ()<UITextViewDelegate,YBPopupMenuDelegate>

@property(nonatomic,strong) UIScrollView *mainScrollView;

@property(nonatomic,strong) UIView *topView;
@property(nonatomic,strong) UIView *topLine;
//请假班级：
@property(nonatomic,strong) UILabel *banJiTitleLabel;
@property(nonatomic,strong) UILabel *banJiContentLabel;
//请假课节：
@property(nonatomic,strong) UILabel *keJieTitleLabel;
@property(nonatomic,strong) UILabel *keJieContentLabel;
//开始时间：
@property(nonatomic,strong) UILabel *startTimeTitleLabel;
@property(nonatomic,strong) UILabel *startTimeContentLabel;
//结束时间：
@property(nonatomic,strong) UILabel *endTimeTitleLabel;
@property(nonatomic,strong) UILabel *endTimeContentLabel;

@property(nonatomic,strong) UIView *middleView;
@property(nonatomic,strong) UIView *line1;
@property(nonatomic,strong) UILabel *qingJiaTitleLabel;
@property(nonatomic,strong) UIButton *qingJiaBtn;
@property(nonatomic,strong) UIView *line2;

@property(nonatomic,strong) UIView *bottomView;
@property(nonatomic,strong) IQTextView *textView;

@property(nonatomic,strong) UIButton *submitBtn;

@property(nonatomic,strong) NSArray *qingJiaArray;

@end

@implementation HXLeaveApplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //UI
    [self createUI];
}

#pragma mark - Event
-(void)selectQingJiaType:(UIControl *)sender{
    [self.view endEditing:YES];
    [YBPopupMenu showRelyOnView:sender titles:self.qingJiaArray icons:nil menuWidth:120 otherSettings:^(YBPopupMenu *popupMenu) {
        popupMenu.offset = 10;
        popupMenu.itemHeight = 40;
        popupMenu.delegate = self;
        popupMenu.isShowShadow = NO;
    }];
}

-(void)submit:(UIButton *)sender{
    [self.view endEditing:YES];
   
    
}

#pragma mark - <YBPopupMenuDelegate>

- (void)ybPopupMenu:(YBPopupMenu *)ybPopupMenu didSelectedAtIndex:(NSInteger)index{
    [self.qingJiaBtn setTitleColor:COLOR_WITH_ALPHA(0x646464, 1) forState:UIControlStateNormal];
    [self.qingJiaBtn setTitle:self.qingJiaArray[index] forState:UIControlStateNormal];
}



#pragma mark - UI
-(void)createUI{
    
    self.sc_navigationBar.title = @"请假申请";
    
    self.qingJiaArray =@[@"病假",@"事假",@"其他"];
    
    [self.view addSubview:self.mainScrollView];
    [self.mainScrollView addSubview:self.topView];
    [self.mainScrollView addSubview:self.middleView];
    [self.mainScrollView addSubview:self.bottomView];
    [self.mainScrollView addSubview:self.submitBtn];
    
    [self.topView addSubview:self.topLine];
    [self.topView addSubview:self.banJiTitleLabel];
    [self.topView addSubview:self.banJiContentLabel];
    [self.topView addSubview:self.keJieTitleLabel];
    [self.topView addSubview:self.keJieContentLabel];
    [self.topView addSubview:self.startTimeTitleLabel];
    [self.topView addSubview:self.startTimeContentLabel];
    [self.topView addSubview:self.endTimeTitleLabel];
    [self.topView addSubview:self.endTimeContentLabel];
    
    [self.middleView addSubview:self.line1];
    [self.middleView addSubview:self.qingJiaTitleLabel];
    [self.middleView addSubview:self.qingJiaBtn];
    [self.middleView addSubview:self.line2];
    
    [self.bottomView addSubview:self.textView];
    
    self.mainScrollView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(kNavigationBarHeight, 0, 0, 0));
    
    self.topView.sd_layout
    .topEqualToView(self.mainScrollView)
    .leftEqualToView(self.mainScrollView)
    .rightEqualToView(self.mainScrollView)
    .heightIs(153);
    
    self.topLine.sd_layout
    .topEqualToView(self.topView)
    .leftEqualToView(self.topView)
    .rightEqualToView(self.topView)
    .heightIs(10);
    
    self.banJiTitleLabel.sd_layout
    .topSpaceToView(self.topLine, 20)
    .leftSpaceToView(self.topView, 20)
    .widthIs(80)
    .heightIs(22);
    
    self.banJiContentLabel.sd_layout
    .centerYEqualToView(self.banJiTitleLabel)
    .leftSpaceToView(self.banJiTitleLabel, 0)
    .rightSpaceToView(self.topView, 20)
    .heightRatioToView(self.banJiTitleLabel, 1);
    
    
    self.keJieTitleLabel.sd_layout
    .topSpaceToView(self.banJiTitleLabel, 8)
    .leftEqualToView(self.banJiTitleLabel)
    .widthRatioToView(self.banJiTitleLabel, 1)
    .heightRatioToView(self.banJiTitleLabel, 1);
    
    self.keJieContentLabel.sd_layout
    .centerYEqualToView(self.keJieTitleLabel)
    .leftEqualToView(self.banJiContentLabel)
    .rightEqualToView(self.banJiContentLabel)
    .heightRatioToView(self.banJiTitleLabel, 1);
    
    self.startTimeTitleLabel.sd_layout
    .topSpaceToView(self.keJieTitleLabel, 8)
    .leftEqualToView(self.banJiTitleLabel)
    .widthRatioToView(self.banJiTitleLabel, 1)
    .heightRatioToView(self.banJiTitleLabel, 1);
    
    self.startTimeContentLabel.sd_layout
    .centerYEqualToView(self.startTimeTitleLabel)
    .leftEqualToView(self.banJiContentLabel)
    .rightEqualToView(self.banJiContentLabel)
    .heightRatioToView(self.banJiTitleLabel, 1);
    
    self.endTimeTitleLabel.sd_layout
    .topSpaceToView(self.startTimeTitleLabel, 8)
    .leftEqualToView(self.banJiTitleLabel)
    .widthRatioToView(self.banJiTitleLabel, 1)
    .heightRatioToView(self.banJiTitleLabel, 1);
    
    self.endTimeContentLabel.sd_layout
    .centerYEqualToView(self.endTimeTitleLabel)
    .leftEqualToView(self.banJiContentLabel)
    .rightEqualToView(self.banJiContentLabel)
    .heightRatioToView(self.banJiTitleLabel, 1);
    
    
    self.middleView.sd_layout
    .topSpaceToView(self.topView, 0)
    .leftEqualToView(self.topView)
    .rightEqualToView(self.topView)
    .heightIs(54);
    
    self.line1.sd_layout
    .topEqualToView(self.middleView)
    .leftSpaceToView(self.middleView, 21)
    .rightSpaceToView(self.middleView, 21)
    .heightIs(1);
    
    self.line2.sd_layout
    .bottomEqualToView(self.middleView)
    .leftEqualToView(self.line1)
    .rightEqualToView(self.line1)
    .heightIs(1);
    
    self.qingJiaTitleLabel.sd_layout
    .centerYEqualToView(self.middleView)
    .leftSpaceToView(self.middleView, 20)
    .widthIs(80)
    .heightIs(22);
    
    self.qingJiaBtn.sd_layout
    .centerYEqualToView(self.middleView)
    .rightSpaceToView(self.middleView, 20)
    .widthIs(120)
    .heightIs(22);
    
    self.qingJiaBtn.imageView.sd_layout
    .centerYEqualToView(self.qingJiaBtn)
    .rightEqualToView(self.qingJiaBtn)
    .widthIs(8)
    .heightIs(15);
    
    
    self.qingJiaBtn.titleLabel.sd_layout
    .centerYEqualToView(self.qingJiaBtn)
    .rightSpaceToView(self.qingJiaBtn.imageView, 20)
    .leftEqualToView(self.qingJiaBtn)
    .heightIs(22);
   
    
    self.bottomView.sd_layout
    .topSpaceToView(self.middleView, 13)
    .leftSpaceToView(self.mainScrollView, 20)
    .rightSpaceToView(self.mainScrollView, 20)
    .heightIs(340);
    self.bottomView.sd_cornerRadius =@4;
    
    self.textView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(10, 10, 10, 10));
    
    self.submitBtn.sd_layout
    .topSpaceToView(self.bottomView, 42)
    .leftSpaceToView(self.mainScrollView, 20)
    .rightSpaceToView(self.mainScrollView, 20)
    .heightIs(48);
    self.submitBtn.sd_cornerRadiusFromHeightRatio=@0.5;
    
    [self.mainScrollView setupAutoContentSizeWithBottomView:self.submitBtn bottomMargin:40];
   
    
}

#pragma mark - LazyLoad
-(UIScrollView *)mainScrollView{
    if (!_mainScrollView) {
        _mainScrollView = [[UIScrollView alloc] init];
        _mainScrollView.backgroundColor = UIColor.clearColor;
        _mainScrollView.bounces = YES;
        _mainScrollView.showsVerticalScrollIndicator = NO;
        self.extendedLayoutIncludesOpaqueBars = YES;
        if (@available(iOS 11.0, *)) {
            _mainScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    return _mainScrollView;
}

-(UIView *)topView{
    if (!_topView) {
        _topView = [[UIView alloc] init];
        _topView.backgroundColor = UIColor.whiteColor;
    }
    return _topView;
}

-(UIView *)topLine{
    if (!_topLine) {
        _topLine = [[UIView alloc] init];
        _topLine.backgroundColor = COLOR_WITH_ALPHA(0xF5F5F5, 1);
    }
    return _topLine;
}




-(UILabel *)banJiTitleLabel{
    if (!_banJiTitleLabel) {
        _banJiTitleLabel = [[UILabel alloc] init];
        _banJiTitleLabel.textAlignment = NSTextAlignmentLeft;
        _banJiTitleLabel.font = HXFont(16);
        _banJiTitleLabel.textColor = COLOR_WITH_ALPHA(0x666666, 1);
        _banJiTitleLabel.text = @"请假班级：";
    }
    return _banJiTitleLabel;
}

-(UILabel *)banJiContentLabel{
    if (!_banJiContentLabel) {
        _banJiContentLabel = [[UILabel alloc] init];
        _banJiContentLabel.textAlignment = NSTextAlignmentLeft;
        _banJiContentLabel.font = HXFont(16);
        _banJiContentLabel.textColor = COLOR_WITH_ALPHA(0x181414, 1);
        _banJiContentLabel.text = @"自学考试20220401班-1";
    }
    return _banJiContentLabel;
}

-(UILabel *)keJieTitleLabel{
    if (!_keJieTitleLabel) {
        _keJieTitleLabel = [[UILabel alloc] init];
        _keJieTitleLabel.textAlignment = NSTextAlignmentLeft;
        _keJieTitleLabel.font = HXFont(16);
        _keJieTitleLabel.textColor = COLOR_WITH_ALPHA(0x666666, 1);
        _keJieTitleLabel.text = @"请假课节：";
    }
    return _keJieTitleLabel;
}

-(UILabel *)keJieContentLabel{
    if (!_keJieContentLabel) {
        _keJieContentLabel = [[UILabel alloc] init];
        _keJieContentLabel.textAlignment = NSTextAlignmentLeft;
        _keJieContentLabel.font = HXFont(16);
        _keJieContentLabel.textColor = COLOR_WITH_ALPHA(0x181414, 1);
        _keJieContentLabel.text = @"自学考试大学语文公开课-12";
    }
    return _keJieContentLabel;
}

-(UILabel *)startTimeTitleLabel{
    if (!_startTimeTitleLabel) {
        _startTimeTitleLabel = [[UILabel alloc] init];
        _startTimeTitleLabel.textAlignment = NSTextAlignmentLeft;
        _startTimeTitleLabel.font = HXFont(16);
        _startTimeTitleLabel.textColor = COLOR_WITH_ALPHA(0x666666, 1);
        _startTimeTitleLabel.text = @"开始时间：";
    }
    return _startTimeTitleLabel;
}

-(UILabel *)startTimeContentLabel{
    if (!_startTimeContentLabel) {
        _startTimeContentLabel = [[UILabel alloc] init];
        _startTimeContentLabel.textAlignment = NSTextAlignmentLeft;
        _startTimeContentLabel.font = HXFont(16);
        _startTimeContentLabel.textColor = COLOR_WITH_ALPHA(0x181414, 1);
        _startTimeContentLabel.text = @"2022-07-18 16:30";
    }
    return _startTimeContentLabel;
}

-(UILabel *)endTimeTitleLabel{
    if (!_endTimeTitleLabel) {
        _endTimeTitleLabel = [[UILabel alloc] init];
        _endTimeTitleLabel.textAlignment = NSTextAlignmentLeft;
        _endTimeTitleLabel.font = HXFont(16);
        _endTimeTitleLabel.textColor = COLOR_WITH_ALPHA(0x666666, 1);
        _endTimeTitleLabel.text = @"结束时间：";
    }
    return _endTimeTitleLabel;
}

-(UILabel *)endTimeContentLabel{
    if (!_endTimeContentLabel) {
        _endTimeContentLabel = [[UILabel alloc] init];
        _endTimeContentLabel.textAlignment = NSTextAlignmentLeft;
        _endTimeContentLabel.font = HXFont(16);
        _endTimeContentLabel.textColor = COLOR_WITH_ALPHA(0x181414, 1);
        _endTimeContentLabel.text = @"2022-07-18 17:30";
    }
    return _endTimeContentLabel;
}

-(UIView *)middleView{
    if (!_middleView) {
        _middleView = [[UIView alloc] init];
        _middleView.backgroundColor = UIColor.whiteColor;
    }
    return _middleView;
}

-(UILabel *)qingJiaTitleLabel{
    if (!_qingJiaTitleLabel) {
        _qingJiaTitleLabel = [[UILabel alloc] init];
        _qingJiaTitleLabel.textAlignment = NSTextAlignmentLeft;
        _qingJiaTitleLabel.font = HXBoldFont(16);
        _qingJiaTitleLabel.textColor = COLOR_WITH_ALPHA(0x474747, 1);
        _qingJiaTitleLabel.text = @"请假类别:";
    }
    return _qingJiaTitleLabel;
}

-(UIButton *)qingJiaBtn{
    if (!_qingJiaBtn) {
        _qingJiaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _qingJiaBtn.clipsToBounds = YES;
        _qingJiaBtn.titleLabel.textAlignment = NSTextAlignmentRight;
        _qingJiaBtn.titleLabel.font = HXFont(16);
        [_qingJiaBtn setTitleColor:COLOR_WITH_ALPHA(0xB1B1B1, 1) forState:UIControlStateNormal];
        [_qingJiaBtn setImage:[UIImage imageNamed:@"qingjiaarrow_icon"] forState:UIControlStateNormal];
        [_qingJiaBtn setTitle:@"请选择" forState:UIControlStateNormal];
        [_qingJiaBtn addTarget:self action:@selector(selectQingJiaType:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _qingJiaBtn;
}


-(UIView *)line1{
    if (!_line1) {
        _line1 = [[UIView alloc] init];
        _line1.backgroundColor = COLOR_WITH_ALPHA(0xEBEBEB, 1);
    }
    return _line1;
}


-(UIView *)line2{
    if (!_line2) {
        _line2 = [[UIView alloc] init];
        _line2.backgroundColor = COLOR_WITH_ALPHA(0xEBEBEB, 1);
    }
    return _line2;
}


-(UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = UIColor.whiteColor;
        _bottomView.layer.borderWidth = 1;
        _bottomView.layer.borderColor = COLOR_WITH_ALPHA(0xEBEBEB, 1).CGColor;
    }
    return _bottomView;
}

-(IQTextView *)textView{
    if (!_textView) {
        _textView = [[IQTextView alloc] init];
        _textView.textColor = COLOR_WITH_ALPHA(0x474747, 1);
        _textView.font = HXFont(14);
        _textView.delegate = self;
        _textView.placeholder = @"请填写请假理由";
        _textView.placeholderTextColor = COLOR_WITH_ALPHA(0xB1B1B1, 1);
    }
    return _textView;
}

-(UIButton *)submitBtn{
    if (!_submitBtn) {
        _submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _submitBtn.clipsToBounds = YES;
        _submitBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _submitBtn.titleLabel.font = HXFont(15);
        [_submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_submitBtn setBackgroundImage:[UIImage imageNamed:@"loginbtn_select"] forState:UIControlStateNormal];
        [_submitBtn setTitle:@"提交申请" forState:UIControlStateNormal];
        [_submitBtn addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitBtn;
}


@end
