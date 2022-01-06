//
//  HXPictureInforConfirmViewController.m
//  HXMinedu
//
//  Created by mac on 2021/12/7.
//

#import "HXPictureInforConfirmViewController.h"
#import "HXSelectStudyTypeViewController.h"
#import "HXZiLiaoInfoViewController.h"
#import "HXZiLiaoCell.h"
#import "HXCommonSelectView.h"
#import "HXNoDataTipView.h"

@interface HXPictureInforConfirmViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)  UITableView *mainTableView;
@property (nonatomic,strong)  UIView *tableHeaderView;
@property(strong,nonatomic)   HXNoDataTipView *noDataTipView;

@property(nonatomic,strong) UIControl *majorSwitchControl;///汉语言文学
@property(nonatomic,strong) UILabel *majorLabel;
@property(nonatomic,strong) UIImageView *triangleImageView;

@property(nonatomic,strong) HXCommonSelectView *commonSelectView;
//选择的专业
@property(nonatomic,strong) HXCommonSelectModel *selectMajorModel;
//专业数据源
@property(nonatomic,strong) NSMutableArray *majorList;
//学生资料数据源
@property(nonatomic,strong) NSMutableArray *fileTypeList;

@end

@implementation HXPictureInforConfirmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //UI
    [self createUI];
    //获取学生所有专业
    [self getAllMajorList];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.majorList.count>0) {
        [self.majorList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            HXCommonSelectModel *model = obj;
            if (model.isSelected) {
                self.selectMajorModel = model;
                self.majorLabel.text = self.selectMajorModel.majorName;
                //重新获取学生资料统计
                [self getFileTypeInfo];
                *stop = YES;
                return;
            }
        }];
    }
    
}

#pragma mark - 获取学生所有专业
-(void)getAllMajorList{
    [HXBaseURLSessionManager postDataWithNSString:HXPOST_GetAllMajorList withDictionary:nil success:^(NSDictionary * _Nonnull dictionary) {
        
        BOOL success = [dictionary boolValueForKey:@"Success"];
        if (success) {
            NSArray *list = [HXCommonSelectModel mj_objectArrayWithKeyValuesArray:[dictionary objectForKey:@"Data"]];
            [self.majorList addObjectsFromArray:list];
            if (self.majorList.count>0) {
                self.selectMajorModel = self.majorList.firstObject;
                self.selectMajorModel.isSelected = YES;
                self.majorLabel.text = self.selectMajorModel.majorName;
                //获取学生资料统计
                [self getFileTypeInfo];
            }
        }
    } failure:^(NSError * _Nonnull error) {
       
    }];
    
}

#pragma mark - 获取学生资料统计
-(void)getFileTypeInfo{
    NSDictionary *dic = @{
        @"version_id":HXSafeString(self.selectMajorModel.version_id),
        @"major_id":HXSafeString(self.selectMajorModel.major_id),
        @"type":@(self.selectMajorModel.type)
    };
    [self.noDataTipView removeFromSuperview];
    [HXBaseURLSessionManager postDataWithNSString:HXPOST_GetFileTypeInfo withDictionary:dic success:^(NSDictionary * _Nonnull dictionary) {
        [self.mainTableView.mj_header endRefreshing];
        BOOL success = [dictionary boolValueForKey:@"Success"];
        if (success) {
            NSArray *list = [HXFileTypeInfoModel mj_objectArrayWithKeyValuesArray:[dictionary objectForKey:@"Data"]];
            [self.fileTypeList removeAllObjects];
            [self.fileTypeList addObjectsFromArray:list];
            if (self.fileTypeList.count>0) {
                [self.mainTableView reloadData];
            }else{
                [self.view addSubview:self.noDataTipView];
            }
        }
    } failure:^(NSError * _Nonnull error) {
        [self.mainTableView.mj_header endRefreshing];
    }];
    
}


#pragma mark - Event
//切换专业
-(void)selectType:(UIControl *)sender{
    
    if (self.majorList.count>0) {
        [self.commonSelectView show];
        self.commonSelectView.dataArray = self.majorList;
        self.commonSelectView.title = @"选择专业";
        WeakSelf(weakSelf);
        self.commonSelectView.seletConfirmBlock = ^(HXCommonSelectModel * _Nonnull selectModel) {
            StrongSelf(strongSelf);
            strongSelf.selectMajorModel = selectModel;
            strongSelf.majorLabel.text = strongSelf.selectMajorModel.majorName;
            //获取学生资料统计
            [strongSelf getFileTypeInfo];
        };
    }
}




