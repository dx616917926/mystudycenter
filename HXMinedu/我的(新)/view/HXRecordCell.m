//
//  HXRecordCell.m
//  HXMinedu
//
//  Created by mac on 2021/4/7.
//

#import "HXRecordCell.h"
#import "HXRecordInfoCell.h"
@interface HXRecordCell ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property(nonatomic,strong) UIImageView *titleImageView;
@property(nonatomic,strong) UILabel *titleLabel;
@property(nonatomic,strong) UICollectionView *infoCollectionView;
//是否是职业资格档案
@property(nonatomic,assign) BOOL isZhiYeDangAn;

@end

@implementation HXRecordCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 10;
        self.layer.shadowColor = COLOR_WITH_ALPHA(0x000000, 0.15).CGColor;
        self.layer.shadowOffset = CGSizeMake(0, 3);
        self.layer.shadowRadius = 4;
        self.layer.shadowOpacity = 1;
        [self createUI];
    }
    return self;
}

-(void)setMajorModel:(HXMajorModel *)majorModel{
    _majorModel = majorModel;
    self.titleLabel.text = HXSafeString(majorModel.title);
    self.isZhiYeDangAn = [majorModel.title isEqualToString:@"职业资格档案"];
    [self.infoCollectionView reloadData];
}

#pragma mark - <UICollectionViewDataSource,UICollectionViewDelegate>
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.isZhiYeDangAn?6:8;
    
    
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HXRecordInfoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HXRecordInfoCell class]) forIndexPath:indexPath];
    if (self.isZhiYeDangAn) {
        switch (indexPath.row) {
            case 0:
                cell.titleLabel.text = @"准考证号";
                cell.contentLabel.text = [HXCommonUtil isNull:self.majorModel.examineeNo]?@"--":self.majorModel.examineeNo;
                break;
            case 1:
                cell.titleLabel.text = @"报考批次";
                cell.contentLabel.text = [HXCommonUtil isNull:self.majorModel.enterDate]?@"--":self.majorModel.enterDate;
                break;
            case 2:
                cell.titleLabel.text = @"证书项目";
                cell.contentLabel.text = [HXCommonUtil isNull:self.majorModel.educationName]?@"--":self.majorModel.educationName;
                break;
            case 3:
                cell.titleLabel.text = @"证书等级";
                cell.contentLabel.text = [HXCommonUtil isNull:self.majorModel.majorName]?@"--":self.majorModel.majorName;
                break;
            case 4:
                cell.titleLabel.text = @"报考班型";
                cell.contentLabel.text = [HXCommonUtil isNull:self.majorModel.studyTypeName]?@"--":self.majorModel.studyTypeName;
                break;
            case 5:
                cell.titleLabel.text = @"我的班级";
                cell.contentLabel.text = [HXCommonUtil isNull:self.majorModel.ClassName]?@"--":self.majorModel.ClassName;
                break;
                
            default:
                break;
        }
    }else{
        switch (indexPath.row) {
            case 0:
                cell.titleLabel.text = ([self.majorModel.title containsString:@"成考"]? @"考生号":@"考籍号");
                cell.contentLabel.text = [HXCommonUtil isNull:self.majorModel.examineeNo]?@"--":self.majorModel.examineeNo;
                break;
            case 1:
                cell.titleLabel.text = @"报考批次";
                cell.contentLabel.text = [HXCommonUtil isNull:self.majorModel.enterDate]?@"--":self.majorModel.enterDate;
                break;
            case 2:
                cell.titleLabel.text = @"层次";
                cell.contentLabel.text = [HXCommonUtil isNull:self.majorModel.educationName]?@"--":self.majorModel.educationName;
                break;
            case 3:
                cell.titleLabel.text = @"报考学校";
                cell.contentLabel.text = [HXCommonUtil isNull:self.majorModel.bkSchool]?@"--":self.majorModel.bkSchool;
                break;
            case 4:
                cell.titleLabel.text = @"专业";
                cell.contentLabel.text = [HXCommonUtil isNull:self.majorModel.majorName]?@"--":self.majorModel.majorName;
                break;
            case 5:
                cell.titleLabel.text = @"学习形式";
                cell.contentLabel.text = [HXCommonUtil isNull:self.majorModel.studyTypeName]?@"--":self.majorModel.studyTypeName;
                break;
            case 6:
                cell.titleLabel.text = @"学历班型";
                cell.contentLabel.text = [HXCommonUtil isNull:self.majorModel.EdtClassTypeName]?@"--":self.majorModel.EdtClassTypeName;
                break;
            case 7:
                cell.titleLabel.text = @"我的班级";
                cell.contentLabel.text = [HXCommonUtil isNull:self.majorModel.ClassName]?@"--":self.majorModel.ClassName;
                break;
                
            default:
                break;
        }
    }
    return cell;
    
}

-(void)createUI{
    
    [self addSubview:self.titleImageView];
    [self.titleImageView addSubview:self.titleLabel];
    [self addSubview:self.infoCollectionView];
    
    self.titleImageView.sd_layout
    .centerXEqualToView(self)
    .topSpaceToView(self, 10)
    .widthRatioToView(self, 0.5)
    .heightIs(40);
    
    self.titleLabel.sd_layout
    .centerXEqualToView(self.titleImageView)
    .centerYEqualToView(self.titleImageView)
    .heightIs(20);
    [self.titleLabel setSingleLineAutoResizeWithMaxWidth:120];
    
    self.infoCollectionView.sd_layout
    .topSpaceToView(self.titleImageView, 10)
    .leftEqualToView(self)
    .rightEqualToView(self)
    .bottomSpaceToView(self, 0);
}


#pragma mark - lazyLoad
-(UICollectionView *)infoCollectionView{
    if (!_infoCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.sectionInset = UIEdgeInsetsMake(0, 20, 0, 20);
        float width = floorf((kScreenWidth-86)/2);
        layout.itemSize = CGSizeMake(width,35);
        _infoCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _infoCollectionView.backgroundColor = [UIColor clearColor];
        _infoCollectionView.delegate = self;
        _infoCollectionView.dataSource = self;
        _infoCollectionView.showsVerticalScrollIndicator = NO;
        _infoCollectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _infoCollectionView.scrollIndicatorInsets = _infoCollectionView.contentInset;
        _infoCollectionView.showsVerticalScrollIndicator = NO;
        ///注册cell、段头
        [_infoCollectionView registerClass:[HXRecordInfoCell class]
                 forCellWithReuseIdentifier:NSStringFromClass([HXRecordInfoCell class])];

    }
    return _infoCollectionView;;
}

-(UIImageView *)titleImageView{
    if (!_titleImageView) {
        _titleImageView = [[UIImageView alloc] init];
        _titleImageView.image = [UIImage resizedImageWithName:@"kuangjia"];
    }
    return _titleImageView;;
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = COLOR_WITH_ALPHA(0xffffff, 1);
        _titleLabel.font = HXBoldFont(15);
    }
    return _titleLabel;
}


@end
