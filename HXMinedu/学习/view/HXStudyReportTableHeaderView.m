//
//  HXStudyReportTableHeaderView.m
//  HXMinedu
//
//  Created by mac on 2021/4/7.
//

#import "HXStudyReportTableHeaderView.h"

@interface HXStudyReportTableHeaderView ()
@property(nonatomic,strong) UIView *bigBackGroundView;
@property(nonatomic,strong) UIImageView *cardImageView;
@property(nonatomic,strong) UIImageView * dashLineImageView;
@property(nonatomic,strong) UILabel *titleLabel;
@property(nonatomic,strong) UILabel *generateTimeLabel;

@property(nonatomic,strong) UIImageView *crownImageView;
@property(nonatomic,strong) UILabel *keywordTipLabel;
@property(nonatomic,strong) UIImageView *keywordImageView;
@property(nonatomic,strong) UILabel *keywordLabel;

@property(nonatomic,strong) UIImageView *headerImageView;
@property(nonatomic,strong) UILabel *nameLabel;

@property(nonatomic,strong) UIButton *tagBtn1;
@property(nonatomic,strong) UIButton *tagBtn2;

@property(nonatomic,strong) UIImageView *mingyanImageView;
@property(nonatomic,strong) UILabel *mingyanLabel;



@property(nonatomic,strong) UIView *threeContainerView;
@property(nonatomic,strong) NSMutableArray *threeControls;



@end

