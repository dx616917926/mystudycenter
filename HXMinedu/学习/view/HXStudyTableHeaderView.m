//
//  HXStudyTableHeaderView.m
//  HXMinedu
//
//  Created by mac on 2021/4/6.
//

#import "HXStudyTableHeaderView.h"


@interface HXStudyTableHeaderView ()<SDCycleScrollViewDelegate>

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
   
    [self addSubview:self.containerView];
    [self.containerView addSubview:self.noticeBtn];
    [self.containerView addSubview:self.liveBroadcastBtn];
    [self addSubview:self.bannerView];
    [self addSubview:self.studyReportImageView];
    [self addSubview:self.versionBtn];
    [self addSubview:self.courseLearnLabel];
    
    
    self.containerView.sd_layout
    .topSpaceToView(self, 16)
    .leftSpaceToView(self, _kpw(23))
    .rightSpaceToView(self, _kpw(23))
    .heightIs(50);
    
    self.noticeBtn.sd_layout
    .centerYEqualToView(self.containerView)
    .leftSpaceToView(self.containerView, 0)
    .widthIs(_kpw(152))
    .heightRatioToView(self.containerView, 1);
    self.noticeBtn.layer.cornerRadius = 6;
    
    self.noticeBtn.imageView.sd_layout
    .centerYEqualToView(self.noticeBtn)
    .leftSpaceToView(self.noticeBtn, _kpw(38))
    .widthIs(28)
    .heightEqualToWidth();
    [self.noticeBtn.imageView updateLayout];
    
    self.noticeBtn.titleLabel.sd_layout
    .centerYEqualToView(self.noticeBtn)
    .leftSpaceToView(self.noticeBtn.imageView, 12)
    .rightSpaceToView(self.noticeBtn, 10)
    .heightRatioToView(self.noticeBtn, 1);
    
    self.liveBroadcastBtn.sd_layout
    .centerYEqualToView(self.noticeBtn)
    .rightSpaceToView(self.containerView, 0)
    .widthRatioToView(self.noticeBtn, 1)
    .heightRatioToView(self.noticeBtn, 1);
    self.liveBroadcastBtn.layer.cornerRadius = 6;
    
    self.liveBroadcastBtn.imageView.sd_layout
    .centerYEqualToView(self.liveBroadcastBtn)
    .leftSpaceToView(self.liveBroadcastBtn, _kpw(38))
    .widthIs(28)
    .heightEqualToWidth();

    self.liveBroadcastBtn.titleLabel.sd_layout
    .centerYEqualToView(self.liveBroadcastBtn)
    .leftSpaceToView(self.liveBroadcastBtn.imageView, 12)
    .rightSpaceToView(self.liveBroadcastBtn, 10)
    .heightRatioToView(self.liveBroadcastBtn, 1);
    
    ///广告栏
    self.bannerView.sd_layout
    .topSpaceToView(self.containerView, 16)
    .centerXEqualToView(self)
    .widthIs(floorf(kScreenWidth-_kpw(23)*2))
    .heightIs(floorf((kScreenWidth-_kpw(23)*2)*141/345));
    self.bannerView.sd_cornerRadius = @8;

    
    self.studyReportImageView.sd_layout
    .topSpaceToView(self.bannerView, 16)
    .leftEqualToView(self.containerView)
    .rightEqualToView(self.containerView)
    .heightIs((kScreenWidth-_kpw(23)*2)*0.353);
    
    
    
    self.courseLearnLabel.sd_layout
    .topSpaceToView(self.studyReportImageView, 16)
    .leftEqualToView(self.containerView)
    .heightIs(22);
    [self.courseLearnLabel setSingleLineAutoResizeWithMaxWidth:100];
    
    self.versionBtn.sd_layout
    .centerYEqualToView(self.courseLearnLabel)
    .leftSpaceToView(self.courseLearnLabel, 16)
    .rightSpaceToView(self, _kpw(23))
    .heightIs(22);
    
    self.versionBtn.imageView.sd_layout
    .centerYEqualToView(self.versionBtn)
    .rightSpaceToView(self.versionBtn, 0)
    .widthIs(16)
    .heightEqualToWidth();

    self.versionBtn.titleLabel.sd_layout
    .centerYEqualToView(self.versionBtn)
    .rightSpaceToView(self.versionBtn.imageView, 5)
    .leftSpaceToView(self.versionBtn, 5)
    .heightRatioToView(self.versionBtn, 1);
    
    
    [self setupAutoHeightWithBottomView:self.courseLearnLabel bottomMargin:16];
    
    //主动调用刷新布局
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
}

#pragma mark - lazyLoad
-(UIImageView *)studyReportImageView{
    if (!_studyReportImageView) {
        _studyReportImageView = [[UIImageView alloc] init];
        _studyReportImageView.userInteractionEnabled = YES;
        _studyReportImageView.image = [UIImage imageNamed:@"baogaobanner"];
        _studyReportImageView.contentMode = UIViewContentModeScaleAspectFit;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushStudyReport:)];
        [_studyReportImageView addGestureRecognizer:tap];
    }
    return _studyReportImageView;
}

-(SDCycleScrollView *)bannerView{
    if (!_bannerView) {
        _bannerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero delegate:self placeholderImage:nil];
        _bannerView.backgroundColor = COLOR_WITH_ALPHA(0xEFEFEF, 1);
        _bannerView.showPageControl = YES;
        _bannerView.pageControlDotSize = CGSizeMake(8, 8);
        _bannerView.infiniteLoop = YES;
        _bannerView.autoScrollTimeInterval = 3.0f;
        _bannerView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        _bannerView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
       
    }   
    return _bannerView;
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

-(UIButton *)versionBtn{
    if (!_versionBtn) {
        _versionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _versionBtn.tag = 9003;
        _versionBtn.titleLabel.textAlignment = NSTextAlignmentRight;
        _versionBtn.titleLabel.font = HXBoldFont(_kpAdaptationWidthFont(12));
        [_versionBtn setImage:[UIImage imageNamed:@"arrow_blue"] forState:UIControlStateNormal];
        [_versionBtn setTitleColor: COLOR_WITH_ALPHA(0x4BA4FE, 1) forState:UIControlStateNormal];
        [_versionBtn addTarget:self action:@selector(clickItem:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _versionBtn;
}

@end
