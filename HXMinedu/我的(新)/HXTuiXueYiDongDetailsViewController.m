//
//  HXTuiXueYiDongDetailsViewController.m
//  HXMinedu
//
//  Created by mac on 2021/7/9.
//

#import "HXTuiXueYiDongDetailsViewController.h"
#import "HXYiDongAndRefundConfirmViewController.h"
#import "HXYiDongHeadInfoCell.h"
#import "HXMajorInfoCell.h"
#import "HXSuggestionCell.h"
#import "HXReviewerSuggestionCell.h"
#import "HXToastSuggestionView.h"
#import "HXCustomToastView.h"

@interface HXTuiXueYiDongDetailsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) UITableView *mainTableView;
@property(nonatomic,strong) UIView *bottomView;
@property(nonatomic,strong) UIView *bottomShadowView;
@property(nonatomic,strong) UIButton *rejectBtn;//驳回
@property(nonatomic,strong) UIButton *confirmBtn;//确认异动



//异动详情
@property(nonatomic,strong) HXYiDongInfoModel *yiDongInfoModel;
//专业详情
@property(nonatomic,strong) HXMajorInfoModel *majorInfoModel;

@end

@implementation HXTuiXueYiDongDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //UI
    [self createUI];
    //获取学生退学休学异动详情
    [self getStopStudyByTxAndXxInfo];
}

#pragma mark - 获取学生退学休学异动详情
-(void)getStopStudyByTxAndXxInfo{
    
    NSDictionary *dic = @{
        @"stopStudyId":HXSafeString(self.stopStudyId)
    };
    [self.view showLoading];
    [HXBaseURLSessionManager postDataWithNSString:HXPOST_GetStopStudyByTxAndXxInfo  withDictionary:dic success:^(NSDictionary * _Nonnull dictionary) {
        [self.view hideLoading];
        BOOL success = [dictionary boolValueForKey:@"Success"];
        if (success) {
            NSDictionary *dataDic = [dictionary objectForKey:@"Data"];
            self.yiDongInfoModel = [HXYiDongInfoModel mj_objectWithKeyValues:[dataDic objectForKey:@"t_StopStudyByTxAndXxInfo_app"]];
            self.majorInfoModel = [HXMajorInfoModel mj_objectWithKeyValues:[dataDic objectForKey:@"t_StopStudyByTxAndXxMajorInfo_app"]];
            [self.mainTableView reloadData];
            ///0-待确认  1-已确认   2-审核中   3-待终审    4-已同意    5-已驳回
            if (self.yiDongInfoModel.reviewstatus == 0) {
                self.bottomShadowView.hidden = self.bottomView.hidden = NO;
            }else{
                self.bottomShadowView.hidden = self.bottomView.hidden = YES;
            }
        }
    } failure:^(NSError * _Nonnull error) {
        [self.view hideLoading];
    }];
}

#pragma mark - 学生异动信息确认或驳回
-(void)loadRefundConfirmOrRejectRemark:(NSString *)remark reviewStatus:(NSInteger)reviewStatus{
    
    NSDictionary *dic = @{
        @"stopStudyId":HXSafeString(self.stopStudyId),
        @"reviewStatus":@(reviewStatus),
        @"rejectRemark":HXSafeString(remark),
        @"payMode":@"",
        @"image":@"",
        @"khm":@"",
        @"khh":@"",
        @"khsk":@""
    };
    
    [HXBaseURLSessionManager postDataWithNSString:HXPOST_StuStopConfirmOrReject  withDictionary:dic success:^(NSDictionary * _Nonnull dictionary) {
        [self.view hideLoading];
        BOOL success = [dictionary boolValueForKey:@"Success"];
        if (success) {
            self.bottomView.hidden = self.bottomShadowView.hidden = YES;
            //刷新数据
            [self getStopStudyByTxAndXxInfo];
            
            HXCustomToastView *toastView = [[HXCustomToastView alloc] init];
            reviewStatus == 1?[toastView showConfirmToastHideAfter:2]:[toastView showRejectToastHideAfter:2];
            //通知异动列表刷新
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ConfirmOrRejectYiDongNotification" object:nil];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //返回异动列表界面
                [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj isKindOfClass:[HXYiDongAndRefundConfirmViewController class]]) {
                        [self.navigationController popToViewController:obj animated:YES];
                        *stop =  YES;
                        return;
                    }
                }];
            });
        }
    } failure:^(NSError * _Nonnull error) {
        [self.view hideLoading];
        self.bottomView.hidden = self.bottomShadowView.hidden = NO;
    }];
    
}

