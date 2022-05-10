//
//  HXSelectCourseCell.m
//  HXMinedu
//
//  Created by mac on 2022/2/15.
//

#import "HXSelectCourseCell.h"
#import "SDWebImage.h"


@interface HXSelectCourseCell ()
@property(nonatomic,strong) UIView *shadowBackgroundView;
@property(nonatomic,strong) UIView *bigBackgroundView;
@property(nonatomic,strong) UIImageView *courseImageView;
@property(nonatomic,strong) UILabel *courseNameLabel;

@property(nonatomic,strong) UIButton *courseTypeButton;
@property(nonatomic,strong) UIButton *clickButton;
@property(nonatomic,strong) UILabel *timeLabel;

@end

@implementation HXSelectCourseCell

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

#pragma mark - Event

-(void)clickButton:(UIButton *)sender{
    HXModelItem *item = self.courseModel.modules.firstObject;
    item.StemCode = self.courseModel.StemCode;
    if (self.delegate && [self.delegate respondsToSelector:@selector(handleItem:)]) {
        [self.delegate handleItem:item];
    }
}


//-(void)setType:(HXClickType)type{
//    _type = type;
//    switch (self.type) {
//        case HXKeJianXueXiClickType:
//            [self.clickButton setTitle:@"点击学习" forState:UIControlStateNormal];
//            break;
//        case HXQiMoKaoShiClickType:
//            [self.clickButton setTitle:@"点击考试" forState:UIControlStateNormal];
//            break;
//        case HXPingShiZuoYeClickType:
//        case HXLiNianZhenTiClickType:
//            [self.clickButton setTitle:@"点击练习" forState:UIControlStateNormal];
//            break;
//        default:
//            break;
//    }
//}

-(void)setCourseModel:(HXCourseModel *)courseModel{
    _courseModel = courseModel;
    [self.courseImageView sd_setImageWithURL:[NSURL URLWithString:[HXCommonUtil stringEncoding:courseModel.imageURL]] placeholderImage:nil];
    self.courseNameLabel.text = HXSafeString(courseModel.courseName);
    [self.courseTypeButton setTitle:HXSafeString(courseModel.revision) forState:UIControlStateNormal];
    
    HXModelItem *item = courseModel.modules.firstObject;
    self.clickButton.enabled = YES;
    self.clickButton.backgroundColor = COLOR_WITH_ALPHA(0x5699FF, 1);
    self.timeLabel.text = [NSString stringWithFormat:@"课程有效期：%@-%@",item.StartDate,item.EndDate];
}


#pragma mark - UI
-(void)createUI{
    [self.contentView addSubview:self.shadowBackgroundView];
    [self.contentView addSubview:self.bigBackgroundView];
    [self.bigBackgroundView addSubview:self.courseImageView];
    [self.bigBackgroundView addSubview:self.courseNameLabel];
    [self.bigBackgroundView addSubview:self.courseTypeButton];
    [self.bigBackgroundView addSubview:self.clickButton];
    [self.bigBackgroundView addSubview:self.timeLabel];
    
    
    self.bigBackgroundView.sd_layout
    .leftSpaceToView(self.contentView, _kpw(20))
    .topSpaceToView(self.contentView, 10)
    .rightSpaceToView(self.contentView, _kpw(20))
    .bottomSpaceToView(self.contentView, 10);
    self.bigBackgroundView.sd_cornerRadius = @8;
    
    self.shadowBackgroundView.sd_layout
    .topEqualToView(self.bigBackgroundView)
    .leftEqualToView(self.bigBackgroundView)
    .rightEqualToView(self.bigBackgroundView)
    .bottomEqualToView(self.bigBackgroundView);
    self.shadowBackgroundView.layer.cornerRadius = 8;
    
    self.courseImageView.sd_layout
    .topSpaceToView(self.bigBackgroundView, 15)
    .leftSpaceToView(self.bigBackgroundView, 15)
    .widthIs(_kpw(134))
    .heightIs(_kpw(92));
    self.courseImageView.sd_cornerRadius = @4;
    

    self.courseNameLabel.sd_layout
    .topEqualToView(self.courseImageView)
    .leftSpaceToView(self.courseImageView, 15)
    .rightSpaceToView(self.bigBackgroundView, 15)
    .autoHeightRatio(0);
    [self.courseNameLabel setMaxNumberOfLinesToShow:2];
    
    self.courseTypeButton.sd_layout
    .topSpaceToView(self.courseNameLabel, 5)
    .leftEqualToView(self.courseNameLabel);
    [self.courseTypeButton setupAutoSizeWithHorizontalPadding:15 buttonHeight:20];
    self.courseTypeButton.sd_cornerRadius = @4;
    
    self.clickButton.sd_layout
    .leftEqualToView(self.courseNameLabel)
    .bottomEqualToView(self.courseImageView)
    .widthIs(100)
    .heightIs(_kpw(30));
    self.clickButton.sd_cornerRadiusFromHeightRatio = @0.5;
    
    self.timeLabel.sd_layout
    .bottomSpaceToView(self.bigBackgroundView, 20)
    .leftEqualToView(self.courseImageView)
    .rightSpaceToView(self.bigBackgroundView, 15)
    .heightIs(14);
  
}


