//
//  HXZiZhuJiaoFeiCell.m
//  HXMinedu
//
//  Created by mac on 2021/12/8.
//

#import "HXZiZhuJiaoFeiCell.h"
#import <objc/runtime.h>

@interface HXZiZhuJiaoFeiCell ()
@property(nonatomic,strong) UIImageView *bigTopGroundImageView;

@property(nonatomic,strong) UIView *topContainerView;
@property(nonatomic,strong) UILabel *paymentNameLabel;//缴费类别
@property(nonatomic,strong) UILabel *yingjiaoLabel;//应缴金额
@property(nonatomic,strong) UILabel *shijiaoLabel;//累计实缴金额
@property(nonatomic,strong) UIImageView *typeImageView;//标准
@property(nonatomic,strong) UILabel *typeLabel;
@property(nonatomic,strong) UIImageView *dashLine1;//分割线

@property(nonatomic,strong) UIView *middleContainerView;//记录每一项

@property(nonatomic,strong) UIImageView *smallBottomImageView;//分割线
@property(nonatomic,strong) UIView *bottomContainerView;
@property(nonatomic,strong) UILabel *xiaojiLabel;//小计
@property(nonatomic,strong) UILabel *yingjiaoToatalMoneyLabel;//应缴金额总和
@property(nonatomic,strong) UILabel *shijiaoToatalMoneyLabel;//实缴金额总和



@end



const NSString *YingJiaoFeeWithItemKey = @"yingJiaoFeeWithItemKey";
           
@implementation HXZiZhuJiaoFeiCell

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
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        [self createUI];
    }
    return self;
}

#pragma mark - Event
-(void)selectItem:(UIControl *)sender{
    UIControl *item = sender;
    //获取绑定的关联对象
    HXPaymentDetailModel *model = (HXPaymentDetailModel *)objc_getAssociatedObject(sender, &YingJiaoFeeWithItemKey);
    sender.selected = !sender.selected;
    model.isSeleted = sender.selected;
    UIImageView *selectImageView = (UIImageView*)[item viewWithTag:66666];
    selectImageView.image = [UIImage imageNamed:(sender.selected?@"item_select":@"item_unselect")];
}

