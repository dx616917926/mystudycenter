//
//  HXRefundMethodCell.m
//  HXMinedu
//
//  Created by mac on 2021/6/7.
//

#import "HXRefundMethodCell.h"
#import "YBPopupMenu.h"
#import "SDWebImage.h"

@interface HXRefundMethodCell ()<YBPopupMenuDelegate> 
@property(nonatomic,nonnull) UILabel *refundMethodLabel;//退费方式：
@property(nonatomic,nonnull) UIButton *refundMethodBtn;

@property(nonatomic,nonnull) UIView *qRCodeContainerView;///二维码
@property(nonatomic,nonnull) UILabel *refundQRCodeLabel;//退费二维码：
@property(nonatomic,nonnull) UIImageView *refundQRCodeImageView;
@property(nonatomic,nonnull) UIButton *uploadBtn;

@property(nonatomic,nonnull) UIView *unionPayContainerView;///银联
@property(nonatomic,nonnull) UILabel *nameLabel;//开户名：
@property(nonatomic,nonnull) UITextField *nameTextField;
@property(nonatomic,nonnull) UILabel *bankLabel;//开户行：
@property(nonatomic,nonnull) UITextField *bankTextField;
@property(nonatomic,nonnull) UILabel *accountNumLabel;//收款账户：
@property(nonatomic,nonnull) UITextField *accountNumTextField;

@property(nonatomic,strong) NSArray *titles;


@end

@implementation HXRefundMethodCell

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
-(void)showMenu:(UIButton *)sender{
    [YBPopupMenu showRelyOnView:sender titles:self.titles icons:nil menuWidth:76 otherSettings:^(YBPopupMenu *popupMenu) {
        popupMenu.itemHeight = 35;
        popupMenu.delegate = self;
        popupMenu.isShowShadow = NO;
    }];
    
}

-(void)tapImageView:(UITapGestureRecognizer *)ges{
    if (self.delegate && [self.delegate respondsToSelector:@selector(refundMethodCell:tapShowRefundQRCodeImageView:)]) {
        [self.delegate refundMethodCell:self tapShowRefundQRCodeImageView:self.refundQRCodeImageView];
    }
}


#pragma mark - <YBPopupMenuDelegate>
/**
 点击事件回调
 */
- (void)ybPopupMenu:(YBPopupMenu *)ybPopupMenu didSelectedAtIndex:(NSInteger)index{
    [self.refundMethodBtn setTitle:self.titles[index] forState:UIControlStateNormal];
    if (index == 0) {
        self.qRCodeContainerView.hidden = YES;
        self.unionPayContainerView.hidden = NO;
    }else{
        self.qRCodeContainerView.hidden = NO;
        self.unionPayContainerView.hidden = YES;
    }
    if (self.infoConfirmCallBack) {
        self.infoConfirmCallBack(index+1, self.nameTextField.text, self.bankTextField.text, self.accountNumTextField.text);
    }
}

-(void)upLoadImage:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(refundMethodCell:clickUpLoadBtn:showRefundQRCodeImageView:)]) {
        [self.delegate refundMethodCell:self clickUpLoadBtn:sender showRefundQRCodeImageView:self.refundQRCodeImageView];
    }
}


#pragma mark -
-(void)textFieldTextDidChangeNotification:(NSNotification *)notif{
    UITextField *textfiled = notif.object;
    if (textfiled == self.bankTextField) {
        [HXCommonUtil limitIncludeChineseTextField:textfiled Length:50];
    }else{
        [HXCommonUtil limitIncludeChineseTextField:textfiled Length:20];
    }
    if (self.infoConfirmCallBack) {
        self.infoConfirmCallBack(1, self.nameTextField.text, self.bankTextField.text, self.accountNumTextField.text);
    }
}

