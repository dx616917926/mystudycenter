//
//  HXFeeEditItemCell.m
//  HXMinedu
//
//  Created by mac on 2021/12/9.
//

#import "HXFeeEditItemCell.h"
#import <objc/runtime.h>

@interface HXFeeEditItemCell ()
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
@property(nonatomic,strong) UILabel *yingjiaoXiaoJiLabel;//本次应缴小计：
@property(nonatomic,strong) UILabel *yingjiaoXiaoJiMoneyLabel;



@end

const NSString *YingJiaoFeeWithTextFiledKey = @"yingJiaoFeeWithTextFiledKey";
           
@implementation HXFeeEditItemCell

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

-(void)dealloc{
    [HXNotificationCenter removeObserver:self];
}


#pragma mark - 监听金额输入
-(void)textFieldTextDidChangeNotification:(NSNotification *)notification{
    UITextField *textField = notification.object;
    //获取绑定的关联对象
    HXPaymentDetailModel *model = (HXPaymentDetailModel *)objc_getAssociatedObject(textField, &YingJiaoFeeWithTextFiledKey);
    model.payMoney = [textField.text floatValue];
    //计算本次应缴小计：
    __block float feeSubtotal = 0.0;
    [self.paymentDetailsInfoModel.payableDetailsInfoList enumerateObjectsUsingBlock:^(HXPaymentDetailModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        feeSubtotal += obj.payMoney;
    }];
    self.paymentDetailsInfoModel.feeSubtotal = feeSubtotal;
    self.yingjiaoXiaoJiMoneyLabel.text = [NSString stringWithFormat:@"¥%.2f",feeSubtotal];
    //修改自助缴费本次实缴金额通知
    [HXNotificationCenter postNotificationName:kChangeZiZhuShiJiaoFeeNotification object:nil];
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
    self.yingjiaoXiaoJiMoneyLabel.text = [NSString stringWithFormat:@"¥%.2f",paymentDetailsInfoModel.feeSubtotal];
   
    
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
        
        
        [self.middleContainerView addSubview:itemView];
        itemView.sd_layout
        .topSpaceToView(self.middleContainerView, i*40)
        .leftEqualToView(self.middleContainerView)
        .rightEqualToView(self.middleContainerView)
        .heightIs(40);
        
        
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.textAlignment = NSTextAlignmentCenter;
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
        
        UITextField *shijiaoTextField = [[UITextField alloc] init];
        shijiaoTextField.keyboardType = UIKeyboardTypeDecimalPad;
        shijiaoTextField.textColor = COLOR_WITH_ALPHA(0x5699FF, 1);
        shijiaoTextField.layer.borderWidth = 1;
        shijiaoTextField.layer.borderColor = COLOR_WITH_ALPHA(0x5699FF, 1).CGColor;
        shijiaoTextField.textAlignment = NSTextAlignmentLeft;
        shijiaoTextField.font = HXFont(13);
        shijiaoTextField.text = [NSString stringWithFormat:@"%.2f",model.payMoney];
        UIView *lefteView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 30)];
        shijiaoTextField.leftView = lefteView;
        shijiaoTextField.leftViewMode = UITextFieldViewModeAlways;
        [itemView addSubview:shijiaoTextField];
        //将数据关联输入框
        objc_setAssociatedObject(shijiaoTextField, &YingJiaoFeeWithTextFiledKey, model, OBJC_ASSOCIATION_RETAIN);
        //监听本次实缴金额变化
        [HXNotificationCenter addObserver:self selector:@selector(textFieldTextDidChangeNotification:) name:UITextFieldTextDidChangeNotification object:shijiaoTextField];
        

        nameLabel.sd_layout
        .centerYEqualToView(itemView)
        .leftSpaceToView(itemView, 0)
        .heightIs(17)
        .widthRatioToView(itemView, 0.3);
        
        yinjiaolabel.sd_layout
        .centerYEqualToView(itemView)
        .leftSpaceToView(nameLabel, 5)
        .heightIs(17)
        .widthRatioToView(itemView, 0.35);
        
        shijiaoTextField.sd_layout
        .centerYEqualToView(itemView)
        .leftSpaceToView(yinjiaolabel, 5)
        .heightIs(30)
        .widthRatioToView(itemView, 0.25);
        shijiaoTextField.sd_cornerRadius = @4;
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
    [self.bottomContainerView addSubview:self.yingjiaoXiaoJiLabel];
    [self.bottomContainerView addSubview:self.yingjiaoXiaoJiMoneyLabel];
    
    
    
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
    
    self.yingjiaoXiaoJiLabel.sd_layout
    .centerYEqualToView(self.bottomContainerView)
    .centerXEqualToView(self.bottomContainerView).offset(50)
    .heightIs(20);
    [self.yingjiaoXiaoJiLabel setSingleLineAutoResizeWithMaxWidth:120];
    
    self.yingjiaoXiaoJiMoneyLabel.sd_layout
    .centerYEqualToView(self.bottomContainerView)
    .leftSpaceToView(self.yingjiaoXiaoJiLabel, 0)
    .rightSpaceToView(self.bottomContainerView, 20)
    .heightIs(20);
    

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
        _shijiaoLabel.text = @"本次实缴金额";
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


-(UILabel *)yingjiaoXiaoJiLabel{
    if (!_yingjiaoXiaoJiLabel) {
        _yingjiaoXiaoJiLabel = [[UILabel alloc] init];
        _yingjiaoXiaoJiLabel.textAlignment = NSTextAlignmentLeft;
        _yingjiaoXiaoJiLabel.font = HXFont(12);
        _yingjiaoXiaoJiLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        _yingjiaoXiaoJiLabel.text = @"本次应缴小计：";
    }
    return _yingjiaoXiaoJiLabel;
}

-(UILabel *)yingjiaoXiaoJiMoneyLabel{
    if (!_yingjiaoXiaoJiMoneyLabel) {
        _yingjiaoXiaoJiMoneyLabel = [[UILabel alloc] init];
        _yingjiaoXiaoJiMoneyLabel.textAlignment = NSTextAlignmentLeft;
        _yingjiaoXiaoJiMoneyLabel.font = HXFont(12);
        _yingjiaoXiaoJiMoneyLabel.textColor = COLOR_WITH_ALPHA(0xFE664B, 1);
    }
    return _yingjiaoXiaoJiMoneyLabel;
}




@end

