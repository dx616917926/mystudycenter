//
//  HXSuggestionCell.m
//  HXMinedu
//
//  Created by mac on 2021/6/4.
//

#import "HXSuggestionCell.h"

@interface HXSuggestionCell ()

@property(nonatomic,strong) UIView *shadowBackgroundView;
@property(nonatomic,strong) UIView *bigBackgroundView;
@property(nonatomic,strong) UILabel *titleLabel;
@property(nonatomic,strong) UILabel *contentLabel;
@property(nonatomic,strong) UILabel *timeLabel;

@end

@implementation HXSuggestionCell

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
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        [self createUI];
    }
    return self;
}


-(void)setStudentRefundDetailsModel:(HXStudentRefundDetailsModel *)studentRefundDetailsModel{
    _studentRefundDetailsModel = studentRefundDetailsModel;
    self.contentLabel.text = [HXCommonUtil isNull:studentRefundDetailsModel.rejectRemark]?@"确认无误":studentRefundDetailsModel.rejectRemark;
    self.timeLabel.text = studentRefundDetailsModel.rejectTime;
}

#pragma mark - UI
-(void)createUI{
    [self.contentView addSubview:self.shadowBackgroundView];
    [self.contentView addSubview:self.bigBackgroundView];
    [self.bigBackgroundView addSubview:self.titleLabel];
    [self.bigBackgroundView addSubview:self.contentLabel];
    [self.bigBackgroundView addSubview:self.timeLabel];
   
    self.bigBackgroundView.sd_layout
    .leftSpaceToView(self.contentView, _kpw(10))
    .topSpaceToView(self.contentView, 8)
    .rightSpaceToView(self.contentView, _kpw(10));
    self.bigBackgroundView.sd_cornerRadius = @6;
    
    self.titleLabel.sd_layout
    .topSpaceToView(self.bigBackgroundView, 20)
    .leftSpaceToView(self.bigBackgroundView, 24)
    .rightSpaceToView(self.bigBackgroundView, 24)
    .heightIs(20);
    
    self.timeLabel.sd_layout
    .topSpaceToView(self.bigBackgroundView, 52)
    .rightSpaceToView(self.bigBackgroundView, 12)
    .heightIs(17);
    [self.timeLabel setSingleLineAutoResizeWithMaxWidth:150];
    
    self.contentLabel.sd_layout
    .topSpaceToView(self.titleLabel, 10)
    .leftSpaceToView(self.bigBackgroundView, 40)
    .rightSpaceToView(self.timeLabel, 10)
    .autoHeightRatio(0);
    
    //设置bigBackgroundView自适应高度
    [self.bigBackgroundView setupAutoHeightWithBottomViewsArray:@[self.contentLabel,self.timeLabel] bottomMargin:24];
    
    self.shadowBackgroundView.sd_layout
    .topEqualToView(self.bigBackgroundView)
    .leftEqualToView(self.bigBackgroundView)
    .rightEqualToView(self.bigBackgroundView)
    .bottomEqualToView(self.bigBackgroundView);
    self.shadowBackgroundView.layer.cornerRadius = 6;
    
    ///设置cell高度自适应
    [self setupAutoHeightWithBottomView:self.bigBackgroundView bottomMargin:8];
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

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        _titleLabel.font = HXBoldFont(14);
        _titleLabel.text = @"确认意见：";
    }
    return _titleLabel;
}

-(UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        _contentLabel.textColor = COLOR_WITH_ALPHA(0x5699FF, 1);
        _contentLabel.font = HXBoldFont(14);
        _contentLabel.numberOfLines = 0;
//        _contentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _contentLabel;
}

-(UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        _timeLabel.textColor = COLOR_WITH_ALPHA(0xAFAFAF, 1);
        _timeLabel.font = HXBoldFont(12);
        
    }
    return _timeLabel;
}
    
@end
