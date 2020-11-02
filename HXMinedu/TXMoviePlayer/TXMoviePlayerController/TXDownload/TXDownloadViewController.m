//
//  TXDownloadViewController.m
//  TXMoviePlayer
//
//  Created by Mac on 2019/10/18.
//  Copyright © 2019 华夏大地教育网. All rights reserved.
//

#import "TXDownloadViewController.h"
#import "TXDownloadViewCell.h"
#import "AFNetworkReachabilityManager.h"
#import "DownloadManager.h"
#import "TXHTTPSessionManager.h"

NSString * const TXDownloadViewPepareToDownloadNotification = @"TXDownloadViewPepareToDownloadNotification";


@interface TXDownloadViewController ()<UITableViewDelegate,UITableViewDataSource,DownloadManagerDelegate>
{
    BOOL checkWIFI;
}
@property(nonatomic, strong) UIView *headerView;
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) UIButton *closeButton;
/**
 正在缓存列表
 */
@property(nonatomic, strong) NSMutableArray <DownloadSource *>*downloadingVideoArray;

/**
 已缓存列表
 */
@property(nonatomic, strong) NSMutableArray <DownloadSource *>*doneVideoArray;

/**
 选中的编辑列表
 */
@property(nonatomic, strong) NSMutableArray <DownloadSource *>*editVideoArray;

/**
所有DownloadSource的字典
*/
@property(nonatomic, strong) NSMutableDictionary *allVideoDictionary;

@end

@implementation TXDownloadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    checkWIFI = YES;
    
    [self setupViews];
    [self loadLocalVideo];
    DEFAULT_DM.delegate = self;
    
    //播放器要下载的某个视频的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(prepareToDownloadNotification:) name:TXDownloadViewPepareToDownloadNotification object:nil];
}

- (void)dealloc
{
    NSLog(@"%s", __func__);
}

-(void)setupViews
{
    //
    self.tableView                 = [[UITableView alloc] init];
    self.tableView.delegate        = self;
    self.tableView.dataSource      = self;
    self.tableView.cellLayoutMarginsFollowReadableWidth = NO;
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithRed:0.968 green:0.976 blue:0.984 alpha:1];
    [self.tableView registerClass:[TXDownloadViewCell class] forCellReuseIdentifier:@"TXDownloadViewCell"];
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(44);
        make.left.right.bottom.offset(0);
    }];
    
    if (IS_iPhoneX) {
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 34, 0);
    }
    
    //
    self.headerView = [[UIView alloc] init];
    self.headerView.backgroundColor = [UIColor whiteColor];
    [self.headerView.layer setShadowColor:[UIColor colorWithRed:0.909 green:0.901 blue:0.917 alpha:1].CGColor];
    [self.headerView.layer setShadowOffset:CGSizeMake(0, 2)];
    [self.headerView.layer setShadowOpacity:0.9];
    [self.view addSubview:self.headerView];
    
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.offset(0);
        make.height.mas_equalTo(44);
    }];
    
    //
    self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.closeButton setImage:[UIImage imageNamed:@"sp_nav_close"] forState:UIControlStateNormal];
    [self.closeButton addTarget:self action:@selector(closeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView addSubview:self.closeButton];
    
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.width.height.mas_equalTo(44);
        make.centerY.offset(0);
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"下载管理";
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textColor = [UIColor blackColor];
    [self.headerView addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.centerX.offset(0);
    }];
}

- (void)loadLocalVideo{
  
    [self.doneVideoArray removeAllObjects];
    [self.downloadingVideoArray removeAllObjects];
    
    self.downloadingVideoArray =  [NSMutableArray arrayWithArray:DEFAULT_DM.downloadingdSources];
    self.doneVideoArray = [NSMutableArray arrayWithArray:DEFAULT_DM.doneSources];
    for (DownloadSource *source in self.downloadingVideoArray) {
        source.downloadStatus = DownloadTypeStoped;
    }
    
    [self.allVideoDictionary removeAllObjects];
    for (DownloadSource *source in self.downloadingVideoArray) {
        [self.allVideoDictionary setObject:source forKey:source.catalogID];
    }
    for (DownloadSource *source in self.doneVideoArray) {
        [self.allVideoDictionary setObject:source forKey:source.catalogID];
    }
    
    [self.tableView reloadData];
}

- (void)setCatalogArray:(NSArray<TXCatalog *> *)catalogArray {
 
    _catalogArray = catalogArray;
    
    [self.tableView reloadData];
    
    [self setTableHeaderView];
}

/// 返回按钮
- (void)closeButtonAction {
    if (self.delegate && [self.delegate respondsToSelector:@selector(closeButtonAction:)]) {
        [self.delegate closeButtonAction:self];
    }
}

