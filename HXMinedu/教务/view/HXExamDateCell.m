//
//  HXExamDateCell.m
//  HXMinedu
//
//  Created by mac on 2021/4/8.
//

#import "HXExamDateCell.h"

@interface HXExamDateCell ()
@property(nonatomic,strong) UILabel *dateLabel;
@property(nonatomic,strong) UIView *bottomLine;
@property(nonatomic,strong) UIImageView *stateImageView;

@end

@implementation HXExamDateCell

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

-(void)setExamDateModel:(HXExamDateModel *)examDateModel{
    _examDateModel = examDateModel;
    self.dateLabel.text = [NSString stringWithFormat:@"%@",examDateModel.examDate];
    self.dateLabel.textColor = examDateModel.isSelected?COLOR_WITH_ALPHA(0x4BA4FE, 1):COLOR_WITH_ALPHA(0x2C2C2E, 1);
    self.stateImageView.image = examDateModel.isSelected?[UIImage imageNamed:@"date_select"]:[UIImage imageNamed:@"date_unselect"];
}

#pragma mark - UI
-(void)createUI{
    [self addSubview:self.dateLabel];
    [self addSubview:self.bottomLine];
    [self addSubview:self.stateImageView];

    
    self.bottomLine.sd_layout
    .leftSpaceToView(self, _kpw(70))
    .rightSpaceToView(self, _kpw(70))
    .bottomEqualToView(self)
    .heightIs(0.5);
    
    self.stateImageView.sd_layout
    .centerYEqualToView(self)
    .rightEqualToView(self.bottomLine).offset(-14)
    .widthIs(10)
    .heightEqualToWidth();
    
    self.dateLabel.sd_layout
    .centerYEqualToView(self)
    .leftEqualToView(self.bottomLine)
    .rightEqualToView(self.bottomLine)
    .heightIs(20);
    
    
}
#pragma mark - lazyLoad

-(UILabel *)dateLabel{
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.textAlignment = NSTextAlignmentCenter;
        _dateLabel.font = HXFont(14);
        _dateLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        
    }
    return _dateLabel;
}

-(UIView *)bottomLine{
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = COLOR_WITH_ALPHA(0x979797, 0.39);
    }
    return _bottomLine;
}

-(UIImageView *)stateImageView{
    if (!_stateImageView) {
        _stateImageView = [[UIImageView alloc] init];
        _stateImageView.userInteractionEnabled = YES;
        _stateImageView.image = [UIImage imageNamed:@"date_unselect"];
    }
    return _stateImageView;
}


@end
