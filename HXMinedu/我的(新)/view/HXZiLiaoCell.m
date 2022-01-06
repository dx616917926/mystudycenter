//
//  HXZiLiaoCell.m
//  HXMinedu
//
//  Created by mac on 2021/12/8.
//

#import "HXZiLiaoCell.h"

@interface HXZiLiaoCell ()

@property(nonatomic,strong) UILabel *titleLabel;
@property(nonatomic,strong) UILabel *numLabel;
@property(nonatomic,strong) UIImageView *stateImageView;
@property(nonatomic,strong) UILabel *stateLabel;
@property(nonatomic,strong) UIImageView *arrowImageView;
@property(nonatomic,strong) UIView *bottomLine;

@end

@implementation HXZiLiaoCell

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

#pragma mark - Setter
-(void)setFileTypeInfoModel:(HXFileTypeInfoModel *)fileTypeInfoModel{
    
    _fileTypeInfoModel = fileTypeInfoModel;
    
    self.titleLabel.text = [NSString stringWithFormat:@"%@(%ld)",fileTypeInfoModel.reserve,(long)fileTypeInfoModel.count];
    
    //状态 1待完善 2待确认 3已完善
    if (fileTypeInfoModel.status == 1) {
        self.stateImageView.image = [UIImage imageNamed:@"noupload_icon"];
        self.stateLabel.text = @"待完善";
        self.stateImageView.hidden = YES;
        self.numLabel.hidden = NO;
        self.numLabel.backgroundColor = COLOR_WITH_ALPHA(0xFF3D3D, 1);
        self.numLabel.text = [NSString stringWithFormat:@"%ld",(fileTypeInfoModel.count-fileTypeInfoModel.stuFileCount)];
    }else if (fileTypeInfoModel.status == 2) {
        self.stateImageView.image = [UIImage imageNamed:@"unconfirm_icon"];
        self.stateLabel.text = @"待确认";
        self.stateImageView.hidden = YES;
        self.numLabel.hidden = NO;
        self.numLabel.backgroundColor = COLOR_WITH_ALPHA(0xFF9F0A, 1);
        self.numLabel.text = [NSString stringWithFormat:@"%ld",fileTypeInfoModel.dqrCount];
    }else {
        self.stateImageView.image = [UIImage imageNamed:@"confirm_icon"];
        self.stateLabel.text = @"已完善";
        self.stateImageView.hidden = NO;
        self.numLabel.hidden = YES;
    }
}

#pragma mark - UI
-(void)createUI{
    [self addSubview:self.titleLabel];
    [self addSubview:self.numLabel];
    [self addSubview:self.stateImageView];
    [self addSubview:self.stateLabel];
    [self addSubview:self.arrowImageView];
    [self addSubview:self.bottomLine];
    
    self.bottomLine.sd_layout
    .bottomEqualToView(self)
    .leftSpaceToView(self, 10)
    .rightSpaceToView(self, 10)
    .heightIs(0.5);
    
    
    self.arrowImageView.sd_layout
    .centerYEqualToView(self)
    .rightEqualToView(self.bottomLine).offset(-10)
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
    
    self.numLabel.sd_layout
    .centerYEqualToView(self.stateImageView)
    .centerXEqualToView(self.stateImageView)
    .widthRatioToView(self.stateImageView, 1)
    .heightRatioToView(self.stateImageView, 1);
    self.numLabel.sd_cornerRadiusFromHeightRatio = @0.5;
    
    self.titleLabel.sd_layout
    .centerYEqualToView(self)
    .leftEqualToView(self.bottomLine).offset(10)
    .rightSpaceToView(self.stateImageView, 10)
    .autoHeightRatio(0);

}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = HXFont(16);
        _titleLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        _titleLabel.numberOfLines = 2;
       
    }
    return _titleLabel;;
}

-(UILabel *)numLabel{
    if (!_numLabel) {
        _numLabel = [[UILabel alloc] init];
        _numLabel.textAlignment = NSTextAlignmentCenter;
        _numLabel.font = HXFont(16);
        _numLabel.textColor = COLOR_WITH_ALPHA(0xffffff, 1);
        _numLabel.numberOfLines = 1;
        _numLabel.hidden = YES;
    }
    return _numLabel;;
}

-(UIImageView *)stateImageView{
    if (!_stateImageView) {
        _stateImageView = [[UIImageView alloc] init];
        _stateImageView.image = [UIImage imageNamed:@"confirm_icon"];
        _stateImageView.hidden = YES;
    }
    return _stateImageView;
}

-(UILabel *)stateLabel{
    if (!_stateLabel) {
        _stateLabel = [[UILabel alloc] init];
        _stateLabel.textAlignment = NSTextAlignmentRight;
        _stateLabel.font = HXFont(16);
        _stateLabel.textColor = COLOR_WITH_ALPHA(0x858585, 1);
        
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
