//
//  HXScanCodePaymentViewController.m
//  HXMinedu
//
//  Created by mac on 2021/5/6.
//

#import "HXScanCodePaymentViewController.h"
#import "HXUpLoadVoucherViewController.h"
#import "HXScanCodePaymentModel.h"
#import "SDWebImage.h"

@interface HXScanCodePaymentViewController ()

@property(nonatomic,strong) UIScrollView * mainScrollView;
@property(nonatomic,strong) UILabel *paymentMoneyLabel;
@property(nonatomic,strong) UILabel *paymentTitleLabel;

@property(nonatomic,strong) UIView * bigBackgroundView;
@property(nonatomic,strong) UIView * btnsContainerView;
@property(nonatomic,strong) UIButton *zfbBtn;
@property(nonatomic,strong) UIButton *weiXinBtn;
@property(nonatomic,strong) UIButton *qiTaBtn;
@property(nonatomic,strong) UIButton *selectBtn;
@property(nonatomic,strong) NSMutableArray *btnArray;


@property(nonatomic,strong) UIView * middleWhiteView;
@property(nonatomic,strong) UIImageView *qRCodeImageView;

@property(nonatomic,strong) UIView *bottomView;
@property(nonatomic,strong) UILabel *bottomLabel;

@property(nonatomic,strong) UIButton *paymentBtn;

@property(nonatomic,strong) HXScanCodePaymentModel *scanCodePaymentModel;

@end

const NSString * deepBackGroundColorKey = @"DeepBackGroundColorKey";
const NSString * lightBackGroundColorKey = @"LightBackGroundColorKey";

@implementation HXScanCodePaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
    //获取扫码支付数据
    [self confirmOrder];
}

#pragma mark - 获取扫码支付数据
-(void)confirmOrder{
    HXMajorModel *selectMajorModel = [HXPublicParamTool sharedInstance].selectMajorModel;
    NSDictionary *dic = @{
        @"version_id":HXSafeString(selectMajorModel.versionId),
        @"major_id":HXSafeString(selectMajorModel.major_id),
        @"type":@(selectMajorModel.type),
        @"orderNum":HXSafeString(self.orderNum),
    };
    
    [HXBaseURLSessionManager postDataWithNSString:HXPOST_Get_ConfirmOrder withDictionary:dic success:^(NSDictionary * _Nonnull dictionary) {
        
        BOOL success = [dictionary boolValueForKey:@"Success"];
        if (success) {
            //刷新数据
            self.scanCodePaymentModel = [HXScanCodePaymentModel mj_objectWithKeyValues:[dictionary objectForKey:@"Data"]];
            [self refreshUI];
        }else{
            [self.view showErrorWithMessage:[dictionary stringValueForKey:@"Message"]];
        }
    } failure:^(NSError * _Nonnull error) {
        

    }];
    
}

-(void)refreshUI{
    NSString *needStr = [NSString stringWithFormat:@"%.2f",self.scanCodePaymentModel.fee];
    NSString *contentStr = [@"¥ " stringByAppendingString:needStr];
    self.paymentMoneyLabel.attributedText = [HXCommonUtil getAttributedStringWith:needStr needAttributed:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:26]} content:contentStr defaultAttributed:@{NSFontAttributeName:[UIFont systemFontOfSize:18]}];
    self.paymentTitleLabel.text =HXSafeString(self.scanCodePaymentModel.addfeeType_Name);
    [self.btnArray removeAllObjects];
    if (![HXCommonUtil isNull:self.scanCodePaymentModel.alipay_code]) {
        [self.btnsContainerView addSubview:self.zfbBtn];
        [self.btnArray addObject:self.zfbBtn];
    }
    if (![HXCommonUtil isNull:self.scanCodePaymentModel.weixinpay_code]) {
        [self.btnsContainerView addSubview:self.weiXinBtn];
        [self.btnArray addObject:self.weiXinBtn];
    }
   
    self.btnsContainerView.sd_layout
    .topSpaceToView(self.bigBackgroundView, 5)
    .leftSpaceToView(self.bigBackgroundView, 5)
    .rightSpaceToView(self.bigBackgroundView, 5);
    
    
    
    [self.btnsContainerView setupAutoWidthFlowItems:self.btnArray withPerRowItemsCount:self.btnArray.count verticalMargin:0 horizontalMargin:5 verticalEdgeInset:0 horizontalEdgeInset:0];
    [self.btnsContainerView updateLayout];
    
    [self.btnArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn = obj;
        [btn addTarget:self action:@selector(switchPaymentMethod:) forControlEvents:UIControlEventTouchUpInside];
        btn.sd_layout.heightIs(38);
        btn.titleLabel.sd_layout
        .centerYEqualToView(btn)
        .centerXEqualToView(btn).offset(10)
        .heightIs(17);
        [btn.titleLabel setSingleLineAutoResizeWithMaxWidth:50];
        
        btn.imageView.sd_layout
        .centerYEqualToView(btn)
        .rightSpaceToView(btn.titleLabel, 5)
        .widthIs(20)
        .heightEqualToWidth();
        
    
        CAShapeLayer *shapLayer = [[CAShapeLayer alloc] init];
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:btn.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
        shapLayer.path = path.CGPath;
        btn.layer.mask = shapLayer;
        
        
    }];
    
    if (self.btnArray.count>0) {
        self.selectBtn = self.btnArray.firstObject;
        ///改变选中
        [self changeState];
    }
}