-(void)setStudentRefundDetailsModel:(HXStudentRefundDetailsModel *)studentRefundDetailsModel{
    ////1银联 2扫码
    _studentRefundDetailsModel = studentRefundDetailsModel;
    if (studentRefundDetailsModel.payMode== 1 && studentRefundDetailsModel.reviewStatus!= 0) {
        self.refundMethodBtn.userInteractionEnabled = NO;
        [self.refundMethodBtn setTitle:@"银联" forState:UIControlStateNormal];
        self.unionPayContainerView.hidden = NO;
        self.qRCodeContainerView.hidden = YES;
        self.nameTextField.userInteractionEnabled = self.bankTextField.userInteractionEnabled = self.accountNumTextField.userInteractionEnabled = NO;
        self.nameTextField.text = studentRefundDetailsModel.khm;
        self.bankTextField.text = studentRefundDetailsModel.khh;
        self.accountNumTextField.text = studentRefundDetailsModel.khsk;
        
    }else if (studentRefundDetailsModel.payMode== 2 && studentRefundDetailsModel.reviewStatus!= 0) {
        self.refundMethodBtn.userInteractionEnabled = NO;
        [self.refundMethodBtn setTitle:@"扫码" forState:UIControlStateNormal];
        self.unionPayContainerView.hidden = YES;
        self.uploadBtn.hidden = YES;
        self.qRCodeContainerView.hidden = NO;
        [self.refundQRCodeImageView sd_setImageWithURL:[NSURL URLWithString:HXSafeString(studentRefundDetailsModel.skewm)] placeholderImage:nil];
        self.refundQRCodeImageView.backgroundColor = COLOR_WITH_ALPHA(0xD8D8D8, 1);
    }else{
        self.refundMethodBtn.userInteractionEnabled = YES;
        [self.refundMethodBtn setTitle:@"银联" forState:UIControlStateNormal];
        self.unionPayContainerView.hidden = NO;
        self.uploadBtn.hidden = NO;
        self.qRCodeContainerView.hidden = YES;
        self.nameTextField.userInteractionEnabled = self.bankTextField.userInteractionEnabled = self.accountNumTextField.userInteractionEnabled = YES;
        self.refundQRCodeImageView.backgroundColor = [UIColor clearColor];
        if (self.infoConfirmCallBack) {
            self.infoConfirmCallBack(1, self.nameTextField.text, self.bankTextField.text, self.accountNumTextField.text);
        }
    }
    
}

