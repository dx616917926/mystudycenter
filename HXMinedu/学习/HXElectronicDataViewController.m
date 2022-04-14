//
//  HXElectronicDataViewController.m
//  HXMinedu
//
//  Created by mac on 2022/4/13.
//

#import "HXElectronicDataViewController.h"
#import "HXElectronicDataCell.h"
#import <QuickLook/QuickLook.h>
@interface HXElectronicDataViewController ()<UITableViewDelegate,UITableViewDataSource,QLPreviewControllerDataSource>

@property(nonatomic,strong) UITableView *mainTableView;
//下载管理对象
@property(nonatomic,strong) AFURLSessionManager *manager;

@property (nonatomic, copy) NSString *downLoadUrl;
@property (nonatomic, strong) QLPreviewController *QLController;
@property (nonatomic, copy) NSURL *fileURL;
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation HXElectronicDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //UI
    [self createUI];
    //下载管理对象
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    self.manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    //预览资料对象
    self.QLController = [[QLPreviewController alloc] init];
    self.QLController.dataSource = self;
    //获取课程教学资料列表
    [self getTeachingMaterialsList];
}

#pragma mark- Setter
-(void)setStudentCourseID:(NSString *)studentCourseID{
    _studentCourseID = studentCourseID;
}


#pragma mark -  获取课程教学资料列表
-(void)getTeachingMaterialsList{
    
    [self.view showLoading];
    
    HXMajorModel *selectMajorModel = [HXPublicParamTool sharedInstance].selectMajorModel;
    NSDictionary *dic = @{
        @"version_id":HXSafeString(selectMajorModel.versionId),
        @"type":@(selectMajorModel.type),
        @"major_id":HXSafeString(selectMajorModel.major_id),
        @"studentCourseID":HXSafeString(self.studentCourseID)
        
    };
    
    [HXBaseURLSessionManager postDataWithNSString:HXPOST_GetTeachingMaterialsList withDictionary:dic success:^(NSDictionary * _Nonnull dictionary) {
        [self.view hideLoading];
        BOOL success = [dictionary boolValueForKey:@"Success"];
        if (success) {
            NSArray *list = [HXElectronicDataModel mj_objectArrayWithKeyValuesArray:[dictionary objectForKey:@"Data"]];
            self.dataArray = list;
            [self.mainTableView reloadData];
        }
    } failure:^(NSError * _Nonnull error) {
        [self.view hideLoading];
    }];
}


#pragma mark - 下载电子资料
-(void)downLoadElectronicData:(HXElectronicDataModel *)electronicDataModell{
    NSString *downLoadUrl = [HXCommonUtil stringEncoding:electronicDataModell.FileUrl];
    if ([HXCommonUtil isNull:downLoadUrl]){
        [self.view showTostWithMessage:@"资源无效"];
        return;
    }
    // 2. 创建下载路径和请求对象
    NSURL *URL = [NSURL URLWithString:downLoadUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    NSString *fileName = electronicDataModell.FileName; //获取文件名称
    [self.view showLoadingWithMessage:@"正在下载..."];
    //下载文件
    NSURLSessionDownloadTask *downloadTask = [self.manager downloadTaskWithRequest:request progress:^(NSProgress *downloadProgress){

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
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *electronicDataCellIdentifier = @"HXElectronicDataCellIdentifier";
    HXElectronicDataCell *cell = [tableView dequeueReusableCellWithIdentifier:electronicDataCellIdentifier];
    if (!cell) {
        cell = [[HXElectronicDataCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:electronicDataCellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.electronicDataModel = self.dataArray[indexPath.row];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HXElectronicDataModel *electronicDataModel = self.dataArray[indexPath.row];
    [self downLoadElectronicData:electronicDataModel];
}



#pragma mark - UI
-(void)createUI{
   
    self.sc_navigationBar.title = @"电子资料";
    [self.view addSubview:self.mainTableView];
}


-(UITableView *)mainTableView{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavigationBarHeight, kScreenWidth, kScreenHeight-kNavigationBarHeight) style:UITableViewStylePlain];
        _mainTableView.bounces = NO;
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.backgroundColor = [UIColor clearColor];
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
        _mainTableView.contentInset = UIEdgeInsetsMake(10, 0, kScreenBottomMargin, 0);
        _mainTableView.scrollIndicatorInsets = _mainTableView.contentInset;
        _mainTableView.showsVerticalScrollIndicator = NO;
    }
    return _mainTableView;
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
