//
//  HXSelectHistoryTimeCell.m
//  HXMinedu
//
//  Created by mac on 2021/7/29.
//

#import "HXSelectHistoryTimeCell.h"

@interface HXSelectHistoryTimeCell ()

@property(nonatomic,strong) UIImageView *backgroudImageView;
@property(nonatomic,strong) UILabel *titleLabel;

@end

@implementation HXSelectHistoryTimeCell

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


-(void)setTimeModel:(HXHistoryTimeModel *)timeModel{
    _timeModel = timeModel;
    self.titleLabel.text = HXSafeString(timeModel.createDate);
    self.titleLabel.textColor = timeModel.isSelected?[UIColor whiteColor]:COLOR_WITH_ALPHA(0x2C2C2E, 1);
    self.backgroudImageView.image = timeModel.isSelected?[UIImage imageNamed:@"navbar_bg"]:nil;
    
}



#pragma mark - UI布局
-(void)createUI{
    [self addSubview:self.backgroudImageView];
    [self addSubview:self.titleLabel];
    
    self.backgroudImageView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));

    
    self.titleLabel.sd_layout
    .centerYEqualToView(self)
    .leftSpaceToView(self, 20)
    .rightSpaceToView(self, 20)
    .autoHeightRatio(0);
    
}

#pragma mark - lazyLoad
-(UIImageView *)backgroudImageView{
    if (!_backgroudImageView) {
        _backgroudImageView = [[UIImageView alloc] init];
        _backgroudImageView.backgroundColor = [UIColor whiteColor];
        _backgroudImageView.contentMode = UIViewContentModeScaleAspectFill;
        _backgroudImageView.clipsToBounds = YES;
    }
    return _backgroudImageView;
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        _titleLabel.font = HXFont(14);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.numberOfLines = 1;
    }
    return _titleLabel;
}



@end

