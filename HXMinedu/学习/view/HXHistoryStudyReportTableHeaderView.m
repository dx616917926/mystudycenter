//
//  HXHistoryStudyReportTableHeaderView.m
//  HXMinedu
//
//  Created by mac on 2021/7/29.
//

#import "HXHistoryStudyReportTableHeaderView.h"

@interface HXHistoryStudyReportTableHeaderView ()

@property(nonatomic,strong) UIImageView *gradientImageView;

@property(strong,nonatomic) UIView  *custommNavView;
@property(nonatomic,strong) UILabel *titleLabel;
@property(nonatomic,strong) UIImageView *whiteTriangleImageView;

@property(nonatomic,strong) UIView *threeContainerView;
@property(nonatomic,strong) NSMutableArray *threeControls;
@property(nonatomic,strong) UILabel *generateTimeLabel;

@end

@implementation HXHistoryStudyReportTableHeaderView

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

#pragma mark - UI
-(void)createUI{
    
    [self addSubview:self.gradientImageView];
    
    [self.gradientImageView addSubview:self.custommNavView];
    [self.custommNavView addSubview:self.backBtn];
    [self.custommNavView addSubview:self.titleControl];
    [self.titleControl addSubview:self.titleLabel];
    [self.titleControl addSubview:self.whiteTriangleImageView];
    
    [self.gradientImageView addSubview:self.threeContainerView];
    [self.gradientImageView addSubview:self.generateTimeLabel];
    
    self.gradientImageView.sd_layout
    .topEqualToView(self)
    .leftEqualToView(self)
    .rightEqualToView(self);
    
    self.custommNavView.sd_layout
    .topEqualToView(self.gradientImageView)
    .leftEqualToView(self.gradientImageView)
    .rightEqualToView(self.gradientImageView)
    .heightIs(kNavigationBarHeight);
    
    
    self.backBtn.sd_layout
    .topSpaceToView(self.custommNavView, kStatusBarHeight)
    .leftSpaceToView(self.custommNavView, 0)
    .widthIs(80)
    .heightIs(kNavigationBarHeight-kStatusBarHeight);
    
    self.backBtn.imageView.sd_layout
    .centerYEqualToView(self.backBtn)
    .leftSpaceToView(self.backBtn, 20)
    .widthIs(24)
    .heightEqualToWidth();
    
    self.titleControl.sd_layout
    .centerYEqualToView(self.backBtn)
    .leftSpaceToView(self.custommNavView, 100)
    .rightSpaceToView(self.custommNavView, 100)
    .heightIs(kNavigationBarHeight-kStatusBarHeight);
    
    self.titleLabel.sd_layout
    .centerXEqualToView(self.titleControl).offset(-4)
    .centerYEqualToView(self.titleControl)
    .heightIs(25);
    [self.titleLabel setSingleLineAutoResizeWithMaxWidth:(kScreenWidth-220)];
    
    self.whiteTriangleImageView.sd_layout
    .leftSpaceToView(self.titleLabel, 3)
    .bottomEqualToView(self.titleLabel).offset(-5)
    .widthIs(6)
    .heightEqualToWidth();
    
    
    
    NSArray *titles = @[@"课件学习",@"平时作业",@"期末考试"];
    [self.threeControls removeAllObjects];
    for (int i = 0; i<titles.count; i++) {
        UIControl *control = [[UIControl alloc] init];
        control.backgroundColor = [UIColor whiteColor];
        [self.threeContainerView addSubview:control];
        [self.threeControls addObject:control];
        UILabel *topLabel = [[UILabel alloc] init];
        topLabel.tag = 3333;
        topLabel.textAlignment = NSTextAlignmentCenter;
        topLabel.font = HXFont(12);
        topLabel.textColor = COLOR_WITH_ALPHA(0xAFAFAF, 1);
        [control addSubview:topLabel];
        UILabel *bottomLabel = [[UILabel alloc] init];
        bottomLabel.tag = 4444;
        bottomLabel.textAlignment = NSTextAlignmentCenter;
        bottomLabel.font = HXFont(14);
        bottomLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        bottomLabel.text = titles[i];
        [control addSubview:bottomLabel];
    }
    
    
    
    
    self.threeContainerView.sd_layout
    .topSpaceToView(self.custommNavView, 40)
    .leftSpaceToView(self.gradientImageView, 20)
    .rightSpaceToView(self.gradientImageView, 20);
    
   
    for (UIControl *control in self.threeControls) {
        control.sd_layout.heightIs(70);
        control.sd_cornerRadius = @5;
        UILabel *topLabel = [control viewWithTag:3333];
        topLabel.sd_layout
        .topSpaceToView(control, 12)
        .leftEqualToView(control)
        .rightEqualToView(control)
        .heightIs(30);
        
        UILabel *bottomLabel = [control viewWithTag:4444];
        bottomLabel.sd_layout
        .bottomSpaceToView(control, 7)
        .leftEqualToView(control)
        .rightEqualToView(control)
        .heightIs(20);
    }
    
    
    [self.threeContainerView setupAutoMarginFlowItems:self.threeControls withPerRowItemsCount:3 itemWidth:_kpw(105) verticalMargin:0 verticalEdgeInset:0 horizontalEdgeInset:0];
    
    self.generateTimeLabel.sd_layout
    .topSpaceToView(self.threeContainerView, 17)
    .leftSpaceToView(self.gradientImageView, 20)
    .rightSpaceToView(self.gradientImageView, 20)
    .heightIs(17);
    
    [self.gradientImageView setupAutoHeightWithBottomView:self.generateTimeLabel bottomMargin:26];
    
    [self setupAutoHeightWithBottomView:self.gradientImageView bottomMargin:0];
    //主动调用刷新布局
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
}

