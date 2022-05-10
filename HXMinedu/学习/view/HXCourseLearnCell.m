//
//  HXCourseLearnCell.m
//  HXMinedu
//
//  Created by mac on 2021/4/6.
//

#import "HXCourseLearnCell.h"
#import <objc/runtime.h>
#import "SDWebImage.h"


@interface HXCourseLearnCell ()
@property(nonatomic,strong) UIView *shadowBackgroundView;
@property(nonatomic,strong) UIView *bigBackgroundView;
@property(nonatomic,strong) UIImageView *courseImageView;
@property(nonatomic,strong) UILabel *courseNameLabel;

@property(nonatomic,strong) UIImageView *hisVersionImageView;

@property(nonatomic,strong) UIImageView *courseTypeImageView;
@property(nonatomic,strong) UILabel *courseTypeLabel;

@property(nonatomic,strong) UIView *containerView;


@end

const NSString * BtnWithItemKey = @"BtnWithItemKey";

@implementation HXCourseLearnCell

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

#pragma mark - Event

-(void)clickItem:(UIButton *)sender{
    NSInteger tag = sender.tag;
    HXModelItem *item = objc_getAssociatedObject(sender, &BtnWithItemKey);
    HXClickType type = HXNoClickType;
    if (tag == 7777) {
        type = HXKeJianXueXiClickType;
    }else if(tag == 8888){
        type = HXPingShiZuoYeClickType;
    }else if(tag == 9999){
        type = HXQiMoKaoShiClickType;
    }else if(tag == 1010){
        type = HXLiNianZhenTiClickType;
    }else if(tag == 1011){
        type = HXZiLiaoClickType;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(handleType:withItem:)]) {
        [self.delegate handleType:type withItem:item];
    }
}

-(void)setCourseModel:(HXCourseModel *)courseModel{
    _courseModel = courseModel;
    [self.courseImageView sd_setImageWithURL:[NSURL URLWithString:[HXCommonUtil stringEncoding:courseModel.imageURL]] placeholderImage:nil];
    self.courseNameLabel.text = HXSafeString(courseModel.courseName);
    
    //5001-必修 5002-选修 以外其它
    if (courseModel.courseType_id == 5001) {
        self.courseTypeImageView.image = [UIImage imageNamed:@"bixiuke"];
        self.courseTypeLabel.text = @"必修课";
    }else if (courseModel.courseType_id == 5002) {
        self.courseTypeImageView.image = [UIImage imageNamed:@"xuanxiuke"];
        self.courseTypeLabel.text = @"选修课";
    }else{
        self.courseTypeImageView.image = [UIImage imageNamed:@"qitake"];
        self.courseTypeLabel.text = @"其它";
    }
    
   // 1为有历史版本  0为没有历史版本
    self.hisVersionImageView.hidden = (courseModel.isHisVersion==1?NO:YES);
    
    [self.containerView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //移除关联对象
        objc_removeAssociatedObjects(obj);
        [obj removeFromSuperview];
        obj = nil;
    }];
    if (courseModel.modules.count == 0) {
        self.containerView.sd_layout.heightIs(0);
    }else{
        self.containerView.sd_layout.heightIs(46);
        
        
        for (int i= 0; i<courseModel.modules.count; i++) {
            
            HXModelItem *item = courseModel.modules[i];
            item.StemCode = courseModel.StemCode;
            item.courseName = courseModel.courseName;
            item.course_id = courseModel.course_id;
            item.studentCourseID = courseModel.studentCourseID;
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.containerView addSubview:btn];
            
            //将数据关联按钮
            objc_setAssociatedObject(btn, &BtnWithItemKey, item, OBJC_ASSOCIATION_RETAIN);
            btn.titleLabel.font = HXFont(13);
            [btn setTitleColor:COLOR_WITH_ALPHA(0x5699FF, 1) forState:UIControlStateNormal];
            [btn setBackgroundColor:COLOR_WITH_ALPHA(0xEFF7FF, 1)];
            [btn addTarget:self action:@selector(clickItem:) forControlEvents:UIControlEventTouchUpInside];
            if ([item.ExamCourseType isEqualToString:@"1"]) {//课件学习
                [btn setTitle:@"视频" forState:UIControlStateNormal];
                btn.tag = 7777;
                [btn setImage:[UIImage imageNamed:@"kejian_icon"] forState:UIControlStateNormal];
            }else if ([item.ExamCourseType isEqualToString:@"2"]) {//平时作业
                [btn setTitle:@"作业" forState:UIControlStateNormal];
                btn.tag = 8888;
                [btn setImage:[UIImage imageNamed:@"pingshi_icon"]forState:UIControlStateNormal];
            }else if ([item.ExamCourseType isEqualToString:@"3"]) {//期末考试
                [btn setTitle:@"模考" forState:UIControlStateNormal];
                btn.tag = 9999;
                [btn setImage:[UIImage imageNamed:@"qimo_icon"] forState:UIControlStateNormal];
            }else if ([item.ExamCourseType isEqualToString:@"4"]) {//历年真题
                [btn setTitle:@"真题" forState:UIControlStateNormal];
                btn.tag = 1010;
                [btn setImage:[UIImage imageNamed:@"zhenti_icon"] forState:UIControlStateNormal];
            }else if ([item.ExamCourseType isEqualToString:@"5"]) {//电子资料
                [btn setTitle:@"资料" forState:UIControlStateNormal];
                btn.tag = 1011;
                [btn setImage:[UIImage imageNamed:@"dianziziliao_icon"] forState:UIControlStateNormal];
            }
            
            
            btn.sd_layout
            .topEqualToView(self.containerView)
            .leftSpaceToView(self.containerView, 20+i*(60+_kpw(10)))
            .widthIs(60)
            .heightIs(25);
            btn.sd_cornerRadius = @2;
            
            btn.imageView.sd_layout
            .centerYEqualToView(btn)
            .leftSpaceToView(btn, 5)
            .widthIs(13)
            .heightEqualToWidth();

            btn.titleLabel.sd_layout
            .centerYEqualToView(btn)
            .leftSpaceToView(btn.imageView, 5)
            .rightSpaceToView(btn, 2)
            .heightRatioToView(btn, 1);
        }
    }
}