#pragma mark - 赋值刷新
-(void)setPaymentDetailsInfoModel:(HXPaymentDetailsInfoModel *)paymentDetailsInfoModel{
  
    _paymentDetailsInfoModel = paymentDetailsInfoModel;
    //1-标准 2-补录 3-报考
    if (paymentDetailsInfoModel.ftype == 1) {
        self.typeImageView.image = [UIImage imageNamed:@"biaozhun"];
    }else if (paymentDetailsInfoModel.ftype == 2) {
        self.typeImageView.image = [UIImage imageNamed:@"bulu"];
    }else if (paymentDetailsInfoModel.ftype == 3) {
        self.typeImageView.image = [UIImage imageNamed:@"baokao"];
    }else{
        self.typeImageView.image = [UIImage imageNamed:@"qitaleixing"];
    }
    self.typeLabel.text = HXSafeString(paymentDetailsInfoModel.ftypeName);
    self.yingjiaoToatalMoneyLabel.text = [NSString stringWithFormat:@"¥%.2f",paymentDetailsInfoModel.feeSubtotal];
    self.shijiaoToatalMoneyLabel.text = [NSString stringWithFormat:@"¥%.2f",paymentDetailsInfoModel.payMoneySubtotal];
   
    
    [self.middleContainerView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //移除关联对象
        objc_removeAssociatedObjects(obj);
        [obj removeFromSuperview];
        obj = nil;
    }];
    
   
    NSMutableArray *list = [NSMutableArray array];
    [list addObjectsFromArray:paymentDetailsInfoModel.payableDetailsInfoList];
    
    ///创建条目
    for (int i = 0; i < list.count; i++) {
        HXPaymentDetailModel *model =list[i];
        UIControl *itemView = [[UIControl alloc] init];
        itemView.backgroundColor = [UIColor clearColor];
        [itemView addTarget:self action:@selector(selectItem:) forControlEvents:UIControlEventTouchUpInside];
        //将数据关联按钮
        objc_setAssociatedObject(itemView, &YingJiaoFeeWithItemKey, model, OBJC_ASSOCIATION_RETAIN);
        //IsFee勾选
    
        [self.middleContainerView addSubview:itemView];
        itemView.sd_layout
        .topSpaceToView(self.middleContainerView, i*40)
        .leftEqualToView(self.middleContainerView)
        .rightEqualToView(self.middleContainerView)
        .heightIs(40);
        
        UIImageView *selectImageView = [[UIImageView alloc] init];
        selectImageView.userInteractionEnabled = YES;
        selectImageView.tag = 66666;
        selectImageView.image = [UIImage imageNamed:@"item_unselect"];
        [itemView addSubview:selectImageView];
        
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        nameLabel.font = HXFont(12);
        nameLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        nameLabel.text = HXSafeString( model.feeType_Name);
        [itemView addSubview:nameLabel];
        
        UILabel *yinjiaolabel = [[UILabel alloc] init];
        yinjiaolabel.textAlignment = NSTextAlignmentCenter;
        yinjiaolabel.font = HXFont(12);
        yinjiaolabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        yinjiaolabel.text = [NSString stringWithFormat:@"¥%.2f",model.fee];
        [itemView addSubview:yinjiaolabel];
        
        UILabel *shijiaolabel = [[UILabel alloc] init];
        shijiaolabel.textAlignment = NSTextAlignmentCenter;
        shijiaolabel.font = HXFont(12);
        shijiaolabel.text = [NSString stringWithFormat:@"¥%.2f",model.payMoney];
        [itemView addSubview:shijiaolabel];
        ///类型 1-标准 2-补录 3-报考
        if (paymentDetailsInfoModel.ftype == 1) {
            shijiaolabel.textColor = COLOR_WITH_ALPHA(0x5699FF, 1);
        }else if (paymentDetailsInfoModel.ftype == 2) {
            shijiaolabel.textColor = COLOR_WITH_ALPHA(0x4DC656, 1);
        }else if (paymentDetailsInfoModel.ftype == 3) {
            shijiaolabel.textColor = COLOR_WITH_ALPHA(0xfe664b, 1);
        }else{
            shijiaolabel.textColor = COLOR_WITH_ALPHA(0xfece4b, 1);
        }
        //实缴小于应缴才能继续勾选
        if (model.IsFee) {
            selectImageView.hidden = NO;
            itemView.userInteractionEnabled = YES;
        }else{
            selectImageView.hidden = YES;
            itemView.userInteractionEnabled = NO;
        }
        
        selectImageView.sd_layout
        .centerYEqualToView(itemView)
        .leftSpaceToView(itemView, 15)
        .heightIs(15)
        .widthEqualToHeight();
        
        nameLabel.sd_layout
        .centerYEqualToView(itemView)
        .leftSpaceToView(selectImageView, 5)
        .heightIs(17)
        .widthRatioToView(itemView, 0.25);
        
        yinjiaolabel.sd_layout
        .centerYEqualToView(itemView)
        .leftSpaceToView(nameLabel, 5)
        .heightIs(17)
        .widthRatioToView(itemView, 0.3);
        
        shijiaolabel.sd_layout
        .centerYEqualToView(itemView)
        .leftSpaceToView(yinjiaolabel, 5)
        .heightIs(17)
        .widthRatioToView(itemView, 0.3);
    }
    
    self.middleContainerView.sd_layout.heightIs(40*list.count);
    [self.middleContainerView updateLayout];
    
   
}

