//
//  HXInfoConfirmChildViewController.m
//  HXMinedu
//
//  Created by mac on 2021/6/9.
//

#import "HXInfoConfirmChildViewController.h"
#import "HXConfirmViewController.h"
#import "HXInfoConfirmCell.h"
#import "HXNoDataTipView.h"
#import "HXPictureInfoModel.h"
@interface HXInfoConfirmChildViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)  UITableView *mainTableView;
@property(strong,nonatomic)   HXNoDataTipView *noDataTipView;
@end

@implementation HXInfoConfirmChildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //UI
    [self createUI];

}



#pragma mark - 获取学生图片信息
-(void)setPictureInfoList:(NSArray *)pictureInfoList{
    _pictureInfoList = pictureInfoList;
    
}



#pragma mark - <UITableViewDelegate,UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return  self.pictureInfoList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 47;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *infoConfirmCellIdentifier = @"HXInfoConfirmCellIdentifier";
    HXInfoConfirmCell *cell = [tableView dequeueReusableCellWithIdentifier:infoConfirmCellIdentifier];
    if (!cell) {
        cell = [[HXInfoConfirmCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:infoConfirmCellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    HXPictureInfoModel *pictureInfoModel = self.pictureInfoList[indexPath.row];
    cell.pictureInfoModel = pictureInfoModel;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    HXPictureInfoModel *pictureInfoModel = self.pictureInfoList[indexPath.row];
    HXConfirmViewController *confirmVc = [[HXConfirmViewController alloc] init];
    confirmVc.pictureInfoModel = pictureInfoModel;
    WeakSelf(weakSelf)
    confirmVc.refreshInforBlock = ^(NSInteger flag) {
        if (flag == 1) {//已上传待确定
            pictureInfoModel.status = 1;
            pictureInfoModel.studentstatus = 0;
        }
        if (flag == 2) {//已确定
            pictureInfoModel.status = 1;
            pictureInfoModel.studentstatus = 1;
        }
        [weakSelf.mainTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];

    };
    [self.navigationController pushViewController:confirmVc animated:YES];
}

#pragma mark - UI
-(void)createUI{
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.mainTableView];
    self.mainTableView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    if (self.pictureInfoList.count == 0) {
        [self.view addSubview:self.noDataTipView];
    }else{
        [self.noDataTipView removeFromSuperview];
    }
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
        _mainTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

