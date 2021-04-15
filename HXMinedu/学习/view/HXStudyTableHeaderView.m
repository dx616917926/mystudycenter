//
//  HXStudyTableHeaderView.m
//  HXMinedu
//
//  Created by mac on 2021/4/6.
//

#import "HXStudyTableHeaderView.h"

@interface HXStudyTableHeaderView ()
@property(nonatomic,strong) UIImageView *studyReportImageView;
@property(nonatomic,strong) UIView *containerView;
@property(nonatomic,strong) UIButton *noticeBtn;
@property(nonatomic,strong) UIButton *liveBroadcastBtn;
@property(nonatomic,strong) UILabel *courseLearnLabel;

@end

@implementation HXStudyTableHeaderView

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

#pragma mark - Event
-(void)pushStudyReport:(UITapGestureRecognizer *)tap{
    if (self.delegate && [self.delegate respondsToSelector:@selector(handleEventWithFlag:)]) {
        [self.delegate handleEventWithFlag:0];
    }
}

-(void)clickItem:(UIButton *)sender{
    NSInteger flag = sender.tag -9000;
    if (self.delegate && [self.delegate respondsToSelector:@selector(handleEventWithFlag:)]) {
        [self.delegate handleEventWithFlag:flag];
    }
}

#pragma mark - UI
-(void)createUI{
    [self addSubview:self.studyReportImageView];
    [self addSubview:self.containerView];
    [self.containerView addSubview:self.noticeBtn];
    [self.containerView addSubview:self.liveBroadcastBtn];
    [self addSubview:self.courseLearnLabel];
    
    self.studyReportImageView.sd_layout
    .topSpaceToView(self, 16)
    .leftSpaceToView(self, _kpw(23))
    .rightSpaceToView(self, _kpw(23))
    .heightIs(104);
    self.studyReportImageView.sd_cornerRadius = @12;
    
    self.containerView.sd_layout
    .topSpaceToView(self.studyReportImageView, 16)
    .leftEqualToView(self)
    .rightEqualToView(self)
    .heightIs(44);
    
    self.noticeBtn.sd_layout
    .centerYEqualToView(self.containerView)
    .leftSpaceToView(self.containerView, _kpw(35))
    .widthIs(_kpw(102))
    .heightIs(44);
    self.noticeBtn.layer.cornerRadius = 6;
    
    self.noticeBtn.imageView.sd_layout
    .centerYEqualToView(self.noticeBtn)
    .leftSpaceToView(self.noticeBtn, 10)
    .widthIs(28)
    .heightEqualToWidth();
    [self.noticeBtn.imageView updateLayout];
    
    self.noticeBtn.titleLabel.sd_layout
    .centerYEqualToView(self.noticeBtn)
    .leftSpaceToView(self.noticeBtn.imageView, 14)
    .rightSpaceToView(self.noticeBtn, 10)
    .heightRatioToView(self.noticeBtn, 1);
    
    self.liveBroadcastBtn.sd_layout
    .centerYEqualToView(self.noticeBtn)
    .leftSpaceToView(self.noticeBtn, _kpw(24))
    .widthRatioToView(self.noticeBtn, 1)
    .heightRatioToView(self.noticeBtn, 1);
    self.liveBroadcastBtn.layer.cornerRadius = 6;
    
    self.liveBroadcastBtn.imageView.sd_layout
    .centerYEqualToView(self.liveBroadcastBtn)
    .leftSpaceToView(self.liveBroadcastBtn, 10)
    .widthIs(28)
    .heightEqualToWidth();

    self.liveBroadcastBtn.titleLabel.sd_layout
    .centerYEqualToView(self.liveBroadcastBtn)
    .leftSpaceToView(self.liveBroadcastBtn.imageView, 14)
    .rightSpaceToView(self.liveBroadcastBtn, 10)
    .heightRatioToView(self.liveBroadcastBtn, 1);
    
//    [self.containerView setupAutoMarginFlowItems:@[self.noticeBtn,self.liveBroadcastBtn] withPerRowItemsCount:3 itemWidth:_kpw(88) verticalMargin:0 verticalEdgeInset:0 horizontalEdgeInset:_kpw(35)];
    
    self.courseLearnLabel.sd_layout
    .topSpaceToView(self.containerView, 16)
    .leftEqualToView(self.studyReportImageView)
    .rightEqualToView(self.studyReportImageView)
    .heightIs(22);
    
    [self setupAutoHeightWithBottomView:self.courseLearnLabel bottomMargin:16];
    

}

