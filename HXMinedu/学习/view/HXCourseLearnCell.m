//
//  HXCourseLearnCell.m
//  HXMinedu
//
//  Created by mac on 2021/4/6.
//

#import "HXCourseLearnCell.h"
#import <objc/runtime.h>
@interface HXCourseLearnCell ()
@property(nonatomic,strong) UIView *shadowBackgroundView;
@property(nonatomic,strong) UIView *bigBackgroundView;
@property(nonatomic,strong) UILabel *courseNameLabel;
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
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(handleType:withItem:)]) {
        [self.delegate handleType:type withItem:item];
    }
}

-(void)setCourseModel:(HXCourseModel *)courseModel{
    _courseModel = courseModel;
    self.courseNameLabel.text = HXSafeString(courseModel.courseName);
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
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.containerView addSubview:btn];
            //将数据关联按钮
            objc_setAssociatedObject(btn, &BtnWithItemKey, item, OBJC_ASSOCIATION_RETAIN);
            btn.titleLabel.font = HXFont(_kpAdaptationWidthFont(10));
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn setTitle:HXSafeString(item.ModuleName) forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(clickItem:) forControlEvents:UIControlEventTouchUpInside];
            if ([item.ModuleName isEqualToString:@"课件学习"]) {
                btn.tag = 7777;
                [btn setBackgroundColor:COLOR_WITH_ALPHA(0xFE664B, 1)];
                [btn setImage:[UIImage imageNamed:@"kejian_icon"] forState:UIControlStateNormal];
            }else if ([item.ModuleName isEqualToString:@"平时作业"]) {
                btn.tag = 8888;
                [btn setBackgroundColor:COLOR_WITH_ALPHA(0xFEC44B, 1)];
                [btn setImage:[UIImage imageNamed:@"pingshi_icon"] forState:UIControlStateNormal];
            }else{
                btn.tag = 9999;
                [btn setBackgroundColor:COLOR_WITH_ALPHA(0x4B74FE, 1)];
                [btn setImage:[UIImage imageNamed:@"qimo_icon"] forState:UIControlStateNormal];
            }
            
            btn.sd_layout
            .topEqualToView(self.containerView)
            .leftSpaceToView(self.containerView, _kpw(23)+i*(_kpw(80)+_kpw(23)))
            .widthIs(_kpw(80))
            .heightIs(30);
            btn.sd_cornerRadiusFromHeightRatio = @0.5;
            
            btn.imageView.sd_layout
            .centerYEqualToView(btn)
            .leftSpaceToView(btn, 10)
            .widthIs(12)
            .heightEqualToWidth();

            btn.titleLabel.sd_layout
            .centerYEqualToView(btn)
            .leftSpaceToView(btn.imageView, 5)
            .rightSpaceToView(btn, 10)
            .heightRatioToView(btn, 1);
        }
    }
    
}


#pragma mark - UI
-(void)createUI{
    [self.contentView addSubview:self.shadowBackgroundView];
    [self.contentView addSubview:self.bigBackgroundView];
    [self.bigBackgroundView addSubview:self.courseNameLabel];
    [self.bigBackgroundView addSubview:self.containerView];
   

    
    self.bigBackgroundView.sd_layout
    .leftSpaceToView(self.contentView, _kpw(23))
    .topSpaceToView(self.contentView, 7)
    .rightSpaceToView(self.contentView, _kpw(23));
    self.bigBackgroundView.sd_cornerRadius = @5;
    
    self.courseNameLabel.sd_layout
    .leftSpaceToView(self.bigBackgroundView, _kpw(28))
    .rightSpaceToView(self.bigBackgroundView, _kpw(28))
    .topSpaceToView(self.bigBackgroundView, 18)
    .heightIs(22);
    
    self.containerView.sd_layout
    .topSpaceToView(self.courseNameLabel, 16)
    .leftEqualToView(self.bigBackgroundView)
    .rightEqualToView(self.bigBackgroundView)
    .heightIs(46);

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


-(UILabel *)courseNameLabel{
    if (!_courseNameLabel) {
        _courseNameLabel = [[UILabel alloc] init];
        _courseNameLabel.textColor = COLOR_WITH_ALPHA(0x4BA4FE, 1);
        _courseNameLabel.font = [UIFont boldSystemFontOfSize:16];
        
    }
    return _courseNameLabel;;
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
