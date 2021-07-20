//
//  HXOriginalPaymentInfoViewController.m
//  HXMinedu
//
//  Created by mac on 2021/7/9.
//

#import "HXOriginalPaymentInfoViewController.h"
#import "HXYiDongHeadInfoCell.h"
#import "HXMajorInfoCell.h"
#import "HXOriginalPaymentInfoCell.h"
#import "HXZzyAndZcpModel.h"


@interface HXOriginalPaymentInfoViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UITableView *mainTableView;


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

@implementation HXOriginalPaymentInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
 
    [self createUI];
    
    [self getStopStudyByZzyAndZcpInfo];
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


#pragma mark - <UITableViewDelegate,UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 2) {
        return self.zzyAndZcpModel.stopStudyByZzyAndZcpFeeList.count;
    }else{
        return 1;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 2) {
        return self.headerView;
    }else{
        return nil;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 2) {
        return self.footerView;
    }else{
        return nil;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 2) {
        return 38;
    }else{
        return 0.001;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 2) {
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
            return 156;
            break;
        case 2:
            {
                HXPaymentDetailsInfoModel *paymentDetailsInfoModel = self.zzyAndZcpModel.stopStudyByZzyAndZcpFeeList[indexPath.row];
                CGFloat rowHeight = [tableView cellHeightForIndexPath:indexPath
                                                                model:paymentDetailsInfoModel keyPath:@"paymentDetailsInfoModel"
                                                            cellClass:([HXOriginalPaymentInfoCell class])
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
    static NSString *oiginalPaymentInfoCellIdentifier = @"HXOriginalPaymentInfoCellIdentifier";
    
    
    switch (indexPath.section) {
        case 0:
        {
            
            HXYiDongHeadInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:yiDongHeadInfoCellIdentifier];
            if (!cell) {
                cell = [[HXYiDongHeadInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:yiDongHeadInfoCellIdentifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.yiDongInfoModel = self.zzyAndZcpModel.yiDongInfoModel;
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
            cell.majorInfoModel = self.zzyAndZcpModel.majorInfoModel;
            return cell;
        }
            break;
        case 2:
        {
            HXOriginalPaymentInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:oiginalPaymentInfoCellIdentifier];
            if (!cell) {
                cell = [[HXOriginalPaymentInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:oiginalPaymentInfoCellIdentifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            HXPaymentDetailsInfoModel *paymentDetailsInfoModel = self.zzyAndZcpModel.stopStudyByZzyAndZcpFeeList[indexPath.row];
            [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
            cell.paymentDetailsInfoModel = paymentDetailsInfoModel;
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

    self.mainTableView.sd_layout
    .topSpaceToView(self.view, kNavigationBarHeight)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomEqualToView(self.view);
    
   
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
        _mainTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _mainTableView.scrollIndicatorInsets = _mainTableView.contentInset;
        _mainTableView.showsVerticalScrollIndicator = NO;
    }
    return _mainTableView;
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


