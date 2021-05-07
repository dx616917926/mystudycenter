//
//  HXTeachPlanCell.m
//  HXMinedu
//
//  Created by mac on 2021/3/29.
//

#import "HXTeachPlanCell.h"
#import "HXGradientProgressView.h"

@interface HXTeachPlanCell ()
@property(nonatomic,strong) UIView *shadowBackgroundView;
@property(nonatomic,strong) UIView *bigBackgroundView;
@property(nonatomic,strong) UILabel *courseNameLabel;
@property(nonatomic,strong) UILabel *codeNameLabel;
@property(nonatomic,strong) UIImageView *triangleImageView;
@property(nonatomic,strong) UIView *creditView;
@property(nonatomic,strong) UILabel *creditNumLabel;

@property(nonatomic,strong) UILabel *tongkaoLabel;
@property(nonatomic,strong) UILabel *tongkaoNumLabel;
@property(nonatomic,strong) UIImageView *resultImageView;
@property(nonatomic,strong) UIButton *wangxueBtn;

@end

@implementation HXTeachPlanCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}

#pragma mark - 刷新数据
-(void)setTeachCourseModel:(HXTeachCourseModel *)teachCourseModel{
    _teachCourseModel = teachCourseModel;
    
    self.courseNameLabel.text = HXSafeString(teachCourseModel.courseName);
    self.codeNameLabel.text = HXSafeString(teachCourseModel.courseCode);
    self.creditNumLabel.text = [NSString stringWithFormat:@"%@学分",HXSafeString(teachCourseModel.coursePoint)];
    
    if (teachCourseModel.isShowCheckLookName==1) {//显示统考
        self.tongkaoLabel.sd_layout
        .topSpaceToView(self.courseNameLabel, 12)
        .heightIs(17);
        self.tongkaoLabel.hidden = NO;
        self.tongkaoNumLabel.hidden = NO;
        self.resultImageView.hidden = NO;
        self.tongkaoLabel.text = HXSafeString(teachCourseModel.checkLookName);
        self.resultImageView.image = (teachCourseModel.IsPass==1?[UIImage imageNamed:@"success_icon"]:[UIImage imageNamed:@"fail_icon"]);
    }else{
        self.tongkaoLabel.sd_layout
        .topSpaceToView(self.courseNameLabel, 0)
        .heightIs(0);
        self.tongkaoLabel.hidden = YES;
        self.tongkaoNumLabel.hidden = YES;
        self.resultImageView.hidden = YES;
    }
    self.tongkaoLabel.text = HXSafeString(teachCourseModel.checkLookName);
    if (![HXCommonUtil isNull:teachCourseModel.finalScore]) {
        self.tongkaoNumLabel.attributedText = [HXCommonUtil getAttributedStringWith:teachCourseModel.finalScore needAttributed:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],NSForegroundColorAttributeName:COLOR_WITH_ALPHA(0x2C2C2E, 1)} content:([teachCourseModel.finalScore isEqual:@"暂无成绩"]?@"暂无成绩":[teachCourseModel.finalScore stringByAppendingString:@" 分"]) defaultAttributed:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:COLOR_WITH_ALPHA(0x2C2C2E, 1)}];
    }
    self.resultImageView.image = (teachCourseModel.IsPass==1?[UIImage imageNamed:@"success_icon"]:[UIImage imageNamed:@"fail_icon"]);
    //控制网学显示
    self.wangxueBtn.hidden = !teachCourseModel.isNetCourse;
    if (teachCourseModel.isShowCheckLookName == 1) {
        self.wangxueBtn.sd_layout
        .centerYEqualToView(self.tongkaoLabel)
        .leftSpaceToView(self.resultImageView, _kpw(35));
    }else{
        self.wangxueBtn.sd_layout
        .centerYEqualToView(self.courseNameLabel)
        .rightSpaceToView(self.bigBackgroundView, _kpw(0));
    }
    //控制学分显示
    self.triangleImageView.hidden = teachCourseModel.isShowFinalScore==1?NO:YES;
    
}


