//
//  HXCommonSelectView.m
//  HXXiaoGuan
//
//  Created by mac on 2021/6/28.
//

#import "HXCommonSelectView.h"
#import "IQKeyboardManager.h"

@interface HXCommonSelectView ()<UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate>
@property(nonatomic,strong) UIView *maskView;
@property(nonatomic,strong) UIView *bigWhiteShadowView;
@property(nonatomic,strong) UIView *bigWhiteView;
@property(nonatomic,strong) UILabel *titleLabel;
@property(nonatomic,strong) UILabel *showLabel;
@property(nonatomic,strong) UITextField *searchTextField;
@property(nonatomic,strong) UILabel *noDataLabel;
@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *confirmBtn;

///是否是搜索模式
@property(nonatomic,assign) BOOL isSearchMode;
///搜索数据源
@property(nonatomic,strong) NSMutableArray *searchDataArray;
@property(nonatomic,strong) NSString *keyValue;

@property (nonatomic, strong)  HXCommonSelectModel *begainSelectModel;
@property (nonatomic, strong)  HXCommonSelectModel *lastSelectModel;

@end

@implementation HXCommonSelectView


-(instancetype)init{
    self = [super init];
    if (self) {
        [self createUI];
    }
    return self;
}

-(void)dealloc{
   
}

#pragma mark - UIKeyboardWillShowNotification
-(void)keyboardShow:(NSNotification *)not{
    NSDictionary* info = [not userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    CGFloat height = kbSize.height;
    self.transform = CGAffineTransformMakeTranslation(0, -height*0.5);
}

-(void)keyboardHide:(NSNotification *)not{
    self.transform = CGAffineTransformMakeTranslation(0, 0);
    if (self.isSearchMode) {
        if (self.searchDataArray.count>0) {
            __block NSInteger selectIndex = -1;
            [self.searchDataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                HXCommonSelectModel *model = obj;
                if (model.isSelected) {
                    selectIndex = idx;
                    *stop = YES;
                    return;
                }
            }];
            [self.mainTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(selectIndex!=-1?selectIndex:0) inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        }
    }else{
        if (self.dataArray.count>0) {
            __block NSInteger selectIndex = -1;
            [self.dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                HXCommonSelectModel *model = obj;
                if (model.isSelected) {
                    selectIndex = idx;
                    *stop = YES;
            
                    return;
                }
            }];
            [self.mainTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(selectIndex!=-1?selectIndex:0) inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        }
    }
}

#pragma mark - setter
-(void)setSelectNum:(NSInteger)selectNum{
    _selectNum = selectNum;
    [self.mainTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:selectNum inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

-(void)setDataArray:(NSArray *)dataArray{
    self.isSearchMode = NO;
    self.showLabel.text = nil;
    self.searchTextField.text = nil;
    self.noDataLabel.hidden = YES;
    _dataArray = dataArray;
    if (dataArray.count == 0) {
        [self.superview showTostWithMessage:@"无数据"];
        [self dismiss];
        return;
    }
    if (dataArray.count>0) {
        __block NSInteger selectIndex = -1;
        [dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            HXCommonSelectModel *model = obj;
            if (model.isSelected) {
                selectIndex = idx;
                *stop = YES;
                self.showLabel.text = model.content;
                return;
            }
        }];
        self.begainSelectModel = (selectIndex!=-1 ? self.dataArray[selectIndex]:nil);
        self.lastSelectModel = (selectIndex!=-1 ? self.dataArray[selectIndex]:nil);
        [self.mainTableView reloadData];
        [self.mainTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(selectIndex!=-1?selectIndex:0) inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
}

-(void)setTitle:(NSString *)title{
    _title = title;
    self.titleLabel.text = title;
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"搜索%@",title] attributes:
                                      @{NSForegroundColorAttributeName:COLOR_WITH_ALPHA(0xC0C7D2, 1),
                                        NSFontAttributeName:_searchTextField.font
                                      }];
    self.searchTextField.attributedPlaceholder = attrString;
    //选择资料类型等的搜索框去掉
    if ([@"选择资料类型" containsString:title]) {
        self.bigWhiteShadowView.sd_layout.heightIs(430);
        self.searchTextField.sd_layout.topSpaceToView(self.showLabel, 10).heightIs(0);
    }else{
        self.bigWhiteShadowView.sd_layout.heightIs(515);
        self.searchTextField.sd_layout.topSpaceToView(self.showLabel, 30).heightIs(42);
    }
}


///专门针对人员分配、转移
-(void)setSpacialTitle:(NSString *)spacialTitle{
    _spacialTitle = spacialTitle;
    self.titleLabel.text = spacialTitle;
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"搜索咨询师"] attributes:
                                      @{NSForegroundColorAttributeName:COLOR_WITH_ALPHA(0xC0C7D2, 1),
                                        NSFontAttributeName:_searchTextField.font
                                      }];
    self.searchTextField.attributedPlaceholder = attrString;
    self.bigWhiteShadowView.sd_layout.heightIs(515);
    self.searchTextField.sd_layout.topSpaceToView(self.showLabel, 30).heightIs(42);
}