#pragma mark - Event
-(void)upLoadVoucher:(UIButton *)sender{
    HXUpLoadVoucherViewController *vc = [[HXUpLoadVoucherViewController alloc] init];
    vc.scanCodePaymentModel = self.scanCodePaymentModel;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)switchPaymentMethod:(UIButton *)sender{
    if (sender == self.selectBtn) return;
    self.selectBtn = sender;
    [self changeState];
}
///改变选中
-(void)changeState{
    [self.btnArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn = obj;
        if (btn == self.selectBtn) {
            btn.backgroundColor = COLOR_WITH_ALPHA(0xffffff, 1);
            [btn setTitleColor:COLOR_WITH_ALPHA(0x2D2C2D, 1) forState:UIControlStateNormal];
            if ([[self.selectBtn titleForState:UIControlStateNormal] isEqualToString:@"支付宝"]) {
                [btn setImage:[UIImage imageNamed:@"zfb_select"] forState:UIControlStateNormal];
                [self.qRCodeImageView sd_setImageWithURL:[NSURL URLWithString:HXSafeString(self.scanCodePaymentModel.alipay_code)] placeholderImage:nil];

            }else if ([[self.selectBtn titleForState:UIControlStateNormal] isEqualToString:@"微信"]) {
                [btn setImage:[UIImage imageNamed:@"weixin_select"] forState:UIControlStateNormal];
                [self.qRCodeImageView sd_setImageWithURL:[NSURL URLWithString:HXSafeString(self.scanCodePaymentModel.weixinpay_code)] placeholderImage:nil];
            }else{
                [btn setImage:[UIImage imageNamed:@"qita_select"] forState:UIControlStateNormal];

            }
        }else{
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            if ([[self.selectBtn titleForState:UIControlStateNormal] isEqualToString:@"支付宝"]) {
                btn.backgroundColor = COLOR_WITH_ALPHA(0x1677FF, 1);
                self.bottomView.backgroundColor = COLOR_WITH_ALPHA(0x1677FF, 1);
                self.bigBackgroundView.backgroundColor = COLOR_WITH_ALPHA(0x7DAAFF, 1);
                
            }else if ([[self.selectBtn titleForState:UIControlStateNormal] isEqualToString:@"微信"]) {
                btn.backgroundColor = COLOR_WITH_ALPHA(0x00C800, 1);
                self.bottomView.backgroundColor = COLOR_WITH_ALPHA(0x00C800, 1);
                self.bigBackgroundView.backgroundColor = COLOR_WITH_ALPHA(0x9EDBA9, 1);
            }else{
                btn.backgroundColor = COLOR_WITH_ALPHA(0xFF8324, 1);
                self.bottomView.backgroundColor = COLOR_WITH_ALPHA(0xFF8324, 1);
                self.bigBackgroundView.backgroundColor = COLOR_WITH_ALPHA(0xFFC258, 1);
            }
            
            if ([[btn titleForState:UIControlStateNormal] isEqualToString:@"支付宝"]) {
                [btn setImage:[UIImage imageNamed:@"zfb_unselect"] forState:UIControlStateNormal];
            }else if ([[btn titleForState:UIControlStateNormal] isEqualToString:@"微信"]) {
                [btn setImage:[UIImage imageNamed:@"weixin_unselect"] forState:UIControlStateNormal];
            }else{
                [btn setImage:[UIImage imageNamed:@"qita_unselect"] forState:UIControlStateNormal];
            }
        }
        
    }];
}

