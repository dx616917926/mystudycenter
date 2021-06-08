//
//  HXRegistFormViewController.m
//  HXMinedu
//
//  Created by mac on 2021/4/8.
//

#import "HXRegistFormViewController.h"
#import <AFNetworking/AFNetworking.h>
#import <QuickLook/QuickLook.h>
#import "HXRegistFormCell.h"
#import "HXNoDataTipView.h"
#import "HXRegistFormModel.h"

@interface HXRegistFormViewController ()<QLPreviewControllerDataSource,UITableViewDelegate,UITableViewDataSource,HXRegistFormCellDelegate>
@property (nonatomic, strong) UITableView *mainTableView;
@property(nonatomic,strong) HXNoDataTipView *noDataTipView;
@property (nonatomic, strong) NSArray *dataList;

@property (nonatomic, copy) NSString *downLoadUrl;
@property (nonatomic, strong) QLPreviewController *QLController;
@property (nonatomic, copy) NSURL *fileURL;

@end

@implementation HXRegistFormViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //UI
    [self createUI];
    ///获取新生报名表单下载链接
    [self getDownPdf];
    
    self.QLController = [[QLPreviewController alloc] init];
    self.QLController.dataSource = self;
}

#pragma mark - QLPreviewControllerDataSource
/// 文件路径
- (id<QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index {
    return self.fileURL;
}
/// 文件数
- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller {
    return 1;
}

#pragma mark - <UITableViewDelegate,UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 162;

}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *registFormCellIdentifier = @"HXRegistFormCellIdentifier";
    HXRegistFormCell *cell = [tableView dequeueReusableCellWithIdentifier:registFormCellIdentifier];
    if (!cell) {
        cell = [[HXRegistFormCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:registFormCellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    HXRegistFormModel *registFormModel = self.dataList[indexPath.row];
    cell.registFormModel = registFormModel;
    return cell;
}



#pragma mark - <HXRegistFormCellDelegate>

-(void)registFormCell:(HXRegistFormCell *)cell downLoadUrl:(NSString *)url{
    self.downLoadUrl = url;
    if ([HXCommonUtil isNull:self.downLoadUrl]) {
        [self.view showTostWithMessage:@"资源无效"];
        return;
    }
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    // 1. 创建会话管理者
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    // 2. 创建下载路径和请求对象
    NSURL *URL = [NSURL URLWithString:self.downLoadUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    NSString *fileName = [self.downLoadUrl lastPathComponent]; //获取文件名称
//    //判断是否存在
//        if ([self isFileExist:fileName]) {
//            NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
//            NSURL *url = [documentsDirectoryURL URLByAppendingPathComponent:fileName];
//            self.fileURL = url;
//            [self presentViewController:self.QLController animated:YES completion:nil];
//            //刷新界面,如果不刷新的话，不重新走一遍代理方法，返回的url还是上一次的url
//            [self.QLController refreshCurrentPreviewItem];
//        } else {
//
//        }
    [self.view showLoadingWithMessage:@"正在下载..."];
    //下载文件
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress *downloadProgress){
        
    } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        NSURL *url = [documentsDirectoryURL URLByAppendingPathComponent:fileName];
        return url;
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        [self.view hideLoading];
        self.fileURL = filePath;
        [self presentViewController:self.QLController animated:YES completion:nil];
        //刷新界面,如果不刷新的话，不重新走一遍代理方法，返回的url还是上一次的url
        [self.QLController refreshCurrentPreviewItem];
    }];
    [downloadTask resume];
}

// 判断文件是否已经在沙盒中存在，1:存在 0:不存在
- (BOOL)isFileExist:(NSString *)fileName{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *filePath = [path stringByAppendingPathComponent:fileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL result = [fileManager fileExistsAtPath:filePath];
    return result;
}

#pragma mark - 获取新生报名表单下载链接
-(void)getDownPdf{
    
    [HXBaseURLSessionManager postDataWithNSString:HXPOST_Get_DownPdf  withDictionary:nil success:^(NSDictionary * _Nonnull dictionary) {
        
        BOOL success = [dictionary boolValueForKey:@"Success"];
        if (success) {
            self.dataList = [HXRegistFormModel mj_objectArrayWithKeyValuesArray:[dictionary objectForKey:@"Data"]];;
            if (self.dataList.count == 0) {
                [self.view addSubview:self.noDataTipView];
            }else{
                [self.noDataTipView removeFromSuperview];
            }
            [self.mainTableView reloadData];
        }
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

#pragma mark - UI
-(void)createUI{
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.sc_navigationBar.title = @"报名表单";
    [self.view addSubview:self.mainTableView];
    self.mainTableView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(kNavigationBarHeight, 0, 0, 0));
    
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
        _mainTableView.contentInset = UIEdgeInsetsMake(16, 0, 0, 0);
        _mainTableView.scrollIndicatorInsets = _mainTableView.contentInset;
        _mainTableView.showsVerticalScrollIndicator = NO;
    }
    return _mainTableView;
}

-(HXNoDataTipView *)noDataTipView{
    if (!_noDataTipView) {
        _noDataTipView = [[HXNoDataTipView alloc] initWithFrame:self.mainTableView.bounds];
        _noDataTipView.tipTitle = @"暂无数据~";
    }
    return _noDataTipView;
}


@end
