//
//  HXInfoConfirmViewController.m
//  HXMinedu
//
//  Created by mac on 2021/4/9.
//

#import "HXInfoConfirmViewController.h"
#import "HXConfirmViewController.h"
#import "HXInfoConfirmCell.h"
#import "HXPictureInfoModel.h"
#import "HXNoDataTipView.h"

@interface HXInfoConfirmViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) NSArray *titles;
@property (nonatomic,strong)  UITableView *mainTableView;
@property (nonatomic,strong)  NSArray *pictureInfoList;
@property(strong,nonatomic) HXNoDataTipView *noDataTipView;
@end

@implementation HXInfoConfirmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //UI
    [self createUI];
    //获取学生图片信息
    [self getStudentFile];
}


#pragma mark - 获取学生图片信息
-(void)getStudentFile{
    [self.view showLoading];
    HXMajorModel *selectMajorModel = [HXPublicParamTool sharedInstance].selectMajorModel;
    NSDictionary *dic = @{
        @"version_id":HXSafeString(selectMajorModel.versionId),
        @"major_id":HXSafeString(selectMajorModel.major_id)
    };
    [HXBaseURLSessionManager postDataWithNSString:HXPOST_Get_StudentFile  withDictionary:dic success:^(NSDictionary * _Nonnull dictionary) {
        [self.view hideLoading];
        BOOL success = [dictionary boolValueForKey:@"Success"];
        if (success) {
            self.pictureInfoList = [HXPictureInfoModel mj_objectArrayWithKeyValuesArray:[dictionary objectForKey:@"Data"]];
            [self.mainTableView reloadData];
            if (self.pictureInfoList.count == 0) {
                [self.view addSubview:self.noDataTipView];
            }else{
                [self.noDataTipView removeFromSuperview];
            }
        }
    } failure:^(NSError * _Nonnull error) {
        [self.view hideLoading];
    }];
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
//    if (pictureInfoModel.status == 0) {
//        [self.view showTostWithMessage:@"待上传"];
//        return;//待上传，不跳转
//    }
    HXConfirmViewController *confirmVc = [[HXConfirmViewController alloc] init];
    confirmVc.pictureInfoModel = pictureInfoModel;
    WeakSelf(weakSelf)
    confirmVc.refreshInforBlock = ^{
        //重新拉取服务器数据
        [weakSelf getStudentFile];
    };
    [self.navigationController pushViewController:confirmVc animated:YES];
}

#pragma mark - UI
-(void)createUI{
   
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.sc_navigationBar.title = @"图片信息确认";
  
    [self.view addSubview:self.mainTableView];
    
    self.mainTableView.sd_layout
    .topSpaceToView(self.view, kNavigationBarHeight)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomSpaceToView(self.view, kScreenBottomMargin);
    
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
