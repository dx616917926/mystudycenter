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

-(void)createUI{
    [self.contentView addSubview:self.bigBackGroundView];
    [self.bigBackGroundView addSubview:self.examTitleLabel];
    [self.bigBackGroundView addSubview:self.scoreLabel];
    [self.bigBackGroundView addSubview:self.resultBtn];
    
    self.bigBackGroundView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(5, _kpw(23), 5, _kpw(23)));
    self.bigBackGroundView.layer.cornerRadius = 5;
    
    self.examTitleLabel.sd_layout
    .leftSpaceToView(self.bigBackGroundView, _kpw(28))
    .centerYEqualToView(self.bigBackGroundView)
    .widthRatioToView(self.bigBackGroundView, 0.45)
    .autoHeightRatio(0);
    [self.examTitleLabel setMaxNumberOfLinesToShow:2];
    
    
    self.scoreLabel.sd_layout
    .centerYEqualToView(self.bigBackGroundView)
    .leftSpaceToView(self.examTitleLabel, 20)
    .heightIs(22);
    [self.scoreLabel setSingleLineAutoResizeWithMaxWidth:80];
    
    self.resultBtn.sd_layout
    .centerYEqualToView(self.bigBackGroundView)
    .leftSpaceToView(self.scoreLabel, 20)
    .heightIs(40)
    .rightSpaceToView(self.bigBackGroundView, _kpw(5));
    
    self.resultBtn.imageView.sd_layout
    .centerYEqualToView(self.resultBtn)
    .leftEqualToView(self.resultBtn)
    .widthIs(25)
    .heightEqualToWidth();
    
    self.resultBtn.titleLabel.sd_layout
    .centerYEqualToView(self.resultBtn)
    .leftSpaceToView(self.resultBtn.imageView,10)
    .rightSpaceToView(self.resultBtn, 5)
    .heightIs(20);
    
}

#pragma mark - lazyload
-(UIView *)bigBackGroundView{
    if (!_bigBackGroundView) {
        _bigBackGroundView = [[UIView alloc] init];
        _bigBackGroundView.backgroundColor = COLOR_WITH_ALPHA(0x45EFCF, 0.10);
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
        _examTitleLabel.textColor = COLOR_WITH_ALPHA(0x333333, 1);
        _examTitleLabel.font = [UIFont systemFontOfSize:16];
        _examTitleLabel.text = @"毛泽东思想和邓小平理论与“三个代表”";
        _examTitleLabel.numberOfLines = 2;
    }
    return _examTitleLabel;;
}

-(UILabel *)scoreLabel{
    if (!_scoreLabel) {
        _scoreLabel = [[UILabel alloc] init];
        _scoreLabel.textColor = COLOR_WITH_ALPHA(0x333333, 1);
        _scoreLabel.font = [UIFont systemFontOfSize:16];
        _scoreLabel.text = @"96分";
    }
    return _scoreLabel;;
}

-(UIButton *)resultBtn{
    if (!_resultBtn) {
        _resultBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _resultBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        _resultBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        [_resultBtn setImage:[UIImage imageNamed:@"success_icon"] forState:UIControlStateNormal];
        [_resultBtn setTitleColor:COLOR_WITH_ALPHA(0x999999, 1) forState:UIControlStateNormal];
        [_resultBtn setTitle:@"通过" forState:UIControlStateNormal];
    }
    return _resultBtn;
}

@end
