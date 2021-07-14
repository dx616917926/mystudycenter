//
//  HXZhuanJieYiDongDetailsViewController.m
//  HXMinedu
//
//  Created by mac on 2021/7/8.
//

#import "HXZhuanJieYiDongDetailsViewController.h"
#import "HXYiDongTuiFeiViewController.h"
#import "HXMajorInfoCell.h"
#import "HXRecentPaymentInfoCell.h"
#import "HXZzyAndZcpModel.h"

@interface HXZhuanJieYiDongDetailsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) UITableView *mainTableView;
@property(nonatomic,strong) UIView *bottomView;
@property(nonatomic,strong) UIButton *nextBtn;//下一步

//新缴费信息
@property(nonatomic,strong) UIView *headerView;
@property(nonatomic,strong) UIImageView *bigHeaderWhiteImageView;
@property(nonatomic,strong) UILabel *xinPayMentInfoLabel;
@property(nonatomic,strong) UIView *line1;
//应缴合计
@property(nonatomic,strong) UILabel *yinJiaoLabel;
@property(nonatomic,strong) UILabel *yinJiaoMoneyLabel;
@property(nonatomic,strong) UIView *line2;
//结转合计
@property(nonatomic,strong) UILabel *jieZhuanLabel;
@property(nonatomic,strong) UILabel *jieZhuanMoneyLabel;
//结账后应退
@property(nonatomic,strong) UILabel *yingTuiLabel;
@property(nonatomic,strong) UILabel *yingTuiMoneyLabel;

@property(nonatomic,strong) UIView *footerView;
@property(nonatomic,strong) UIImageView *bigFooterWhiteImageView;

//转产品/专业详情
@property(nonatomic,strong) HXZzyAndZcpModel *zzyAndZcpModel;

@end

@implementation HXZhuanJieYiDongDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
    //获取学生转专业转产品异动新专业详情
    [self getStopStudyByZzyAndZcpNewMajorInfo];
}


#pragma mark - 获取学生转专业转产品异动新专业详情
-(void)getStopStudyByZzyAndZcpNewMajorInfo{
    
    NSDictionary *dic = @{
        @"stopStudyId":HXSafeString(self.stopStudyId)
    };
    [self.view showLoading];
    [HXBaseURLSessionManager postDataWithNSString:HXPOST_GetStopStudyByZzyAndZcpNewMajorInfo  withDictionary:dic success:^(NSDictionary * _Nonnull dictionary) {
        [self.view hideLoading];
        BOOL success = [dictionary boolValueForKey:@"Success"];
        if (success) {
            self.zzyAndZcpModel = [HXZzyAndZcpModel mj_objectWithKeyValues:[dictionary objectForKey:@"Data"]];
            self.zzyAndZcpModel.jiezhuanMajorInfoModel.isRecent = YES;
            self.yinJiaoMoneyLabel.text = [NSString stringWithFormat:@"¥%.2f",self.zzyAndZcpModel.payMoneyTotal];
            self.jieZhuanMoneyLabel.text =[NSString stringWithFormat:@"¥%.2f",self.zzyAndZcpModel.costMoneyTotal];
            self.yingTuiMoneyLabel.text = [NSString stringWithFormat:@"¥%.2f",self.zzyAndZcpModel.refundTotal];
            
            [self.mainTableView reloadData];
        }
    } failure:^(NSError * _Nonnull error) {
        [self.view hideLoading];
    }];
}
#pragma mark - Event
-(void)next:(UIButton *)sender{
    HXYiDongTuiFeiViewController *vc = [[HXYiDongTuiFeiViewController alloc] init];
    vc.stopStudyId = self.stopStudyId;
    [self.navigationController pushViewController:vc animated:YES];
}



