
//
//  HXStudyViewController.m
//  HXMinedu
//
//  Created by mac on 2021/3/26.
//

#import "HXStudyViewController.h"
#import "HXSelectStudyTypeViewController.h"
#import "HXCustommNavView.h"

@interface HXStudyViewController ()
@property(nonatomic,strong) HXCustommNavView *custommNavView;
//报考类型数组
@property (nonatomic, strong) NSArray *versionList;
@property (nonatomic, strong) HXVersionModel *selectVersionModel;
@property (nonatomic, strong) HXMajorModel *selectMajorModel;

@end

@implementation HXStudyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //布局UI
    [self createUI];
    //获取报考类型专业列表
    [self getVersionandMajorList];
   
    //登录成功的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getVersionandMajorList) name:LOGINSUCCESS object:nil];
}

#pragma mark - event
-(void)selectStudyType{
    HXSelectStudyTypeViewController *vc =[[HXSelectStudyTypeViewController alloc] init];
    vc.versionList = self.versionList;
    //选择完成回调
    WeakSelf(weakSelf)
    vc.selectFinishCallBack = ^(NSArray * _Nonnull versionList, HXVersionModel * _Nonnull selectVersionModel, HXMajorModel * _Nonnull selectMajorModel) {
        weakSelf.versionList = versionList;
        weakSelf.selectVersionModel = selectVersionModel;
        weakSelf.selectMajorModel = selectMajorModel;
        weakSelf.custommNavView.selectVersionModel = selectVersionModel;

    };
    [self presentViewController:vc animated:YES completion:nil];
}


#pragma mark - 网络请求
//获取报考类型专业列表
-(void)getVersionandMajorList{
    [self.view showLoading];
    [HXBaseURLSessionManager postDataWithNSString:HXPOST_Get_Version_Major_List withDictionary:nil success:^(NSDictionary * _Nonnull dictionary) {
        [self.view hideLoading];
        BOOL success = [dictionary boolValueForKey:@"Success"];
        if (success) {
            self.versionList = [HXVersionModel mj_objectArrayWithKeyValuesArray:[dictionary objectForKey:@"Data"]];
            ///由于报考类型数据多处用到，避免频繁获取，此处保存在单例中
            [HXPublicParamTool sharedInstance].versionList = [self.versionList copy];
            ///刷新导航数据
            [self refreshNavBarData];
        }else{
            [self.view showErrorWithMessage:[dictionary stringValueForKey:@"Message"]];
        }
    } failure:^(NSError * _Nonnull error) {
        [self.view hideLoading];
    }];
}

-(void)refreshNavBarData{
    //默认选中第一个类型里的第一个专业
    self.selectVersionModel = self.versionList.firstObject;
    self.selectVersionModel.isSelected = YES;
    self.selectMajorModel = self.selectVersionModel.majorList.firstObject;
    self.selectMajorModel.isSelected = YES;
    self.custommNavView.selectVersionModel = self.selectVersionModel;
    
}

#pragma mark - UI
-(void)createUI{
    self.sc_navigationBar.titleView = self.custommNavView;
    __weak __typeof(self) weakSelf = self;
    self.custommNavView.selectTypeCallBack = ^{
        [weakSelf selectStudyType];
    };
}


#pragma mark - lazyload
-(HXCustommNavView *)custommNavView{
    if (!_custommNavView) {
        _custommNavView = [[HXCustommNavView alloc] initWithFrame:CGRectMake(0, kStatusBarHeight, kScreenWidth, kNavigationBarHeight-kStatusBarHeight)];
    }
    return _custommNavView;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]  removeObserver:self];
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
