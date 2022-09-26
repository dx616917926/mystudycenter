//
//  HXMyOnLiveViewController.m
//  HXMinedu
//
//  Created by mac on 2022/8/10.
//

#import "HXMyOnLiveViewController.h"
#import "HXKeChengContainerViewController.h"
#import "HXKeChengHuiFangViewController.h"
#import "HXZuoYeViewController.h"
#import "HXCommonWebViewController.h"
#import "HXKeChengKeJieCell.h"

@interface HXMyOnLiveViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property(nonatomic,strong) UIView *topContainerView;
@property(nonatomic,strong) UIButton *keChengBtn;
@property(nonatomic,strong) UIButton *huiFangBtn;
@property(nonatomic,strong) UIButton *zuoYeBtn;

@property(nonatomic,strong) UIButton *dongTaiBtn;

@property(nonatomic,strong) UIView *searchContainerView;
@property(nonatomic,strong) UITextField *searchTextField;
@property(nonatomic,strong) UIButton *searchBtn;
@property(nonatomic,strong) UITableView *mainTableView;

@property(nonatomic,strong) UIView *noDataView;

///是否搜索模式
@property(nonatomic,assign) BOOL isSearchMode;
@property(nonatomic,strong) NSString *keyValue;//搜索关键词

@property(nonatomic,strong) NSMutableArray *dataArray;
@property(nonatomic,strong) NSMutableArray *searchArray;

@property(nonatomic,assign) NSInteger pageIndex;

@end

@implementation HXMyOnLiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //UI
    [self createUI];
    //直播列表
    [self loadData];
    //登录成功的通知
    [HXNotificationCenter addObserver:self selector:@selector(loadData) name:LOGINSUCCESS object:nil];
}