#pragma mark - UI
-(void)createUI{
    [self.contentView addSubview:self.shadowBackgroundView];
    [self.contentView addSubview:self.bigBackgroundView];
    [self.bigBackgroundView addSubview:self.courseImageView];
    [self.bigBackgroundView addSubview:self.courseTypeImageView];
    [self.courseTypeImageView addSubview:self.courseTypeLabel];
    [self.bigBackgroundView addSubview:self.courseNameLabel];
    [self.bigBackgroundView addSubview:self.hisVersionImageView];
//    [self.bigBackgroundView addSubview:self.crownImageView];
//    [self.bigBackgroundView addSubview:self.rectangleImageView];
//    [self.rectangleImageView addSubview:self.jingpinLabel];
    [self.bigBackgroundView addSubview:self.containerView];
   

    
    self.bigBackgroundView.sd_layout
    .leftSpaceToView(self.contentView, _kpw(10))
    .topSpaceToView(self.contentView, 7)
    .rightSpaceToView(self.contentView, _kpw(10));
    self.bigBackgroundView.sd_cornerRadius = @5;
    
    self.courseImageView.sd_layout
    .topSpaceToView(self.bigBackgroundView, 20)
    .leftSpaceToView(self.bigBackgroundView, 20)
    .widthIs(_kpw(130))
    .heightIs(_kpw(83));
    self.courseImageView.sd_cornerRadius = @4;
    
    self.courseTypeImageView.sd_layout
    .topEqualToView(self.bigBackgroundView)
    .rightEqualToView(self.bigBackgroundView)
    .widthIs(60)
    .heightIs(40);
    
    
    
    self.courseNameLabel.sd_layout
    .topEqualToView(self.courseImageView).offset(8)
    .leftSpaceToView(self.courseImageView, 24)
    .autoHeightRatio(0);
    [self.courseNameLabel setSingleLineAutoResizeWithMaxWidth:_kpw(105)];
    [self.courseNameLabel setMaxNumberOfLinesToShow:2];
    
    self.hisVersionImageView.sd_layout
    .topEqualToView(self.courseImageView).offset(8)
    .leftSpaceToView(self.courseNameLabel, 5)
    .widthIs(22)
    .heightEqualToWidth();
    
    self.containerView.sd_layout
    .topSpaceToView(self.courseImageView, 15)
    .leftEqualToView(self.bigBackgroundView)
    .rightEqualToView(self.bigBackgroundView)
    .heightIs(40);

    //设置bigBackgroundView自适应高度
    [self.bigBackgroundView setupAutoHeightWithBottomView:self.containerView bottomMargin:0];
    self.shadowBackgroundView.sd_layout
    .topEqualToView(self.bigBackgroundView)
    .leftEqualToView(self.bigBackgroundView)
    .rightEqualToView(self.bigBackgroundView)
    .bottomEqualToView(self.bigBackgroundView);
    self.shadowBackgroundView.layer.cornerRadius = 5;
    
    ///设置cell高度自适应
    [self setupAutoHeightWithBottomView:self.bigBackgroundView bottomMargin:7];
}


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

-(UIImageView *)courseImageView{
    if (!_courseImageView) {
        _courseImageView = [[UIImageView alloc] init];
        _courseImageView.backgroundColor = COLOR_WITH_ALPHA(0xEFEFEF, 1);
        _courseImageView.clipsToBounds = YES;
        _courseImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _courseImageView;;
}

-(UIImageView *)courseTypeImageView{
    if (!_courseTypeImageView) {
        _courseTypeImageView = [[UIImageView alloc] init];
        
    }
    return _courseTypeImageView;
}

-(UILabel *)courseTypeLabel{
    if (!_courseTypeLabel) {
        _courseTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 16,60, 20)];
        _courseTypeLabel.textColor = COLOR_WITH_ALPHA(0xffffff, 1);
        _courseTypeLabel.textAlignment = NSTextAlignmentCenter;
        _courseTypeLabel.font = HXFont(12);
        _courseTypeLabel.backgroundColor = [UIColor clearColor];
        _courseTypeLabel.transform = CGAffineTransformMakeRotation(M_PI/5.45);
        _courseTypeLabel.transform = CGAffineTransformTranslate(_courseTypeLabel.transform ,0, -14);
        
    }
    return _courseTypeLabel;
}

-(UILabel *)courseNameLabel{
    if (!_courseNameLabel) {
        _courseNameLabel = [[UILabel alloc] init];
        _courseNameLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        _courseNameLabel.numberOfLines = 2;
        _courseNameLabel.font = HXFont(16);
        
    }
    return _courseNameLabel;;
}


-(UIImageView *)hisVersionImageView{
    if (!_hisVersionImageView) {
        _hisVersionImageView = [[UIImageView alloc] init];
        _hisVersionImageView.image = [UIImage imageNamed:@"hisversion"];
        _hisVersionImageView.hidden = YES;
    }
    return _hisVersionImageView;
}



-(UIView *)containerView{
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = [UIColor clearColor];
        _containerView.clipsToBounds = YES;
    }
    return _containerView;
}


@end
