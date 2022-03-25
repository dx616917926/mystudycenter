//
//  HXZiLiaoInfoViewController.m
//  HXMinedu
//
//  Created by mac on 2021/12/8.
//

#import "HXZiLiaoInfoViewController.h"
#import "HXConfirmViewController.h"
#import "HXInfoConfirmCell.h"
#import "HXCommonSelectView.h"
#import "HXNoDataTipView.h"

@interface HXZiLiaoInfoViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)  UITableView *mainTableView;

@property (nonatomic,strong)  UIView *tableHeaderView;
@property (nonatomic,strong)  UILabel *ziLiaoTitleLabel;
@property (nonatomic,strong)  UIButton *ziLiaoSwitchBtn;

@property(strong,nonatomic)   HXNoDataTipView *noDataTipView;

@property(nonatomic,strong) UIControl *majorSwitchControl;///汉语言文学
@property(nonatomic,strong) UILabel *majorLabel;
@property(nonatomic,strong) UIImageView *triangleImageView;

@property(nonatomic,strong) HXCommonSelectView *commonSelectView;

//选择的专业
@property(nonatomic,strong) HXCommonSelectModel *selectMajorModel;
//选择的资料
@property(nonatomic,strong) HXCommonSelectModel *selectFileTypeModel;
@property(nonatomic,strong) NSMutableArray *fileTypeList;
@property(nonatomic,strong) NSMutableArray *photoInfoList;

@end

@implementation HXZiLiaoInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //UI
    [self createUI];
    //获取机构资料类型
    [self getFileTypeList];
}

#pragma mark - Setter
-(void)setMajorList:(NSArray<HXCommonSelectModel *> *)majorList{
    _majorList = majorList;
    [majorList enumerateObjectsUsingBlock:^(HXCommonSelectModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.isSelected) {
            self.selectMajorModel = obj;
            *stop = YES;
            return;
        }
    }];
    if (self.selectMajorModel==nil) {
        self.selectMajorModel = self.majorList.firstObject;
    }
}

-(void)setSelectFileTypeName:(NSString *)selectFileTypeName{
    _selectFileTypeName = selectFileTypeName;
}

#pragma mark - 获取机构资料类型
-(void)getFileTypeList{
    NSDictionary *dic = @{
        @"version_id":HXSafeString(self.selectMajorModel.version_id),
        @"major_id":HXSafeString(self.selectMajorModel.major_id),
        @"type":@(self.selectMajorModel.type)
    };
    [self.noDataTipView removeFromSuperview];
    [HXBaseURLSessionManager postDataWithNSString:HXPOST_GetFileTypeList withDictionary:dic success:^(NSDictionary * _Nonnull dictionary) {
        BOOL success = [dictionary boolValueForKey:@"Success"];
        if (success) {
            NSArray *list = [HXCommonSelectModel mj_objectArrayWithKeyValuesArray:[dictionary objectForKey:@"Data"]];
            [self.fileTypeList removeAllObjects];
            [self.fileTypeList addObjectsFromArray:list];
            if (self.fileTypeList.count>0&&![HXCommonUtil isNull:self.selectFileTypeName]) {
                //有初始选择
                [self.fileTypeList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    HXCommonSelectModel *model = obj;
                    if ([model.text isEqualToString:self.selectFileTypeName]) {
                        self.selectFileTypeModel = model;
                        self.selectFileTypeModel.isSelected = YES;
                        self.ziLiaoTitleLabel.text = self.selectFileTypeModel.text;
                        //获取学生图片信息V3
                        [self getStudentFileV3];
                        *stop = YES;
                        return;
                    }
                }];
                ///有初始选择,默认选择第一个
                if (self.selectFileTypeModel==nil) {
                    self.selectFileTypeModel = self.fileTypeList.firstObject;
                    self.selectFileTypeModel.isSelected = YES;
                    //获取学生图片信息V3
                    [self getStudentFileV3];
                }
            }
        }
    } failure:^(NSError * _Nonnull error) {
       
    }];
    
}

