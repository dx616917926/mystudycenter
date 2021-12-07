//
//  HXDissertationCell.m
//  HXMinedu
//
//  Created by mac on 2021/12/6.
//

#import "HXDissertationCell.h"

@interface HXDissertationCell ()

@property(nonatomic,strong) UIView *shadowBackgroundView;
@property(nonatomic,strong) UIView *bigBackgroundView;
@property(nonatomic,strong) UILabel *schoolNameLabel;
@property(nonatomic,strong) UILabel *cengCiNameLabel;
@property(nonatomic,strong) UILabel *majorNameLabel;

@property(nonatomic,strong) UIImageView *triangleImageView;
@property(nonatomic,strong) UILabel *typeLabel;

@property(nonatomic,strong) UIImageView *wordImageView;

@end

@implementation HXDissertationCell

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

#pragma mark - UI布局
-(void)createUI{
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.shadowBackgroundView];
    [self.contentView addSubview:self.bigBackgroundView];
    [self.bigBackgroundView addSubview:self.schoolNameLabel];
    [self.bigBackgroundView addSubview:self.cengCiNameLabel];
    [self.bigBackgroundView addSubview:self.majorNameLabel];
    [self.bigBackgroundView addSubview:self.triangleImageView];
    [self.triangleImageView addSubview:self.typeLabel];
    [self.bigBackgroundView addSubview:self.wordImageView];
  
    
    self.bigBackgroundView.sd_layout
    .leftSpaceToView(self.contentView, 20)
    .topSpaceToView(self.contentView, 10)
    .rightSpaceToView(self.contentView, 20)
    .bottomSpaceToView(self.contentView, 10);
    self.bigBackgroundView.sd_cornerRadius = @8;
    
    self.shadowBackgroundView.sd_layout
    .topEqualToView(self.bigBackgroundView)
    .leftEqualToView(self.bigBackgroundView)
    .rightEqualToView(self.bigBackgroundView)
    .bottomEqualToView(self.bigBackgroundView);
    self.shadowBackgroundView.layer.cornerRadius = 8;
   
    self.triangleImageView.sd_layout
    .topEqualToView(self.bigBackgroundView)
    .rightEqualToView(self.bigBackgroundView)
    .widthIs(60)
    .heightIs(38);
    
    self.wordImageView.sd_layout
    .bottomEqualToView(self.bigBackgroundView)
    .rightEqualToView(self.bigBackgroundView)
    .widthIs(88)
    .heightIs(63);
    
    self.schoolNameLabel.sd_layout
    .leftSpaceToView(self.bigBackgroundView, 24)
    .rightSpaceToView(self.triangleImageView, 0)
    .topSpaceToView(self.bigBackgroundView, 18)
    .heightIs(25);
   
    self.cengCiNameLabel.sd_layout
    .topSpaceToView(self.schoolNameLabel, 10)
    .leftEqualToView(self.schoolNameLabel)
    .rightEqualToView(self.schoolNameLabel)
    .heightIs(22);
    
    self.majorNameLabel.sd_layout
    .topSpaceToView(self.cengCiNameLabel, 10)
    .leftEqualToView(self.schoolNameLabel)
    .rightEqualToView(self.schoolNameLabel)
    .heightIs(22);
    

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

-(UIImageView *)wordImageView{
    if (!_wordImageView) {
        _wordImageView = [[UIImageView alloc] init];
        _wordImageView.image = [UIImage imageNamed:@"word_icon"];
    }
    return _wordImageView;
}


-(UILabel *)schoolNameLabel{
    if (!_schoolNameLabel) {
        _schoolNameLabel = [[UILabel alloc] init];
        _schoolNameLabel.textColor = COLOR_WITH_ALPHA(0x5D5D63, 1);
        _schoolNameLabel.font = HXFont(18);
        _schoolNameLabel.text = @"湖南涉外经济学院";
    }
    return _schoolNameLabel;;
}

-(UILabel *)cengCiNameLabel{
    if (!_cengCiNameLabel) {
        _cengCiNameLabel = [[UILabel alloc] init];
        _cengCiNameLabel.textColor = COLOR_WITH_ALPHA(0x5D5D63, 1);
        _cengCiNameLabel.font = HXFont(16);
        _cengCiNameLabel.text = @"专升本";
    }
    return _cengCiNameLabel;;
}

-(UILabel *)majorNameLabel{
    if (!_majorNameLabel) {
        _majorNameLabel = [[UILabel alloc] init];
        _majorNameLabel.textColor = COLOR_WITH_ALPHA(0x5D5D63, 1);
        _majorNameLabel.font = HXFont(16);
        _majorNameLabel.text = @"A020106金融学";
    }
    return _majorNameLabel;
}


-(UILabel *)typeLabel{
    if (!_typeLabel) {
        _typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 12,60,20)];
        _typeLabel.textColor = COLOR_WITH_ALPHA(0xffffff, 1);
        _typeLabel.textAlignment = NSTextAlignmentCenter;
        _typeLabel.font = HXFont(14);
        _typeLabel.backgroundColor = [UIColor clearColor];
        _typeLabel.transform = CGAffineTransformMakeRotation(M_PI/5.45);
        _typeLabel.transform = CGAffineTransformTranslate(_typeLabel.transform ,0, -12);
        _typeLabel.text = @"自学";
    }
    return _typeLabel;
}

@end
