//
//  HXSettingViewController.m
//  HXMinedu
//
//  Created by Mac on 2020/11/6.
//

#import "HXSettingViewController.h"
#import <SDWebImage/SDImageCache.h>
#import "HXFileManager.h"
#import "HXCheckUpdateTool.h"

@interface HXSettingViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    
}
@property(nonatomic, strong) UITableView *mTableView;
@property(nonatomic, strong) HXBarButtonItem *leftBarItem;

@end

@implementation HXSettingViewController

-(void)loadView
{
    [super loadView];
    
    @weakify(self);
    self.leftBarItem = [[HXBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navi_back"] style:HXBarButtonItemStylePlain handler:^(id sender) {
        
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.sc_navigationBar.title = @"设置";
    self.sc_navigationBar.leftBarButtonItem = self.leftBarItem;
    
    [self createTableView];
}

#pragma mark - createTableView

-(void)createTableView
{
    self.mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight, kScreenWidth, kScreenHeight-kNavigationBarHeight) style:UITableViewStyleGrouped];
    self.mTableView.delegate = self;
    self.mTableView.dataSource = self;
    self.mTableView.contentInsetTop = 0;
    self.mTableView.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
    self.mTableView.cellLayoutMarginsFollowReadableWidth = NO;
    [self.view addSubview:self.mTableView];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 80;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        UIView * view = [[UIView alloc]init];
        view.backgroundColor = [UIColor clearColor];
        UIButton * button = [UIButton buttonWithType:UIButtonTypeSystem];
        [button setFrame:CGRectMake(0, 30, kScreenWidth, 50)];
        [button setTitle:@"退出登录" forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor whiteColor]];
        [button setTitleColor:[UIColor colorWithRed:0.988 green:0.255 blue:0.271 alpha:1.000] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:17]];
        [button addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
        return view;
    }
    
    return nil;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //需要补全
    UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"MoreViewCell"];
    cell.textLabel.font = [UIFont systemFontOfSize:17];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
    cell.detailTextLabel.textColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1];//@"#666666"];
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.detailTextLabel.text = @"";
    
    if (@available(iOS 13, *)) {
        UIImageView *accessoryImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"accessory_icon"]];
        cell.accessoryView = accessoryImgView;
    }
    
    switch (indexPath.row) {
        case 0:{
            cell.textLabel.text = @"检查更新";
            NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
            
            // app版本
            NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
            app_Version = [NSString stringWithFormat:@"v%@",app_Version];
            cell.detailTextLabel.text = app_Version;
        }
           break;
        case 1:
            {
                cell.textLabel.text = @"清除缓存";
                [[SDImageCache sharedImageCache] calculateSizeWithCompletionBlock:^(NSUInteger fileCount1, NSUInteger totalSize1) {
                    //
                    [HXFileManager calculateSizeWithCompletionBlock:^(NSUInteger fileCount2, NSUInteger totalSize2) {
                        //
                        NSString *fileSizeStr = [NSByteCountFormatter stringFromByteCount:totalSize1+totalSize2
                                                                               countStyle:NSByteCountFormatterCountStyleFile];
                        if ([fileSizeStr isEqualToString:@"Zero KB"]) {
                            fileSizeStr = @"0 KB";
                        }
                        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", fileSizeStr ];
                    }];
                }];
            }
            break;
        default:
            break;
    }
    return cell;
}
#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    switch (indexPath.row) {
        case 0:{
            //检查更新
            [[HXCheckUpdateTool sharedInstance] checkUpdateWithInController:self];
        }
            break;
        case 1: {
                
                [self.view showLoadingWithMessage:@"清除缓存中……"];
                
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
            break;
        default:
            break;
    }
}

-(void)logout
{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定退出此账号？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //注销登录
            [[NSNotificationCenter defaultCenter] postNotificationName:SHOWLOGIN object:nil];
            [self.tabBarController setSelectedIndex:0];  //默认选中在线学习模块
            [self.navigationController popViewControllerAnimated:NO];
        });
    }];
    UIAlertAction *confirmAction2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertC addAction:confirmAction2];
    [alertC addAction:confirmAction];
    [self presentViewController:alertC animated:YES completion:nil];
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
