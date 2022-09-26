//
//  HXSearchKeChengViewController.m
//  HXMinedu
//
//  Created by mac on 2022/8/12.
//

#import "HXSearchKeChengViewController.h"
#import "HXKeChengListViewController.h"
#import "HXHuiFangListViewController.h"
#import "HXMianShouListViewController.h"
#import "HXCommonWebViewController.h"
#import "HXKeChengCell.h"


@interface HXSearchKeChengViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property(nonatomic,strong) UIView *searchContainerView;
@property(nonatomic,strong) UITextField *searchTextField;
@property (nonatomic, strong) UIButton *cancelBtn;

@property(nonatomic,strong) UITableView *mainTableView;

@property(nonatomic,strong) UIView *noDataView;

@property(nonatomic,strong) NSMutableArray *searchArray;
@property(nonatomic,assign) NSInteger pageIndex;

@end

@implementation HXSearchKeChengViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //UI
    [self createUI];
}

-(void)dealloc{
    [HXNotificationCenter removeObserver:self];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

#pragma mark - Event
-(void)cancel:(UIButton *)sender{
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 搜索结果
-(void)loadData{
    if ([HXCommonUtil isNull:self.searchTextField.text]) {
        [self.searchArray removeAllObjects];
        [self.mainTableView reloadData];
        return;
    }
    
    self.pageIndex = 1;
    NSDictionary *dic = @{
        @"keyValue":HXSafeString(self.searchTextField.text),
        @"pageIndex":@(self.pageIndex),
        @"pageSize":@(15),
        @"type":@(self.type)//1全部课程 2回放
    };

    [HXBaseURLSessionManager postDataWithNSString:HXPOST_GetOnliveMealList  withDictionary:dic success:^(NSDictionary * _Nonnull dictionary) {
       
        [self.mainTableView.mj_header endRefreshing];
        BOOL success = [dictionary boolValueForKey:@"Success"];
        NSDictionary *data = [dictionary objectForKey:@"Data"];
        if (success) {
            NSArray *array = [HXKeChengModel mj_objectArrayWithKeyValuesArray:[data objectForKey:@"t_OnliveMealList_app"]];
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
            [self.searchArray removeAllObjects];
            [self.searchArray addObjectsFromArray:array];
            [self.mainTableView reloadData];
        }
    } failure:^(NSError * _Nonnull error) {
       
        [self.mainTableView.mj_header endRefreshing];
    }];
}

-(void)loadMoreData{
    
    self.pageIndex++;
    NSDictionary *dic = @{
        @"keyValue":HXSafeString(self.searchTextField.text),
        @"pageIndex":@(self.pageIndex),
        @"pageSize":@(15),
        @"type":@(self.type)//1全部课程 2回放
    };
    
    [HXBaseURLSessionManager postDataWithNSString:HXPOST_GetOnliveMealList  withDictionary:dic success:^(NSDictionary * _Nonnull dictionary) {
        [self.mainTableView.mj_footer endRefreshing];
        BOOL success = [dictionary boolValueForKey:@"Success"];
        NSDictionary *data = [dictionary objectForKey:@"Data"];
        if (success) {
            NSArray *array = [HXKeChengModel mj_objectArrayWithKeyValuesArray:[data objectForKey:@"t_OnliveMealList_app"]];
            if (array.count == 15) {
                self.mainTableView.mj_footer.hidden = NO;
            }else{
                self.mainTableView.mj_footer.hidden = YES;
            }
            [self.searchArray addObjectsFromArray:array];
            [self.mainTableView reloadData];
        }
    } failure:^(NSError * _Nonnull error) {
        [self.mainTableView.mj_footer endRefreshing];
        self.pageIndex--;
    }];
}

#pragma mark - NSNotification
-(void)textFieldTextDidChangeNotification:(NSNotification *)not{
    [self loadData];
}

#pragma mark -<UITextFieldDelegate>
- (BOOL)textFieldShouldClear:(UITextField *)textField{
    [self.noDataView removeFromSuperview];
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    [self loadData];
    return YES;
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

#pragma mark - <UITableViewDelegate,UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.searchArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *keChengCellIdentifier = @"HXKeChengCellIdentifier";
    HXKeChengCell *cell = [tableView dequeueReusableCellWithIdentifier:keChengCellIdentifier];
    if (!cell) {
        cell = [[HXKeChengCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:keChengCellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.keChengModel = self.searchArray[indexPath.row];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HXKeChengModel *keChengModel = self.searchArray[indexPath.row];
    ///直播类型 1ClassIn   2保利威     保利威直接跳转页面直播     ClassIn进入下一页面展示课节
    if (keChengModel.LiveType==1) {
        //1全部课程   2回放
        if (self.type==1) {
            HXKeChengListViewController *vc= [[HXKeChengListViewController alloc] init];
            vc.MealName = keChengModel.MealName;
            vc.mealGuid = keChengModel.MealGuid;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            HXHuiFangListViewController *vc= [[HXHuiFangListViewController alloc] init];
            vc.MealName = keChengModel.MealName;
            vc.mealGuid = keChengModel.MealGuid;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if (keChengModel.LiveType==3) {
        HXMianShouListViewController *vc= [[HXMianShouListViewController alloc] init];
        vc.MealName = keChengModel.MealName;
        vc.mealGuid = keChengModel.MealGuid;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (keChengModel.LiveType==2) {
        HXCommonWebViewController *webViewVC = [[HXCommonWebViewController alloc] init];
        webViewVC.urlString = keChengModel.liveUrl;
        webViewVC.cuntomTitle = keChengModel.MealName;
        webViewVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:webViewVC animated:YES];
    }
}



#pragma mark - UI
-(void)createUI{
    self.sc_navigationBar.title = @"搜索";
    
    [self.view addSubview:self.searchContainerView];
    
    [self.searchContainerView addSubview:self.cancelBtn];
    [self.searchContainerView addSubview:self.searchTextField];
    
    [self.view addSubview:self.mainTableView];
    
    
    self.searchContainerView.sd_layout
    .topSpaceToView(self.view, kNavigationBarHeight+20)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .heightIs(50);
    
    
    self.searchTextField.sd_layout
    .centerYEqualToView(self.searchContainerView)
    .leftSpaceToView(self.searchContainerView, 15)
    .rightSpaceToView(self.searchContainerView, 60)
    .heightIs(42);
    self.searchTextField.sd_cornerRadiusFromHeightRatio = @0.5;
    
    self.cancelBtn.sd_layout
    .centerYEqualToView(self.searchTextField)
    .leftSpaceToView(self.searchTextField, 5)
    .rightEqualToView(self.searchContainerView)
    .heightIs(40);
    
    self.mainTableView.sd_layout
    .topSpaceToView(self.searchContainerView, 5)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomSpaceToView(self.view, 0);
    [self.mainTableView updateLayout];
    

}


#pragma mark - LazyLoad
-(NSMutableArray *)searchArray{
    if (!_searchArray) {
        _searchArray = [NSMutableArray array];
    }
    return _searchArray;
}


-(UIView *)searchContainerView{
    if (!_searchContainerView) {
        _searchContainerView = [[UIView alloc] init];
        _searchContainerView.backgroundColor = [UIColor clearColor];
    }
    return  _searchContainerView;
}

-(UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBtn.titleLabel.font = HXFont(16);
        [_cancelBtn setTitleColor:COLOR_WITH_ALPHA(0x5699FF, 1) forState:UIControlStateNormal];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

-(UITextField *)searchTextField{
    if (!_searchTextField) {
        _searchTextField = [[UITextField alloc] init];
        _searchTextField.font = HXFont(14);
        _searchTextField.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"请输入课程名称" attributes:
                                          @{NSForegroundColorAttributeName:COLOR_WITH_ALPHA(0xC0C7D2, 1),
                                            NSFontAttributeName:_searchTextField.font
                                          }];
        _searchTextField.attributedPlaceholder = attrString;
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
        _searchTextField.returnKeyType = UIReturnKeySearch;
        [HXNotificationCenter addObserver:self selector:@selector(textFieldTextDidChangeNotification:) name:UITextFieldTextDidChangeNotification object:_searchTextField];
    }
    return _searchTextField;;
}

- (UITableView *)mainTableView {
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _mainTableView.showsVerticalScrollIndicator = NO;
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.bounces = YES;
        _mainTableView.backgroundColor = COLOR_WITH_ALPHA(0xFFFFFF, 1);
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if ([_mainTableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_mainTableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
        self.extendedLayoutIncludesOpaqueBars = YES;
        if (@available(iOS 11.0, *)) {
            _mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _mainTableView.estimatedRowHeight = 0;
            _mainTableView.estimatedSectionHeaderHeight = 0.0;
            _mainTableView.estimatedSectionFooterHeight = 0.0;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        _mainTableView.contentInset = UIEdgeInsetsMake(0, 0, kScreenBottomMargin, 0);
        _mainTableView.scrollIndicatorInsets = _mainTableView.contentInset;
        
    }
    return _mainTableView;
}


-(UIView *)noDataView{
    if(!_noDataView){
        _noDataView = [[UIView alloc] initWithFrame:self.mainTableView.frame];
        _noDataView.backgroundColor = UIColor.whiteColor;
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"nokecheng_icon"];
        [_noDataView addSubview:imageView];
        
        UILabel *tipLabel = [[UILabel alloc] init];
        tipLabel.font = HXFont(16);
        tipLabel.textColor = COLOR_WITH_ALPHA(0x4988FD, 1);
        tipLabel.textAlignment = NSTextAlignmentCenter;
        tipLabel.text = @"暂无课程";
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



@end