#pragma mark - UI
-(void)createUI{
    [self.contentView addSubview:self.bigTopGroundImageView];
    
    [self.bigTopGroundImageView addSubview:self.topContainerView];
    [self.topContainerView addSubview:self.paymentNameLabel];
    [self.topContainerView addSubview:self.yingjiaoLabel];
    [self.topContainerView addSubview:self.shijiaoLabel];
    [self.topContainerView addSubview:self.typeImageView];
    [self.typeImageView addSubview:self.typeLabel];
    [self.topContainerView addSubview:self.dashLine1];
    
    [self.bigTopGroundImageView addSubview:self.middleContainerView];
    
    [self.contentView addSubview:self.smallBottomImageView];
    [self.smallBottomImageView addSubview:self.bottomContainerView];
    [self.bottomContainerView addSubview:self.xiaojiLabel];
    [self.bottomContainerView addSubview:self.yingjiaoToatalMoneyLabel];
    [self.bottomContainerView addSubview:self.shijiaoToatalMoneyLabel];
    
    
    self.bigTopGroundImageView.sd_layout
    .topSpaceToView(self.contentView, 0)
    .leftSpaceToView(self.contentView, 10)
    .rightSpaceToView(self.contentView, 10);
    
    self.topContainerView.sd_layout
    .topEqualToView(self.bigTopGroundImageView)
    .leftEqualToView(self.bigTopGroundImageView)
    .rightEqualToView(self.bigTopGroundImageView)
    .heightIs(45);
    
    self.paymentNameLabel.sd_layout
    .topSpaceToView(self.topContainerView, 18)
    .leftSpaceToView(self.topContainerView, 5)
    .heightIs(17)
    .widthRatioToView(self.topContainerView, 0.3);
    
    self.yingjiaoLabel.sd_layout
    .centerYEqualToView(self.paymentNameLabel)
    .leftSpaceToView(self.paymentNameLabel, 5)
    .heightIs(17)
    .widthRatioToView(self.topContainerView, 0.3);
    
    self.shijiaoLabel.sd_layout
    .centerYEqualToView(self.paymentNameLabel)
    .leftSpaceToView(self.yingjiaoLabel, 5)
    .heightIs(17)
    .widthRatioToView(self.topContainerView, 0.3);
    
    self.typeImageView.sd_layout
    .topEqualToView(self.topContainerView)
    .rightEqualToView(self.topContainerView)
    .widthIs(60)
    .heightIs(36);
    
    self.dashLine1.sd_layout
    .bottomSpaceToView(self.topContainerView, 0)
    .leftSpaceToView(self.topContainerView, 14)
    .rightSpaceToView(self.topContainerView, 14)
    .heightIs(1);
    
    self.middleContainerView.sd_layout
    .topSpaceToView(self.topContainerView, 0)
    .leftEqualToView(self.bigTopGroundImageView)
    .rightEqualToView(self.bigTopGroundImageView)
    .heightIs(0);
    
    [self.bigTopGroundImageView setupAutoHeightWithBottomView:self.middleContainerView bottomMargin:0];
    
    
    self.smallBottomImageView.sd_layout
    .topSpaceToView(self.bigTopGroundImageView, 0)
    .leftSpaceToView(self.contentView, 10)
    .rightSpaceToView(self.contentView, 10)
    .heightIs(45);
    
    self.bottomContainerView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    
    
    self.xiaojiLabel.sd_layout
    .centerYEqualToView(self.bottomContainerView)
    .leftSpaceToView(self.bottomContainerView, 5)
    .heightIs(17)
    .widthRatioToView(self.bottomContainerView, 0.3);
    
    self.yingjiaoToatalMoneyLabel.sd_layout
    .centerYEqualToView(self.bottomContainerView)
    .leftSpaceToView(self.xiaojiLabel, 5)
    .heightIs(20)
    .widthRatioToView(self.bottomContainerView, 0.3);
    
    self.shijiaoToatalMoneyLabel.sd_layout
    .centerYEqualToView(self.bottomContainerView)
    .leftSpaceToView(self.yingjiaoToatalMoneyLabel, 5)
    .heightIs(20)
    .widthRatioToView(self.bottomContainerView, 0.3);
    

    ///设置cell高度自适应
    [self setupAutoHeightWithBottomView:self.smallBottomImageView bottomMargin:0];
   
}

#pragma mark - lazyLoad

-(UIImageView *)bigTopGroundImageView{
    if (!_bigTopGroundImageView) {
        _bigTopGroundImageView = [[UIImageView alloc] init];
        _bigTopGroundImageView.userInteractionEnabled = YES;
        _bigTopGroundImageView.clipsToBounds = YES;
        _bigTopGroundImageView.image = [UIImage resizedImageWithName:@"bigtop"];
    }
    return _bigTopGroundImageView;
}

-(UIView *)topContainerView{
    if (!_topContainerView) {
        _topContainerView = [[UIView alloc] init];
        _topContainerView.backgroundColor = [UIColor clearColor];
        _topContainerView.clipsToBounds = YES;
    }
    return _topContainerView;
}

-(UILabel *)paymentNameLabel{
    if (!_paymentNameLabel) {
        _paymentNameLabel = [[UILabel alloc] init];
        _paymentNameLabel.textAlignment = NSTextAlignmentCenter;
        _paymentNameLabel.font = HXFont(12);
        _paymentNameLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        _paymentNameLabel.text = @"缴费类别";
    }
    return _paymentNameLabel;
}