#pragma mark - 获取学生图片信息V3
-(void)getStudentFileV3{
    NSDictionary *dic = @{
        @"version_id":HXSafeString(self.selectMajorModel.version_id),
        @"major_id":HXSafeString(self.selectMajorModel.major_id),
        @"type":@(self.selectMajorModel.type),
        @"reserve":HXSafeString(self.selectFileTypeModel.value)
    };
    [self.noDataTipView removeFromSuperview];
    [HXBaseURLSessionManager postDataWithNSString:HXPOST_GetStudentFileV3 withDictionary:dic success:^(NSDictionary * _Nonnull dictionary) {
        [self.mainTableView.mj_header endRefreshing];
        BOOL success = [dictionary boolValueForKey:@"Success"];
        if (success) {
            NSArray *list = [HXPictureInfoModel mj_objectArrayWithKeyValuesArray:[dictionary objectForKey:@"Data"]];
            [self.photoInfoList removeAllObjects];
            [self.photoInfoList addObjectsFromArray:list];
            [self.mainTableView reloadData];
        }else{
            [self.view addSubview:self.noDataTipView];
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
            //获取机构资料类型
            [strongSelf getFileTypeList];
        };
    }
}

///切换资料
-(void)ziLiaoSwitch:(UIButton *)sender{
    
    if (self.fileTypeList.count>0) {
        [self.commonSelectView show];
        self.commonSelectView.dataArray = self.fileTypeList;
        self.commonSelectView.title = @"选择资料类型";
        WeakSelf(weakSelf);
        self.commonSelectView.seletConfirmBlock = ^(HXCommonSelectModel * _Nonnull selectModel) {
            StrongSelf(strongSelf);
            strongSelf.selectFileTypeModel = selectModel;
            strongSelf.ziLiaoTitleLabel.text = strongSelf.selectFileTypeModel.text;
            //获取学生图片信息V3
            [strongSelf getStudentFileV3];

        };
    }
    
}


#pragma mark - <UITableViewDelegate,UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return  self.photoInfoList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *infoConfirmCellIdentifier = @"HXInfoConfirmCellIdentifier";
    HXInfoConfirmCell *cell = [tableView dequeueReusableCellWithIdentifier:infoConfirmCellIdentifier];
    if (!cell) {
        cell = [[HXInfoConfirmCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:infoConfirmCellIdentifier];
    }
    cell.pictureInfoModel = self.photoInfoList[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    HXPictureInfoModel *pictureInfoModel = self.photoInfoList[indexPath.row];
    pictureInfoModel.major_id = self.selectMajorModel.major_id;
    pictureInfoModel.version_id = self.selectMajorModel.version_id;
    HXConfirmViewController *confirmVc = [[HXConfirmViewController alloc] init];
    confirmVc.pictureInfoModel = pictureInfoModel;
    WeakSelf(weakSelf)
    confirmVc.refreshInforBlock = ^(NSInteger flag) {
        if (flag == 1) {//已上传待确定
            [weakSelf getStudentFileV3];
        }
        if (flag == 2) {//已确定
            [weakSelf getStudentFileV3];
        }
        [weakSelf.mainTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];

    };
    [self.navigationController pushViewController:confirmVc animated:YES];
}

#pragma mark - UI
-(void)createUI{
    self.sc_navigationBar.titleView = self.majorSwitchControl;
    self.majorLabel.text = self.selectMajorModel.majorName;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.mainTableView];
    self.mainTableView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(kNavigationBarHeight, 0, 0, 0));
    //下拉刷新
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getStudentFileV3)];
    self.mainTableView.mj_header = header;
}


#pragma mark - lazyLoad
-(NSMutableArray *)fileTypeList{
    if (!_fileTypeList) {
        _fileTypeList = [NSMutableArray array];
    }
    return _fileTypeList;
}

-(NSMutableArray *)photoInfoList{
    if (!_photoInfoList) {
        _photoInfoList = [NSMutableArray array];
    }
    return _photoInfoList;
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
        
        [_tableHeaderView addSubview:self.ziLiaoTitleLabel];
        [_tableHeaderView addSubview:self.ziLiaoSwitchBtn];
        
        self.ziLiaoTitleLabel.sd_layout
        .centerYEqualToView(_tableHeaderView)
        .leftSpaceToView(_tableHeaderView, 20)
        .widthIs(120)
        .heightIs(25);
        
        self.ziLiaoSwitchBtn.sd_layout
        .centerYEqualToView(_tableHeaderView)
        .rightSpaceToView(_tableHeaderView, 0)
        .widthIs(60)
        .heightIs(50);
        
        self.ziLiaoSwitchBtn.imageView.sd_layout
        .centerYEqualToView(self.ziLiaoSwitchBtn)
        .rightSpaceToView(self.ziLiaoSwitchBtn, 20)
        .widthIs(21)
        .heightIs(15);
        
    }
    return _tableHeaderView;
}

-(UILabel *)ziLiaoTitleLabel{
    if (!_ziLiaoTitleLabel) {
        _ziLiaoTitleLabel =[[UILabel alloc] init];
        _ziLiaoTitleLabel.font = HXBoldFont(18);
        _ziLiaoTitleLabel.textColor = COLOR_WITH_ALPHA(0x5D5D63, 1);
    }
    return _ziLiaoTitleLabel;
}

-(UIButton *)ziLiaoSwitchBtn{
    if (!_ziLiaoSwitchBtn) {
        _ziLiaoSwitchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_ziLiaoSwitchBtn setImage:[UIImage imageNamed:@"ziliaoswitch_icon"] forState:UIControlStateNormal];
        [_ziLiaoSwitchBtn addTarget:self action:@selector(ziLiaoSwitch:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _ziLiaoSwitchBtn;
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
