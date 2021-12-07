//
//  HXExaminationResultsCell.m
//  HXMinedu
//
//  Created by mac on 2021/3/30.
//

#import "HXExaminationResultsCell.h"

@interface HXExaminationResultsCell ()
@property(nonatomic,strong) UIView *bigBackGroundView;
@property(nonatomic,strong) UILabel *examTitleLabel;
@property(nonatomic,strong) UILabel *scoreLabel;
@property(nonatomic,strong) UIButton *resultBtn;



@end

@implementation HXExaminationResultsCell

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

-(void)setExamDateCourseScoreModel:(HXExamDateCourseScoreModel *)examDateCourseScoreModel{
    _examDateCourseScoreModel = examDateCourseScoreModel;
    self.examTitleLabel.text = HXSafeString(examDateCourseScoreModel.courseName);
    self.scoreLabel.text = [examDateCourseScoreModel.finalScore isEqualToString:@"-99"]?@"":[HXSafeString(examDateCourseScoreModel.finalScore) stringByAppendingString:@"分"];
    if (examDateCourseScoreModel.isHaveKaoQi) {
        self.resultBtn.sd_layout.widthIs(90);
        if (examDateCourseScoreModel.IsPass == 1) {
            [self.resultBtn setTitle:@"通过" forState:UIControlStateNormal];
            [self.resultBtn setImage:[UIImage imageNamed:@"success_icon"] forState:UIControlStateNormal];
            self.bigBackGroundView.backgroundColor = COLOR_WITH_ALPHA(0xF3FFFA, 1);
        }else{
            [self.resultBtn setTitle:([examDateCourseScoreModel.finalScore isEqualToString:@"-99"]?@"暂无成绩":@"未通过") forState:UIControlStateNormal];
            [self.resultBtn setImage:([examDateCourseScoreModel.finalScore isEqualToString:@"-99"]?[UIImage imageNamed:@"clock_icon"]:[UIImage imageNamed:@"fail_icon"]) forState:UIControlStateNormal];
            self.bigBackGroundView.backgroundColor = ([examDateCourseScoreModel.finalScore isEqualToString:@"-99"]?COLOR_WITH_ALPHA(0xFFF7EA, 1):COLOR_WITH_ALPHA(0xFFF8FA, 1));
        }
    }else{
        self.resultBtn.sd_layout.widthIs(0);
    }
    
   
}

#pragma mark - UI
-(void)createUI{
    [self.contentView addSubview:self.bigBackGroundView];
    [self.bigBackGroundView addSubview:self.examTitleLabel];
    [self.bigBackGroundView addSubview:self.scoreLabel];
    [self.bigBackGroundView addSubview:self.resultBtn];
    
    self.bigBackGroundView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(5, _kpw(23), 5, _kpw(23)));
    self.bigBackGroundView.layer.cornerRadius = 5;
    

    self.resultBtn.sd_layout
    .centerYEqualToView(self.bigBackGroundView)
    .widthIs(90)
    .heightIs(40)
    .rightSpaceToView(self.bigBackGroundView, _kpw(10));
    
    self.resultBtn.imageView.sd_layout
    .centerYEqualToView(self.resultBtn)
    .leftEqualToView(self.resultBtn)
    .widthIs(15)
    .heightEqualToWidth();
    
    self.resultBtn.titleLabel.sd_layout
    .centerYEqualToView(self.resultBtn)
    .leftSpaceToView(self.resultBtn.imageView,8)
    .rightEqualToView(self.resultBtn)
    .heightIs(20);
    
    self.scoreLabel.sd_layout
    .centerYEqualToView(self.bigBackGroundView)
    .rightSpaceToView(self.resultBtn, 10)
    .heightIs(22);
    [self.scoreLabel setSingleLineAutoResizeWithMaxWidth:80];
    
    self.examTitleLabel.sd_layout
    .leftSpaceToView(self.bigBackGroundView, _kpw(28))
    .centerYEqualToView(self.bigBackGroundView)
    .rightSpaceToView(self.scoreLabel, 20)
    .autoHeightRatio(0);
    [self.examTitleLabel setMaxNumberOfLinesToShow:2];
    
}

#pragma mark - lazyload
-(UIView *)bigBackGroundView{
    if (!_bigBackGroundView) {
        _bigBackGroundView = [[UIView alloc] init];
        _bigBackGroundView.backgroundColor = COLOR_WITH_ALPHA(0xF3FFFA, 1);
        _bigBackGroundView.layer.shadowColor = COLOR_WITH_ALPHA(0x000000, 0.15).CGColor;
        _bigBackGroundView.layer.shadowOffset = CGSizeMake(0, 2);
        _bigBackGroundView.layer.shadowRadius = 4;
        _bigBackGroundView.layer.shadowOpacity = 1;
    }
    return _bigBackGroundView;
}

-(UILabel *)examTitleLabel{
    if (!_examTitleLabel) {
        _examTitleLabel = [[UILabel alloc] init];
        _examTitleLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        _examTitleLabel.font = HXFont(16);
        _examTitleLabel.numberOfLines = 2;
    }
    return _examTitleLabel;;
}

-(UILabel *)scoreLabel{
    if (!_scoreLabel) {
        _scoreLabel = [[UILabel alloc] init];
        _scoreLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        _scoreLabel.font = HXBoldFont(16);
    }
    return _scoreLabel;;
}

-(UIButton *)resultBtn{
    if (!_resultBtn) {
        _resultBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _resultBtn.titleLabel.font = HXFont(14);
        _resultBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        [_resultBtn setTitleColor:COLOR_WITH_ALPHA(0x2C2C2E, 1) forState:UIControlStateNormal];
        _resultBtn.clipsToBounds = YES;
    }
    return _resultBtn;
}

@end