@implementation HXStudyReportTableHeaderView

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
    
    [self addSubview:self.bigBackGroundView];
    [self.bigBackGroundView addSubview:self.cardImageView];
    [self.cardImageView addSubview:self.titleLabel];
    [self.cardImageView addSubview:self.dashLineImageView];
    [self.cardImageView addSubview:self.generateTimeLabel];
    [self.cardImageView addSubview:self.crownImageView];
    [self.cardImageView addSubview:self.keywordTipLabel];
    [self.cardImageView addSubview:self.keywordImageView];
    [self.cardImageView addSubview:self.keywordLabel];
    [self.cardImageView addSubview:self.headerImageView];
    [self.cardImageView addSubview:self.nameLabel];
    [self.cardImageView addSubview:self.tagBtn1];
    [self.cardImageView addSubview:self.tagBtn2];
    [self.cardImageView addSubview:self.mingyanImageView];
    [self.mingyanImageView addSubview:self.mingyanLabel];
    [self.cardImageView addSubview:self.checkHistoryBtn];
    [self.bigBackGroundView addSubview:self.threeContainerView];
    
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
    
    
    self.bigBackGroundView.sd_layout
    .topEqualToView(self)
    .leftEqualToView(self)
    .rightEqualToView(self);
    
    self.cardImageView.sd_layout
    .topSpaceToView(self.bigBackGroundView, 16)
    .leftSpaceToView(self.bigBackGroundView, 20)
    .rightSpaceToView(self.bigBackGroundView, 20);
    
    self.titleLabel.sd_layout
    .topSpaceToView(self.cardImageView, 26)
    .leftSpaceToView(self.cardImageView, 20)
    .rightSpaceToView(self.cardImageView, 20)
    .heightIs(25);
    
    self.generateTimeLabel.sd_layout
    .topSpaceToView(self.titleLabel, 6)
    .leftSpaceToView(self.cardImageView, 20)
    .rightSpaceToView(self.cardImageView, 20)
    .heightIs(17);
    
    self.dashLineImageView.sd_layout
    .topSpaceToView(self.cardImageView, 100)
    .leftSpaceToView(self.cardImageView, 12)
    .rightSpaceToView(self.cardImageView, 12)
    .heightIs(1);
    
    self.crownImageView.sd_layout
    .topSpaceToView(self.generateTimeLabel, 55)
    .centerXEqualToView(self.cardImageView)
    .widthIs(47)
    .heightIs(40);
    
    self.keywordTipLabel.sd_layout
    .topSpaceToView(self.crownImageView, 10)
    .leftSpaceToView(self.cardImageView, 20)
    .rightSpaceToView(self.cardImageView, 20)
    .heightIs(20);
    
    self.keywordImageView.sd_layout
    .topSpaceToView(self.keywordTipLabel, 30)
    .leftSpaceToView(self.cardImageView, _kpw(53))
    .rightSpaceToView(self.cardImageView, _kpw(53))
    .heightIs(_kpw(50));
    
    self.keywordLabel.sd_layout
    .centerYEqualToView(self.keywordImageView)
    .centerXEqualToView(self.keywordImageView)
    .widthIs(200)
    .heightIs(30);
    
    self.headerImageView.sd_layout
    .topSpaceToView(self.keywordImageView, 24)
    .leftSpaceToView(self.cardImageView, 23)
    .widthIs(50)
    .heightEqualToWidth();
    self.headerImageView.sd_cornerRadiusFromHeightRatio = @0.5;
    
    self.nameLabel.sd_layout
    .centerYEqualToView(self.headerImageView)
    .leftSpaceToView(self.headerImageView, 16)
    .heightIs(25);
    [self.nameLabel setSingleLineAutoResizeWithMaxWidth:80];
    
    self.tagBtn1.sd_layout
    .centerYEqualToView(self.headerImageView)
    .leftSpaceToView(self.nameLabel, 30);
    self.tagBtn1.sd_cornerRadius = @4;
    [self.tagBtn1 setupAutoSizeWithHorizontalPadding:8 buttonHeight:24];
    [self.tagBtn1 updateLayout];
    
   
    
    self.tagBtn2.sd_layout
    .centerYEqualToView(self.headerImageView)
    .leftSpaceToView(self.tagBtn1, 18);
    self.tagBtn2.sd_cornerRadius = @4;
    [self.tagBtn2 setupAutoSizeWithHorizontalPadding:8 buttonHeight:24];
    [self.tagBtn2 updateLayout];
    
    
    
    self.mingyanImageView.sd_layout
    .topSpaceToView(self.headerImageView, 14)
    .leftSpaceToView(self.cardImageView, 15)
    .rightSpaceToView(self.cardImageView, 15)
    .heightIs(64);
    
    self.mingyanLabel.sd_layout
    .leftSpaceToView(self.mingyanImageView, 20)
    .rightSpaceToView(self.mingyanImageView, 20)
    .centerYEqualToView(self.mingyanImageView)
    .autoHeightRatio(0);
    
    self.checkHistoryBtn.sd_layout
    .topSpaceToView(self.mingyanImageView, 10)
    .leftSpaceToView(self.cardImageView, 15)
    .rightSpaceToView(self.cardImageView, 15)
    .heightIs(24);
    
    self.checkHistoryBtn.titleLabel.sd_layout
    .centerXEqualToView(self.checkHistoryBtn).offset(-6)
    .centerYEqualToView(self.checkHistoryBtn)
    .heightIs(24);
    [self.checkHistoryBtn.titleLabel setSingleLineAutoResizeWithMaxWidth:150];
    
    self.checkHistoryBtn.imageView.sd_layout
    .leftSpaceToView(self.checkHistoryBtn.titleLabel, 2)
    .centerYEqualToView(self.checkHistoryBtn)
    .heightIs(12)
    .widthEqualToHeight();
    
    [self.cardImageView setupAutoHeightWithBottomView:self.checkHistoryBtn bottomMargin:10];
    
    self.threeContainerView.sd_layout
    .topSpaceToView(self.cardImageView, 15)
    .leftEqualToView(self.cardImageView)
    .rightEqualToView(self.cardImageView);

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
    
   
    [self.bigBackGroundView setupAutoHeightWithBottomView:self.threeContainerView bottomMargin:50];
    
    [self setupAutoHeightWithBottomView:self.bigBackGroundView bottomMargin:0];
    //主动调用刷新布局
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
}

