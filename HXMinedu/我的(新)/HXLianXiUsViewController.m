//
//  HXLianXiUsViewController.m
//  HXMinedu
//
//  Created by mac on 2022/8/24.
//

#import "HXLianXiUsViewController.h"
#import "HXLianXiCell.h"
#import "SDWebImage.h"

@interface HXLianXiUsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,strong)  UITableView *mainTableView;
@property(nonatomic,strong) UIImageView *logoViewImageView;

@property (nonatomic, strong) HXContactDetailsModel *selectContactDetailsModel;

@end

@implementation HXLianXiUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //处理数据
    [self processData];
    //UI
    [self createUI];
}

#pragma mark -处理数据
-(void)processData{
    self.selectContactDetailsModel = [HXPublicParamTool sharedInstance].selectContactDetailsModel;
    [self.dataArray removeAllObjects];
    [self.selectContactDetailsModel.contactDetailsList enumerateObjectsUsingBlock:^(HXContactModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        HXContactModel *model = obj;
        model.title = [NSString stringWithFormat:@"联系电话%lu",(unsigned long)(idx+1)];
        [self.dataArray addObject:model];
    }];
    
    [self.selectContactDetailsModel.contactEmailList enumerateObjectsUsingBlock:^(HXContactModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        HXContactModel *model = obj;
        model.title = [NSString stringWithFormat:@"联系邮箱%lu",(unsigned long)(idx+1)];
        [self.dataArray addObject:model];
    }];
    
    [self.mainTableView reloadData];
}

#pragma mark - <UITableViewDelegate,UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return  self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 47;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *lianXiCellIdentifier = @"HXLianXiCellIdentifier";
    HXLianXiCell *cell = [tableView dequeueReusableCellWithIdentifier:lianXiCellIdentifier];
    if (!cell) {
        cell = [[HXLianXiCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lianXiCellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contactModel = self.dataArray[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - UI
-(void)createUI{
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.sc_navigationBar.title = @"联系我们";
    [self.view addSubview:self.logoViewImageView];
    [self.view addSubview:self.mainTableView];
    
    self.logoViewImageView.sd_layout
    .bottomSpaceToView(self.view, 32+kScreenBottomMargin)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .heightIs(48);
    self.logoViewImageView.sd_cornerRadius = @6;
    
    self.mainTableView.sd_layout
    .topSpaceToView(self.view, kNavigationBarHeight)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomSpaceToView(self.logoViewImageView, 30);
    
    [self.logoViewImageView sd_setImageWithURL:[NSURL URLWithString:HXSafeString([HXPublicParamTool sharedInstance].jiGouLogoUrl)] placeholderImage:[UIImage imageNamed:@"xuexi_logo"] options:SDWebImageRefreshCached];
    
}



#pragma mark - lazyLoad
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
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
        _mainTableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
        _mainTableView.scrollIndicatorInsets = _mainTableView.contentInset;
        _mainTableView.showsVerticalScrollIndicator = NO;
    }
    return _mainTableView;
}

-(UIImageView *)logoViewImageView{
    if (!_logoViewImageView) {
        _logoViewImageView = [[UIImageView alloc] init];
        _logoViewImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _logoViewImageView;
}

@end
