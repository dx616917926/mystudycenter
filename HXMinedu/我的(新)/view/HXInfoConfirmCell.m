//
//  HXInfoConfirmCell.m
//  HXMinedu
//
//  Created by mac on 2021/4/9.
//

#import "HXInfoConfirmCell.h"

@interface HXInfoConfirmCell ()

@property(nonatomic,strong) UILabel *titleLabel;
@property(nonatomic,strong) UIImageView *stateImageView;
@property(nonatomic,strong) UILabel *stateLabel;
@property(nonatomic,strong) UIImageView *arrowImageView;
@property(nonatomic,strong) UIView *bottomLine;

@end

@implementation HXInfoConfirmCell

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

-(void)setPictureInfoModel:(HXPictureInfoModel *)pictureInfoModel{
    _pictureInfoModel = pictureInfoModel;
    self.titleLabel.text = HXSafeString(pictureInfoModel.fileTypeName);
    
    if (pictureInfoModel.status == 0) {//待上传
        self.stateImageView.image = [UIImage imageNamed:@"noupload_icon"];
        self.stateLabel.text = @"待上传";
    }else {
        self.stateImageView.image = (pictureInfoModel.studentstatus == 1? [UIImage imageNamed:@"confirm_icon"]:[UIImage imageNamed:@"unconfirm_icon"]);
        self.stateLabel.text = (pictureInfoModel.studentstatus == 1? @"已确认":@"未确认");
    }
}

#pragma mark - UI
-(void)createUI{
    [self addSubview:self.titleLabel];
    [self addSubview:self.stateImageView];
    [self addSubview:self.stateLabel];
    [self addSubview:self.arrowImageView];
    [self addSubview:self.bottomLine];
    
    self.bottomLine.sd_layout
    .bottomEqualToView(self)
    .leftSpaceToView(self, _kpw(30))
    .rightSpaceToView(self, _kpw(30))
    .heightIs(0.5);
    
    
    
    self.arrowImageView.sd_layout
    .centerYEqualToView(self)
    .rightEqualToView(self.bottomLine).offset(-5)
    .widthIs(14)
    .heightIs(14);
    
    self.stateLabel.sd_layout
    .centerYEqualToView(self)
    .rightSpaceToView(self.arrowImageView, 14)
    .heightIs(20);
    [self.stateLabel setSingleLineAutoResizeWithMaxWidth:100];
    
    self.stateImageView.sd_layout
    .centerYEqualToView(self)
    .rightSpaceToView(self.stateLabel, 10)
    .heightIs(20)
    .widthEqualToHeight();
    
    self.titleLabel.sd_layout
    .centerYEqualToView(self)
    .leftEqualToView(self.bottomLine).offset(2)
    .rightSpaceToView(self.stateImageView, 10)
    .autoHeightRatio(0);
    [self.titleLabel setMaxNumberOfLinesToShow:2];
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = HXFont(16);
        _titleLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;;
}

-(UIImageView *)stateImageView{
    if (!_stateImageView) {
        _stateImageView = [[UIImageView alloc] init];
    }
    return _stateImageView;
}

-(UILabel *)stateLabel{
    if (!_stateLabel) {
        _stateLabel = [[UILabel alloc] init];
        _stateLabel.textAlignment = NSTextAlignmentLeft;
        _stateLabel.font = HXFont(14);
        _stateLabel.textColor = COLOR_WITH_ALPHA(0xAFAFAF, 1);
        
    }
    return _stateLabel;;
}
-(UIImageView *)arrowImageView{
    if (!_arrowImageView) {
        _arrowImageView = [[UIImageView alloc] init];
        _arrowImageView.image = [UIImage imageNamed:@"rightarrow"];

    }
    return _arrowImageView;
}

-(UIView *)bottomLine{
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = COLOR_WITH_ALPHA(0x979797, 0.4);
    }
    return _bottomLine;
}
@end