-(UILabel *)yingjiaoLabel{
    if (!_yingjiaoLabel) {
        _yingjiaoLabel = [[UILabel alloc] init];
        _yingjiaoLabel.textAlignment = NSTextAlignmentCenter;
        _yingjiaoLabel.font = HXFont(12);
        _yingjiaoLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        _yingjiaoLabel.text = @"应缴金额";
    }
    return _yingjiaoLabel;
}

-(UILabel *)shijiaoLabel{
    if (!_shijiaoLabel) {
        _shijiaoLabel = [[UILabel alloc] init];
        _shijiaoLabel.textAlignment = NSTextAlignmentCenter;
        _shijiaoLabel.font = HXFont(12);
        _shijiaoLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        _shijiaoLabel.text = @"累计实缴金额";
    }
    return _shijiaoLabel;
}

-(UIImageView *)typeImageView{
    if (!_typeImageView) {
        _typeImageView = [[UIImageView alloc] init];
        _typeImageView.image = [UIImage imageNamed:@"biaozhun"];
    }
    return _typeImageView;
}

-(UILabel *)typeLabel{
    if (!_typeLabel) {
        _typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 16,60, 20)];
        _typeLabel.textColor = COLOR_WITH_ALPHA(0xffffff, 1);
        _typeLabel.textAlignment = NSTextAlignmentCenter;
        _typeLabel.font = HXFont(12);
        _typeLabel.backgroundColor = [UIColor clearColor];
        _typeLabel.transform = CGAffineTransformMakeRotation(M_PI/5.45);
        _typeLabel.transform = CGAffineTransformTranslate(_typeLabel.transform ,0, -16);
        _typeLabel.text = @"标准";
    }
    return _typeLabel;
}

-(UIImageView *)dashLine1{
    if (!_dashLine1) {
        _dashLine1 = [[UIImageView alloc] init];
        _dashLine1.image = [UIImage imageNamed:@"short_dashline"];
    }
    return _dashLine1;
}



-(UIView *)middleContainerView{
    if (!_middleContainerView) {
        _middleContainerView = [[UIView alloc] init];
        _middleContainerView.backgroundColor = [UIColor clearColor];
        _middleContainerView.clipsToBounds = YES;
    }
    return _middleContainerView;
}

-(UIImageView *)smallBottomImageView{
    if (!_smallBottomImageView) {
        _smallBottomImageView = [[UIImageView alloc] init];
        _smallBottomImageView.image = [UIImage imageNamed:@"smallbottom"];
        _smallBottomImageView.clipsToBounds = YES;
        _smallBottomImageView.backgroundColor = [UIColor clearColor];
    }
    return _smallBottomImageView;
}

-(UIView *)bottomContainerView{
    if (!_bottomContainerView) {
        _bottomContainerView = [[UIView alloc] init];
        _bottomContainerView.backgroundColor = [UIColor clearColor];
        _bottomContainerView.clipsToBounds = YES;
    }
    return _bottomContainerView;
}


-(UILabel *)xiaojiLabel{
    if (!_xiaojiLabel) {
        _xiaojiLabel = [[UILabel alloc] init];
        _xiaojiLabel.textAlignment = NSTextAlignmentCenter;
        _xiaojiLabel.font = HXFont(12);
        _xiaojiLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        _xiaojiLabel.text = @"小计：";
    }
    return _xiaojiLabel;
}

-(UILabel *)yingjiaoToatalMoneyLabel{
    if (!_yingjiaoToatalMoneyLabel) {
        _yingjiaoToatalMoneyLabel = [[UILabel alloc] init];
        _yingjiaoToatalMoneyLabel.textAlignment = NSTextAlignmentCenter;
        _yingjiaoToatalMoneyLabel.font = HXBoldFont(14);
        _yingjiaoToatalMoneyLabel.textColor = COLOR_WITH_ALPHA(0xFE664B, 1);
    }
    return _yingjiaoToatalMoneyLabel;
}

-(UILabel *)shijiaoToatalMoneyLabel{
    if (!_shijiaoToatalMoneyLabel) {
        _shijiaoToatalMoneyLabel = [[UILabel alloc] init];
        _shijiaoToatalMoneyLabel.textAlignment = NSTextAlignmentCenter;
        _shijiaoToatalMoneyLabel.font = HXBoldFont(14);
        _shijiaoToatalMoneyLabel.textColor = COLOR_WITH_ALPHA(0xFE664B, 1);
    }
    return _shijiaoToatalMoneyLabel;
}




@end

