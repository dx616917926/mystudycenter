//
//  HXSystemNotificationCell.m
//  HXMinedu
//
//  Created by mac on 2021/4/12.
//

#import "HXSystemNotificationCell.h"

@interface HXSystemNotificationCell ()
@property(nonatomic,strong) UIView *bigBackGroundView;
@property(nonatomic,strong) UIImageView *notifiIcon;
@property(nonatomic,strong) UILabel *messageTitleLabel;
@property(nonatomic,strong) UILabel *sendTimeLabel;
@property(nonatomic,strong) UIButton *checkBtn;
@property(nonatomic,strong) UIView *bottomLine;

@end

@implementation HXSystemNotificationCell

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
        [self createUI];
    }
    return self;
}

-(void)setMessageModel:(HXMessageObject *)messageModel{
    _messageModel = messageModel;
    self.messageTitleLabel.text = HXSafeString(messageModel.MessageTitle);
    self.sendTimeLabel.text = HXSafeString(messageModel.sendTime);
}

#pragma mark - UI
-(void)createUI{
    
    [self.contentView addSubview:self.bigBackGroundView];
    [self.bigBackGroundView addSubview:self.notifiIcon];
    [self.bigBackGroundView addSubview:self.messageTitleLabel];
    [self.bigBackGroundView addSubview:self.sendTimeLabel];
    [self.bigBackGroundView addSubview:self.bottomLine];
    [self.bigBackGroundView addSubview:self.checkBtn];
    
    self.bigBackGroundView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, _kpw(23), 0, _kpw(23)));
    self.bigBackGroundView.sd_cornerRadius = @8;
    
    
    self.notifiIcon.sd_layout
    .topSpaceToView(self.bigBackGroundView, 20)
    .leftSpaceToView(self.bigBackGroundView, 20)
    .widthIs(20)
    .heightEqualToWidth();
    
    self.messageTitleLabel.sd_layout
    .centerYEqualToView(self.notifiIcon)
    .leftSpaceToView(self.notifiIcon, 16)
    .rightSpaceToView(self.bigBackGroundView, 16)
    .heightIs(20);
    
    self.sendTimeLabel.sd_layout
    .topSpaceToView(self.messageTitleLabel, 8)
    .leftSpaceToView(self.bigBackGroundView, 20)
    .rightSpaceToView(self.bigBackGroundView, 20)
    .heightIs(17);
    
    self.bottomLine.sd_layout
    .topSpaceToView(self.sendTimeLabel, 8)
    .leftSpaceToView(self.bigBackGroundView, 20)
    .rightSpaceToView(self.bigBackGroundView, 20)
    .heightIs(1);
    
    self.checkBtn.sd_layout
    .topSpaceToView(self.bottomLine, 1)
    .leftSpaceToView(self.bigBackGroundView, 20)
    .rightSpaceToView(self.bigBackGroundView, 20)
    .bottomSpaceToView(self.bigBackGroundView, 1);
    
    self.checkBtn.imageView.sd_layout
    .centerYEqualToView(self.checkBtn)
    .rightEqualToView(self.checkBtn)
    .widthIs(16)
    .heightEqualToWidth();
    
    self.checkBtn.titleLabel.sd_layout
    .centerYEqualToView(self.checkBtn)
    .leftEqualToView(self.checkBtn)
    .rightSpaceToView(self.checkBtn.imageView, 16)
    .heightRatioToView(self.checkBtn, 1);
    
    
}

#pragma mark - lazyload

-(UIView *)bigBackGroundView{
    if (!_bigBackGroundView) {
        _bigBackGroundView = [[UIView alloc] init];
        _bigBackGroundView.backgroundColor = [UIColor whiteColor];
    }
    return _bigBackGroundView;
}

-(UIImageView *)notifiIcon{
    if (!_notifiIcon) {
        _notifiIcon = [[UIImageView alloc] init];
        _notifiIcon.image = [UIImage imageNamed:@"systnotif_icon"];
    }
    return _notifiIcon;
}

-(UILabel *)messageTitleLabel{
    if (!_messageTitleLabel) {
        _messageTitleLabel = [[UILabel alloc] init];
        _messageTitleLabel.textAlignment = NSTextAlignmentLeft;
        _messageTitleLabel.font = HXFont(14);
        _messageTitleLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        
        _messageTitleLabel.numberOfLines = 1;
    }
    return _messageTitleLabel;
}

-(UILabel *)sendTimeLabel{
    if (!_sendTimeLabel) {
        _sendTimeLabel = [[UILabel alloc] init];
        _sendTimeLabel.textAlignment = NSTextAlignmentRight;
        _sendTimeLabel.font = HXFont(12);
        _sendTimeLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        
    }
    return _sendTimeLabel;
}
-(UIView *)bottomLine{
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = COLOR_WITH_ALPHA(0xAFAFAF, 0.4);
    }
    return _bottomLine;
}

-(UIButton *)checkBtn{
    if (!_checkBtn) {
        _checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _checkBtn.userInteractionEnabled = NO;
        _checkBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        _checkBtn.titleLabel.font = HXFont(14);
        [_checkBtn setTitleColor:COLOR_WITH_ALPHA(0x2C2C2E, 1) forState:UIControlStateNormal];
        [_checkBtn setTitle:@"查看详情" forState:UIControlStateNormal];
        [_checkBtn setImage:[UIImage imageNamed:@"systnotif_arrow"] forState:UIControlStateNormal];
    }
    return _checkBtn;
}
@end
