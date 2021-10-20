//
//  HXLiveBroadCastCell.m
//  HXMinedu
//
//  Created by mac on 2021/10/19.
//

#import "HXLiveBroadCastCell.h"
#import "SDWebImage.h"

@interface HXLiveBroadCastCell ()

@property(nonatomic,strong) UIImageView *coverImageView;
@property(nonatomic,strong) UIButton *playStateBtn;
@property(nonatomic,strong) UILabel *titleLabel;
@property(nonatomic,strong) UILabel *teacherLabel;
@property(nonatomic,strong) UILabel *roomNumLabel;
@property(nonatomic,strong) UIImageView *timerImageView;
@property(nonatomic,strong) UILabel *timeLabel;
@property(nonatomic,strong) UIView *botttomLine;
@end

@implementation HXLiveBroadCastCell

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

#pragma mark - Seeter

-(void)setLiveBroadcastModel:(HXLiveBroadcastModel *)liveBroadcastModel{
    _liveBroadcastModel = liveBroadcastModel;
    
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:[HXCommonUtil stringEncoding:liveBroadcastModel.imgUrl]] placeholderImage:nil];
    
    if (liveBroadcastModel.isLive==1) {
        [self.playStateBtn setTitle:@"已开播" forState:UIControlStateNormal];
        self.playStateBtn.backgroundColor = COLOR_WITH_ALPHA(0xFF9F0A, 1);
    }else{
        [self.playStateBtn setTitle:@"未开播" forState:UIControlStateNormal];
        self.playStateBtn.backgroundColor = COLOR_WITH_ALPHA(0x5D5D63, 1);
    }
    
    self.titleLabel.text = liveBroadcastModel.liveName;
    self.teacherLabel.text = liveBroadcastModel.liveUser;
    self.roomNumLabel.text = ([HXCommonUtil isNull:liveBroadcastModel.roomNumber]?@"房间号:--":[NSString stringWithFormat:@"房间号:%@",liveBroadcastModel.roomNumber]);
    self.timeLabel.text = liveBroadcastModel.liveStartDateText;
}

#pragma mark - UI
-(void)createUI{
    [self.contentView addSubview:self.coverImageView];
    [self.coverImageView addSubview:self.playStateBtn];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.teacherLabel];
    [self.contentView addSubview:self.roomNumLabel];
    [self.contentView addSubview:self.timerImageView];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.botttomLine];
    
    
    self.coverImageView.sd_layout
    .centerYEqualToView(self.contentView)
    .leftSpaceToView(self.contentView, 20)
    .widthIs(110)
    .heightIs(62);
    self.coverImageView.sd_cornerRadius = @4;
    
    self.playStateBtn.sd_layout
    .topEqualToView(self.coverImageView)
    .leftEqualToView(self.coverImageView);
    [self.playStateBtn setupAutoSizeWithHorizontalPadding:8 buttonHeight:15];
    self.playStateBtn.sd_cornerRadius = @4;
    
    self.titleLabel.sd_layout
    .topEqualToView(self.coverImageView)
    .leftSpaceToView(self.coverImageView, 20)
    .rightSpaceToView(self.contentView, 20)
    .heightIs(20);
    
    self.teacherLabel.sd_layout
    .topSpaceToView(self.titleLabel, 5)
    .leftEqualToView(self.titleLabel)
    .rightEqualToView(self.titleLabel)
    .heightIs(17);
    
    self.roomNumLabel.sd_layout
    .bottomEqualToView(self.coverImageView)
    .leftEqualToView(self.titleLabel)
    .heightIs(14);
    [self.roomNumLabel setSingleLineAutoResizeWithMaxWidth:100];
    
    self.timerImageView.sd_layout
    .centerYEqualToView(self.roomNumLabel)
    .leftSpaceToView(self.roomNumLabel, 12)
    .widthIs(10)
    .heightEqualToWidth();
    
    self.timeLabel.sd_layout
    .centerYEqualToView(self.roomNumLabel)
    .leftSpaceToView(self.timerImageView, 5)
    .rightEqualToView(self.titleLabel)
    .heightEqualToWidth();
    
    
    self.botttomLine.sd_layout
    .bottomEqualToView(self.contentView)
    .leftEqualToView(self.coverImageView)
    .rightEqualToView(self.contentView)
    .heightIs(1);
}



#pragma mark - LazyLoad
-(UIImageView *)coverImageView{
    if (!_coverImageView) {
        _coverImageView = [[UIImageView alloc] init];
        _coverImageView.backgroundColor = COLOR_WITH_ALPHA(0xEEEEEE, 1);
        _coverImageView.clipsToBounds = YES;
    }
    return _coverImageView;
}

-(UIButton *)playStateBtn{
    if (!_playStateBtn) {
        _playStateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _playStateBtn.titleLabel.font = HXFont(10);
        [_playStateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_playStateBtn setTitle:@"已开播" forState:UIControlStateNormal];
        _playStateBtn.backgroundColor = COLOR_WITH_ALPHA(0xFF9F0A, 1);
    }
    return _playStateBtn;
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = HXFont(14);
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _titleLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        
    }
    return _titleLabel;
}

-(UILabel *)teacherLabel{
    if (!_teacherLabel) {
        _teacherLabel = [[UILabel alloc] init];
        _teacherLabel.textAlignment = NSTextAlignmentLeft;
        _teacherLabel.font = HXFont(12);
        _teacherLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _teacherLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        
    }
    return _teacherLabel;
}

-(UILabel *)roomNumLabel{
    if (!_roomNumLabel) {
        _roomNumLabel = [[UILabel alloc] init];
        _roomNumLabel.textAlignment = NSTextAlignmentLeft;
        _roomNumLabel.font = HXFont(10);
        _roomNumLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _roomNumLabel.textColor = COLOR_WITH_ALPHA(0xB1B1B1, 1);
        
    }
    return _roomNumLabel;
}

-(UIImageView *)timerImageView{
    if (!_timerImageView) {
        _timerImageView = [[UIImageView alloc] init];
        _timerImageView.image = [UIImage imageNamed:@"timer_icon"];
    }
    return _timerImageView;
}

-(UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        _timeLabel.font = HXFont(10);
        _timeLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _timeLabel.textColor = COLOR_WITH_ALPHA(0xB1B1B1, 1);
        
    }
    return _timeLabel;
}

-(UIView *)botttomLine{
    if (!_botttomLine) {
        _botttomLine = [[UIView alloc] init];
        _botttomLine.backgroundColor = COLOR_WITH_ALPHA(0xEEEEEE, 1);
    }
    return _botttomLine;
}

@end
