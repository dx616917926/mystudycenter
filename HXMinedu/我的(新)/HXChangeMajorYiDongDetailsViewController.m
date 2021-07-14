//
//  HXChangeMajorYiDongDetailsViewController.m
//  HXMinedu
//
//  Created by mac on 2021/7/9.
//

#import "HXChangeMajorYiDongDetailsViewController.h"
#import "HXZhuanJieYiDongDetailsViewController.h"
#import "HXNotZhuanJieYiDongDetailsViewController.h"
#import "HXOriginalPaymentInfoViewController.h"
#import "HXRecentPaymentInfoViewController.h"
#import "HXYiDongHeadInfoCell.h"
#import "HXMajorInfoCell.h"
#import "HXCheckMajorInfoCell.h"
#import "HXSuggestionCell.h"
#import "HXOriginalPaymentInfoCell.h"
#import "HXReviewerSuggestionCell.h"
#import "HXToastSuggestionView.h"
#import "HXCustomToastView.h"
#import "HXZzyAndZcpModel.h"

@interface HXChangeMajorYiDongDetailsViewController ()<UITableViewDelegate,UITableViewDataSource,HXCheckMajorInfoCellDelegate>
@property(nonatomic,strong) UITableView *mainTableView;
@property(nonatomic,strong) UIView *bottomView;
@property(nonatomic,strong) UIButton *nextBtn;//下一步

@property(nonatomic,strong) UIView *headerView;
@property(nonatomic,strong) UIImageView *bigHeaderWhiteImageView;

@property(nonatomic,strong) UIView *footerView;
@property(nonatomic,strong) UIImageView *bigFooterWhiteImageView;
@property(nonatomic,strong) UILabel *jieZhuanRemarkLabel;
@property(nonatomic,strong) UILabel *jieZhuanRemarkContentLabel;
@property(nonatomic,strong) UILabel *jieZhuanAmountLabel;
@property(nonatomic,strong) UILabel *jieZhuanAmountContentLabel;



//转产品/专业模型
@property(nonatomic,strong) HXZzyAndZcpModel *zzyAndZcpModel;

@end

@implementation HXChangeMajorYiDongDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
    
    if (self.isconfirm) {
        self.bottomView.hidden = YES;
        // 获取学生已确认异动详情
        [self getStopStudyConfirmedInfo];
    }else{
        self.bottomView.hidden = NO;
        // 获取学生转专业转产品异动详情
        [self getStopStudyByZzyAndZcpInfo];
    }
    
}

-(void)setIsconfirm:(BOOL)isconfirm{
    _isconfirm = isconfirm;
}

#pragma mark - 获取学生转专业转产品异动详情
-(void)getStopStudyByZzyAndZcpInfo{
    
    NSDictionary *dic = @{
        @"stopStudyId":HXSafeString(self.stopStudyId)
    };
    [self.view showLoading];
    [HXBaseURLSessionManager postDataWithNSString:HXPOST_GetStopStudyByZzyAndZcpInfo  withDictionary:dic success:^(NSDictionary * _Nonnull dictionary) {
        [self.view hideLoading];
        BOOL success = [dictionary boolValueForKey:@"Success"];
        if (success) {
            self.zzyAndZcpModel = [HXZzyAndZcpModel mj_objectWithKeyValues:[dictionary objectForKey:@"Data"]];
            self.jieZhuanRemarkContentLabel.text = ([HXCommonUtil isNull:self.zzyAndZcpModel.yiDongInfoModel.costRemark]?@"--":self.zzyAndZcpModel.yiDongInfoModel.costRemark);
            self.jieZhuanAmountContentLabel.text = [NSString stringWithFormat:@"¥%.2f",self.zzyAndZcpModel.costMoneyTotal];
            [self.mainTableView reloadData];
        }
    } failure:^(NSError * _Nonnull error) {
        [self.view hideLoading];
    }];
}

#pragma mark - 获取学生已确认异动详情
-(void)getStopStudyConfirmedInfo{
    
    NSDictionary *dic = @{
        @"stopStudyId":HXSafeString(self.stopStudyId)
    };
    [self.view showLoading];
    [HXBaseURLSessionManager postDataWithNSString:HXPOST_GetStopStudyConfirmedInfo  withDictionary:dic success:^(NSDictionary * _Nonnull dictionary) {
        [self.view hideLoading];
        BOOL success = [dictionary boolValueForKey:@"Success"];
        if (success) {
            self.zzyAndZcpModel = [HXZzyAndZcpModel mj_objectWithKeyValues:[dictionary objectForKey:@"Data"]];
            self.zzyAndZcpModel.confirmedRecentMajorInfoModel.isRecent = YES;
            [self.mainTableView reloadData];
        }
    } failure:^(NSError * _Nonnull error) {
        [self.view hideLoading];
    }];
}

