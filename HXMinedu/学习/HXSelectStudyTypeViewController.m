//
//  HXSelectStudyTypeViewController.m
//  HXMinedu
//
//  Created by mac on 2021/3/31.
//

#import "HXSelectStudyTypeViewController.h"
#import "HXLeftCell.h"
#import "HXRightCollectionViewCell.h"
#import "HXRightSectionHeadView.h"

@interface HXSelectStudyTypeViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDataSource,UICollectionViewDelegate>
@property(nonatomic,strong) UIView *bigNavBackGroundView;
@property(nonatomic,strong) UIButton *closeBtn;
@property(nonatomic,strong) UILabel *titleLabel;

@property(nonatomic,strong) UITableView *leftTableView;
@property(nonatomic,strong) UIView *leftShadowView;
@property(nonatomic,strong) UICollectionView *rightCollectionView;

@property(nonatomic,strong)  HXVersionModel *leftFirstSelectModel;//记录左侧刚进来时次选择
@property(nonatomic,strong)  HXMajorModel*rightFirstSelectModel;//记录右侧侧刚进来时次选择
@property(nonatomic,strong)  HXVersionModel *leftSelectModel;
@property(nonatomic,strong)  HXMajorModel*rightSelectModel;

@end

@implementation HXSelectStudyTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = COLOR_WITH_ALPHA(0xFCFCFC, 1);
    
    [self createUI];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    if (@available(iOS 13.0, *)) {
        return UIStatusBarStyleDarkContent;
    } else {
        return UIStatusBarStyleDefault;
    }
}



#pragma mark - Event
-(void)clickCloseBtn{
    
    BOOL isRefesh = NO;
    if (![self.rightSelectModel.major_id isEqualToString:self.rightFirstSelectModel.major_id]) {
        isRefesh = YES;
        ///刷新选中的
        [self.versionList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            HXVersionModel *model = obj;
            if (model.type == self.leftSelectModel.type) {
                model.isSelected = YES;
                [model.majorList enumerateObjectsUsingBlock:^(HXMajorModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj.major_id isEqualToString:self.rightSelectModel.major_id]) {
                        obj.isSelected = YES;
                    }else{
                        obj.isSelected = NO;
                    }
                }];
            }else{
                model.isSelected = NO;
                [model.majorList enumerateObjectsUsingBlock:^(HXMajorModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    obj.isSelected = NO;
                }];
            }
        }];
    }
    
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.selectFinishCallBack&&isRefesh) {
            self.selectFinishCallBack(self.versionList,self.leftSelectModel,self.rightSelectModel);
        }
    }];
}


#pragma mark - <UITableViewDelegate,UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.versionList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 52;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *leftCellIdentifier = @"HXLeftCelldentifier";
    HXLeftCell *cell = [tableView dequeueReusableCellWithIdentifier:leftCellIdentifier];
    if (!cell) {
        cell = [[HXLeftCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:leftCellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.versionList[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    HXVersionModel *model = self.versionList[indexPath.row];
    if (model == self.leftSelectModel) {
        return;
    }
    //刷新右侧数据
    self.leftSelectModel.isSelected = NO;
    model.isSelected = YES;
    self.leftSelectModel = model;
    [self.leftTableView reloadData];
    [self.rightCollectionView reloadData];
    
    //隐藏选择的cell的上面那个cell的分割线
    HXLeftCell *cell = (HXLeftCell*)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:(indexPath.row-1) inSection:0]];
    if (cell) {
        [cell hideBottomLine];
    }

}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

#pragma mark - <UICollectionViewDataSource,UICollectionViewDelegate>
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.leftSelectModel.majorList.count;
    
    
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HXRightCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HXRightCollectionViewCell class]) forIndexPath:indexPath];
    cell.model = self.leftSelectModel.majorList[indexPath.row];
    return cell;
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    if (kind == UICollectionElementKindSectionHeader) {
        HXRightSectionHeadView *head = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([HXRightSectionHeadView class]) forIndexPath:indexPath];
        return head;
    }else{
        return nil;
    }
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    self.rightSelectModel = self.leftSelectModel.majorList[indexPath.row];
    self.rightSelectModel.isSelected = YES;
    [self clickCloseBtn];
    
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(kScreenWidth-_kpw(130), 52);
}