-(UIView *)shadowBackgroundView{
    if (!_shadowBackgroundView) {
        _shadowBackgroundView = [[UIView alloc] init];
        _shadowBackgroundView.backgroundColor = [UIColor whiteColor];
        _shadowBackgroundView.layer.shadowColor = COLOR_WITH_ALPHA(0x000000, 0.15).CGColor;
        _shadowBackgroundView.layer.shadowOffset = CGSizeMake(0, 3);
        _shadowBackgroundView.layer.shadowRadius = 6;
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

-(UIImageView *)courseImageView{
    if (!_courseImageView) {
        _courseImageView = [[UIImageView alloc] init];
        _courseImageView.backgroundColor = COLOR_WITH_ALPHA(0xEFEFEF, 1);
        _courseImageView.clipsToBounds = YES;
        _courseImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _courseImageView;;
}
-(UILabel *)courseNameLabel{
    if (!_courseNameLabel) {
        _courseNameLabel = [[UILabel alloc] init];
        _courseNameLabel.textColor = COLOR_WITH_ALPHA(0x5D5D63, 1);
        _courseNameLabel.numberOfLines = 2;
        _courseNameLabel.font = HXBoldFont(_kpw(15));
    }
    return _courseNameLabel;;
}

-(UIButton *)courseTypeButton{
    if (!_courseTypeButton) {
        _courseTypeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _courseTypeButton.titleLabel.font = HXFont(10);
        _courseTypeButton.backgroundColor = COLOR_WITH_ALPHA(0xFFF7E6, 1);
        [_courseTypeButton setTitleColor:COLOR_WITH_ALPHA(0xF88520, 1) forState:UIControlStateNormal];
        
    }
    return _courseTypeButton;
}

-(UIButton *)clickButton{
    if (!_clickButton) {
        _clickButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _clickButton.titleLabel.font = HXFont(12);
        _clickButton.backgroundColor = COLOR_WITH_ALPHA(0x5699FF, 1);
        [_clickButton setTitleColor:COLOR_WITH_ALPHA(0xFFFFFF, 1) forState:UIControlStateNormal];
        [_clickButton setTitleColor:COLOR_WITH_ALPHA(0x717171, 1) forState:UIControlStateDisabled];
        [_clickButton setTitle:@"点击学习" forState:UIControlStateNormal];
        [_clickButton setTitle:@"已停用" forState:UIControlStateDisabled];
        [_clickButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _clickButton;
}


-(UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = COLOR_WITH_ALPHA(0x5D5D63, 1);
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        _timeLabel.font = HXFont(12);
        
    }
    return _timeLabel;
}




@end