#pragma mark - Event
-(void)next:(UIButton *)sender{
    //1-需要退费  0-不需要退费
    if (self.zzyAndZcpModel.isRefund == 1) {
        HXZhuanJieYiDongDetailsViewController *vc = [[HXZhuanJieYiDongDetailsViewController alloc] init];
        vc.stopStudyId = self.stopStudyId;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        HXNotZhuanJieYiDongDetailsViewController *vc = [[HXNotZhuanJieYiDongDetailsViewController alloc] init];
        vc.stopStudyId = self.stopStudyId;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - <HXCheckMajorInfoCellDelegate>查看原专业/新专业缴费信息
-(void)checkDetailsWithRecent:(BOOL)isRecent{
    if (isRecent) {//新专业缴费信息
        HXRecentPaymentInfoViewController *vc = [[HXRecentPaymentInfoViewController alloc] init];
        vc.stopStudyId = self.stopStudyId;
        [self.navigationController pushViewController:vc animated:YES];
    }else{//原专业缴费信息
        HXOriginalPaymentInfoViewController *vc = [[HXOriginalPaymentInfoViewController alloc] init];
        vc.stopStudyId = self.stopStudyId;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - <UITableViewDelegate,UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (!self.isconfirm) {
        return 3;
    }else{
        //reviewstatus=2和3时显示确认意见 reviewstatus=4和5时显示确认意见和审核意见 其他不显示
        NSInteger reviewstatus = self.zzyAndZcpModel.confirmedYiDongInfoModel.reviewstatus;
        switch (reviewstatus) {
            case 0:
            case 1:
                return 3;
                break;
            case 2:
            case 3:
                return 4;
                break;
            case 4:
            case 5:
                return 5;
                break;
            default:
                return 0;
                break;
        }
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (!self.isconfirm && section == 2) {
        return self.zzyAndZcpModel.stopStudyByZzyAndZcpFeeList.count;
    }else{
        return 1;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (!self.isconfirm && section == 2) {
        return self.headerView;
    }else{
        return nil;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (!self.isconfirm && section == 2) {
        return self.footerView;
    }else{
        return nil;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (!self.isconfirm && section == 2) {
        return 38;
    }else{
        return 0.001;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (!self.isconfirm && section == 2) {
        return 90;
    }else{
        return 0.001;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return 104;
            break;
        case 1:
            return self.isconfirm?182:156;
            break;
        case 2:
            if (self.isconfirm) {
                return 182;
            }else{
                HXPaymentDetailsInfoModel *paymentDetailsInfoModel = self.zzyAndZcpModel.stopStudyByZzyAndZcpFeeList[indexPath.row];
                CGFloat rowHeight = [tableView cellHeightForIndexPath:indexPath
                                                                model:paymentDetailsInfoModel keyPath:@"paymentDetailsInfoModel"
                                                            cellClass:([HXOriginalPaymentInfoCell class])
                                                     contentViewWidth:kScreenWidth];
                return rowHeight;
            }
            break;
        case 3://确认意见
        {
            HXYiDongInfoModel *yiDongInfoModel = self.zzyAndZcpModel.confirmedYiDongInfoModel;
            CGFloat rowHeight = [tableView cellHeightForIndexPath:indexPath
                                                            model:yiDongInfoModel keyPath:@"yiDongInfoModel"
                                                        cellClass:([HXSuggestionCell class])
                                                 contentViewWidth:kScreenWidth];
            return rowHeight;
        }
            break;
        case 4://审核意见
        {
            HXYiDongInfoModel *yiDongInfoModel = self.zzyAndZcpModel.confirmedYiDongInfoModel;
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
    static NSString *reviewerSuggestionCellIdentifier = @"HXReviewerSuggestionCellIdentifier";
    static NSString *majorInfoCellIdentifier = @"HXMajorInfoCellIdentifier";
    static NSString *suggestionCellIdentifier = @"HXSuggestionCellIdentifier";
    static NSString *checkMajorInfoCellIdentifier = @"HXCheckMajorInfoCellIdentifier";
    static NSString *oiginalPaymentInfoCellIdentifier = @"HXOriginalPaymentInfoCellIdentifier";
    
    
    switch (indexPath.section) {
        case 0:
        {
            
            HXYiDongHeadInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:yiDongHeadInfoCellIdentifier];
            if (!cell) {
                cell = [[HXYiDongHeadInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:yiDongHeadInfoCellIdentifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.yiDongInfoModel = (self.isconfirm ? self.zzyAndZcpModel.confirmedYiDongInfoModel: self.zzyAndZcpModel.yiDongInfoModel);
            return cell;
        }
            break;
        case 1:
        {
            if (self.isconfirm) {
                HXCheckMajorInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:checkMajorInfoCellIdentifier];
                if (!cell) {
                    cell = [[HXCheckMajorInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:checkMajorInfoCellIdentifier];
                }
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.delegate = self;
                cell.majorInfoModel = self.zzyAndZcpModel.confirmedOldMajorInfoModel;
                return cell;
            }else{
                HXMajorInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:majorInfoCellIdentifier];
                if (!cell) {
                    cell = [[HXMajorInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:majorInfoCellIdentifier];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.majorInfoModel = self.zzyAndZcpModel.majorInfoModel;
                return cell;
            }
        }
            break;
        case 2:
        {
            if (self.isconfirm) {
                HXCheckMajorInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:checkMajorInfoCellIdentifier];
                if (!cell) {
                    cell = [[HXCheckMajorInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:checkMajorInfoCellIdentifier];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.delegate = self;
                cell.majorInfoModel = self.zzyAndZcpModel.confirmedRecentMajorInfoModel;
                return cell;
            }else{
                HXOriginalPaymentInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:oiginalPaymentInfoCellIdentifier];
                if (!cell) {
                    cell = [[HXOriginalPaymentInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:oiginalPaymentInfoCellIdentifier];
                }
                HXPaymentDetailsInfoModel *paymentDetailsInfoModel = self.zzyAndZcpModel.stopStudyByZzyAndZcpFeeList[indexPath.row];
                [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
                cell.paymentDetailsInfoModel = paymentDetailsInfoModel;
                return cell;
            }
        }
            break;
        case 3://确认意见
        {
            HXSuggestionCell *cell = [tableView dequeueReusableCellWithIdentifier:suggestionCellIdentifier];
            if (!cell) {
                cell = [[HXSuggestionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:suggestionCellIdentifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            HXYiDongInfoModel *yiDongInfoModel = self.zzyAndZcpModel.confirmedYiDongInfoModel;
            cell.yiDongInfoModel = yiDongInfoModel;
            return cell;
        }
            break;
        case 4:
        {
            HXReviewerSuggestionCell *cell = [tableView dequeueReusableCellWithIdentifier:reviewerSuggestionCellIdentifier];
            if (!cell) {
                cell = [[HXReviewerSuggestionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reviewerSuggestionCellIdentifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            HXYiDongInfoModel *yiDongInfoModel = self.zzyAndZcpModel.confirmedYiDongInfoModel;
            cell.yiDongInfoModel = yiDongInfoModel;
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
   
    [self.view addSubview:self.bottomView];
    [self.bottomView addSubview:self.nextBtn];
    
    
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
    
   
    
    self.nextBtn.sd_layout
    .topSpaceToView(self.bottomView, 26)
    .leftSpaceToView(self.bottomView, 10)
    .rightSpaceToView(self.bottomView, 10)
    .heightIs(40);
    self.nextBtn.sd_cornerRadiusFromHeightRatio = @0.5;
    
   
}

#pragma mark - lazyLoad
-(UITableView *)mainTableView{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
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



-(UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = COLOR_WITH_ALPHA(0xFCFCFC, 1);
        _bottomView.clipsToBounds = YES;
    }
    return _bottomView;
}

-(UIButton *)nextBtn{
    if (!_nextBtn) {
        _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _nextBtn.titleLabel.font = HXBoldFont(16);
        _nextBtn.backgroundColor = COLOR_WITH_ALPHA(0x5699FF, 1);
        [_nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
        [_nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_nextBtn addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextBtn;
}

-(UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 38)];
        _headerView.backgroundColor = [UIColor clearColor];
        [_headerView addSubview:self.bigHeaderWhiteImageView];
        self.bigHeaderWhiteImageView.sd_layout
        .topSpaceToView(_headerView, 8)
        .leftSpaceToView(_headerView, 10)
        .rightSpaceToView(_headerView, 10)
        .bottomEqualToView(_headerView);

        UILabel *label = [[UILabel alloc] init];
        label.font = HXBoldFont(16);
        label.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        label.text = @"原缴费信息";
        [self.bigHeaderWhiteImageView addSubview:label];
        label.sd_layout
        .topSpaceToView(self.bigHeaderWhiteImageView, 14)
        .leftSpaceToView(self.bigHeaderWhiteImageView, 24)
        .rightSpaceToView(self.bigHeaderWhiteImageView, 24)
        .heightIs(22);
    }
    return _headerView;
}
-(UIImageView *)bigHeaderWhiteImageView{
    if (!_bigHeaderWhiteImageView) {
        _bigHeaderWhiteImageView = [[UIImageView alloc] init];
        _bigHeaderWhiteImageView.image = [UIImage resizedImageWithName:@"top_radius"];
    }
    return _bigHeaderWhiteImageView;
}

-(UIView *)footerView{
    if (!_footerView) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 90)];
        _footerView.backgroundColor = [UIColor clearColor];
        [_footerView addSubview:self.bigFooterWhiteImageView];
        [self.bigFooterWhiteImageView addSubview:self.jieZhuanRemarkLabel];
        [self.bigFooterWhiteImageView addSubview:self.jieZhuanRemarkContentLabel];
        [self.bigFooterWhiteImageView addSubview:self.jieZhuanAmountLabel];
        [self.bigFooterWhiteImageView addSubview:self.jieZhuanAmountContentLabel];
        
        self.bigFooterWhiteImageView.sd_layout
        .topSpaceToView(_footerView, 0)
        .leftSpaceToView(_footerView, 10)
        .rightSpaceToView(_footerView, 10)
        .bottomSpaceToView(_footerView, 8);
        
        self.jieZhuanRemarkLabel.sd_layout
        .topSpaceToView(self.bigFooterWhiteImageView, 13)
        .leftSpaceToView(self.bigFooterWhiteImageView, 33)
        .heightIs(17);
        [self.jieZhuanRemarkLabel setSingleLineAutoResizeWithMaxWidth:100];
        
        self.jieZhuanRemarkContentLabel.sd_layout
        .topEqualToView(self.jieZhuanRemarkLabel).offset(2)
        .leftSpaceToView(self.jieZhuanRemarkLabel, 0)
        .rightSpaceToView(self.bigFooterWhiteImageView, 24)
        .autoHeightRatio(0);
        [self.jieZhuanRemarkContentLabel setMaxNumberOfLinesToShow:2];
        
        self.jieZhuanAmountLabel.sd_layout
        .topSpaceToView(self.bigFooterWhiteImageView, 50)
        .leftSpaceToView(self.bigFooterWhiteImageView, _kpw(150))
        .heightIs(17);
        [self.jieZhuanAmountLabel setSingleLineAutoResizeWithMaxWidth:120];

        self.jieZhuanAmountContentLabel.sd_layout
        .centerYEqualToView(self.jieZhuanAmountLabel)
        .leftSpaceToView(self.jieZhuanAmountLabel, 0)
        .rightSpaceToView(self.bigFooterWhiteImageView, 24)
        .heightIs(17);
       
    }
    return _footerView;
}

-(UIImageView *)bigFooterWhiteImageView{
    if (!_bigFooterWhiteImageView) {
        _bigFooterWhiteImageView = [[UIImageView alloc] init];
        _bigFooterWhiteImageView.image = [UIImage resizedImageWithName:@"bottom_radius"];
    }
    return _bigFooterWhiteImageView;
}

-(UILabel *)jieZhuanRemarkLabel{
    if (!_jieZhuanRemarkLabel) {
        _jieZhuanRemarkLabel = [[UILabel alloc] init];
        _jieZhuanRemarkLabel.textAlignment = NSTextAlignmentLeft;
        _jieZhuanRemarkLabel.font = HXFont(12);
        _jieZhuanRemarkLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        _jieZhuanRemarkLabel.text = @"结转备注：";
    }
    return _jieZhuanRemarkLabel;
}

-(UILabel *)jieZhuanRemarkContentLabel{
    if (!_jieZhuanRemarkContentLabel) {
        _jieZhuanRemarkContentLabel = [[UILabel alloc] init];
        _jieZhuanRemarkContentLabel.textAlignment = NSTextAlignmentLeft;
        _jieZhuanRemarkContentLabel.font = HXFont(12);
        _jieZhuanRemarkContentLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        _jieZhuanRemarkContentLabel.numberOfLines = 2;
        
    }
    return _jieZhuanRemarkContentLabel;
}

-(UILabel *)jieZhuanAmountLabel{
    if (!_jieZhuanAmountLabel) {
        _jieZhuanAmountLabel = [[UILabel alloc] init];
        _jieZhuanAmountLabel.textAlignment = NSTextAlignmentLeft;
        _jieZhuanAmountLabel.font = HXFont(12);
        _jieZhuanAmountLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        _jieZhuanAmountLabel.text = @"合计可结转金额：";
    }
    return _jieZhuanAmountLabel;
}

-(UILabel *)jieZhuanAmountContentLabel{
    if (!_jieZhuanAmountContentLabel) {
        _jieZhuanAmountContentLabel = [[UILabel alloc] init];
        _jieZhuanAmountContentLabel.textAlignment = NSTextAlignmentLeft;
        _jieZhuanAmountContentLabel.font = HXFont(12);
        _jieZhuanAmountContentLabel.textColor = COLOR_WITH_ALPHA(0xFE664B, 1);
       
    }
    return _jieZhuanAmountContentLabel;
}


@end

