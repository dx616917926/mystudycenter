//
//  HXSelectTimeCell.m
//  HXMinedu
//
//  Created by mac on 2022/3/25.
//

#import "HXSelectTimeCell.h"

@interface HXSelectTimeCell ()
@property(nonatomic,strong) UILabel *dateLabel;
@property(nonatomic,strong) UIView *bgView;

@end

@implementation HXSelectTimeCell

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
    self.dateLabel.text = examDateModel.examDate;
    self.bgView.backgroundColor = examDateModel.isSelected?COLOR_WITH_ALPHA(0xEFEFEF, 1):COLOR_WITH_ALPHA(0xFFFFFF, 1);
}

#pragma mark - UI
-(void)createUI{
    
    [self addSubview:self.bgView];
    [self addSubview:self.dateLabel];
    
    self.bgView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    
    self.dateLabel.sd_layout
    .centerYEqualToView(self.bgView)
    .leftEqualToView(self.bgView)
    .rightEqualToView(self.bgView)
    .heightIs(20);
    
    
}
#pragma mark - lazyLoad

-(UILabel *)dateLabel{
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.textAlignment = NSTextAlignmentCenter;
        _dateLabel.font = HXFont(14);
        _dateLabel.textColor = COLOR_WITH_ALPHA(0x5D5D63, 1);
        _dateLabel.text = @"2020-12-01 至 2021-07-26";
    }
    return _dateLabel;
}

-(UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = COLOR_WITH_ALPHA(0xFFFFFF, 1);
    }
    return _bgView;
}

@end