-(void)setStudyReportModel:(HXStudyReportModel *)studyReportModel{
    _studyReportModel = studyReportModel;
    self.generateTimeLabel.text = HXSafeString(studyReportModel.historyTime);
    for (int i = 0;i < self.threeControls.count;i++) {
        UIControl *control = self.threeControls[i];
        UILabel *topLabel = [control viewWithTag:3333];
        if (i == 0) {
            NSString *content = [NSString stringWithFormat:@"共 %@ 分钟",studyReportModel.kjxx];
            topLabel.attributedText = [HXCommonUtil getAttributedStringWith:studyReportModel.kjxx needAttributed:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:22],NSForegroundColorAttributeName:COLOR_WITH_ALPHA(0xFF781C, 1)} content:content defaultAttributed:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:COLOR_WITH_ALPHA(0xAFAFAF, 1)}];
        }else if(i == 1){
            if ([studyReportModel.pszy isEqualToString:@"暂无成绩"]) {
                topLabel.text = @"暂无成绩";
            }else{
                NSString *content = [NSString stringWithFormat:@"最高 %@ 分",studyReportModel.pszy];
                topLabel.attributedText = [HXCommonUtil getAttributedStringWith:studyReportModel.pszy needAttributed:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:22],NSForegroundColorAttributeName:COLOR_WITH_ALPHA(0xFF781C, 1)} content:content defaultAttributed:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:COLOR_WITH_ALPHA(0xAFAFAF, 1)}];
            }
            
        }else if(i == 2){
            if ([studyReportModel.qmcj isEqualToString:@"暂无成绩"]) {
                topLabel.text = @"暂无成绩";
            }else{
                NSString *content = [NSString stringWithFormat:@"最高 %@ 分",studyReportModel.qmcj];
                topLabel.attributedText = [HXCommonUtil getAttributedStringWith:studyReportModel.qmcj needAttributed:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:22],NSForegroundColorAttributeName:COLOR_WITH_ALPHA(0xFF781C, 1)} content:content defaultAttributed:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:COLOR_WITH_ALPHA(0xAFAFAF, 1)}];
            }
            
        }
    }
}
    
   


#pragma mark - lazyLoad
-(UIImageView *)gradientImageView{
    if (!_gradientImageView) {
        _gradientImageView = [[UIImageView alloc] init];
        _gradientImageView.image = [UIImage imageNamed:@"historybg"];
        _gradientImageView.userInteractionEnabled = YES;
    }
    return _gradientImageView;
}

-(UIView *)custommNavView{
    if (!_custommNavView) {
        _custommNavView = [[UIView alloc] init];
        _custommNavView.backgroundColor = [UIColor clearColor];
    }
    return _custommNavView;
}

-(UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:[UIImage imageNamed:@"navihistory_whiteback"] forState:UIControlStateNormal];
        
    }
    return _backBtn;
}

-(UIControl *)titleControl{
    if (!_titleControl) {
        _titleControl = [[UIControl alloc] init];
    }
    return _titleControl;
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = HXBoldFont(18);
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.numberOfLines = 1;
        _titleLabel.text = @"历史学习报告";
    }
    return _titleLabel;
}

-(UIImageView *)whiteTriangleImageView{
    if (!_whiteTriangleImageView) {
        _whiteTriangleImageView = [[UIImageView alloc] init];
        _whiteTriangleImageView.image = [UIImage imageNamed:@"white_triangle"];
        _whiteTriangleImageView.hidden = NO;
    }
    return _whiteTriangleImageView;
}

-(UIView *)threeContainerView{
    if (!_threeContainerView) {
        _threeContainerView = [[UIView alloc] init];
    }
    return _threeContainerView;
}



-(NSMutableArray *)threeControls{
    if (!_threeControls) {
        _threeControls = [NSMutableArray array];
    }
    return _threeControls;;
}

-(UILabel *)generateTimeLabel{
    if (!_generateTimeLabel) {
        _generateTimeLabel = [[UILabel alloc] init];
        _generateTimeLabel.textAlignment = NSTextAlignmentCenter;
        _generateTimeLabel.font = HXFont(12);
        _generateTimeLabel.textColor = COLOR_WITH_ALPHA(0xFFFFFF, 1);
    }
    return _generateTimeLabel;
}

@end