#pragma mark - Event
//驳回
-(void)reject:(UIButton *)sender{
    HXToastSuggestionView *toastSuggestionView = [[HXToastSuggestionView alloc] init];
    [toastSuggestionView showRejecttoastWithCallBack:^(NSString * _Nonnull cotent) {
        [self loadRefundConfirmOrRejectRemark:cotent reviewStatus:2];
    }];
}

//确认
-(void)confirm:(UIButton *)sender{
    
    HXToastSuggestionView *toastSuggestionView = [[HXToastSuggestionView alloc] init];
    [toastSuggestionView showConfirmToastWithCallBack:^(NSString * _Nonnull cotent) {
        [self loadRefundConfirmOrRejectRemark:cotent reviewStatus:1];
    }];
}



#pragma mark - <UITableViewDelegate,UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //0-待确认 1-已确认 2-审核中 3-待终审 4-已同意 5-已驳回
    //reviewstatus=2和3时显示确认意见  reviewstatus=4和5时显示确认意见和审核意见  其他不显示
    NSInteger reviewstatus = self.yiDongInfoModel.reviewstatus;
    switch (reviewstatus) {
        case 0:
        case 1:
            return 2;
            break;
        case 2:
        case 3:
            return 3;
            break;
        case 4:
        case 5:
            return 4;
            break;
        default:
            return 0;
            break;
    }
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            return 104;
            break;
        case 1:
            return 156;
            break;
        case 2:
        {
            HXYiDongInfoModel *yiDongInfoModel = self.yiDongInfoModel;
            CGFloat rowHeight = [tableView cellHeightForIndexPath:indexPath
                                                            model:yiDongInfoModel keyPath:@"yiDongInfoModel"
                                                        cellClass:([HXSuggestionCell class])
                                                 contentViewWidth:kScreenWidth];
            return rowHeight;
        }
            break;
        case 3:
        {
            HXYiDongInfoModel *yiDongInfoModel = self.yiDongInfoModel;
            CGFloat rowHeight = [tableView cellHeightForIndexPath:indexPath
                                                            model:yiDongInfoModel keyPath:@"yiDongInfoModel"
                                                        cellClass:([HXReviewerSuggestionCell class])
                                                 contentViewWidth:kScreenWidth];
            return rowHeight;
        }
            break;
        default:
            return 0;
            break;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *yiDongHeadInfoCellIdentifier = @"HXYiDongHeadInfoCellIdentifier";
    static NSString *majorInfoCellIdentifier = @"HXMajorInfoCellIdentifier";
    static NSString *suggestionCellIdentifier = @"HXSuggestionCellIdentifier";
    static NSString *reviewerSuggestionCellIdentifier = @"HXReviewerSuggestionCellIdentifier";
    
    switch (indexPath.row) {
        case 0:
        {
            HXYiDongHeadInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:yiDongHeadInfoCellIdentifier];
            if (!cell) {
                cell = [[HXYiDongHeadInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:yiDongHeadInfoCellIdentifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.yiDongInfoModel = self.yiDongInfoModel;
            return cell;
        }
            break;
        case 1:
        {
            HXMajorInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:majorInfoCellIdentifier];
            if (!cell) {
                cell = [[HXMajorInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:majorInfoCellIdentifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.majorInfoModel = self.majorInfoModel;
            return cell;
        }
            break;
        case 2:
        {
            HXSuggestionCell *cell = [tableView dequeueReusableCellWithIdentifier:suggestionCellIdentifier];
            if (!cell) {
                cell = [[HXSuggestionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:suggestionCellIdentifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
            cell.yiDongInfoModel = self.yiDongInfoModel;
            return cell;
        }
            break;
        case 3:
        {
            HXReviewerSuggestionCell *cell = [tableView dequeueReusableCellWithIdentifier:reviewerSuggestionCellIdentifier];
            if (!cell) {
                cell = [[HXReviewerSuggestionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reviewerSuggestionCellIdentifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
            cell.yiDongInfoModel = self.yiDongInfoModel;
            return cell;
        }
            break;
            
        default:
            return nil;
            break;
    }
    
}

#pragma mark - UI
-(void)createUI{
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.sc_navigationBar.title = @"异动详情";
    [self.view addSubview:self.mainTableView];
    [self.view addSubview:self.bottomShadowView];
    [self.view addSubview:self.bottomView];
    [self.bottomView addSubview:self.rejectBtn];
    [self.bottomView addSubview:self.confirmBtn];
    
    self.mainTableView.sd_layout
    .topSpaceToView(self.view, kNavigationBarHeight)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomEqualToView(self.view);
    
    self.bottomView.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomEqualToView(self.view)
    .heightIs(120);
    [self.bottomView updateLayout];
    
    UIBezierPath * bPath = [UIBezierPath bezierPathWithRoundedRect:self.bottomView.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(24, 24)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.path = bPath.CGPath;
    self.bottomView.layer.mask = maskLayer;
    
    self.bottomShadowView.sd_layout
    .leftEqualToView(self.bottomView)
    .rightEqualToView(self.bottomView)
    .bottomEqualToView(self.bottomView)
    .heightRatioToView(self.bottomView, 1);
    self.bottomShadowView.layer.cornerRadius = 24;
    
    self.rejectBtn.sd_layout
    .topSpaceToView(self.bottomView, 28)
    .leftSpaceToView(self.bottomView, 28)
    .widthIs(145)
    .heightIs(44);
    self.rejectBtn.sd_cornerRadiusFromHeightRatio = @0.5;
    
    self.confirmBtn.sd_layout
    .topSpaceToView(self.bottomView, 28)
    .rightSpaceToView(self.bottomView, 28)
    .widthIs(145)
    .heightIs(44);
    self.confirmBtn
    .sd_cornerRadiusFromHeightRatio = @0.5;
    
}



#pragma mark - lazyLoad
-(UITableView *)mainTableView{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
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
        _mainTableView.contentInset = UIEdgeInsetsMake(0, 0, 150, 0);
        _mainTableView.scrollIndicatorInsets = _mainTableView.contentInset;
        _mainTableView.showsVerticalScrollIndicator = NO;
    }
    return _mainTableView;
}


-(UIView *)bottomShadowView{
    if (!_bottomShadowView) {
        _bottomShadowView = [[UIView alloc] init];
        _bottomShadowView.backgroundColor = [UIColor whiteColor];
        _bottomShadowView.layer.shadowColor = COLOR_WITH_ALPHA(0x000000, 0.15).CGColor;
        _bottomShadowView.layer.shadowOffset = CGSizeMake(0, -2);
        _bottomShadowView.layer.shadowRadius = 4;
        _bottomShadowView.layer.shadowOpacity = 1;
    }
    return _bottomShadowView;
}

-(UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = [UIColor whiteColor];
        _bottomView.clipsToBounds = YES;
    }
    return _bottomView;
}

-(UIButton *)rejectBtn{
    if (!_rejectBtn) {
        _rejectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rejectBtn.titleLabel.font = HXBoldFont(16);
        _rejectBtn.backgroundColor = COLOR_WITH_ALPHA(0xFE664B, 1);
        [_rejectBtn setTitle:@"驳 回" forState:UIControlStateNormal];
        [_rejectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_rejectBtn addTarget:self action:@selector(reject:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rejectBtn;
}

-(UIButton *)confirmBtn{
    if (!_confirmBtn) {
        _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _confirmBtn.titleLabel.font = HXBoldFont(16);
        _confirmBtn.backgroundColor = COLOR_WITH_ALPHA(0x4DC656, 1);
        [_confirmBtn setTitle:@"确认异动" forState:UIControlStateNormal];
        [_confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_confirmBtn addTarget:self action:@selector(confirm:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmBtn;
}


@end

