//
//  HXMyGraduationViewController.m
//  HXMinedu
//
//  Created by mac on 2021/12/6.
//

#import "HXMyGraduationViewController.h"
#import "HXLunWenViewController.h"
#import "HXDissertationCell.h"

@interface HXMyGraduationViewController ()<UITableViewDelegate,UITableViewDataSource,UIDocumentPickerDelegate>

@property(strong,nonatomic) UITableView *mainTableView;
@property(strong,nonatomic) UIView *noDataTipView;
@property(strong,nonatomic) UIView *noUpLoadTipView;
@property(strong,nonatomic) NSMutableArray *dataArray;


@end

@implementation HXMyGraduationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //UI
    [self createUI];
    
    //获取学生论文
    [self getStudentPaper];
}


#pragma mark -  获取学生论文
-(void)getStudentPaper{
    
    [self.noDataTipView removeFromSuperview];
    [self.noUpLoadTipView removeFromSuperview];
    NSDictionary *dic = @{
        @"version_id":HXSafeString(self.selectMajorModel.versionId),
        @"major_id":HXSafeString(self.selectMajorModel.major_id)
    };
    
    [HXBaseURLSessionManager postDataWithNSString:HXPOST_GetStudentPaper withDictionary:dic success:^(NSDictionary * _Nonnull dictionary) {
        [self.mainTableView.mj_header endRefreshing];
        BOOL success = [dictionary boolValueForKey:@"Success"];
        if (success) {
            HXStudentPaperModel *model = [HXStudentPaperModel mj_objectWithKeyValues:[dictionary objectForKey:@"Data"]];
            if (model.IsUpload==1) {
                [self.dataArray removeAllObjects];
                if ([model.version_id integerValue]>0) {
                    [self.dataArray addObject:model];
                    [self.mainTableView reloadData];
                }else{
                    [self.mainTableView addSubview:self.noDataTipView];
                }
            }else{
                [self.mainTableView addSubview:self.noUpLoadTipView];
            }
        }
    } failure:^(NSError * _Nonnull error) {
        [self.mainTableView.mj_header endRefreshing];
    }];
}

//上传论文
-(void)uploadingWithFileData:(NSString *)fileData fileName:(NSString *)fileName{
    [self.view showLoading];
    NSDictionary *dic = @{
        @"version_id":HXSafeString(self.selectMajorModel.versionId),
        @"major_id":HXSafeString(self.selectMajorModel.major_id),
        @"file":HXSafeString(fileData),
        @"fileName":HXSafeString(fileName)
    };
    [HXBaseURLSessionManager postDataWithNSString:HXPOST_UploadStudentPaperFile withDictionary:dic success:^(NSDictionary * _Nonnull dictionary) {
        [self.view hideLoading];
        BOOL success = [dictionary boolValueForKey:@"Success"];
        if (success) {
            [self.noDataTipView removeFromSuperview];
            //获取学生论文
            [self getStudentPaper];
        }
    } failure:^(NSError * _Nonnull error) {
        [self.view hideLoading];
    }];
}

#pragma mark - Event
//上传论文
-(void)upLoadLunWen:(UIButton *)sender{
    NSArray * types = @[@"public.item"];
   
    UIDocumentPickerViewController *documentPicker = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:types inMode:UIDocumentPickerModeOpen];
    documentPicker.delegate = self;//(UIDocumentPickerDelegate)
    documentPicker.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:documentPicker animated:YES completion:nil];
}

#pragma mark - <UIDocumentPickerDelegate>选择文件回调
- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentsAtURLs:(NSArray<NSURL *> *)urls {
    //获取授权
    BOOL fileUrlAuthozied = [urls.firstObject startAccessingSecurityScopedResource];
    if (fileUrlAuthozied) {
        //通过文件协调工具来得到新的文件地址，以此得到文件保护功能
        NSFileCoordinator *fileCoordinator = [[NSFileCoordinator alloc] init];
        NSError *error;
        [fileCoordinator coordinateReadingItemAtURL:urls.firstObject options:0 error:&error byAccessor:^(NSURL *newURL) {
            //读取文件
            NSString *fileName = [newURL lastPathComponent];
            NSError *error = nil;
            NSData *fileData = [NSData dataWithContentsOfURL:newURL options:NSDataReadingMappedIfSafe error:&error];
            if (error) {
                //读取出错
                [self.view showErrorWithMessage:@"读取出错"];
            } else {
                //上传
                NSLog(@"fileData --- %lu",(unsigned long)fileData.length);
                NSString *base64Str = [fileData base64EncodedStringWithOptions:0];
                [self uploadingWithFileData:base64Str fileName:fileName];
            }
            [self dismissViewControllerAnimated:YES completion:NULL];
        }];
        [urls.firstObject stopAccessingSecurityScopedResource];
    } else {
        //授权失败
        [self.view showErrorWithMessage:@"授权失败"];
    }
}