-(void)setTableHeaderView
{
    if (self.catalogArray.count == 0) {
        //设置空白界面
        UIView *blankBg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
        UIImageView *logoImg = [[UIImageView alloc]initWithFrame:CGRectMake((kScreenWidth-120)/2, 100, 120, 100)];
        logoImg.image = [UIImage imageNamed:@"ic_no_events"];
        [blankBg addSubview:logoImg];
        UILabel *warnMsg = [[UILabel alloc]initWithFrame:CGRectMake(30, 200, kScreenWidth-60, 80)];
        warnMsg.numberOfLines = 2;
        warnMsg.text = @"暂无数据！";
        warnMsg.textColor = [UIColor colorWithWhite:0.5 alpha:1.000];
        warnMsg.font = [UIFont systemFontOfSize:16];
        warnMsg.textAlignment = NSTextAlignmentCenter;
        [blankBg addSubview:warnMsg];
        [self.tableView setTableHeaderView:blankBg];
        
    }else{
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 8)];
        view.backgroundColor = [UIColor clearColor];
        self.tableView.tableHeaderView = view;
    }
}

#pragma mark - Lazy init

- (NSMutableArray <DownloadSource *>*)downloadingVideoArray{
    if (!_downloadingVideoArray) {
        _downloadingVideoArray = [[NSMutableArray alloc]init];
    }
    return _downloadingVideoArray;
}

- (NSMutableArray <DownloadSource *>*)doneVideoArray{
    if (!_doneVideoArray) {
        _doneVideoArray = [[NSMutableArray alloc]init];
    }
    return _doneVideoArray;
}

- (NSMutableArray <DownloadSource *>*)editVideoArray{
    if (!_editVideoArray) {
        _editVideoArray = [[NSMutableArray alloc]init];
    }
    return _editVideoArray;
}

- (NSMutableDictionary *)allVideoDictionary{
    if (!_allVideoDictionary) {
        _allVideoDictionary = [[NSMutableDictionary alloc] init];
    }
    return _allVideoDictionary;
}

#pragma mark - TXDownloadViewPepareToDownloadNotification

- (void)prepareToDownloadNotification:(NSNotification *)notification {
    
    TXCatalog *catalog = notification.object;
    [self prepareToDownloadCatalog:catalog];
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.catalogArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TXDownloadViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TXDownloadViewCell" forIndexPath:indexPath];

    TXCatalog *catalog = [self.catalogArray objectAtIndex:indexPath.row];
    
    cell.catalogModel = catalog;
    
    //点击播放与当前播放一致
    cell.isSelected = [self.currentCatalog.ID isEqualToString:catalog.ID];
    
    cell.downloadSourceModel = [self.allVideoDictionary objectForKey:catalog.ID];
    
    [cell setNeedsLayout];
    [cell layoutIfNeeded];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TXCatalog *catalog = [self.catalogArray objectAtIndex:indexPath.row];
    
    if (catalog.isMedia) {

        //判断是否已经下载完成、正在下载
        DownloadSource *video = [self.allVideoDictionary objectForKey:catalog.ID];
        if (video) {
            if (video.downloadStatus == DownloadTypeLoading || video.downloadStatus == DownloadTypeWaiting) {
                [DEFAULT_DM stopDownloadSource:video];
                [self.view showTostWithMessage:@"已停止下载"];
                return;
            }
            if (video.downloadStatus == DownloadTypefinish) {
                
                //ActionSheet
                __weak __typeof(self)weakSelf = self;
                NSString *message = [NSString stringWithFormat:@"是否删除该视频？\n%@",video.totalDataString];
                UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleActionSheet];
                if (IS_IPAD) {
                    alertC = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
                }
                UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                    
                    [DEFAULT_DM clearMedia:video];
                    [weakSelf.view showSuccessWithMessage:@"视频已删除"];
                    [weakSelf.doneVideoArray removeObject:video];
                    [weakSelf.allVideoDictionary removeObjectForKey:video.catalogID];
                    [weakSelf.tableView reloadData];
                }];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                }];
                [alertC addAction:confirmAction];
                [alertC addAction:cancelAction];
                [self presentViewController:alertC animated:YES completion:nil];
                return;
            }
        }
        
        //检查网络
        if (checkWIFI) {
            
            if (![AFNetworkReachabilityManager sharedManager].isReachable) {
                //请检查网络
                [[UIApplication sharedApplication].keyWindow showErrorWithMessage:@"请检查网络!"];
            }else if ([AFNetworkReachabilityManager sharedManager].isReachableViaWiFi) {
                //准备下载指定章节
                [self prepareToDownloadCatalog:catalog];
            }else
            {
                //alert
                __weak __typeof(self)weakSelf = self;
                UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"您当前使用的是移动网络，是否继续？" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"继续" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [weakSelf prepareToDownloadCatalog:catalog];
                    self->checkWIFI = NO;
                }];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                }];
                [alertC addAction:confirmAction];
                [alertC addAction:cancelAction];
                [self presentViewController:alertC animated:YES completion:nil];
            }
        }else
        {
            //准备下载指定章节
            [self prepareToDownloadCatalog:catalog];
        }
    }
}

