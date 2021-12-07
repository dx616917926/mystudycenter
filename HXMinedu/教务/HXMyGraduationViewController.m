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
@property(strong,nonatomic) NSMutableArray *dataArray;


@end

@implementation HXMyGraduationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //UI
    [self createUI];
}


#pragma mark - Event
//上传论文
-(void)upLoadLunWen:(UIButton *)sender{
    NSArray * types=@[@"public.item"];
   
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
                [self.noDataTipView removeFromSuperview];
                NSLog(@"fileData --- %@",fileData);
//                [self uploadingWithFileData:fileData fileName:fileName fileURL:newURL];
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
    return 3;
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    HXLunWenViewController *lunWenVc = [[HXLunWenViewController alloc] init];
    lunWenVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:lunWenVc animated:YES];
}


#pragma mark - 布局子视图
-(void)createUI{
    [self.view addSubview:self.mainTableView];
    [self.view addSubview:self.noDataTipView];
  
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
        _noDataTipView = [[UIView alloc] initWithFrame:self.mainTableView.frame];
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


@end