-(void)setStudyReportModel:(HXStudyReportModel *)studyReportModel{
    _studyReportModel = studyReportModel;
    self.generateTimeLabel.text = HXSafeString(studyReportModel.buildTime);
    self.keywordLabel.text =  HXSafeString(studyReportModel.keyWords);
    self.nameLabel.text = HXSafeString(studyReportModel.name);
    if (![HXCommonUtil isNull:studyReportModel.mark1]) {
        [self.tagBtn1 setTitle:HXSafeString(studyReportModel.mark1) forState:UIControlStateNormal];
        [self.tagBtn1 updateLayout];
        //生成渐变色
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.bounds = self.tagBtn1.bounds;
        gradientLayer.startPoint = CGPointMake(0, 0.5);
        gradientLayer.endPoint = CGPointMake(1, 0.5);
        gradientLayer.anchorPoint = CGPointMake(0, 0);
        NSArray *colorArr = @[(id)COLOR_WITH_ALPHA(0xFF9234, 1).CGColor,(id)COLOR_WITH_ALPHA(0xFFC134, 1).CGColor];
        gradientLayer.colors = colorArr;
        [self.tagBtn1.layer insertSublayer:gradientLayer below:self.tagBtn1.titleLabel.layer];
    }
   
    if (![HXCommonUtil isNull:studyReportModel.mark2]) {
        [self.tagBtn2 setTitle:HXSafeString(studyReportModel.mark2)forState:UIControlStateNormal];
        [self.tagBtn2 updateLayout];
        CAGradientLayer *gradientLayer2 = [CAGradientLayer layer];
        gradientLayer2.bounds = self.tagBtn2.bounds;
        gradientLayer2.startPoint = CGPointMake(0, 0.5);
        gradientLayer2.endPoint = CGPointMake(1, 0.5);
        gradientLayer2.anchorPoint = CGPointMake(0, 0);
        NSArray *colorArr2 = @[(id)COLOR_WITH_ALPHA(0xFF87B3, 1).CGColor,(id)COLOR_WITH_ALPHA(0xFFB1F6, 1).CGColor];
        gradientLayer2.colors = colorArr2;
        [self.tagBtn2.layer insertSublayer:gradientLayer2 below:self.tagBtn2.titleLabel.layer];
    }
    
    self.mingyanLabel.text = HXSafeString(studyReportModel.remarks);
    
    self.checkHistoryBtn.hidden = (studyReportModel.isHisVersion == 1?NO:YES);
    
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

-(UIView *)bigBackGroundView{
    if (!_bigBackGroundView) {
        _bigBackGroundView = [[UIView alloc] init];
        _bigBackGroundView.backgroundColor = COLOR_WITH_ALPHA(0x4BA4FE, 1);
    }
    return _bigBackGroundView;
}

-(UIImageView *)cardImageView{
    if (!_cardImageView) {
        _cardImageView = [[UIImageView alloc] init];
        _cardImageView.image = [UIImage resizedImageWithName:@"cardkuang_icon"];
        _cardImageView.userInteractionEnabled = YES;
    }
    return _cardImageView;
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = HXFont(18);
        _titleLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        _titleLabel.text = @"学习报告";
    }
    return _titleLabel;
}

-(UILabel *)generateTimeLabel{
    if (!_generateTimeLabel) {
        _generateTimeLabel = [[UILabel alloc] init];
        _generateTimeLabel.textAlignment = NSTextAlignmentCenter;
        _generateTimeLabel.font = HXFont(12);
        _generateTimeLabel.textColor = COLOR_WITH_ALPHA(0xAFAFAF, 1);
       
    }
    return _generateTimeLabel;
}

-(UIImageView *)dashLineImageView{
    if (!_dashLineImageView) {
        _dashLineImageView = [[UIImageView alloc] init];
        _dashLineImageView.image = [UIImage imageNamed:@"carddashline"];
    }
    return _dashLineImageView;
}

