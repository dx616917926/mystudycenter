//
//  HXSetViewController.m
//  HXMinedu
//
//  Created by mac on 2021/4/8.
//

#import "HXSetViewController.h"
#import "HXAboutUsViewController.h"
#import "HXResetViewController.h"
#import "HXSetCell.h"
#import "SDImageCache.h"
#import "HXFileManager.h"


@interface HXSetViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) NSArray *titles;
@property (nonatomic,strong)  UITableView *mainTableView;
@property(nonatomic,strong) UIButton *logOutBtn;

@end

@implementation HXSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //UI
    [self createUI];
}


#pragma mark - Event
-(void)logOut:(UIButton *)sender{
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定退出此账号？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        //退出登录---先主动请求接口！
        [HXBaseURLSessionManager doLogout];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //退出登录--弹登录框！
            [[NSNotificationCenter defaultCenter] postNotificationName:SHOWLOGIN object:nil];
            [self.tabBarController setSelectedIndex:0];  //默认选中课程模块
            [self.navigationController popViewControllerAnimated:NO];
        });
    }];
    UIAlertAction *confirmAction2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertC addAction:confirmAction2];
    [alertC addAction:confirmAction];
    [self presentViewController:alertC animated:YES completion:nil];
    
}

#pragma mark - <UITableViewDelegate,UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return  2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 47;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *setCellIdentifier = @"HXSetCellIdentifier";
    HXSetCell *cell = [tableView dequeueReusableCellWithIdentifier:setCellIdentifier];
    if (!cell) {
        cell = [[HXSetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:setCellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.detailLabel.text = nil;
    cell.titleLabel.text = self.titles[indexPath.row];
    if (indexPath.row == 1) {
        //SDImageCache 图片缓存大小
        [[SDImageCache sharedImageCache] calculateSizeWithCompletionBlock:^(NSUInteger fileCount1, NSUInteger totalSize1) {
            //本地缓存文件大小
            [HXFileManager calculateSizeWithCompletionBlock:^(NSUInteger fileCount2, NSUInteger totalSize2) {
                //
                NSString *fileSizeStr = [NSByteCountFormatter stringFromByteCount:totalSize1+totalSize2
                                                                       countStyle:NSByteCountFormatterCountStyleFile];
                if ([fileSizeStr isEqualToString:@"Zero KB"]) {
                    fileSizeStr = @"0 KB";
                }
                cell.detailLabel.text = [NSString stringWithFormat:@"%@", fileSizeStr ];
            }];
        }];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row==0) {
        HXResetViewController *resetVc = [[HXResetViewController alloc] init];
        [self.navigationController pushViewController:resetVc animated:YES];
    }else if (indexPath.row ==1){
//        HXAboutUsViewController *aboutUsVc = [[HXAboutUsViewController alloc] init];
//        [self.navigationController pushViewController:aboutUsVc animated:YES];
        
        [self.view showLoadingWithMessage:@"清除缓存中……"];
        //删除sdwebimage的缓存
        [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
            
        }];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"showPrivacyPolicyAlert"];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSFileManager * fileManager = [NSFileManager defaultManager];
        NSString * path = [paths firstObject];
        if ([fileManager fileExistsAtPath:path]) {
            NSArray *childerFiles=[fileManager subpathsAtPath:path];
            for (NSString *fileName in childerFiles) {
                //如有需要，加入条件，过滤掉不想删除的文件
                NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
                [fileManager removeItemAtPath:absolutePath error:nil];
            }
        }
        //
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [self.view showSuccessWithMessage:@"清除完毕！"];
    }
}



#pragma mark - UI
-(void)createUI{
    self.titles = @[@"修改密码",@"清除缓存"];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.sc_navigationBar.title = @"通用设置";
    [self.view addSubview:self.logOutBtn];
    [self.view addSubview:self.mainTableView];
    
    self.logOutBtn.sd_layout
    .bottomSpaceToView(self.view, 32+kScreenBottomMargin)
    .leftSpaceToView(self.view, _kpw(30))
    .rightSpaceToView(self.view, _kpw(30))
    .heightIs(40);
    self.logOutBtn.sd_cornerRadius = @6;
    
    self.mainTableView.sd_layout
    .topSpaceToView(self.view, kNavigationBarHeight)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomSpaceToView(self.logOutBtn, 30);
    
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
        _mainTableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
        _mainTableView.scrollIndicatorInsets = _mainTableView.contentInset;
        _mainTableView.showsVerticalScrollIndicator = NO;
    }
    return _mainTableView;
}

-(UIButton *)logOutBtn{
    if (!_logOutBtn) {
        _logOutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _logOutBtn.titleLabel.font = HXBoldFont(16);
        _logOutBtn.backgroundColor = COLOR_WITH_ALPHA(0xFE664B, 1);
        [_logOutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_logOutBtn addTarget:self action:@selector(logOut:) forControlEvents:UIControlEventTouchUpInside];
        [_logOutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    }
    return _logOutBtn;
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