#pragma mark - UI
-(void)createUI{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.sc_navigationBar.title = @"扫码支付";
    
    
    [self.view addSubview:self.mainScrollView];
    [self.mainScrollView addSubview:self.paymentMoneyLabel];
    [self.mainScrollView addSubview:self.paymentTitleLabel];
    [self.mainScrollView addSubview:self.bigBackgroundView];
    [self.bigBackgroundView addSubview:self.btnsContainerView];
    [self.bigBackgroundView addSubview:self.middleWhiteView];
    [self.middleWhiteView addSubview:self.qRCodeImageView];
    [self.bigBackgroundView addSubview:self.bottomView];
    [self.bottomView addSubview:self.bottomLabel];
    [self.mainScrollView addSubview:self.paymentBtn];
    
    
    self.mainScrollView.sd_layout
    .topSpaceToView(self.view, kNavigationBarHeight)
    .leftEqualToView(self.view)
    .widthIs(kScreenWidth)
    .bottomEqualToView(self.view);
    
    self.paymentMoneyLabel.sd_layout
    .topSpaceToView(self.mainScrollView, 40)
    .leftSpaceToView(self.mainScrollView, _kpw(28))
    .rightSpaceToView(self.mainScrollView, _kpw(28))
    .heightIs(37);
    
    self.paymentTitleLabel.sd_layout
    .topSpaceToView(self.paymentMoneyLabel, 5)
    .leftSpaceToView(self.mainScrollView, _kpw(28))
    .rightSpaceToView(self.mainScrollView, _kpw(28))
    .heightIs(20);
    
    
    self.bigBackgroundView.sd_layout
    .topSpaceToView(self.paymentTitleLabel, 14)
    .leftSpaceToView(self.mainScrollView, _kpw(28))
    .rightSpaceToView(self.mainScrollView, _kpw(28))
    .heightIs(_kpw(353));
    self.bigBackgroundView.sd_cornerRadius = @14;
    
    
    
    self.middleWhiteView.sd_layout
    .topSpaceToView(self.bigBackgroundView,70)
    .leftSpaceToView(self.bigBackgroundView, _kpw(28))
    .rightSpaceToView(self.bigBackgroundView, _kpw(28))
    .bottomEqualToView(self.bigBackgroundView);
    self.middleWhiteView.sd_cornerRadius = @16;
    
    

    
    self.qRCodeImageView.sd_layout
    .topSpaceToView(self.middleWhiteView, 10)
    .leftSpaceToView(self.middleWhiteView, 10)
    .rightSpaceToView(self.middleWhiteView, 10)
    .bottomSpaceToView(self.middleWhiteView, 48);
    
    
    self.bottomView.sd_layout
    .bottomEqualToView(self.bigBackgroundView)
    .leftEqualToView(self.bigBackgroundView)
    .rightEqualToView(self.bigBackgroundView)
    .heightIs(38);
    
    self.bottomLabel.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    
    
    self.paymentBtn.sd_layout
    .topSpaceToView(self.bigBackgroundView, 97)
    .leftSpaceToView(self.mainScrollView, _kpw(28))
    .rightSpaceToView(self.mainScrollView, _kpw(28))
    .heightIs(45);
    self.paymentBtn.sd_cornerRadius = @6;
    [self.paymentBtn updateLayout];
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.bounds = self.paymentBtn.bounds;
    gradientLayer.startPoint = CGPointMake(0, 0.5);
    gradientLayer.endPoint = CGPointMake(1, 0.5);
    gradientLayer.anchorPoint = CGPointMake(0, 0);
    NSArray *colorArr = @[(id)COLOR_WITH_ALPHA(0x4BA4FE, 1).CGColor,(id)COLOR_WITH_ALPHA(0x45EFCF, 1).CGColor];
    gradientLayer.colors = colorArr;
    [self.paymentBtn.layer insertSublayer:gradientLayer below:self.paymentBtn.titleLabel.layer];
    
    [self.mainScrollView setupAutoContentSizeWithBottomView:self.paymentBtn bottomMargin:kScreenBottomMargin+50];
    
    
   
   
    
}


#pragma mark - LazyLoad
-(NSMutableArray *)btnArray{
    if (!_btnArray) {
        _btnArray = [NSMutableArray array];
    }
    return _btnArray;
}
-(UIScrollView *)mainScrollView{
    if (!_mainScrollView) {
        _mainScrollView = [[UIScrollView alloc] init];
        _mainScrollView.backgroundColor = COLOR_WITH_ALPHA(0xF5F6FA, 1);
        _mainScrollView.showsVerticalScrollIndicator = NO;
        _mainScrollView.bounces = NO;
    }
    return _mainScrollView;
}

