//
//  HXSelectThemeViewController.m
//  HXNavigationController
//
//  Created by iMac on 16/7/25.
//  Copyright © 2016年 TheLittleBoy. All rights reserved.
//

#import "HXSelectThemeViewController.h"
#import "HXBaseTableViewCell.h"

@interface HXSelectThemeViewController ()
{
    NSArray * themeNameArray;
    NSArray * themeTypeArray;
}
@property (nonatomic, strong) HXBarButtonItem *leftBarItem;

@end

@implementation HXSelectThemeViewController

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
    // Do any additional setup after loading the view from its nib.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.sc_navigationBar.title = @"选择主题";
    
    self.sc_navigationBar.leftBarButtonItem = self.leftBarItem;
    
    themeNameArray = @[@"默认(蓝色)",@"红色",@"绿色"];
    themeTypeArray = @[[NSNumber numberWithInteger:HXThemeBlue],
                       [NSNumber numberWithInteger:HXThemeRed],
                       [NSNumber numberWithInteger:HXThemeGreen]];
    
    [self createTableView];
}

-(void)createTableView
{
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight, kScreenWidth, kScreenHeight-kNavigationBarHeight) style:UITableViewStylePlain];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    _myTableView.backgroundColor = [UIColor whiteColor];
    _myTableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    if ([_myTableView respondsToSelector:@selector(setCellLayoutMarginsFollowReadableWidth:)]) {
        _myTableView.cellLayoutMarginsFollowReadableWidth = NO;
    }
    if (@available(iOS 11.0, *)) {
        _myTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [self.view addSubview:_myTableView];
    
    UIView * view = [[UIView alloc] init];
    [self.myTableView setTableFooterView:view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return themeNameArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HXBaseTableViewCell *cell = (HXBaseTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"themeCell"];
    if (cell == nil) {
        cell = [[HXBaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"themeCell"];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleDefault];
    cell.textLabel.font = [UIFont systemFontOfSize:17];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",themeNameArray[indexPath.row]];
    
    HXTheme theme = [[themeTypeArray objectAtIndex:indexPath.row] integerValue];
    
    if (theme == kCurrentTheme) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        cell.tintColor = kNavigationBarColor;
    }else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HXTheme theme = [[themeTypeArray objectAtIndex:indexPath.row] integerValue];
    kCurrentTheme = theme;
    
    [tableView reloadData];
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