#pragma mark - lazyLoad
-(UIImageView *)studyReportImageView{
    if (!_studyReportImageView) {
        _studyReportImageView = [[UIImageView alloc] init];
        _studyReportImageView.userInteractionEnabled = YES;
        _studyReportImageView.image = [UIImage imageNamed:@"baogaobanner"];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushStudyReport:)];
        [_studyReportImageView addGestureRecognizer:tap];
    }
    return _studyReportImageView;
}

-(UIView *)containerView{
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = [UIColor whiteColor];
        _containerView.clipsToBounds = YES;
    }
    return _containerView;
}

-(UIButton *)noticeBtn{
    if (!_noticeBtn) {
        _noticeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _noticeBtn.tag = 9001;
        _noticeBtn.backgroundColor = COLOR_WITH_ALPHA(0xFFF1EF, 1);
        _noticeBtn.layer.shadowColor = COLOR_WITH_ALPHA(0xD1553E, 0.1).CGColor;
        _noticeBtn.layer.shadowOffset = CGSizeMake(0, 2);
        _noticeBtn.layer.shadowRadius = 5;
        _noticeBtn.layer.shadowOpacity = 1;
        _noticeBtn.titleLabel.font = HXFont(_kpAdaptationWidthFont(16));
        [_noticeBtn setImage:[UIImage imageNamed:@"notice_icon"] forState:UIControlStateNormal];
        [_noticeBtn setTitleColor:COLOR_WITH_ALPHA(0xFE664B, 1) forState:UIControlStateNormal];
        [_noticeBtn setTitle:@"公告" forState:UIControlStateNormal];
        [_noticeBtn addTarget:self action:@selector(clickItem:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _noticeBtn;
}

-(UIButton *)liveBroadcastBtn{
    if (!_liveBroadcastBtn) {
        _liveBroadcastBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _liveBroadcastBtn.tag = 9002;
        _liveBroadcastBtn.backgroundColor = COLOR_WITH_ALPHA(0xFEEFFF, 1);
        _liveBroadcastBtn.layer.shadowColor = COLOR_WITH_ALPHA(0x9F4BFE, 0.1).CGColor;
        _liveBroadcastBtn.layer.shadowOffset = CGSizeMake(0, 2);
        _liveBroadcastBtn.layer.shadowRadius = 5;
        _liveBroadcastBtn.layer.shadowOpacity = 1;
        _liveBroadcastBtn.titleLabel.font = HXFont(_kpAdaptationWidthFont(16));
        [_liveBroadcastBtn setImage:[UIImage imageNamed:@"liveBroadcast_icon"] forState:UIControlStateNormal];
        [_liveBroadcastBtn setTitleColor:COLOR_WITH_ALPHA(0x9F4BFE, 1) forState:UIControlStateNormal];
        [_liveBroadcastBtn setTitle:@"直播" forState:UIControlStateNormal];
        [_liveBroadcastBtn addTarget:self action:@selector(clickItem:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _liveBroadcastBtn;
}



-(UILabel *)courseLearnLabel{
    if (!_courseLearnLabel) {
        _courseLearnLabel = [[UILabel alloc] init];
        _courseLearnLabel.textAlignment = NSTextAlignmentLeft;
        _courseLearnLabel.font = HXBoldFont(16);
        _courseLearnLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        _courseLearnLabel.text = @"课程学习";
    }
    return _courseLearnLabel;;
}



@end