#pragma mark - <UITableViewDelegate,UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    return  1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 135;

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *dissertationCellIdentifier = @"HXDissertationCellIdentifier";
    HXDissertationCell *cell = [tableView dequeueReusableCellWithIdentifier:dissertationCellIdentifier];
    if (!cell) {
        cell = [[HXDissertationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:dissertationCellIdentifier];
    }
    cell.studentPaperModel = self.dataArray[indexPath.section];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    HXLunWenViewController *lunWenVc = [[HXLunWenViewController alloc] init];
    lunWenVc.hidesBottomBarWhenPushed = YES;
    lunWenVc.selectMajorModel = self.selectMajorModel;
    [self.navigationController pushViewController:lunWenVc animated:YES];
}


#pragma mark - 布局子视图
-(void)createUI{
    [self.view addSubview:self.mainTableView];
    // 下拉刷新
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getStudentPaper)];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    header.automaticallyChangeAlpha = YES;
    //设置header
    self.mainTableView.mj_header = header;
  
}
    
#pragma mark - lazyload
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
-(UITableView *)mainTableView{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kNavigationBarHeight-kTabBarHeight-58) style:UITableViewStyleGrouped];
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
    }
    return _mainTableView;
}

-(UIView *)noDataTipView{
    if (!_noDataTipView) {
        _noDataTipView = [[UIView alloc] initWithFrame:self.mainTableView.bounds];
        _noDataTipView.backgroundColor = COLOR_WITH_ALPHA(0xFCFCFC, 1);
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"search_nodata"];
        [_noDataTipView addSubview:imageView];
        
        UILabel *tipLabel = [[UILabel alloc] init];
        tipLabel.font = HXFont(13);
        tipLabel.textColor = COLOR_WITH_ALPHA(0xB1B1B1, 1);
        tipLabel.textAlignment = NSTextAlignmentCenter;
        tipLabel.text = @"您还没有上传相关资料哦";
        [_noDataTipView addSubview:tipLabel];
        
        UIButton *upLoadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        upLoadBtn.titleLabel.font = HXFont(16);
        [upLoadBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [upLoadBtn setTitle:@"去上传" forState:UIControlStateNormal];
        [upLoadBtn addTarget:self action:@selector(upLoadLunWen:) forControlEvents:UIControlEventTouchUpInside];
        [_noDataTipView addSubview:upLoadBtn];
        
        imageView.sd_layout
        .centerXEqualToView(_noDataTipView)
        .topSpaceToView(_noDataTipView, 50)
        .widthIs(375)
        .heightIs(110);
        
        tipLabel.sd_layout
        .topSpaceToView(imageView, 10)
        .leftEqualToView(_noDataTipView)
        .rightEqualToView(_noDataTipView)
        .heightIs(18);
        
        upLoadBtn.sd_layout
        .centerXEqualToView(_noDataTipView)
        .topSpaceToView(tipLabel, 25)
        .widthIs(126)
        .heightIs(43);
        upLoadBtn.sd_cornerRadiusFromHeightRatio = @0.5;
        [upLoadBtn updateLayout];
        
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.bounds = upLoadBtn.bounds;
        gradientLayer.startPoint = CGPointMake(0, 0.5);
        gradientLayer.endPoint = CGPointMake(1, 0.5);
        gradientLayer.anchorPoint = CGPointMake(0, 0);
        NSArray *colorArr = @[(id)COLOR_WITH_ALPHA(0x3EADFF, 1).CGColor,(id)COLOR_WITH_ALPHA(0x15E88D, 1).CGColor];
        gradientLayer.colors = colorArr;
        [upLoadBtn.layer insertSublayer:gradientLayer below:upLoadBtn.imageView.layer];
    }
    return _noDataTipView;
}


-(UIView *)noUpLoadTipView{
    if (!_noUpLoadTipView) {
        _noUpLoadTipView = [[UIView alloc] initWithFrame:self.mainTableView.bounds];
        _noUpLoadTipView.backgroundColor = COLOR_WITH_ALPHA(0xFCFCFC, 1);
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"search_nodata"];
        [_noUpLoadTipView addSubview:imageView];
        
        UILabel *tipLabel = [[UILabel alloc] init];
        tipLabel.font = HXFont(13);
        tipLabel.textColor = COLOR_WITH_ALPHA(0xB1B1B1, 1);
        tipLabel.textAlignment = NSTextAlignmentCenter;
        tipLabel.text = @"暂无数据";
        [_noUpLoadTipView addSubview:tipLabel];
        
        imageView.sd_layout
        .centerXEqualToView(_noUpLoadTipView)
        .topSpaceToView(_noUpLoadTipView, 50)
        .widthIs(375)
        .heightIs(110);
        
        tipLabel.sd_layout
        .topSpaceToView(imageView, 10)
        .leftEqualToView(_noUpLoadTipView)
        .rightEqualToView(_noUpLoadTipView)
        .heightIs(18);
        
    }
    return _noUpLoadTipView;
}


@end
