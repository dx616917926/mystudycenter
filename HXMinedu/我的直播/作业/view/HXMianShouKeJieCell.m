//
//  HXMianShouKeJieCell.m
//  HXMinedu
//
//  Created by mac on 2022/9/26.
//

#import "HXMianShouKeJieCell.h"

@interface HXMianShouKeJieCell ()
@property(nonatomic,strong) UIView *shadowBackgroundView;
@property(nonatomic,strong) UIView *bigBackgroundView;
@property(nonatomic,strong) UIButton *stateBtn;
@property(nonatomic,strong) UILabel *courseNameLabel;
@property(nonatomic,strong) UILabel *teacherNameLabel;
@property(nonatomic,strong) UILabel *timeLabel;
@property(nonatomic,strong) UILabel *roomNameLabel;
@property(nonatomic,strong) UILabel *roomAddrLabel;

@end


@implementation HXMianShouKeJieCell

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
-(void)setKeJieModel:(HXKeJieModel *)keJieModel{
    
    _keJieModel = keJieModel;

    ///直播状态 0待开始 1直播中 2已结束
    if (keJieModel.LiveState==0) {
        self.stateBtn.backgroundColor = COLOR_WITH_ALPHA(0x4580F8, 1);
        [self.stateBtn setTitle:@"待开始" forState:UIControlStateNormal];
    }else  if (keJieModel.LiveState==1) {
        self.stateBtn.backgroundColor = COLOR_WITH_ALPHA(0xFF8B19, 1);
        [self.stateBtn setTitle:@"上课中" forState:UIControlStateNormal];
    }else  if (keJieModel.LiveState==2) {
        self.stateBtn.backgroundColor = COLOR_WITH_ALPHA(0xABABAB, 1);
        [self.stateBtn setTitle:@"已结束" forState:UIControlStateNormal];
    }
    
    self.courseNameLabel.text = keJieModel.ClassName;
    
    self.teacherNameLabel.text = [NSString stringWithFormat:@"授课教师：%@",keJieModel.TeacherName];
    
    NSArray *weeks = @[@"星期天",@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六"];
    self.timeLabel.text = [NSString stringWithFormat:@"上课时间：%@ %@ %@",keJieModel.ClassBeginDate,weeks[keJieModel.Week],keJieModel.ClassBeginTime];
    
    self.roomNameLabel.text = [NSString stringWithFormat:@"上课教室：%@",keJieModel.RoomName];
    
    self.roomAddrLabel.text = [NSString stringWithFormat:@"教室地址：%@",keJieModel.RoomAddr];
    
}


#pragma mark - UI
-(void)createUI{
    [self.contentView addSubview:self.shadowBackgroundView];
    [self.contentView addSubview:self.bigBackgroundView];
    [self.bigBackgroundView addSubview:self.stateBtn];
    [self.bigBackgroundView addSubview:self.courseNameLabel];
    [self.bigBackgroundView addSubview:self.teacherNameLabel];
    [self.bigBackgroundView addSubview:self.timeLabel];
    [self.bigBackgroundView addSubview:self.roomNameLabel];
    [self.bigBackgroundView addSubview:self.roomAddrLabel];

   
    self.bigBackgroundView.sd_layout
    .topSpaceToView(self.contentView, 5)
    .leftSpaceToView(self.contentView,20)
    .rightSpaceToView(self.contentView, 20);
    self.bigBackgroundView .sd_cornerRadius=@8;
    
    
    self.stateBtn.sd_layout
    .topSpaceToView(self.bigBackgroundView, 8)
    .rightSpaceToView(self.bigBackgroundView, 8);
    self.stateBtn.sd_cornerRadius =@4;
    [self.stateBtn setupAutoSizeWithHorizontalPadding:8 buttonHeight:16];
    
    self.courseNameLabel.sd_layout
    .topSpaceToView(self.bigBackgroundView, 15)
    .leftSpaceToView(self.bigBackgroundView,20)
    .rightSpaceToView(self.stateBtn, 8)
    .heightIs(22);
    
    self.teacherNameLabel.sd_layout
    .topSpaceToView(self.courseNameLabel, 9)
    .leftSpaceToView(self.bigBackgroundView,20)
    .rightSpaceToView(self.bigBackgroundView, 6)
    .heightIs(17);
    
    self.timeLabel.sd_layout
    .topSpaceToView(self.teacherNameLabel, 4)
    .leftEqualToView(self.teacherNameLabel)
    .rightEqualToView(self.teacherNameLabel)
    .heightRatioToView(self.teacherNameLabel, 1);
    
    self.roomNameLabel.sd_layout
    .topSpaceToView(self.timeLabel, 4)
    .leftEqualToView(self.teacherNameLabel)
    .rightEqualToView(self.teacherNameLabel)
    .heightRatioToView(self.teacherNameLabel, 1);
    
    self.roomAddrLabel.sd_layout
    .topSpaceToView(self.roomNameLabel, 4)
    .leftEqualToView(self.teacherNameLabel)
    .rightEqualToView(self.teacherNameLabel)
    .autoHeightRatio(0);
    
    [self.roomAddrLabel setMaxNumberOfLinesToShow:2];
    
    
    //设置bigBackgroundView自适应高度
    [self.bigBackgroundView setupAutoHeightWithBottomView:self.roomAddrLabel bottomMargin:15];
    self.shadowBackgroundView.sd_layout
    .topEqualToView(self.bigBackgroundView)
    .leftEqualToView(self.bigBackgroundView)
    .rightEqualToView(self.bigBackgroundView)
    .bottomEqualToView(self.bigBackgroundView);
    self.shadowBackgroundView.layer.cornerRadius = 8;
    
    ///设置cell高度自适应
    [self setupAutoHeightWithBottomView:self.bigBackgroundView bottomMargin:5];
}


-(UIView *)shadowBackgroundView{
    if (!_shadowBackgroundView) {
        _shadowBackgroundView = [[UIView alloc] init];
        _shadowBackgroundView.backgroundColor = [UIColor whiteColor];
        _shadowBackgroundView.layer.shadowColor = COLOR_WITH_ALPHA(0x000000, 0.15).CGColor;
        _shadowBackgroundView.layer.shadowOffset = CGSizeMake(0, 2);
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

-(UIButton *)stateBtn{
    if (!_stateBtn) {
        _stateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _stateBtn.titleLabel.font = HXFont(10);
        [_stateBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    }
    return _stateBtn;
}

-(UILabel *)courseNameLabel{
    if (!_courseNameLabel) {
        _courseNameLabel = [[UILabel alloc] init];
        _courseNameLabel.textColor = COLOR_WITH_ALPHA(0x181414, 1);
        _courseNameLabel.numberOfLines = 1;
        _courseNameLabel.font = HXBoldFont(16);
        _courseNameLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    }
    return _courseNameLabel;;
}

-(UILabel *)teacherNameLabel{
    if (!_teacherNameLabel) {
        _teacherNameLabel = [[UILabel alloc] init];
        _teacherNameLabel.textColor = COLOR_WITH_ALPHA(0x9F9F9F, 1);
        _teacherNameLabel.numberOfLines = 1;
        _teacherNameLabel.font = HXFont(12);
    }
    return _teacherNameLabel;
}

-(UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = COLOR_WITH_ALPHA(0x9F9F9F, 1);
        _timeLabel.numberOfLines = 1;
        _timeLabel.font = HXFont(12);
    }
    return _timeLabel;
}

-(UILabel *)roomNameLabel{
    if (!_roomNameLabel) {
        _roomNameLabel = [[UILabel alloc] init];
        _roomNameLabel.textColor = COLOR_WITH_ALPHA(0x9F9F9F, 1);
        _roomNameLabel.numberOfLines = 1;
        _roomNameLabel.font = HXFont(12);
    }
    return _roomNameLabel;
}

-(UILabel *)roomAddrLabel{
    if (!_roomAddrLabel) {
        _roomAddrLabel = [[UILabel alloc] init];
        _roomAddrLabel.textColor = COLOR_WITH_ALPHA(0x9F9F9F, 1);
        _roomAddrLabel.numberOfLines = 0;
        _roomAddrLabel.font = HXFont(12);
        _roomAddrLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _roomAddrLabel;
}



@end