#pragma mark - Event
-(void)cancel:(UIButton *)sender{
    [self.dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        HXCommonSelectModel *model = obj;
        if ([model.content isEqualToString:self.begainSelectModel.content]) {
            model.isSelected = YES;
        }else{
            model.isSelected = NO;
        }
    }];
    [self dismiss];
}

-(void)confirm:(UIButton *)sender{
    [self dismiss];
    if (self.seletConfirmBlock && self.lastSelectModel!=self.begainSelectModel) {
        self.seletConfirmBlock(self.lastSelectModel);
    }
}

-(void)dismiss{
    [self removeFromSuperview];
}

#pragma mark - PublickMethod
-(void)show{
   
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}


#pragma mark - NSNotification
-(void)textFieldTextDidChangeNotification:(NSNotification *)not{
    self.noDataLabel.hidden = YES;
    UITextField *textField = not.object;
    if ([HXCommonUtil isNull:textField.text]) {
        [self textFieldShouldClear:textField];
        return;
    }
    self.keyValue = textField.text;
    self.isSearchMode = YES;
    //遍历数组
    [self.searchDataArray removeAllObjects];
    [self.dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        HXCommonSelectModel *model = obj;
        if ([model.content containsString:self.keyValue]) {
            [self.searchDataArray addObject:model];
        }
    }];
    if (self.searchDataArray.count == 0) {
        self.noDataLabel.hidden = NO;
    }else{
        self.noDataLabel.hidden = YES;
    }
    [self.mainTableView reloadData];
}

#pragma mark -<UITextFieldDelegate>
- (BOOL)textFieldShouldClear:(UITextField *)textField{
    self.isSearchMode = NO;
    [self.mainTableView reloadData];
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self endEditing:YES];
    return YES;
}

