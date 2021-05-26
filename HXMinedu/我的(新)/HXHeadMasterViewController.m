//
//  HXHeadMasterViewController.m
//  HXMinedu
//
//  Created by mac on 2021/5/24.
//

#import "HXHeadMasterViewController.h"
#import "SDWebImage.h"
#import "GKPhotoBrowser.h"
#import "HXHeadMasterCell.h"
#import "HXNoDataTipView.h"

@interface HXHeadMasterViewController ()<UITableViewDelegate,UITableViewDataSource,HXHeadMasterCellDelegate>

@property(strong,nonatomic) NSMutableArray *dataArray;

@property(strong,nonatomic) UITableView *mainTableView;
@property(strong,nonatomic) UIView *tableFooterView;
@property(nonatomic,strong) UIImageView *logoViewImageView;
/** 这里用weak是防止GKPhotoBrowser被强引用，导致不能释放 */
@property (nonatomic, weak) GKPhotoBrowser *browser;

@property(nonatomic,strong) HXNoDataTipView *noDataTipView;

@end

@implementation HXHeadMasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
    //获取班主任信息
    [self getHeadTeacherList];
}

#pragma mark -  获取班主任信息
-(void)getHeadTeacherList{
    
    [HXBaseURLSessionManager postDataWithNSString:HXPOST_GetHeadTeacherList   withDictionary:nil success:^(NSDictionary * _Nonnull dictionary) {
        BOOL success = [dictionary boolValueForKey:@"Success"];
        if (success) {
            [self.dataArray addObjectsFromArray:[HXHeadMasterModel mj_objectArrayWithKeyValuesArray:[dictionary objectForKey:@"Data"]]];
            if (self.dataArray.count == 0) {
                [self.view addSubview:self.noDataTipView];
            }else{
                [self.noDataTipView removeFromSuperview];
            }
            [self.mainTableView reloadData];
            NSString *url = [HXPublicParamTool sharedInstance].jiGouLogoUrl;
            [self.logoViewImageView sd_setImageWithURL:[NSURL URLWithString:HXSafeString(url)] placeholderImage:[UIImage imageNamed:@"xuexi_logo"] options:SDWebImageRefreshCached];
        }
    } failure:^(NSError * _Nonnull error) {
        
    }];
}


#pragma mark - <HXHeadMasterCellDelegate>预览大图
-(void)headMasterCell:(HXHeadMasterCell *)cell tapJiGouQRCodeImageView:(UIImageView *)jiGouQRCodeImageView{
    if([HXCommonUtil isNull:cell.headMasterModel.imageUrl]) return;
    NSMutableArray *photos = [NSMutableArray new];
    GKPhoto *photo = [GKPhoto new];
    photo.url = [NSURL URLWithString:cell.headMasterModel.imageUrl];
    photo.sourceImageView = jiGouQRCodeImageView;
    [photos addObject:photo];
    [self.browser resetPhotoBrowserWithPhotos:photos];
    [self.browser showFromVC:self];
}


-(GKPhotoBrowser *)browser{
    if (!_browser) {
        _browser = [GKPhotoBrowser photoBrowserWithPhotos:[NSArray array] currentIndex:0];
        _browser.showStyle = GKPhotoBrowserShowStyleZoom;        // 缩放显示
        _browser.hideStyle = GKPhotoBrowserHideStyleZoomScale;   // 缩放隐藏
        _browser.loadStyle = GKPhotoBrowserLoadStyleIndeterminateMask; // 不明确的加载方式带阴影
        _browser.maxZoomScale = 5.0f;
        _browser.doubleZoomScale = 2.0f;
        _browser.isAdaptiveSafeArea = YES;
        _browser.hidesCountLabel = YES;
        _browser.pageControl.hidden = YES;
        _browser.isScreenRotateDisabled = YES;
        _browser.isHideSourceView = NO;
    }
    return _browser;
}

#pragma mark - <UITableViewDelegate,UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HXHeadMasterModel *headMasterModel = self.dataArray[indexPath.row];
    CGFloat rowHeight = [tableView cellHeightForIndexPath:indexPath
                                                    model:headMasterModel keyPath:@"headMasterModel"
                                                cellClass:([HXHeadMasterCell class])
                                         contentViewWidth:kScreenWidth];
    return rowHeight;
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *headMasterCellIdentifier = @"HXHeadMasterCellIdentifier";
    HXHeadMasterCell *cell = [tableView dequeueReusableCellWithIdentifier:headMasterCellIdentifier];
    if (!cell) {
        cell = [[HXHeadMasterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:headMasterCellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    HXHeadMasterModel *headMasterModel = self.dataArray[indexPath.row];
    cell.headMasterModel = headMasterModel;
    return cell;
}




#pragma mark - UI
-(void)createUI{
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.sc_navigationBar.title = @"班主任名片";
    self.view.backgroundColor = COLOR_WITH_ALPHA(0xFCFCFC, 1);
    [self.view addSubview:self.mainTableView];
    
    self.mainTableView.sd_layout
    .topSpaceToView(self.view, kNavigationBarHeight)
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .bottomEqualToView(self.view);
    
    
}



-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

-(UITableView *)mainTableView{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _mainTableView.bounces = YES;
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.backgroundColor = COLOR_WITH_ALPHA(0xFCFCFC, 1);
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
        _mainTableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
        _mainTableView.scrollIndicatorInsets = _mainTableView.contentInset;
        _mainTableView.showsVerticalScrollIndicator = NO;
        _mainTableView.tableFooterView = self.tableFooterView;
    }
    return _mainTableView;
}

-(UIView *)tableFooterView{
    if (!_tableFooterView) {
        _tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 82)];
        _tableFooterView.backgroundColor = [UIColor clearColor];
        [_tableFooterView addSubview:self.logoViewImageView];
        self.logoViewImageView.sd_layout
        .centerYEqualToView(_tableFooterView)
        .leftSpaceToView(_tableFooterView, 10)
        .rightSpaceToView(_tableFooterView, 10)
        .heightIs(48);
    }
    return _tableFooterView;
}



-(UIImageView *)logoViewImageView{
    if (!_logoViewImageView) {
        _logoViewImageView = [[UIImageView alloc] init];
        _logoViewImageView.contentMode = UIViewContentModeScaleAspectFit;
        _logoViewImageView.image = [UIImage imageNamed:@"xuexi_logo"];
    }
    return _logoViewImageView;
}

-(HXNoDataTipView *)noDataTipView{
    if (!_noDataTipView) {
        _noDataTipView = [[HXNoDataTipView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight, kScreenWidth, kScreenHeight-kNavigationBarHeight)];

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
