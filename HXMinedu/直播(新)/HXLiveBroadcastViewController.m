//
//  HXLiveBroadcastViewController.m
//  HXMinedu
//
//  Created by mac on 2021/10/19.
//

#import "HXLiveBroadcastViewController.h"
#import "HXCommonWebViewController.h"
#import "HXScanQRCodeViewController.h"
#import "HXLiveBroadCastCell.h"
#import "MJRefresh.h"
#import "HXVersionModel.h"
#import "HXNoDataTipView.h"

@interface HXLiveBroadcastViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property(nonatomic,strong) UIView *topView;
@property(nonatomic,strong) UIView *searchContainerView;
@property(nonatomic,strong) UIImageView *searchImageView;
@property(nonatomic,strong) UITextField *searchTextField;
@property(nonatomic,strong) UIButton *scanBtn;
@property(nonatomic,strong) UIButton *searchBtn;

@property(nonatomic,strong) UITableView *mainTableView;

@property(nonatomic,assign) NSInteger pageIndex;
///是否搜索模式
@property(nonatomic,assign) BOOL isSearchMode;
@property(nonatomic,strong) NSString *keyValue;//搜索关键词

@property(nonatomic,strong) NSMutableArray *dataArray;
@property(nonatomic,strong) NSMutableArray *searchArray;

@property(nonatomic,strong) HXNoDataTipView *noDataTipView;

@end

@implementation HXLiveBroadcastViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //UI
    [self createUI];
    //获取直播列表
    [self loadData];
    
    ///监听<<报考类型专业改变>>通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(versionAndMajorChangeNotification:) name:VersionAndMajorChangeNotification object:nil];
    //登录成功的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginsuccessNotification:) name:LOGINSUCCESS object:nil];
}

#pragma mark - /监听<<报考类型专业改变>>通知
-(void)versionAndMajorChangeNotification:(NSNotification *)not{
    //获取直播列表
    [self loadData];
}

-(void)loginsuccessNotification:(NSNotification *)not{
    [HXBaseURLSessionManager postDataWithNSString:HXPOST_Get_Version_Major_List withDictionary:nil success:^(NSDictionary * _Nonnull dictionary) {
        BOOL success = [dictionary boolValueForKey:@"Success"];
        if (success) {
            //////由于报考类型数据多处用到，避免频繁获取，此处保存在单例中
            [HXPublicParamTool sharedInstance].versionList = [HXVersionModel mj_objectArrayWithKeyValuesArray:[dictionary objectForKey:@"Data"]];
            ///默认选择第一个
            HXVersionModel *model = [HXPublicParamTool sharedInstance].versionList.firstObject;
            model.isSelected = YES;
            HXMajorModel *majorModel = model.majorList.firstObject;
            majorModel.isSelected = YES;
            //获取直播列表
            [self loadData];
        }
    } failure:^(NSError * _Nonnull error) {
       
        [self.view hideLoading];
    }];
}