/**
 准备下载指定章节

 @param catalog 章节
 */
- (void)prepareToDownloadCatalog:(TXCatalog *)catalog {
    
    if (!catalog) {
        return;
    }
    
    //请求课件信息
    NSDictionary *param = self.cws_param;
    
    [[UIApplication sharedApplication].keyWindow showLoading];
    
    __weak __typeof(self)weakSelf = self;
    
    [TXHTTPSessionManager requestCatalogInfoWithId:catalog.ID param:param success:^(NSDictionary *dictionary) {
        //
        TXCatalog *item = [TXCatalog mj_objectWithKeyValues:[dictionary objectForKey:@"data"]];

        // 开始下载
        DEFAULT_DM.playAuth = item.media.playAuth;
        
        //每次都创建新的 DownloadSource
        DownloadSource *source = [[DownloadSource alloc]init];
        source.catalogID = item.ID;
        source.vid = item.media.mediaSource;
        source.title = item.title;
        source.coursewareId = weakSelf.coursewareId;
        source.coursewareTitle = weakSelf.coursewareTitle;
        source.classID = weakSelf.classID;
        source.orderNum = catalog.orderNum;
        [DEFAULT_DM clearAllPreparedSources];
        [DEFAULT_DM prepareDownloadSource:source];
        
    } failure:^(NSString *failureMessage) {
        //
        NSLog(@"%@",failureMessage);
        
        [[UIApplication sharedApplication].keyWindow showErrorWithMessage:failureMessage];
    }];
}

#pragma mark DownloadManagerDelegate

/**
 @brief 下载准备完成事件回调
 @param source 下载source指针
 @param info 下载准备完成回调，@see AVPMediaInfo
 */
-(void)downloadManagerOnPrepared:(DownloadSource *)source mediaInfo:(AVPMediaInfo*)info {
   
    NSLog(@"准备下载 ---- \n ");
        
    BOOL find = false;
    for (DownloadSource *item in self.downloadingVideoArray) {
        if (item == source) {
            find = true;
            return;
        }
    }
    if (!find) {
        [self.downloadingVideoArray addObject:source];
    }
    
    [self.allVideoDictionary setObject:source forKey:source.catalogID];
    
    [DEFAULT_DM addDownloadSource:source];
    [DEFAULT_DM startDownloadSource:source];
    
    [[UIApplication sharedApplication].keyWindow showTostWithMessage:@"已开始下载"];
}

/**
 @brief 错误代理回调
 @param source 下载source指针
 @param errorModel 播放器错误描述，参考AliVcPlayerErrorModel
 */
- (void)downloadManagerOnError:(DownloadSource *)source errorModel:(AVPErrorModel *)errorModel {
    
    NSLog(@"下载错误:%@",errorModel.message);
    [[UIApplication sharedApplication].keyWindow showErrorWithMessage:errorModel.message];
    
    source.downloadStatus = DownloadTypeFailed;
    
    [self.tableView reloadData];
}

/**
 @brief 下载进度回调
 @param source 下载source指针
 @param percent 下载进度 0-100
 */
- (void)downloadManagerOnProgress:(DownloadSource *)source percentage:(int)percent {
    
    NSLog(@"~~~~~~~~~~%d",percent);
    source.downloadStatus = DownloadTypeLoading;
}

/**
 @brief 下载完成回调
 @param source 下载source指针
 */
- (void)downloadManagerOnCompletion:(DownloadSource *)source {
    
    if (source) {
        [self.downloadingVideoArray removeObject:source];
        [self.doneVideoArray addObject:source];
        [self.allVideoDictionary setObject:source forKey:source.catalogID];
        [self.tableView reloadData];
        
        NSString *showString = [NSString stringWithFormat:@"%@ %@",source.title,NSLocalizedString(@"下载成功", nil)];
        [self.view showSuccessWithMessage:showString];
    }
}

/**
 下载状态改变回调
 */
- (void)onSourceStateChanged:(DownloadSource *)source {
    [self.tableView reloadData];
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
