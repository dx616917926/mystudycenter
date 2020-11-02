//
//  TXCatalogListViewController.m
//  TXMoviePlayer
//
//  Created by Mac on 2019/5/23.
//  Copyright © 2019 华夏大地教育网. All rights reserved.
//

#import "TXCatalogListViewController.h"
#import "TXCatalogListViewCell.h"
#import "DownloadManager.h"

@interface TXCatalogListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong) UITableView *tableView;

/// 下载管理的按钮
@property (nonatomic, strong) UIButton *downloadManagerButton;

/**
所有DownloadSource的字典
*/
@property(nonatomic, strong) NSMutableDictionary *allDoneVideoDictionary;


@end

@implementation TXCatalogListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupData];
    
    [self setupViews];
}

- (void)setupData {
    //准备已下载的视频数据
    if (self.canDownload) {
        NSMutableArray *doneVideoArray = [NSMutableArray arrayWithArray:DEFAULT_DM.doneSources];
        self.allDoneVideoDictionary = [NSMutableDictionary dictionary];
        for (DownloadSource *source in doneVideoArray) {
            [self.allDoneVideoDictionary setObject:source forKey:source.catalogID];
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateDownloadSource:) name:TXDownloadSourceCompleteNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteDownloadSource:) name:TXDownloadSourceDeleteNotification object:nil];
    }
}

-(void)setupViews
{
    self.tableView                 = [[UITableView alloc] init];
    self.tableView.delegate        = self;
    self.tableView.dataSource      = self;
    self.tableView.cellLayoutMarginsFollowReadableWidth = NO;
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[TXCatalogListViewCell class] forCellReuseIdentifier:@"TXCatalogListViewCell"];

    [self.view addSubview:self.tableView];
    
    //是否显示下载按钮
    if (self.canDownload) {
        [self.view addSubview:self.downloadManagerButton];
        
        [self.downloadManagerButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.left.bottom.offset(0);
            make.height.mas_equalTo(49);
        }];
        
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.offset(0);
            make.bottom.mas_equalTo(self.downloadManagerButton.mas_top);
        }];
    }else
    {
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
    }
}

- (UIButton *)downloadManagerButton {
    if (!_downloadManagerButton) {
        _downloadManagerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_downloadManagerButton setTitle:@"下载管理" forState:UIControlStateNormal];
        _downloadManagerButton.backgroundColor = [UIColor colorWithRed:0.29 green:0.53 blue:0.95 alpha:1.00];
        [_downloadManagerButton addTarget:self action:@selector(downloadManagerButtonCliecked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _downloadManagerButton;
}

- (void)downloadManagerButtonCliecked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(downloadManagerButtonCliecked)]) {
        [self.delegate downloadManagerButtonCliecked];        
    }
}

- (void)setCatalogArray:(NSArray<TXCatalog *> *)catalogArray {
 
    _catalogArray = catalogArray;
    
    [self.tableView reloadData];
    
    [self setTableHeaderView];
}

- (void)updateDownloadSource:(NSNotification *)notification {
    
    //更新下载数据
    DownloadSource *source = notification.object;
    [self.allDoneVideoDictionary setObject:source forKey:source.catalogID];
    [self.tableView reloadData];
}

- (void)deleteDownloadSource:(NSNotification *)notification {
    
    //删除下载数据
    DownloadSource *source = notification.object;
    [self.allDoneVideoDictionary removeObjectForKey:source.catalogID];
    [self.tableView reloadData];
}

/**
 准备播放指定章节

 @param catalog 章节
 */
- (void)prepareToPlayCatalog:(TXCatalog *)catalog {
    
    [self prepareToPlayCatalog:catalog scrollToPostion:YES];
}

/**
 准备播放指定章节

 @param catalog 章节
 @param scroll 是否滚动显示到当前章节
 */
- (void)prepareToPlayCatalog:(TXCatalog *)catalog scrollToPostion:(BOOL)scroll
{
    _currentCatalog = catalog;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectCatalog:)]) {
        [self.delegate didSelectCatalog:catalog];
    }
    
    [self.tableView reloadData];
    
    //是否滚动显示到当前行
    if (scroll) {
        BOOL find = NO;
        int row = 0;
        for (int i = 0; i<self.catalogArray.count; i++) {
            TXCatalog *catalog = [self.catalogArray objectAtIndex:i];
            if ([self.currentCatalog.ID isEqualToString:catalog.ID]) {
                find = YES;
                row = i;
                break;
            }
        }
        if (find) {
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        }
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

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.catalogArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TXCatalogListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TXCatalogListViewCell" forIndexPath:indexPath];

    TXCatalog *catalog = [self.catalogArray objectAtIndex:indexPath.row];
    
    cell.catalogModel = catalog;
    
    //点击播放与当前播放一致
    cell.isSelected = [self.currentCatalog.ID isEqualToString:catalog.ID];
    
    //是否已经下载
    DownloadSource *source = [self.allDoneVideoDictionary objectForKey:catalog.ID];
    if (source) {
        cell.isDownload = YES;
    }
    
    [cell setNeedsLayout];
    [cell layoutIfNeeded];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TXCatalog *catalog = [self.catalogArray objectAtIndex:indexPath.row];
    
    //点击播放与当前播放一致
    if ([self.currentCatalog.ID isEqualToString:catalog.ID]) {
        return;
    }
    if (catalog.isMedia) {
        //准备播放指定章节，不进行滚动显示操作
        [self prepareToPlayCatalog:catalog scrollToPostion:NO];
    }
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