-(void)createUI{
    [self addSubview:self.refundMethodLabel];
    [self addSubview:self.refundMethodBtn];
    
    [self addSubview:self.qRCodeContainerView];
    [self.qRCodeContainerView addSubview:self.refundQRCodeLabel];
    [self.qRCodeContainerView addSubview:self.refundQRCodeImageView];
    [self.refundQRCodeImageView addSubview:self.uploadBtn];
    [self addSubview:self.unionPayContainerView];
    [self.unionPayContainerView addSubview:self.nameLabel];
    [self.unionPayContainerView addSubview:self.nameTextField];
    [self.unionPayContainerView addSubview:self.bankLabel];
    [self.unionPayContainerView addSubview:self.bankTextField];
    [self.unionPayContainerView addSubview:self.accountNumLabel];
    [self.unionPayContainerView addSubview:self.accountNumTextField];
    
    self.refundMethodLabel.sd_layout
    .topSpaceToView(self, 20)
    .leftSpaceToView(self, 24)
    .widthIs(76)
    .heightIs(20);
    
    self.refundMethodBtn.sd_layout
    .centerYEqualToView(self.refundMethodLabel)
    .leftSpaceToView(self.refundMethodLabel, 5)
    .widthIs(76)
    .heightIs(26);
    self.refundMethodBtn.sd_cornerRadiusFromHeightRatio = @0.5;
    
    self.refundMethodBtn.titleLabel.sd_layout
    .centerYEqualToView(self.refundMethodBtn)
    .centerXEqualToView(self.refundMethodBtn)
    .widthIs(50)
    .heightIs(20);
    
    self.refundMethodBtn.imageView.sd_layout
    .centerYEqualToView(self.refundMethodBtn)
    .rightSpaceToView(self.refundMethodBtn, 7)
    .widthIs(6)
    .heightIs(4);
    
    self.qRCodeContainerView.sd_layout
    .topSpaceToView(self.refundMethodBtn, 16)
    .leftSpaceToView(self, 24)
    .rightSpaceToView(self, 24)
    .heightIs(150);
    
    self.refundQRCodeLabel.sd_layout
    .topSpaceToView(self.qRCodeContainerView, 3)
    .leftEqualToView(self.qRCodeContainerView)
    .widthIs(85)
    .heightIs(20);
    
    self.refundQRCodeImageView.sd_layout
    .topSpaceToView(self.qRCodeContainerView, 0)
    .leftSpaceToView(self.refundQRCodeLabel, 5)
    .widthIs(120)
    .heightEqualToWidth();
    self.refundQRCodeImageView.sd_cornerRadius = @6;
    
    self.uploadBtn.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    
    ///银联
    self.unionPayContainerView.sd_layout
    .topSpaceToView(self.refundMethodBtn, 16)
    .leftSpaceToView(self, 24)
    .rightSpaceToView(self, 24)
    .heightIs(150);
    
    
    self.nameLabel.sd_layout
    .topSpaceToView(self.unionPayContainerView, 5)
    .leftEqualToView(self.unionPayContainerView)
    .widthIs(80)
    .heightIs(20);
    
    self.nameTextField.sd_layout
    .centerYEqualToView(self.nameLabel)
    .leftSpaceToView(self.nameLabel, 3)
    .rightSpaceToView(self.unionPayContainerView, 3)
    .heightIs(26);
    self.nameTextField.sd_cornerRadiusFromHeightRatio = @0.5;
    [HXCommonUtil limitIncludeChineseTextField:self.nameTextField Length:20];
    
    self.bankLabel.sd_layout
    .topSpaceToView(self.nameLabel, 20)
    .leftEqualToView(self.unionPayContainerView)
    .widthRatioToView(self.nameLabel, 1)
    .heightRatioToView(self.nameLabel, 1);
    
    self.bankTextField.sd_layout
    .centerYEqualToView(self.bankLabel)
    .leftSpaceToView(self.bankLabel, 3)
    .rightEqualToView(self.nameTextField)
    .heightRatioToView(self.nameTextField, 1);
    self.bankTextField.sd_cornerRadiusFromHeightRatio = @0.5;
    [HXCommonUtil limitIncludeChineseTextField:self.bankTextField Length:50];
    
    self.accountNumLabel.sd_layout
    .topSpaceToView(self.bankLabel, 20)
    .leftEqualToView(self.unionPayContainerView)
    .widthRatioToView(self.nameLabel, 1)
    .heightRatioToView(self.nameLabel, 1);
    
    self.accountNumTextField.sd_layout
    .centerYEqualToView(self.accountNumLabel)
    .leftSpaceToView(self.accountNumLabel, 3)
    .rightEqualToView(self.nameTextField)
    .heightRatioToView(self.nameTextField, 1);
    self.accountNumTextField.sd_cornerRadiusFromHeightRatio = @0.5;
    [HXCommonUtil limitIncludeChineseTextField:self.accountNumTextField Length:20];
}


#pragma mark - lazyLoad
-(NSArray *)titles{
    return @[@"银联",@"扫码"];
}
-(UILabel *)refundMethodLabel{
    if (!_refundMethodLabel) {
        _refundMethodLabel = [[UILabel alloc] init];
        _refundMethodLabel.font = HXFont(14);
        _refundMethodLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        _refundMethodLabel.textAlignment = NSTextAlignmentLeft;
        _refundMethodLabel.text = @"退费方式：";
    }
    return _refundMethodLabel;
}

-(UIButton *)refundMethodBtn{
    if (!_refundMethodBtn) {
        _refundMethodBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _refundMethodBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _refundMethodBtn.layer.borderWidth = 1;
        _refundMethodBtn.layer.borderColor = COLOR_WITH_ALPHA(0x979797, 1).CGColor;
        _refundMethodBtn.titleLabel.font = HXFont(14);
        [_refundMethodBtn setTitleColor:COLOR_WITH_ALPHA(0x2C2C2E, 1) forState:UIControlStateNormal];
        [_refundMethodBtn setImage:[UIImage imageNamed:@"down_arrow"] forState:UIControlStateNormal];
        
        [_refundMethodBtn addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _refundMethodBtn;
}

-(UIView *)qRCodeContainerView{
    if (!_qRCodeContainerView) {
        _qRCodeContainerView = [[UIView alloc] init];
        _qRCodeContainerView.backgroundColor = [UIColor clearColor];
        
    }
    return _qRCodeContainerView;
}

-(UILabel *)refundQRCodeLabel{
    if (!_refundQRCodeLabel) {
        _refundQRCodeLabel = [[UILabel alloc] init];
        _refundQRCodeLabel.font = HXFont(14);
        _refundQRCodeLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        _refundQRCodeLabel.textAlignment = NSTextAlignmentLeft;
        _refundQRCodeLabel.text = @"退费二维码：";
    }
    return _refundQRCodeLabel;
}

-(UIImageView *)refundQRCodeImageView{
    if (!_refundQRCodeImageView) {
        _refundQRCodeImageView = [[UIImageView alloc] init];
        _refundQRCodeImageView.backgroundColor = COLOR_WITH_ALPHA(0xD8D8D8, 1);
        _refundQRCodeImageView.userInteractionEnabled = YES;
        _refundQRCodeImageView.clipsToBounds = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView:)];
        [_refundQRCodeImageView addGestureRecognizer:tap];
    }
    return _refundQRCodeImageView;
}