#pragma mark - UI布局
-(void)createUI{
    [self.contentView addSubview:self.shadowBackgroundView];
    [self.contentView addSubview:self.bigBackgroundView];
    [self.bigBackgroundView addSubview:self.courseNameLabel];
    [self.bigBackgroundView addSubview:self.codeNameLabel];
    [self.bigBackgroundView addSubview:self.triangleImageView];
    [self.triangleImageView addSubview:self.creditNumLabel];
    [self.bigBackgroundView addSubview:self.tongkaoLabel];
    [self.bigBackgroundView addSubview:self.tongkaoNumLabel];
    [self.bigBackgroundView addSubview:self.resultImageView];
    [self.bigBackgroundView addSubview:self.wangxueBtn];
    
   
    
    self.bigBackgroundView.sd_layout
    .leftSpaceToView(self.contentView, _kpw(23))
    .topSpaceToView(self.contentView, 7)
    .rightSpaceToView(self.contentView, _kpw(23));
    self.bigBackgroundView.sd_cornerRadius = @5;
    
    self.courseNameLabel.sd_layout
    .leftSpaceToView(self.bigBackgroundView, _kpw(28))
    .topSpaceToView(self.bigBackgroundView, 20)
    .heightIs(22);
    [self.courseNameLabel setSingleLineAutoResizeWithMaxWidth:_kpw(180)];
    
    self.codeNameLabel.sd_layout
    .leftSpaceToView(self.courseNameLabel, 14)
    .centerYEqualToView(self.courseNameLabel)
    .heightRatioToView(self.courseNameLabel, 1);
    [self.codeNameLabel setSingleLineAutoResizeWithMaxWidth:_kpw(100)];
    
    self.triangleImageView.sd_layout
    .topEqualToView(self.bigBackgroundView).offset(-2)
    .rightEqualToView(self.bigBackgroundView).offset(2)
    .widthIs(75)
    .heightIs(50);
    

    self.tongkaoLabel.sd_layout
    .leftEqualToView(self.courseNameLabel)
    .topSpaceToView(self.courseNameLabel, 12)
    .heightIs(17);
    [self.tongkaoLabel setSingleLineAutoResizeWithMaxWidth:60];
    
    self.tongkaoNumLabel.sd_layout
    .centerYEqualToView(self.tongkaoLabel)
    .leftSpaceToView(self.tongkaoLabel, 5)
    .heightIs(25);
    [self.tongkaoNumLabel setSingleLineAutoResizeWithMaxWidth:100];
    
    self.resultImageView.sd_layout
    .centerYEqualToView(self.tongkaoLabel)
    .leftSpaceToView(self.tongkaoNumLabel,5)
    .widthIs(14)
    .heightEqualToWidth();
    
    self.wangxueBtn.sd_layout
    .centerYEqualToView(self.tongkaoLabel)
    .leftSpaceToView(self.resultImageView, _kpw(35))
    .widthIs(80)
    .heightIs(25);
    
    self.wangxueBtn.titleLabel.sd_layout
    .centerYEqualToView(self.wangxueBtn)
    .heightRatioToView(self.wangxueBtn, 1)
    .leftEqualToView(self.wangxueBtn)
    .widthIs(30);
    
    self.wangxueBtn.imageView.sd_layout
    .centerYEqualToView(self.wangxueBtn)
    .leftSpaceToView(self.wangxueBtn.titleLabel, 7)
    .heightIs(14)
    .widthEqualToHeight();
    
    //设置bigBackgroundView自适应高度
    [self.bigBackgroundView setupAutoHeightWithBottomView:self.tongkaoLabel bottomMargin:23];
    self.shadowBackgroundView.sd_layout
    .topEqualToView(self.bigBackgroundView)
    .leftEqualToView(self.bigBackgroundView)
    .rightEqualToView(self.bigBackgroundView)
    .bottomEqualToView(self.bigBackgroundView);
    self.shadowBackgroundView.layer.cornerRadius = 5;
    
    ///设置cell高度自适应
    [self setupAutoHeightWithBottomView:self.bigBackgroundView bottomMargin:7];
}