#pragma mark - <UITableViewDelegate,UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.isSearchMode?self.searchDataArray.count : self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *commonSelectCellIdentifier = @"HXCommonSelectCellIdentifier";
    HXCommonSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:commonSelectCellIdentifier];
    if (!cell) {
        cell = [[HXCommonSelectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:commonSelectCellIdentifier];
    }
    cell.commonSelectModel = (self.isSearchMode?self.searchDataArray[indexPath.row] : self.dataArray[indexPath.row]);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self endEditing:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HXCommonSelectModel *model = (self.isSearchMode?self.searchDataArray[indexPath.row] : self.dataArray[indexPath.row]);
    if (self.lastSelectModel == model) return;
    self.lastSelectModel.isSelected = NO;
    model.isSelected = YES;
    self.lastSelectModel = model;
    self.showLabel.text = model.content;
    [tableView reloadData];
    [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}



#pragma mark - UI
-(void)createUI{
    self.backgroundColor = [UIColor clearColor];
    self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    [self addSubview:self.maskView];
    [self addSubview:self.bigWhiteShadowView];
    [self addSubview:self.bigWhiteView];
    [self.bigWhiteView addSubview:self.titleLabel];
    [self.bigWhiteView addSubview:self.showLabel];
    [self.bigWhiteView addSubview:self.searchTextField];
    [self.bigWhiteView addSubview:self.mainTableView];
    [self.bigWhiteView addSubview:self.cancelBtn];
    [self.bigWhiteView addSubview:self.confirmBtn];
    [self.bigWhiteView addSubview:self.noDataLabel];
    
    self.maskView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    
    self.bigWhiteShadowView.sd_layout
    .leftEqualToView(self)
    .rightEqualToView(self)
    .bottomEqualToView(self)
    .heightIs(515);
    self.bigWhiteShadowView.layer.cornerRadius = 22;
    
    self.bigWhiteView.sd_layout
    .leftEqualToView(self)
    .rightEqualToView(self)
    .bottomEqualToView(self)
    .heightRatioToView(self.bigWhiteShadowView, 1);
    [self.bigWhiteView updateLayout];
    UIBezierPath * bPath = [UIBezierPath bezierPathWithRoundedRect:self.bigWhiteView.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(22, 22)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.path = bPath.CGPath;
    self.bigWhiteView.layer.mask = maskLayer;
    
    self.titleLabel.sd_layout
    .topSpaceToView(self.bigWhiteView, 30)
    .leftSpaceToView(self.bigWhiteView, 15)
    .rightSpaceToView(self.bigWhiteView, 15)
    .heightIs(20);
    
    self.showLabel.sd_layout
    .topSpaceToView(self.titleLabel, 5)
    .leftSpaceToView(self.bigWhiteView, 15)
    .rightSpaceToView(self.bigWhiteView, 15)
    .heightIs(18);
    
    self.searchTextField.sd_layout
    .topSpaceToView(self.showLabel, 30)
    .leftSpaceToView(self.bigWhiteView, 15)
    .rightSpaceToView(self.bigWhiteView, 15)
    .heightIs(42);
    self.searchTextField.sd_cornerRadiusFromHeightRatio = @0.5;
    
    self.noDataLabel.sd_layout
    .topSpaceToView(self.searchTextField, 15)
    .leftSpaceToView(self.bigWhiteView, 15)
    .rightSpaceToView(self.bigWhiteView, 15)
    .heightIs(25);
   

    self.cancelBtn.sd_layout
    .bottomSpaceToView(self.bigWhiteView, 40+kScreenBottomMargin)
    .leftSpaceToView(self.bigWhiteView, _kpw(26))
    .widthIs(_kpw(153))
    .heightIs(48);
    self.cancelBtn.sd_cornerRadiusFromHeightRatio = @0.5;
    
    self.confirmBtn.sd_layout
    .centerYEqualToView(self.cancelBtn)
    .rightSpaceToView(self.bigWhiteView, _kpw(26))
    .widthRatioToView(self.cancelBtn, 1)
    .heightRatioToView(self.cancelBtn, 1);
    self.confirmBtn.sd_cornerRadiusFromHeightRatio = @0.5;
    [self.confirmBtn updateLayout];
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.bounds = self.confirmBtn.bounds;
    gradientLayer.startPoint = CGPointMake(0, 0.5);
    gradientLayer.endPoint = CGPointMake(1, 0.5);
    gradientLayer.anchorPoint = CGPointMake(0, 0);
    NSArray *colorArr = @[(id)COLOR_WITH_ALPHA(0x3EADFF, 1).CGColor,(id)COLOR_WITH_ALPHA(0x15E88D, 1).CGColor];
    gradientLayer.colors = colorArr;
    [self.confirmBtn.layer insertSublayer:gradientLayer below:self.confirmBtn.imageView.layer];
    
    self.mainTableView.sd_layout
    .topSpaceToView(self.searchTextField, 10)
    .leftEqualToView(self.bigWhiteView)
    .rightEqualToView(self.bigWhiteView)
    .bottomSpaceToView(self.cancelBtn, 30);
    
}


#pragma mark - Lazyload
-(NSMutableArray *)searchDataArray{
    if (!_searchDataArray) {
        _searchDataArray = [NSMutableArray array];
    }
    return _searchDataArray;
}

-(UIView *)maskView{
    if (!_maskView) {
        _maskView = [[UIView alloc] init];
        _maskView.backgroundColor = COLOR_WITH_ALPHA(0x000000, 0.4);
    }
    return _maskView;
}

-(UIView *)bigWhiteShadowView{
    if (!_bigWhiteShadowView) {
        _bigWhiteShadowView = [[UIView alloc] init];
        _bigWhiteShadowView.backgroundColor = [UIColor whiteColor];
        _bigWhiteShadowView.layer.shadowColor = COLOR_WITH_ALPHA(0x000000, 0.15).CGColor;
        _bigWhiteShadowView.layer.shadowOffset = CGSizeMake(0, -2);
        _bigWhiteShadowView.layer.shadowRadius = 6;
        _bigWhiteShadowView.layer.shadowOpacity = 1;
        _bigWhiteShadowView.layer.cornerRadius = 22;
        
    }
    return _bigWhiteShadowView;
}

-(UIView *)bigWhiteView{
    if (!_bigWhiteView) {
        _bigWhiteView = [[UIView alloc] init];
        _bigWhiteView.backgroundColor = [UIColor whiteColor];
        _bigWhiteView.clipsToBounds = YES;
        
    }
    return _bigWhiteView;
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = HXFont(14);
        _titleLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
    }
    return _titleLabel;
}

-(UILabel *)showLabel{
    if (!_showLabel) {
        _showLabel = [[UILabel alloc] init];
        _showLabel.textAlignment = NSTextAlignmentCenter;
        _showLabel.font = HXFont(13);
        _showLabel.textColor = COLOR_WITH_ALPHA(0x858585, 1);
    }
    return _showLabel;
}

-(UITextField *)searchTextField{
    if (!_searchTextField) {
        _searchTextField = [[UITextField alloc] init];
        _searchTextField.font = HXFont(14);
        _searchTextField.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        
        _searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _searchTextField.layer.borderWidth = 1;
        _searchTextField.layer.borderColor = COLOR_WITH_ALPHA(0xC0C7D2, 1).CGColor;
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 40)];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 20, 20)];
        imageView.image = [UIImage imageNamed:@"graysearch_icon"];
        [leftView addSubview:imageView];
        _searchTextField.leftView = leftView;
        _searchTextField.leftViewMode = UITextFieldViewModeAlways;
        _searchTextField.delegate = self;
        _searchTextField.returnKeyType = UIReturnKeyDone;
        // 修改清除按钮图片
