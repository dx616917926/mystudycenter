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

@end

@implementation HXPictureInforConfirmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //UI
    [self createUI];
    
   
    
}
#pragma mark - Event
//切换专业
-(void)selectType:(UIControl *)sender{
    
    HXSelectStudyTypeViewController *vc =[[HXSelectStudyTypeViewController alloc] init];
    //选择完成回调
    WeakSelf(weakSelf)
    vc.selectFinishCallBack = ^(HXVersionModel * _Nonnull selectVersionModel, HXMajorModel * _Nonnull selectMajorModel) {
        StrongSelf(strongSelf)
        strongSelf.majorLabel.text = selectMajorModel.majorName;
        [HXPublicParamTool sharedInstance].selectMajorModel = selectMajorModel;
    };
    [self presentViewController:vc animated:YES completion:nil];
}

///切换资料
-(void)ziLiaoSwitch:(UIButton *)sender{
    
    [self.commonSelectView show];
    self.commonSelectView.dataArray = @[];
    self.commonSelectView.title = @"选择资料类型";
    WeakSelf(weakSelf);
    self.commonSelectView.seletConfirmBlock = ^(HXCommonSelectModel * _Nonnull selectModel) {
        StrongSelf(strongSelf);
        ///
        
       
        
       
    };
}


#pragma mark - <UITableViewDelegate,UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return  5;
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    HXZiLiaoInfoViewController *vc = [[HXZiLiaoInfoViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UI
-(void)createUI{
    self.sc_navigationBar.titleView = self.majorSwitchControl;
    
    HXMajorModel *selectMajorModel = [HXPublicParamTool sharedInstance].selectMajorModel;
    self.majorLabel.text = selectMajorModel.majorName;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.mainTableView];
    self.mainTableView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(kNavigationBarHeight, 0, 0, 0));
   
}


#pragma mark - lazyLoad
-(UITableView *)mainTableView{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _mainTableView.bounces = NO;
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