#pragma mark - lazyLoad
-(UIView *)shadowBackgroundView{
    if (!_shadowBackgroundView) {
        _shadowBackgroundView = [[UIView alloc] init];
        _shadowBackgroundView.backgroundColor = [UIColor whiteColor];
        _shadowBackgroundView.layer.shadowColor = COLOR_WITH_ALPHA(0x000000, 0.15).CGColor;
        _shadowBackgroundView.layer.shadowOffset = CGSizeMake(0, 2);
        _shadowBackgroundView.layer.shadowRadius = 4;
        _shadowBackgroundView.layer.shadowOpacity = 1;
    }
    return _shadowBackgroundView;
}

-(UIView *)bigBackgroundView{
    if (!_bigBackgroundView) {
        _bigBackgroundView = [[UIView alloc] init];
        _bigBackgroundView.backgroundColor = [UIColor whiteColor];
        _bigBackgroundView.clipsToBounds = YES;
    }
    return _bigBackgroundView;
}

-(UIImageView *)triangleImageView{
    if (!_triangleImageView) {
        _triangleImageView = [[UIImageView alloc] init];
        _triangleImageView.image = [UIImage imageNamed:@"triangle_icon"];
    }
    return _triangleImageView;;
}


-(UILabel *)courseNameLabel{
    if (!_courseNameLabel) {
        _courseNameLabel = [[UILabel alloc] init];
        _courseNameLabel.textColor = COLOR_WITH_ALPHA(0x4BA4FE, 1);
        _courseNameLabel.font = [UIFont boldSystemFontOfSize:16];
        
    }
    return _courseNameLabel;;
}

-(UILabel *)codeNameLabel{
    if (!_codeNameLabel) {
        _codeNameLabel = [[UILabel alloc] init];
        _codeNameLabel.textColor = COLOR_WITH_ALPHA(0xA9A9A9, 1);
        _codeNameLabel.font = [UIFont systemFontOfSize:14];
        
    }
    return _codeNameLabel;;
}

-(UILabel *)creditNumLabel{
    if (!_creditNumLabel) {
        _creditNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30,75, 20)];
        _creditNumLabel.textColor = COLOR_WITH_ALPHA(0xffffff, 1);
        _creditNumLabel.textAlignment = NSTextAlignmentCenter;
        _creditNumLabel.font = [UIFont systemFontOfSize:14];
        _creditNumLabel.backgroundColor = [UIColor clearColor];
        _creditNumLabel.transform = CGAffineTransformMakeRotation(M_PI/5.45);
        _creditNumLabel.transform = CGAffineTransformTranslate(_creditNumLabel.transform ,0, -23);
    }
    return _creditNumLabel;
}



-(UILabel *)tongkaoLabel{
    if (!_tongkaoLabel) {
        _tongkaoLabel = [[UILabel alloc] init];
        _tongkaoLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        _tongkaoLabel.font = [UIFont systemFontOfSize:12];
        _tongkaoLabel.text = @"统考";
    }
    return _tongkaoLabel;;
}

-(UILabel *)tongkaoNumLabel{
    if (!_tongkaoNumLabel) {
        _tongkaoNumLabel = [[UILabel alloc] init];
        _tongkaoNumLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        _tongkaoNumLabel.font = [UIFont systemFontOfSize:12];
        _tongkaoNumLabel.attributedText = [HXCommonUtil getAttributedStringWith:@"89 " needAttributed:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],NSForegroundColorAttributeName:COLOR_WITH_ALPHA(0x2C2C2E, 1)} content:@"89 分" defaultAttributed:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:COLOR_WITH_ALPHA(0x2C2C2E, 1)}];
    }
    return _tongkaoNumLabel;;
}

-(UIImageView *)resultImageView{
    if (!_resultImageView) {
        _resultImageView = [[UIImageView alloc] init];
        _resultImageView.image = [UIImage imageNamed:@"success_icon"];
    }
    return _resultImageView;;
}

-(UIButton *)wangxueBtn{
    if (!_wangxueBtn) {
        _wangxueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _wangxueBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_wangxueBtn setTitle:@"网学" forState:UIControlStateNormal];
        [_wangxueBtn setTitleColor:COLOR_WITH_ALPHA(0x2C2C2E, 1) forState:UIControlStateNormal];
        [_wangxueBtn setImage:[UIImage imageNamed:@"web_icon"] forState:UIControlStateNormal];
    }
    return _wangxueBtn;;
}



@end