#pragma mark - <UITableViewDelegate,UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return  self.fileTypeList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ziLiaoCellIdentifier = @"HXZiLiaoCellIdentifier";
    HXZiLiaoCell *cell = [tableView dequeueReusableCellWithIdentifier:ziLiaoCellIdentifier];
    if (!cell) {
        cell = [[HXZiLiaoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ziLiaoCellIdentifier];
    }
    cell.fileTypeInfoModel = self.fileTypeList[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    HXZiLiaoInfoViewController *vc = [[HXZiLiaoInfoViewController alloc] init];
    vc.majorList = self.majorList;
    HXFileTypeInfoModel *fileTypeInfoModel = self.fileTypeList[indexPath.row];
    vc.selectFileTypeName =fileTypeInfoModel.reserve;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UI
-(void)createUI{
    self.sc_navigationBar.titleView = self.majorSwitchControl;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.mainTableView];
    self.mainTableView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(kNavigationBarHeight, 0, 0, 0));
   
    //下拉刷新
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getFileTypeInfo)];
    self.mainTableView.mj_header = header;
}


#pragma mark - lazyLoad
-(NSMutableArray *)majorList{
    if (!_majorList) {
        _majorList = [NSMutableArray array];
    }
    return _majorList;
}

-(NSMutableArray *)fileTypeList{
    if (!_fileTypeList) {
        _fileTypeList = [NSMutableArray array];
    }
    return _fileTypeList;
}

-(UITableView *)mainTableView{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
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
        _mainTableView.tableHeaderView = self.tableHeaderView;
    }
    return _mainTableView;
}

-(UIView *)tableHeaderView{
    if (!_tableHeaderView) {
        _tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
        UILabel *titleLabel =[[UILabel alloc] init];
        titleLabel.font = HXBoldFont(18);
        titleLabel.textColor = COLOR_WITH_ALPHA(0x5D5D63, 1);
        titleLabel.text = @"资料全览";
        [_tableHeaderView addSubview:titleLabel];
        
//        UIButton *switchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [switchBtn setImage:[UIImage imageNamed:@"ziliaoswitch_icon"] forState:UIControlStateNormal];
//        [_tableHeaderView addSubview:switchBtn];
        
        titleLabel.sd_layout
        .centerYEqualToView(_tableHeaderView)
        .leftSpaceToView(_tableHeaderView, 20)
        .widthIs(120)
        .heightIs(25);
        
//        switchBtn.sd_layout
//        .centerYEqualToView(_tableHeaderView)
//        .rightSpaceToView(_tableHeaderView, 20)
//        .widthIs(21)
//        .heightIs(15);
        
    }
    return _tableHeaderView;
}

-(HXNoDataTipView *)noDataTipView{
    if (!_noDataTipView) {
        _noDataTipView = [[HXNoDataTipView alloc] initWithFrame:self.mainTableView.bounds];
        _noDataTipView.tipTitle = @"暂无数据~";
    }
    return _noDataTipView;
}


-(UIControl *)majorSwitchControl{
    if (!_majorSwitchControl) {
        _majorSwitchControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
        [_majorSwitchControl addSubview:self.majorLabel];
        [_majorSwitchControl addSubview:self.triangleImageView];
        [_majorSwitchControl addTarget:self action:@selector(selectType:) forControlEvents:UIControlEventTouchUpInside];
        
        self.majorLabel.sd_layout
        .centerXEqualToView(_majorSwitchControl).offset(-20)
        .topEqualToView(_majorSwitchControl)
        .heightIs(25);
        [self.majorLabel setSingleLineAutoResizeWithMaxWidth: kScreenWidth-80];
        
        self.triangleImageView.sd_layout
        .leftSpaceToView(self.majorLabel, 3)
        .bottomEqualToView(self.majorLabel).offset(-5)
        .widthIs(6)
        .heightEqualToWidth();
        
    }
    return _majorSwitchControl;
}

-(UILabel *)majorLabel{
    if (!_majorLabel) {
        _majorLabel = [[UILabel alloc] init];
        _majorLabel.font = HXBoldFont(18);
        _majorLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        _majorLabel.textAlignment = NSTextAlignmentCenter;
        _majorLabel.numberOfLines = 1;
        
    }
    return _majorLabel;
}

-(UIImageView *)triangleImageView{
    if (!_triangleImageView) {
        _triangleImageView = [[UIImageView alloc] init];
        _triangleImageView.image = [[UIImage imageNamed:@"white_triangle"] imageWithTintColor:UIColor.blackColor];
        _triangleImageView.hidden = NO;
    }
    return _triangleImageView;
}


-(HXCommonSelectView *)commonSelectView{
    if (!_commonSelectView) {
        _commonSelectView = [[HXCommonSelectView alloc] init];
    }
    return _commonSelectView;
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