-(UILabel *)paymentMoneyLabel{
    if (!_paymentMoneyLabel) {
        _paymentMoneyLabel = [[UILabel alloc] init];
        _paymentMoneyLabel.textAlignment = NSTextAlignmentCenter;
        _paymentMoneyLabel.font = HXBoldFont(26);
        _paymentMoneyLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        
    }
    return _paymentMoneyLabel;
}

-(UILabel *)paymentTitleLabel{
    if (!_paymentTitleLabel) {
        _paymentTitleLabel = [[UILabel alloc] init];
        _paymentTitleLabel.textAlignment = NSTextAlignmentCenter;
        _paymentTitleLabel.font = HXFont(14);
        _paymentTitleLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
       
    }
    return _paymentTitleLabel;
}

-(UIView *)bigBackgroundView{
    if (!_bigBackgroundView) {
        _bigBackgroundView = [[UIView alloc] init];
        _bigBackgroundView.clipsToBounds = YES;
        _bigBackgroundView.backgroundColor = COLOR_WITH_ALPHA(0xFFC258, 1);
    }
    return _bigBackgroundView;
}

-(UIView *)btnsContainerView{
    if (!_btnsContainerView) {
        _btnsContainerView = [[UIView alloc] init];
        _btnsContainerView.backgroundColor = [UIColor clearColor];
        _btnsContainerView.clipsToBounds = YES;
    }
    return _btnsContainerView;
}

-(UIButton *)zfbBtn{
    if (!_zfbBtn) {
        _zfbBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _zfbBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        _zfbBtn.backgroundColor = COLOR_WITH_ALPHA(0x1677FF, 1);
        _zfbBtn.titleLabel.font = HXFont(12);
        [_zfbBtn setTitle:@"支付宝" forState:UIControlStateNormal];
        [_zfbBtn setImage:[UIImage imageNamed:@"zfb_unselect"] forState:UIControlStateNormal];
        //        objc_setAssociatedObject(_zfbBtn, &deepBackGroundColorKey, COLOR_WITH_ALPHA(0x1677FF, 1), OBJC_ASSOCIATION_COPY_NONATOMIC);
        //        objc_setAssociatedObject(_zfbBtn, &lightBackGroundColorKey, COLOR_WITH_ALPHA(0x7DAAFF, 1), OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
    return _zfbBtn;
}

-(UIButton *)weiXinBtn{
    if (!_weiXinBtn) {
        _weiXinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _weiXinBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        _weiXinBtn.backgroundColor = COLOR_WITH_ALPHA(0x00C800, 1);
        _weiXinBtn.titleLabel.font = HXFont(12);
        [_weiXinBtn setTitle:@"微信" forState:UIControlStateNormal];
        [_weiXinBtn setImage:[UIImage imageNamed:@"weixin_unselect"] forState:UIControlStateNormal];
    }
    return _weiXinBtn;
}

-(UIButton *)qiTaBtn{
    if (!_qiTaBtn) {
        _qiTaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _qiTaBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        _qiTaBtn.backgroundColor = COLOR_WITH_ALPHA(0xFF8324, 1);
        _qiTaBtn.titleLabel.font = HXFont(12);
        [_qiTaBtn setTitle:@"其他" forState:UIControlStateNormal];
        [_qiTaBtn setImage:[UIImage imageNamed:@"qita_unselect"] forState:UIControlStateNormal];
    }
    return _qiTaBtn;
}



-(UIView *)middleWhiteView{
    if (!_middleWhiteView) {
        _middleWhiteView = [[UIView alloc] init];
        _middleWhiteView.backgroundColor = [UIColor whiteColor];
    }
    return _middleWhiteView;
}



-(UIImageView *)qRCodeImageView{
    if (!_qRCodeImageView) {
        _qRCodeImageView = [[UIImageView alloc] init];
        _qRCodeImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _qRCodeImageView;
}

-(UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = COLOR_WITH_ALPHA(0xFF8324, 1);
    }
    return _bottomView;
}

-(UILabel *)bottomLabel{
    if (!_bottomLabel) {
        _bottomLabel = [[UILabel alloc] init];
        _bottomLabel.textAlignment = NSTextAlignmentCenter;
        _bottomLabel.font = HXFont(14);
        _bottomLabel.textColor = [UIColor whiteColor];
        _bottomLabel.text = @"截图扫码支付";
    }
    return _bottomLabel;
}

-(UIButton *)paymentBtn{
    if (!_paymentBtn) {
        _paymentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _paymentBtn.titleLabel.font = HXBoldFont(16);
        [_paymentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_paymentBtn setTitle:@"我已付款" forState:UIControlStateNormal];
        [_paymentBtn addTarget:self action:@selector(upLoadVoucher:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _paymentBtn;
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