#pragma mark - <UITableViewDelegate,UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return self.headerView;
    }else{
        return nil;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 1) {
        return self.footerView;
    }else{
        return nil;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 106;
    }else{
        return 0.001;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 1) {
        return 30;
    }else{
        return 0.001;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return 156;
            break;
        case 1:
           {
              
               HXZzyAndZcpModel *zzyAndZcpModel = self.zzyAndZcpModel;
               CGFloat rowHeight = [tableView cellHeightForIndexPath:indexPath
                                                               model:zzyAndZcpModel keyPath:@"zzyAndZcpModel"
                                                           cellClass:([HXRecentPaymentInfoCell class])
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
    
  
    static NSString *majorInfoCellIdentifier = @"HXMajorInfoCellIdentifier";
    static NSString *recentPaymentInfoCellIdentifier = @"HXRecentPaymentInfoCellIdentifier";
    
    
    switch (indexPath.section) {
        case 0:
        {
            HXMajorInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:majorInfoCellIdentifier];
            if (!cell) {
                cell = [[HXMajorInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:majorInfoCellIdentifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.majorInfoModel = self.zzyAndZcpModel.jiezhuanMajorInfoModel;
            return cell;
        }
            break;
        case 1:
        {
            HXRecentPaymentInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:recentPaymentInfoCellIdentifier];
            if (!cell) {
                cell = [[HXRecentPaymentInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:recentPaymentInfoCellIdentifier];
            }
            HXZzyAndZcpModel *zzyAndZcpModel = self.zzyAndZcpModel;
            [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
            cell.zzyAndZcpModel = zzyAndZcpModel;
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
        _mainTableView.contentInset = UIEdgeInsetsMake(10, 0, 150, 0);
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
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 106)];
        _headerView.backgroundColor = [UIColor clearColor];
        [_headerView addSubview:self.bigHeaderWhiteImageView];
        self.bigHeaderWhiteImageView.sd_layout
        .topSpaceToView(_headerView, 8)
        .leftSpaceToView(_headerView, 10)
        .rightSpaceToView(_headerView, 10)
        .bottomEqualToView(_headerView);

        [self.bigHeaderWhiteImageView addSubview:self.xinPayMentInfoLabel];
        [self.bigHeaderWhiteImageView addSubview:self.line1];
        [self.bigHeaderWhiteImageView addSubview:self.yinJiaoLabel];
        [self.bigHeaderWhiteImageView addSubview:self.yinJiaoMoneyLabel];
        [self.bigHeaderWhiteImageView addSubview:self.line2];
        [self.bigHeaderWhiteImageView addSubview:self.jieZhuanLabel];
        [self.bigHeaderWhiteImageView addSubview:self.jieZhuanMoneyLabel];
        [self.bigHeaderWhiteImageView addSubview:self.yingTuiLabel];
        [self.bigHeaderWhiteImageView addSubview:self.yingTuiMoneyLabel];
        
        self.xinPayMentInfoLabel.sd_layout
        .topSpaceToView(self.bigHeaderWhiteImageView, 14)
        .leftSpaceToView(self.bigHeaderWhiteImageView, 24)
        .rightSpaceToView(self.bigHeaderWhiteImageView, 24)
        .heightIs(22);
        
        self.line1.sd_layout
        .topSpaceToView(self.bigHeaderWhiteImageView, 55)
        .leftSpaceToView(self.bigHeaderWhiteImageView, (kScreenWidth-20)/3)
        .widthIs(1)
        .heightIs(28);
        
        self.yinJiaoLabel.sd_layout
        .topSpaceToView(self.xinPayMentInfoLabel, 16)
        .leftSpaceToView(self.bigHeaderWhiteImageView, 0)
        .rightSpaceToView(self.line1, 0)
        .heightIs(17);
        
        self.yinJiaoMoneyLabel.sd_layout
        .topSpaceToView(self.yinJiaoLabel, 3)
        .leftEqualToView(self.yinJiaoLabel)
        .rightEqualToView(self.yinJiaoLabel)
        .heightIs(20);
        
        self.line2.sd_layout
        .topEqualToView(self.line1)
        .leftSpaceToView(self.bigHeaderWhiteImageView, (kScreenWidth-20)*2/3)
        .widthRatioToView(self.line1, 1)
        .heightRatioToView(self.line1, 1);
        
        self.jieZhuanLabel.sd_layout
        .topEqualToView(self.yinJiaoLabel)
        .leftSpaceToView(self.line1, 0)
        .rightSpaceToView(self.line2, 0)
        .heightRatioToView(self.yinJiaoLabel, 1);
        
        self.jieZhuanMoneyLabel.sd_layout
        .topEqualToView(self.yinJiaoMoneyLabel)
        .leftEqualToView(self.jieZhuanLabel)
        .rightEqualToView(self.jieZhuanLabel)
        .heightRatioToView(self.yinJiaoMoneyLabel, 1);
        
        self.yingTuiLabel.sd_layout
        .topEqualToView(self.yinJiaoLabel)
        .leftSpaceToView(self.line2, 0)
        .rightSpaceToView(self.bigHeaderWhiteImageView, 0)
        .heightRatioToView(self.yinJiaoLabel, 1);
        
        self.yingTuiMoneyLabel.sd_layout
        .topEqualToView(self.yinJiaoMoneyLabel)
        .leftEqualToView(self.yingTuiLabel)
        .rightEqualToView(self.yingTuiLabel)
        .heightRatioToView(self.yinJiaoMoneyLabel, 1);
        
        
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

-(UILabel *)xinPayMentInfoLabel{
    if (!_xinPayMentInfoLabel) {
        _xinPayMentInfoLabel = [[UILabel alloc] init];
        _xinPayMentInfoLabel.textAlignment = NSTextAlignmentLeft;
        _xinPayMentInfoLabel.font = HXBoldFont(16);
        _xinPayMentInfoLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        _xinPayMentInfoLabel.text = @"新缴费信息";
    }
    return _xinPayMentInfoLabel;
}

-(UIView *)line1{
    if (!_line1) {
        _line1 = [[UIView alloc] init];
        _line1.backgroundColor = COLOR_WITH_ALPHA(0x979797, 1);
    }
    return _line1;
}

-(UILabel *)yinJiaoLabel{
    if (!_yinJiaoLabel) {
        _yinJiaoLabel = [[UILabel alloc] init];
        _yinJiaoLabel.textAlignment = NSTextAlignmentCenter;
        _yinJiaoLabel.font = HXBoldFont(12);
        _yinJiaoLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        _yinJiaoLabel.text = @"应缴合计";
    }
    return _yinJiaoLabel;
}

-(UILabel *)yinJiaoMoneyLabel{
    if (!_yinJiaoMoneyLabel) {
        _yinJiaoMoneyLabel = [[UILabel alloc] init];
        _yinJiaoMoneyLabel.textAlignment = NSTextAlignmentCenter;
        _yinJiaoMoneyLabel.font = HXFont(12);
        _yinJiaoMoneyLabel.textColor = COLOR_WITH_ALPHA(0x5699FF, 1);
        
    }
    return _yinJiaoMoneyLabel;
}

-(UIView *)line2{
    if (!_line2) {
        _line2 = [[UIView alloc] init];
        _line2.backgroundColor = COLOR_WITH_ALPHA(0x979797, 1);
    }
    return _line2;
}

-(UILabel *)jieZhuanLabel{
    if (!_jieZhuanLabel) {
        _jieZhuanLabel = [[UILabel alloc] init];
        _jieZhuanLabel.textAlignment = NSTextAlignmentCenter;
        _jieZhuanLabel.font = HXBoldFont(12);
        _jieZhuanLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        _jieZhuanLabel.text = @"结转合计";
    }
    return _jieZhuanLabel;
}

-(UILabel *)jieZhuanMoneyLabel{
    if (!_jieZhuanMoneyLabel) {
        _jieZhuanMoneyLabel = [[UILabel alloc] init];
        _jieZhuanMoneyLabel.textAlignment = NSTextAlignmentCenter;
        _jieZhuanMoneyLabel.font = HXFont(12);
        _jieZhuanMoneyLabel.textColor = COLOR_WITH_ALPHA(0xFE664B, 1);
        
    }
    return _jieZhuanMoneyLabel;
}

-(UILabel *)yingTuiLabel{
    if (!_yingTuiLabel) {
        _yingTuiLabel = [[UILabel alloc] init];
        _yingTuiLabel.textAlignment = NSTextAlignmentCenter;
        _yingTuiLabel.font = HXBoldFont(12);
        _yingTuiLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        _yingTuiLabel.text = @"结账后应退";
    }
    return _yingTuiLabel;
}

-(UILabel *)yingTuiMoneyLabel{
    if (!_yingTuiMoneyLabel) {
        _yingTuiMoneyLabel = [[UILabel alloc] init];
        _yingTuiMoneyLabel.textAlignment = NSTextAlignmentCenter;
        _yingTuiMoneyLabel.font = HXFont(12);
        _yingTuiMoneyLabel.textColor = COLOR_WITH_ALPHA(0xFE664B, 1);
       
    }
    return _yingTuiMoneyLabel;
}



-(UIView *)footerView{
    if (!_footerView) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
        _footerView.backgroundColor = [UIColor clearColor];
        [_footerView addSubview:self.bigFooterWhiteImageView];
        
        self.bigFooterWhiteImageView.sd_layout
        .topSpaceToView(_footerView, 0)
        .leftSpaceToView(_footerView, 10)
        .rightSpaceToView(_footerView, 10)
        .bottomSpaceToView(_footerView, 8);
        
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






@end