-(UIImageView *)crownImageView{
    if (!_crownImageView) {
        _crownImageView = [[UIImageView alloc] init];
        _crownImageView.image = [UIImage imageNamed:@"crown_icon"];
    }
    return _crownImageView;
}

-(UILabel *)keywordTipLabel{
    if (!_keywordTipLabel) {
        _keywordTipLabel = [[UILabel alloc] init];
        _keywordTipLabel.textAlignment = NSTextAlignmentCenter;
        _keywordTipLabel.font = HXFont(14);
        _keywordTipLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        _keywordTipLabel.text = @"—— 本周关键词 ——";
    }
    return _keywordTipLabel;
}

-(UIImageView *)keywordImageView{
    if (!_keywordImageView) {
        _keywordImageView = [[UIImageView alloc] init];
        _keywordImageView.image = [UIImage resizedImageWithName:@"kuangjia"];
    }
    return _keywordImageView;
}

-(UILabel *)keywordLabel{
    if (!_keywordLabel) {
        _keywordLabel = [[UILabel alloc] init];
        _keywordLabel.textAlignment = NSTextAlignmentCenter;
        _keywordLabel.font = HXBoldFont(18);
        _keywordLabel.textColor = COLOR_WITH_ALPHA(0xffffff, 1);
        
    }
    return _keywordLabel;
}

-(UIImageView *)headerImageView{
    if (!_headerImageView) {
        _headerImageView = [[UIImageView alloc] init];
        _headerImageView.image = [UIImage imageNamed:@"defaultheader"];
    }
    return _headerImageView;
}

-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.font = HXBoldFont(18);
        _nameLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
       
    }
    return _nameLabel;
}

-(UIButton *)tagBtn1{
    if (!_tagBtn1) {
        _tagBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        _tagBtn1.titleLabel.font = HXFont(12);
        [_tagBtn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
       
    }
    return _tagBtn1;;
}

-(UIButton *)tagBtn2{
    if (!_tagBtn2) {
        _tagBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        _tagBtn2.titleLabel.font = HXFont(12);
        [_tagBtn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
       
    }
    return _tagBtn2;;
}

-(UIImageView *)mingyanImageView{
    if (!_mingyanImageView) {
        _mingyanImageView = [[UIImageView alloc] init];
        _mingyanImageView.image = [UIImage resizedImageWithName:@"mingyankuang"];
    }
    return _mingyanImageView;
}

-(UIButton *)checkHistoryBtn{
    if (!_checkHistoryBtn) {
        _checkHistoryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _checkHistoryBtn.hidden = YES;
        _checkHistoryBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _checkHistoryBtn.titleLabel.font = HXBoldFont(12);
        [_checkHistoryBtn setTitleColor:COLOR_WITH_ALPHA(0xAFAFAF, 1) forState:UIControlStateNormal];
        [_checkHistoryBtn setImage:[UIImage imageNamed:@"accessory_icon"] forState:UIControlStateNormal];
        [_checkHistoryBtn setTitle:@"查看历史学习报告" forState:UIControlStateNormal];
    }
    return _checkHistoryBtn;;
}

-(UIView *)threeContainerView{
    if (!_threeContainerView) {
        _threeContainerView = [[UIView alloc] init];
    }
    return _threeContainerView;
}

-(UILabel *)mingyanLabel{
    if (!_mingyanLabel) {
        _mingyanLabel = [[UILabel alloc] init];
        _mingyanLabel.textAlignment = NSTextAlignmentCenter;
        _mingyanLabel.font = HXFont(12);
        _mingyanLabel.textColor = COLOR_WITH_ALPHA(0x4BA4FE, 1);
        
    }
    return _mingyanLabel;
}

-(NSMutableArray *)threeControls{
    if (!_threeControls) {
        _threeControls = [NSMutableArray array];
    }
    return _threeControls;;
}
@end