#pragma mark - 获取直播列表
-(void)loadData{
    self.isSearchMode = NO;
    self.pageIndex = 1;
    HXMajorModel *selectMajorModel = [HXPublicParamTool sharedInstance].selectMajorModel;
    NSDictionary *dic = @{
        @"version_id":HXSafeString(selectMajorModel.versionId),
        @"major_id":HXSafeString(selectMajorModel.major_id),
        @"pageIndex":@(self.pageIndex),
        @"pageSize":@(15),
        @"keyValue":@""
    };

    [HXBaseURLSessionManager postDataWithNSString:HXPOST_GetLiveList  withDictionary:dic success:^(NSDictionary * _Nonnull dictionary) {
       
        [self.mainTableView.mj_header endRefreshing];
        BOOL success = [dictionary boolValueForKey:@"Success"];
        if (success) {
            NSArray *array = [HXLiveBroadcastModel mj_objectArrayWithKeyValuesArray:[dictionary objectForKey:@"Data"]];
            if (array.count == 15) {
                self.mainTableView.mj_footer.hidden = NO;
            }else{
                self.mainTableView.mj_footer.hidden = YES;
            }
            if (array.count == 0) {
                [self.view addSubview:self.noDataTipView];
            }else{
                [self.noDataTipView removeFromSuperview];
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
    HXMajorModel *selectMajorModel = [HXPublicParamTool sharedInstance].selectMajorModel;
    NSDictionary *dic = @{
        @"version_id":HXSafeString(selectMajorModel.versionId),
        @"major_id":HXSafeString(selectMajorModel.major_id),
        @"pageIndex":@(self.pageIndex),
        @"pageSize":@(15),
        @"keyValue":@""
    };
    
    [HXBaseURLSessionManager postDataWithNSString:HXPOST_GetLiveList  withDictionary:dic success:^(NSDictionary * _Nonnull dictionary) {
        [self.mainTableView.mj_footer endRefreshing];
        BOOL success = [dictionary boolValueForKey:@"Success"];
        if (success) {
            NSArray *array = [HXLiveBroadcastModel mj_objectArrayWithKeyValuesArray:[dictionary objectForKey:@"Data"]];
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
//搜索
-(void)search:(UIButton *)sender{
    self.keyValue = self.searchTextField.text;
    self.isSearchMode = YES;
    [self.view endEditing:YES];
    HXMajorModel *selectMajorModel = [HXPublicParamTool sharedInstance].selectMajorModel;
    NSDictionary *dic = @{
        @"version_id":HXSafeString(selectMajorModel.versionId),
        @"major_id":HXSafeString(selectMajorModel.major_id),
        @"pageIndex":@(1),
        @"pageSize":@(100),
        @"keyValue":HXSafeString(self.keyValue)
    };

    [HXBaseURLSessionManager postDataWithNSString:HXPOST_GetLiveList  withDictionary:dic success:^(NSDictionary * _Nonnull dictionary) {

        [self.mainTableView.mj_header endRefreshing];
        BOOL success = [dictionary boolValueForKey:@"Success"];
        if (success) {
            NSArray *array = [HXLiveBroadcastModel mj_objectArrayWithKeyValuesArray:[dictionary objectForKey:@"Data"]];
            [self.searchArray removeAllObjects];
            [self.searchArray addObjectsFromArray:array];
            [self.mainTableView reloadData];
            [self.mainTableView setContentOffset:CGPointZero animated:NO];
        }
    } failure:^(NSError * _Nonnull error) {

        [self.mainTableView.mj_header endRefreshing];
    }];
    
}


#pragma mark - Event
///扫码
-(void)scanQRCode:(UIButton *)sender{
    HXScanQRCodeViewController *vc = [[HXScanQRCodeViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
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
    return 90;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *liveBroadCastCellIdentifier = @"HXLiveBroadCastCellIdentifier";
    HXLiveBroadCastCell *cell = [tableView dequeueReusableCellWithIdentifier:liveBroadCastCellIdentifier];
    if (!cell) {
        cell = [[HXLiveBroadCastCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:liveBroadCastCellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.liveBroadcastModel = (self.isSearchMode?self.searchArray[indexPath.row]:self.dataArray[indexPath.row]);
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HXLiveBroadcastModel *liveBroadcastModel = (self.isSearchMode?self.searchArray[indexPath.row]:self.dataArray[indexPath.row]);
    if (liveBroadcastModel.isLive == 1) {
        HXCommonWebViewController *webViewVC = [[HXCommonWebViewController alloc] init];
        webViewVC.urlString = liveBroadcastModel.liveUrl;
        webViewVC.cuntomTitle = liveBroadcastModel.liveName;
        webViewVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:webViewVC animated:YES];
    }else{
        [self.view showTostWithMessage:@"暂未开播"];
    }
}


#pragma mark - UI
-(void)createUI{
    self.sc_navigationBar.leftBarButtonItem = nil;
    self.sc_navigationBar.backGroundImage = [UIImage imageNamed:@"navbar_bg"];
    self.sc_navigationBar.title = @"直播";
    self.sc_navigationBar.titleColor = [UIColor whiteColor];
    
    [self.view addSubview:self.topView];
    [self.topView addSubview:self.searchImageView];
    [self.topView addSubview:self.searchContainerView];
    [self.searchContainerView addSubview:self.searchTextField];
    [self.searchContainerView addSubview:self.scanBtn];
    [self.topView addSubview:self.searchBtn];
    [self.view addSubview:self.mainTableView];
    
    self.topView.sd_layout
    .topSpaceToView(self.view, kNavigationBarHeight)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .heightIs(70);
    
    self.searchImageView.sd_layout
    .centerYEqualToView(self.topView)
    .leftSpaceToView(self.topView, 20)
    .widthIs(24)
    .heightEqualToWidth();
    
    self.searchBtn.sd_layout
    .centerYEqualToView(self.topView)
    .rightSpaceToView(self.topView, 20)
    .widthIs(50)
    .heightIs(30);
    
    self.searchContainerView.sd_layout
    .centerYEqualToView(self.topView)
    .leftSpaceToView(self.searchImageView, 12)
    .rightSpaceToView(self.searchBtn, 6)
    .heightIs(30);
    self.searchContainerView.sd_cornerRadiusFromHeightRatio = @0.5;
    
    self.scanBtn.sd_layout
    .centerYEqualToView(self.searchContainerView)
    .rightEqualToView(self.searchContainerView)
    .widthIs(44)
    .heightRatioToView(self.searchContainerView, 1);
    
    self.scanBtn.imageView.sd_layout
    .centerYEqualToView(self.scanBtn)
    .centerXEqualToView(self.scanBtn)
    .widthIs(12)
    .heightEqualToWidth();
    
    self.searchTextField.sd_layout
    .centerYEqualToView(self.searchContainerView)
    .leftEqualToView(self.searchContainerView)
    .rightSpaceToView(self.scanBtn, 0)
    .heightRatioToView(self.searchContainerView, 1);
    self.searchTextField.sd_cornerRadiusFromHeightRatio = @0.5;
    
    self.mainTableView.sd_layout
    .topSpaceToView(self.topView, 0)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomSpaceToView(self.view, kTabBarHeight);
    
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
-(UIView *)topView{
    if (!_topView) {
        _topView = [[UIView alloc] init];
        _topView.backgroundColor = [UIColor whiteColor];
    }
    return _topView;
}

-(UIView *)searchContainerView{
    if (!_searchContainerView) {
        _searchContainerView = [[UIView alloc] init];
        _searchContainerView.backgroundColor = [UIColor whiteColor];
        _searchContainerView.layer.borderWidth = 1;
        _searchContainerView.layer.borderColor = COLOR_WITH_ALPHA(0x5699FF, 1).CGColor;
    }
    return _searchContainerView;
}


-(UIImageView *)searchImageView{
    if (!_searchImageView) {
        _searchImageView = [[UIImageView alloc] init];
        _searchImageView.image = [UIImage imageNamed:@"bluesearch_icon"];
    }
    return _searchImageView;
}

-(UITextField *)searchTextField{
    if (!_searchTextField) {
        _searchTextField = [[UITextField alloc] init];
        _searchTextField.font = HXFont(12);
        _searchTextField.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"输入房间号\\主播名\\课程名" attributes:
                                          @{NSForegroundColorAttributeName:COLOR_WITH_ALPHA(0xACACAC, 1),
                                            NSFontAttributeName:_searchTextField.font
                                          }];
        _searchTextField.attributedPlaceholder = attrString;
        _searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 18, 30)];
        _searchTextField.leftView = leftView;
        _searchTextField.leftViewMode = UITextFieldViewModeAlways;
        _searchTextField.delegate = self;
        _searchTextField.returnKeyType = UIReturnKeySearch;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChangeNotification:) name:UITextFieldTextDidChangeNotification object:_searchTextField];
    }
    return _searchTextField;;
}

-(UIButton *)searchBtn{
    if (!_searchBtn) {
        _searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _searchBtn.titleLabel.font = HXFont(12);
        [_searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
        [_searchBtn setTitleColor:COLOR_WITH_ALPHA(0x5699FF, 1) forState:UIControlStateNormal];
        [_searchBtn addTarget:self action:@selector(search:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _searchBtn;
}

-(UIButton *)scanBtn{
    if (!_scanBtn) {
        _scanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_scanBtn setImage:[UIImage imageNamed:@"scan_icon"] forState:UIControlStateNormal];
        [_scanBtn addTarget:self action:@selector(scanQRCode:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _scanBtn;
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

-(HXNoDataTipView *)noDataTipView{
    if (!_noDataTipView) {
        _noDataTipView = [[HXNoDataTipView alloc] initWithFrame:self.mainTableView.bounds];
        _noDataTipView.tipTitle = @"暂时还没有直播哦~";
    }
    return _noDataTipView;
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
