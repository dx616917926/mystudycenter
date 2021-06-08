//
//  HXYiDongConfirmViewController.m
//  HXMinedu
//
//  Created by mac on 2021/6/3.
//

#import "HXYiDongAndRefundConfirmViewController.h"
#import "HXYiDongDetailsViewController.h"
#import "HXRefundDetailsViewController.h"

@interface HXYiDongAndRefundConfirmViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *mainTableView;


@end

@implementation HXYiDongAndRefundConfirmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //UI
    [self createUI];
}

#pragma mark - UI
-(void)createUI{
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.sc_navigationBar.title =(self.confirmType==0?@"异动确认":@"退费确认");
    [self.view addSubview:self.mainTableView];
    self.mainTableView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(kNavigationBarHeight, 0, kScreenBottomMargin, 0));
    
}

#pragma mark - <UITableViewDelegate,UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 240;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *yiDongAndRefundConfirmCellIdentifier = @"HXYiDongAndRefundConfirmCellIdentifier";
    HXYiDongAndRefundConfirmCell *cell = [tableView dequeueReusableCellWithIdentifier:yiDongAndRefundConfirmCellIdentifier];
    if (!cell) {
        cell = [[HXYiDongAndRefundConfirmCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:yiDongAndRefundConfirmCellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.confirmType = self.confirmType;
//    cell.delegate = self;
//    [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
//    HXCourseModel *courseModel = self.courseList[indexPath.row];
//    cell.courseModel = courseModel;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.confirmType == HXYiDongConfirmType) {
        HXYiDongDetailsViewController *yiDongDetailsVC = [[HXYiDongDetailsViewController alloc] init];
        [self.navigationController pushViewController:yiDongDetailsVC animated:YES];
    }else{
        HXRefundDetailsViewController*refundDetailsVC = [[HXRefundDetailsViewController alloc] init];
        [self.navigationController pushViewController:refundDetailsVC animated:YES];
    }
}

#pragma mark - lazylaod
-(void)setConfirmType:(HXConfirmType)confirmType{
    _confirmType = confirmType;
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
        _mainTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
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