#pragma mark - Event
-(void)clickItem:(UIButton *)sender{
    NSInteger tag = sender.tag;
    switch (tag) {
        case 7001:
        {
            HXKeChengContainerViewController *vc = [[HXKeChengContainerViewController alloc] init];
            vc.sc_navigationBarHidden = YES;//隐藏导航栏
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 7002:
        {
            HXKeChengHuiFangViewController *vc = [[HXKeChengHuiFangViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 7003:
        {
            HXZuoYeViewController *vc = [[HXZuoYeViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        default:
            break;
    }
    
}


#pragma mark - 获取直播列表
-(void)loadData{
    self.isSearchMode = NO;
    self.pageIndex = 1;
    NSDictionary *dic = @{
        @"pageIndex":@(self.pageIndex),
        @"pageSize":@(15),
        @"keyValue":@""
    };

    [HXBaseURLSessionManager postDataWithNSString:HXPOST_GetNewLiveList  withDictionary:dic success:^(NSDictionary * _Nonnull dictionary) {
       
        [self.mainTableView.mj_header endRefreshing];
        BOOL success = [dictionary boolValueForKey:@"Success"];
        if (success) {
            NSArray *array = [HXKeJieModel mj_objectArrayWithKeyValuesArray:[dictionary objectForKey:@"Data"]];
            if (array.count == 15) {
                self.mainTableView.mj_footer.hidden = NO;
            }else{
                self.mainTableView.mj_footer.hidden = YES;
            }
            if (array.count == 0) {
                [self.mainTableView addSubview:self.noDataView];
            }else{
                [self.noDataView removeFromSuperview];
            }
            [self.dataArray removeAllObjects];
            [self.dataArray addObjectsFromArray:array];
            [self.mainTableView reloadData];
            [self.mainTableView setContentOffset:CGPointZero animated:NO];
        }
    } failure:^(NSError * _Nonnull error) {
       
        [self.mainTableView.mj_header endRefreshing];
    }];
    
}

-(void)loadMoreData{
    self.pageIndex++;
   
    NSDictionary *dic = @{
        @"pageIndex":@(self.pageIndex),
        @"pageSize":@(15),
        @"keyValue":@""
    };
    
    [HXBaseURLSessionManager postDataWithNSString:HXPOST_GetNewLiveList  withDictionary:dic success:^(NSDictionary * _Nonnull dictionary) {
        [self.mainTableView.mj_footer endRefreshing];
        BOOL success = [dictionary boolValueForKey:@"Success"];
        if (success) {
            NSArray *array = [HXKeJieModel mj_objectArrayWithKeyValuesArray:[dictionary objectForKey:@"Data"]];
            if (array.count == 15) {
                self.mainTableView.mj_footer.hidden = NO;
            }else{
                self.mainTableView.mj_footer.hidden = YES;
            }
            [self.dataArray addObjectsFromArray:array];
            [self.mainTableView reloadData];
        }
    } failure:^(NSError * _Nonnull error) {
        [self.mainTableView.mj_footer endRefreshing];
        self.pageIndex--;
    }];
}

-(void)search:(UIButton *)sender{
    self.keyValue = self.searchTextField.text;
    self.isSearchMode = YES;
    [self.view endEditing:YES];
    NSDictionary *dic = @{
        @"pageIndex":@(1),
        @"pageSize":@(100),
        @"keyValue":HXSafeString(self.keyValue)
    };

    [HXBaseURLSessionManager postDataWithNSString:HXPOST_GetNewLiveList  withDictionary:dic success:^(NSDictionary * _Nonnull dictionary) {

        [self.mainTableView.mj_header endRefreshing];
        BOOL success = [dictionary boolValueForKey:@"Success"];
        if (success) {
            NSArray *array = [HXKeJieModel mj_objectArrayWithKeyValuesArray:[dictionary objectForKey:@"Data"]];
            [self.searchArray removeAllObjects];
            [self.searchArray addObjectsFromArray:array];
            if (array.count == 0) {
                [self.mainTableView addSubview:self.noDataView];
            }else{
                [self.noDataView removeFromSuperview];
            }
            [self.mainTableView reloadData];
            [self.mainTableView setContentOffset:CGPointZero animated:NO];
        }
    } failure:^(NSError * _Nonnull error) {

        [self.mainTableView.mj_header endRefreshing];
    }];
}


#pragma mark - NSNotification
-(void)textFieldTextDidChangeNotification:(NSNotification *)not{
    UITextField *textField = not.object;
    if ([HXCommonUtil isNull:textField.text]) {
        [self textFieldShouldClear:textField];
    }
}

#pragma mark -<UITextFieldDelegate>
- (BOOL)textFieldShouldClear:(UITextField *)textField{
    self.isSearchMode = NO;
    self.mainTableView.mj_header.hidden = NO;
    if (self.dataArray.count >= 15) {
        self.mainTableView.mj_footer.hidden = NO;
    }else{
        self.mainTableView.mj_footer.hidden = YES;
    }
    
    if (self.dataArray.count == 0) {
        [self.mainTableView addSubview:self.noDataView];
    }else{
        [self.noDataView removeFromSuperview];
    }
    [self.mainTableView reloadData];
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self.view endEditing:YES];
    self.isSearchMode = YES;
    self.mainTableView.mj_header.hidden = YES;
    self.mainTableView.mj_footer.hidden = YES;
    [self search:nil];
    return YES;
}

#pragma mark - <UITableViewDelegate,UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return (self.isSearchMode?self.searchArray.count : self.dataArray.count);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 102;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *keChengKeJieCellIdentifier = @"HXKeChengKeJieCellIdentifier";
    HXKeChengKeJieCell *cell = [tableView dequeueReusableCellWithIdentifier:keChengKeJieCellIdentifier];
    if (!cell) {
        cell = [[HXKeChengKeJieCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:keChengKeJieCellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.keJieModel = (self.isSearchMode?self.searchArray[indexPath.row]:self.dataArray[indexPath.row]);
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HXKeJieModel *keJieModel = (self.isSearchMode?self.searchArray[indexPath.row]:self.dataArray[indexPath.row]);
    //ClassIn的回放跳出去
    if (keJieModel.LiveType==1&&keJieModel.LiveState==2) {
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:HXSafeURL(keJieModel.liveUrl) options:@{} completionHandler:nil];
        } else {
            [[UIApplication sharedApplication] openURL:HXSafeURL(keJieModel.liveUrl)];
        }
    }else{
        HXCommonWebViewController *webViewVC = [[HXCommonWebViewController alloc] init];
        webViewVC.urlString = keJieModel.liveUrl;
        webViewVC.cuntomTitle = keJieModel.ClassName;
        webViewVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:webViewVC animated:YES];
    }

}


#pragma mark - UI
-(void)createUI{
    self.sc_navigationBar.leftBarButtonItem = nil;
    self.sc_navigationBar.backGroundImage = [UIImage imageNamed:@"navbar_bg"];
    self.sc_navigationBar.title = @"我的直播";
    self.sc_navigationBar.titleColor = [UIColor whiteColor];
    
    [self.view addSubview:self.topContainerView];
    [self.topContainerView addSubview:self.keChengBtn];
    [self.topContainerView addSubview:self.huiFangBtn];
    [self.topContainerView addSubview:self.zuoYeBtn];
    [self.view addSubview:self.dongTaiBtn];
    [self.view addSubview:self.searchContainerView];
    [self.searchContainerView addSubview:self.searchTextField];
    [self.searchContainerView addSubview:self.searchBtn];
    [self.view addSubview:self.mainTableView];
    
    
    
    self.topContainerView.sd_layout
    .topSpaceToView(self.view, kNavigationBarHeight+26)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .heightIs(45);
    
    self.keChengBtn.sd_layout
    .centerYEqualToView(self.topContainerView)
    .leftSpaceToView(self.topContainerView, 20)
    .widthIs(_kpw(105))
    .heightRatioToView(self.topContainerView, 1);
    self.keChengBtn.layer.cornerRadius = 4;
    
    self.keChengBtn.imageView.sd_layout
    .centerYEqualToView(self.keChengBtn)
    .leftSpaceToView(self.keChengBtn, _kpw(20))
    .widthIs(28)
    .heightEqualToWidth();
   
    self.keChengBtn.titleLabel.sd_layout
    .centerYEqualToView(self.keChengBtn)
    .leftSpaceToView(self.keChengBtn.imageView, 8)
    .rightSpaceToView(self.keChengBtn, 0)
    .heightRatioToView(self.keChengBtn, 1);
    
    self.huiFangBtn.sd_layout
    .centerYEqualToView(self.keChengBtn)
    .centerXEqualToView(self.topContainerView)
    .widthRatioToView(self.keChengBtn, 1)
    .heightRatioToView(self.keChengBtn, 1);
    self.huiFangBtn.layer.cornerRadius = 4;
    
    self.huiFangBtn.imageView.sd_layout
    .centerYEqualToView(self.huiFangBtn)
    .leftSpaceToView(self.huiFangBtn, _kpw(20))
    .widthIs(28)
    .heightEqualToWidth();

    self.huiFangBtn.titleLabel.sd_layout
    .centerYEqualToView(self.huiFangBtn)
    .leftSpaceToView(self.huiFangBtn.imageView, 8)
    .rightSpaceToView(self.huiFangBtn, 0)
    .heightRatioToView(self.huiFangBtn, 1);
    
    
    self.zuoYeBtn.sd_layout
    .centerYEqualToView(self.keChengBtn)
    .rightSpaceToView(self.topContainerView, 20)
    .widthRatioToView(self.keChengBtn, 1)
    .heightRatioToView(self.keChengBtn, 1);
    self.zuoYeBtn.layer.cornerRadius = 4;
    
    self.zuoYeBtn.imageView.sd_layout
    .centerYEqualToView(self.zuoYeBtn)
    .leftSpaceToView(self.zuoYeBtn, _kpw(20))
    .widthIs(28)
    .heightEqualToWidth();

    self.zuoYeBtn.titleLabel.sd_layout
    .centerYEqualToView(self.zuoYeBtn)
    .leftSpaceToView(self.zuoYeBtn.imageView, 8)
    .rightSpaceToView(self.zuoYeBtn, 0)
    .heightRatioToView(self.zuoYeBtn, 1);

    self.dongTaiBtn.sd_layout
    .topSpaceToView(self.topContainerView, 20)
    .leftSpaceToView(self.view, 20)
    .rightSpaceToView(self.view, 20)
    .heightIs(20);
    
    self.dongTaiBtn.imageView.sd_layout
    .centerYEqualToView(self.dongTaiBtn)
    .leftEqualToView(self.dongTaiBtn)
    .widthIs(13)
    .heightIs(17);
    
    self.dongTaiBtn.titleLabel.sd_layout
    .centerYEqualToView(self.dongTaiBtn)
    .leftSpaceToView(self.dongTaiBtn.imageView, 12)
    .rightSpaceToView(self.dongTaiBtn, 0)
    .heightRatioToView(self.dongTaiBtn, 1);
    
    self.searchContainerView.sd_layout
    .topSpaceToView(self.dongTaiBtn, 10)
    .leftSpaceToView(self.view, 20)
    .rightSpaceToView(self.view, 20)
    .heightIs(40);
    self.searchContainerView.sd_cornerRadius = @8;
    
    self.searchBtn.sd_layout
    .centerYEqualToView(self.searchContainerView)
    .rightEqualToView(self.searchContainerView)
    .widthIs(60)
    .heightRatioToView(self.searchContainerView, 1);
    
    self.searchBtn.imageView.sd_layout
    .centerYEqualToView(self.searchBtn)
    .centerXEqualToView(self.searchBtn)
    .widthIs(16)
    .heightEqualToWidth();
    
    self.searchTextField.sd_layout
    .centerYEqualToView(self.searchContainerView)
    .leftSpaceToView(self.searchContainerView, 0)
    .rightSpaceToView(self.searchBtn, 0)
    .heightRatioToView(self.searchContainerView, 1);
    
    
    
    self.mainTableView.sd_layout
    .topSpaceToView(self.searchContainerView, 6)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomSpaceToView(self.view, kTabBarHeight);
    
    [self.mainTableView updateLayout];
    
    // 刷新
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    header.automaticallyChangeAlpha = YES;
    self.mainTableView.mj_header = header;
    MJRefreshAutoNormalFooter * footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.mainTableView.mj_footer = footer;
    self.mainTableView.mj_footer.hidden = YES;
   
}

#pragma mark - LazyLaod
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

-(NSMutableArray *)searchArray{
    if (!_searchArray) {
        _searchArray = [NSMutableArray array];
    }
    return _searchArray;
}

-(UIView *)topContainerView{
    if (!_topContainerView) {
        _topContainerView = [[UIView alloc] init];
        _topContainerView.backgroundColor = [UIColor whiteColor];
    }
    return _topContainerView;
}

-(UIButton *)keChengBtn{
    if (!_keChengBtn) {
        _keChengBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _keChengBtn.tag = 7001;
        _keChengBtn.backgroundColor = COLOR_WITH_ALPHA(0xFFF6E8, 1);
        _keChengBtn.layer.shadowColor = COLOR_WITH_ALPHA(0xEB4747, 0.1).CGColor;
        _keChengBtn.layer.shadowOffset = CGSizeMake(0, 2);
        _keChengBtn.layer.shadowRadius = 4;
        _keChengBtn.layer.shadowOpacity = 1;
        _keChengBtn.titleLabel.font = HXFont(16);
        [_keChengBtn setImage:[UIImage imageNamed:@"kecheng_icon"] forState:UIControlStateNormal];
        [_keChengBtn setTitleColor:COLOR_WITH_ALPHA(0xFF972E, 1) forState:UIControlStateNormal];
        [_keChengBtn setTitle:@"课程" forState:UIControlStateNormal];
        [_keChengBtn addTarget:self action:@selector(clickItem:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _keChengBtn;
}

-(UIButton *)huiFangBtn{
    if (!_huiFangBtn) {
        _huiFangBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _huiFangBtn.tag = 7002;
        _huiFangBtn.backgroundColor = COLOR_WITH_ALPHA(0xDFEDFF, 1);
        _huiFangBtn.layer.shadowColor = COLOR_WITH_ALPHA(0xEB4747, 0.1).CGColor;
        _huiFangBtn.layer.shadowOffset = CGSizeMake(0, 2);
        _huiFangBtn.layer.shadowRadius = 4;
        _huiFangBtn.layer.shadowOpacity = 1;
        _huiFangBtn.titleLabel.font = HXFont(16);
        [_huiFangBtn setImage:[UIImage imageNamed:@"huifang_icon"] forState:UIControlStateNormal];
        [_huiFangBtn setTitleColor:COLOR_WITH_ALPHA(0x5699FF, 1) forState:UIControlStateNormal];
        [_huiFangBtn setTitle:@"回放" forState:UIControlStateNormal];
        [_huiFangBtn addTarget:self action:@selector(clickItem:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _huiFangBtn;
}

-(UIButton *)zuoYeBtn{
    if (!_zuoYeBtn) {
        _zuoYeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _zuoYeBtn.tag = 7003;
        _zuoYeBtn.backgroundColor = COLOR_WITH_ALPHA(0xE6FFEA, 1);
        _zuoYeBtn.layer.shadowColor = COLOR_WITH_ALPHA(0xEB4747, 0.1).CGColor;
        _zuoYeBtn.layer.shadowOffset = CGSizeMake(0, 2);
        _zuoYeBtn.layer.shadowRadius = 4;
        _zuoYeBtn.layer.shadowOpacity = 1;
        _zuoYeBtn.titleLabel.font = HXFont(16);
        [_zuoYeBtn setImage:[UIImage imageNamed:@"zuoye_icon"] forState:UIControlStateNormal];
        [_zuoYeBtn setTitleColor:COLOR_WITH_ALPHA(0x3DA441, 1) forState:UIControlStateNormal];
        [_zuoYeBtn setTitle:@"作业" forState:UIControlStateNormal];
        [_zuoYeBtn addTarget:self action:@selector(clickItem:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _zuoYeBtn;
}

-(UIButton *)dongTaiBtn{
    if (!_dongTaiBtn) {
        _dongTaiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _dongTaiBtn.userInteractionEnabled = NO;
        _dongTaiBtn.titleLabel.font = HXFont(14);
        [_dongTaiBtn setImage:[UIImage imageNamed:@"fire_icon"] forState:UIControlStateNormal];
        [_dongTaiBtn setTitleColor:COLOR_WITH_ALPHA(0xFF9851, 1) forState:UIControlStateNormal];
        [_dongTaiBtn setTitle:@"最新动态" forState:UIControlStateNormal];
    }
    return _dongTaiBtn;
}


-(UIView *)searchContainerView{
    if (!_searchContainerView) {
        _searchContainerView = [[UIView alloc] init];
        _searchContainerView.backgroundColor = [UIColor whiteColor];
        _searchContainerView.layer.borderWidth = 1;
        _searchContainerView.layer.borderColor = COLOR_WITH_ALPHA(0xD2D2D2, 1).CGColor;
    }
    return _searchContainerView;
}



-(UITextField *)searchTextField{
    if (!_searchTextField) {
        _searchTextField = [[UITextField alloc] init];
        _searchTextField.delegate = self;
        _searchTextField.font = HXFont(14);
        _searchTextField.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"搜索课程名称、教师名称" attributes:
                                          @{NSForegroundColorAttributeName:COLOR_WITH_ALPHA(0x999999, 1),
                                            NSFontAttributeName:_searchTextField.font
                                          }];
        _searchTextField.attributedPlaceholder = attrString;
        _searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 30)];
        _searchTextField.leftView = leftView;
        _searchTextField.leftViewMode = UITextFieldViewModeAlways;
        _searchTextField.enabled = YES;
        _searchTextField.returnKeyType = UIReturnKeySearch;
        [HXNotificationCenter addObserver:self selector:@selector(textFieldTextDidChangeNotification:) name:UITextFieldTextDidChangeNotification object:_searchTextField];
    }
    return _searchTextField;;
}



-(UIButton *)searchBtn{
    if (!_searchBtn) {
        _searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_searchBtn setImage:[UIImage imageNamed:@"search_icon"] forState:UIControlStateNormal];
        [_searchBtn addTarget:self action:@selector(search:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _searchBtn;
}


-(UITableView *)mainTableView{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _mainTableView.bounces = YES;
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.backgroundColor = [UIColor whiteColor];
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if ([_mainTableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_mainTableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
        self.extendedLayoutIncludesOpaqueBars = YES;
        if (@available(iOS 11.0, *)) {
            _mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _mainTableView.estimatedRowHeight = 0;
            _mainTableView.estimatedSectionHeaderHeight = 0;
            _mainTableView.estimatedSectionFooterHeight = 0;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        _mainTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _mainTableView.scrollIndicatorInsets = _mainTableView.contentInset;
        _mainTableView.showsVerticalScrollIndicator = NO;
       
    }
    return _mainTableView;
}

-(UIView *)noDataView{
    if(!_noDataView){
        _noDataView = [[UIView alloc] initWithFrame:self.mainTableView.bounds];
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"nokecheng_icon"];
        [_noDataView addSubview:imageView];
        
        UILabel *tipLabel = [[UILabel alloc] init];
        tipLabel.font = HXFont(16);
        tipLabel.textColor = COLOR_WITH_ALPHA(0x4988FD, 1);
        tipLabel.textAlignment = NSTextAlignmentCenter;
        tipLabel.text = @"暂无更多课程";
        [_noDataView addSubview:tipLabel];
        
        imageView.sd_layout
        .topSpaceToView(_noDataView, 13)
        .centerXEqualToView(_noDataView)
        .widthIs(298)
        .heightIs(339);
        
        tipLabel.sd_layout
        .topSpaceToView(imageView, 10)
        .leftEqualToView(_noDataView)
        .rightEqualToView(_noDataView)
        .heightIs(22);
    
    }
    return _noDataView;
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