#pragma mark - UI
-(void)createUI{
    [self.view addSubview:self.bigNavBackGroundView];
    [self.bigNavBackGroundView addSubview:self.closeBtn];
    [self.bigNavBackGroundView addSubview:self.titleLabel];
    [self.view addSubview:self.leftTableView];
    [self.view addSubview:self.leftShadowView];
    [self.view addSubview:self.rightCollectionView];
    
    self.bigNavBackGroundView.sd_layout
    .topEqualToView(self.view)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .heightIs(kNavigationBarHeight);
    
    self.closeBtn.sd_layout
    .centerYIs(kStatusBarHeight+22)
    .leftEqualToView(self.bigNavBackGroundView)
    .heightIs(44)
    .widthIs(70);
    
    self.closeBtn.imageView.sd_layout
    .leftSpaceToView(self.closeBtn, _kpw(23))
    .centerYEqualToView(self.closeBtn)
    .widthIs(20)
    .heightEqualToWidth();
    
    self.titleLabel.sd_layout
    .centerYEqualToView(self.closeBtn)
    .centerXEqualToView(self.bigNavBackGroundView)
    .heightRatioToView(self.closeBtn, 1)
    .widthIs(kScreenHeight/2);
    
    self.leftTableView.sd_layout
    .leftEqualToView(self.view)
    .topSpaceToView(self.bigNavBackGroundView,0)
    .bottomSpaceToView(self.view,0)
    .widthIs(_kpw(130));
    
    self.leftShadowView.sd_layout
    .topEqualToView(self.leftTableView)
    .leftEqualToView(self.leftTableView)
    .rightEqualToView(self.leftTableView)
    .bottomEqualToView(self.leftTableView);
//
    self.rightCollectionView.sd_layout
    .topEqualToView(self.leftTableView)
    .leftSpaceToView(self.leftTableView, 0)
    .rightEqualToView(self.view)
    .bottomEqualToView(self.view);
    ///调整一下顺序，不然阴影被遮挡了
    [self.view insertSubview:self.rightCollectionView belowSubview:self.bigNavBackGroundView];
    [self.view insertSubview:self.leftTableView aboveSubview:self.bigNavBackGroundView];
    [self.view insertSubview:self.leftShadowView belowSubview:self.bigNavBackGroundView];
    
}

#pragma mark - setter
-(void)setVersionList:(NSArray *)versionList{
    _versionList = versionList;
    //选出左侧选中的
    [versionList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        HXVersionModel *model = obj;
        if (model.isSelected) {
            self.leftFirstSelectModel = model;
            self.leftSelectModel = model;
            *stop = YES;
            return;
        }
    }];
    //选出右侧选中的
    [self.leftSelectModel.majorList enumerateObjectsUsingBlock:^(HXMajorModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        HXMajorModel *model = obj;
        if (model.isSelected) {
            self.rightFirstSelectModel = model;
            self.rightSelectModel = model;
            *stop = YES;
            return;
        }
    }];
}


#pragma mark - lazyLoad
-(UIView *)bigNavBackGroundView{
    if (!_bigNavBackGroundView) {
        _bigNavBackGroundView = [[UIView alloc] init];
        _bigNavBackGroundView.backgroundColor = [UIColor whiteColor];
        _bigNavBackGroundView.layer.shadowColor = COLOR_WITH_ALPHA(0x000000, 0.15).CGColor;
        _bigNavBackGroundView.layer.shadowOffset = CGSizeMake(0, 1);
        _bigNavBackGroundView.layer.shadowRadius = 6;
        _bigNavBackGroundView.layer.shadowOpacity = 1;
    }
    return _bigNavBackGroundView;
}

-(UIButton *)closeBtn{
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setImage:[UIImage imageNamed:@"close_icon"] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(clickCloseBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        _titleLabel.font = HXBoldFont(18);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = @"选择学习类型";
    }
    return _titleLabel;
}

-(UITableView *)leftTableView{
    if (!_leftTableView) {
        _leftTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _leftTableView.bounces = NO;
        _leftTableView.delegate = self;
        _leftTableView.dataSource = self;
        _leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if ([_leftTableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_leftTableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
        self.extendedLayoutIncludesOpaqueBars = YES;
        if (@available(iOS 11.0, *)) {
            _leftTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _leftTableView.estimatedRowHeight = 0;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        _leftTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _leftTableView.scrollIndicatorInsets = _leftTableView.contentInset;
        _leftTableView.showsVerticalScrollIndicator = NO;
    }
    return _leftTableView;
    
}

-(UIView *)leftShadowView{
    if (!_leftShadowView) {
        _leftShadowView = [[UIView alloc] init];
        _leftShadowView.backgroundColor = [UIColor whiteColor];
        _leftShadowView.layer.shadowColor = COLOR_WITH_ALPHA(0x000000, 0.15).CGColor;
        _leftShadowView.layer.shadowOffset = CGSizeMake(0, 1);
        _leftShadowView.layer.shadowRadius = 6;
        _leftShadowView.layer.shadowOpacity = 1;
    }
    return _leftShadowView;
}

-(UICollectionView *)rightCollectionView{
    if (!_rightCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumLineSpacing = 8;
        layout.minimumInteritemSpacing = 8;
        layout.sectionInset = UIEdgeInsetsMake(0, 8, 0, 8);
        float width = floorf((kScreenWidth-24-_kpw(130))/2);
        layout.itemSize = CGSizeMake(width,36);
        _rightCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _rightCollectionView.backgroundColor = [UIColor clearColor];
        _rightCollectionView.delegate = self;
        _rightCollectionView.dataSource = self;
        _rightCollectionView.showsVerticalScrollIndicator = NO;
        _rightCollectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        if (@available(iOS 11.0, *)) {
            _rightCollectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        _rightCollectionView.scrollIndicatorInsets = _rightCollectionView.contentInset;
        _rightCollectionView.showsVerticalScrollIndicator = NO;
        ///注册cell、段头
        [_rightCollectionView registerClass:[HXRightCollectionViewCell class]
                 forCellWithReuseIdentifier:NSStringFromClass([HXRightCollectionViewCell class])];
        ///注册段头
        [_rightCollectionView registerClass:[HXRightSectionHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([HXRightSectionHeadView class])];
    }
    return _rightCollectionView;;
}


@end