//        UIButton *clearBtn = [_searchTextField valueForKey:@"_clearButton"];
//        [clearBtn setImage:[UIImage imageNamed:@"close_icon"]forState:UIControlStateNormal];
        
    }
    return _searchTextField;;
}

-(UILabel *)noDataLabel{
    if (!_noDataLabel) {
        _noDataLabel = [[UILabel alloc] init];
        _noDataLabel.textAlignment = NSTextAlignmentCenter;
        _noDataLabel.font = HXFont(15);
        _noDataLabel.textColor = COLOR_WITH_ALPHA(0x858585, 1);
        _noDataLabel.text = @"没有找到匹配的结果哦~";
        _noDataLabel.hidden = YES;
    }
    return _noDataLabel;
}


- (UITableView *)mainTableView{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _mainTableView.showsVerticalScrollIndicator = NO;
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.bounces = YES;
        _mainTableView.backgroundColor = [UIColor whiteColor];
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if ([_mainTableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_mainTableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
        
        if (@available(iOS 11.0, *)) {
            _mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _mainTableView.estimatedRowHeight = 0;
            _mainTableView.estimatedSectionHeaderHeight = 0;
            _mainTableView.estimatedSectionFooterHeight = 0;
        }
        _mainTableView.contentInset = UIEdgeInsetsMake(20, 0, 50, 0);
        _mainTableView.scrollIndicatorInsets = _mainTableView.contentInset;
        
    }
    return _mainTableView;
}


-(UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBtn.titleLabel.font = HXFont(15);
        _cancelBtn.backgroundColor = COLOR_WITH_ALPHA(0xF0F0F0, 1);
        [_cancelBtn setTitleColor:COLOR_WITH_ALPHA(0x858585, 1) forState:UIControlStateNormal];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

-(UIButton *)confirmBtn{
    if (!_confirmBtn) {
        _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _confirmBtn.titleLabel.font = HXFont(15);
        [_confirmBtn setTitleColor:COLOR_WITH_ALPHA(0xffffff, 1) forState:UIControlStateNormal];
        [_confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
        [_confirmBtn addTarget:self action:@selector(confirm:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmBtn;
}

@end