-(UIButton *)uploadBtn{
    if (!_uploadBtn) {
        _uploadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_uploadBtn setImage:[UIImage imageNamed:@"add_qrcode"] forState:UIControlStateNormal];
        [_uploadBtn addTarget:self action:@selector(upLoadImage:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _uploadBtn;
}

-(UIView *)unionPayContainerView{
    if (!_unionPayContainerView) {
        _unionPayContainerView = [[UIView alloc] init];
        _unionPayContainerView.backgroundColor = [UIColor clearColor];
        
    }
    return _unionPayContainerView;
}

-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = HXFont(14);
        _nameLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.text = @"开户名：";
    }
    return _nameLabel;
}

-(UITextField *)nameTextField{
    if (!_nameTextField) {
        _nameTextField = [[UITextField alloc] init];
        _nameTextField.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        _nameTextField.layer.borderWidth = 1;
        _nameTextField.layer.borderColor = COLOR_WITH_ALPHA(0x979797, 1).CGColor;
        _nameTextField.font = HXFont(14);
        _nameTextField.keyboardType = UIKeyboardTypeDefault;
        UIView *leftview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
        _nameTextField.leftView = leftview;
        _nameTextField.leftViewMode = UITextFieldViewModeAlways;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChangeNotification:) name:UITextFieldTextDidChangeNotification object:_nameTextField];
    }
    return _nameTextField;
}

-(UILabel *)bankLabel{
    if (!_bankLabel) {
        _bankLabel = [[UILabel alloc] init];
        _bankLabel.font = HXFont(14);
        _bankLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        _bankLabel.textAlignment = NSTextAlignmentLeft;
        _bankLabel.text = @"开户行：";
    }
    return _bankLabel;
}

-(UITextField *)bankTextField{
    if (!_bankTextField) {
        _bankTextField = [[UITextField alloc] init];
        _bankTextField.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        _bankTextField.layer.borderWidth = 1;
        _bankTextField.layer.borderColor = COLOR_WITH_ALPHA(0x979797, 1).CGColor;
        _bankTextField.font = HXFont(14);
        _bankTextField.keyboardType = UIKeyboardTypeDefault;
        UIView *leftview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
        _bankTextField.leftView = leftview;
        _bankTextField.leftViewMode = UITextFieldViewModeAlways;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChangeNotification:) name:UITextFieldTextDidChangeNotification object:_bankTextField];
    }
    return _bankTextField;
}

-(UILabel *)accountNumLabel{
    if (!_accountNumLabel) {
        _accountNumLabel = [[UILabel alloc] init];
        _accountNumLabel.font = HXFont(14);
        _accountNumLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        _accountNumLabel.textAlignment = NSTextAlignmentLeft;
        _accountNumLabel.text = @"收款账户：";
    }
    return _accountNumLabel;
}

-(UITextField *)accountNumTextField{
    if (!_accountNumTextField) {
        _accountNumTextField = [[UITextField alloc] init];
        _accountNumTextField.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        _accountNumTextField.layer.borderWidth = 1;
        _accountNumTextField.layer.borderColor = COLOR_WITH_ALPHA(0x979797, 1).CGColor;
        _accountNumTextField.font = HXFont(14);
        _accountNumTextField.keyboardType = UIKeyboardTypeNumberPad;
        UIView *leftview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
        _accountNumTextField.leftView = leftview;
        _accountNumTextField.leftViewMode = UITextFieldViewModeAlways;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChangeNotification:) name:UITextFieldTextDidChangeNotification object:_accountNumTextField];
    }
    return _accountNumTextField;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
