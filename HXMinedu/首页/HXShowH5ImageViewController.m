//
//  HXShowH5ImageViewController.m
//  HXMinedu
//
//  Created by mac on 2021/10/9.
//

#import "HXShowH5ImageViewController.h"
#import "SDWebImage.h"

@interface HXShowH5ImageViewController ()

@property(strong,nonatomic) UIScrollView *mainScrollView;
@property(strong,nonatomic) UIImageView *showImageView;


@end

@implementation HXShowH5ImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    ///UI
    [self createUI];
}

#pragma mark - Setter
- (void)setColumnItemModel:(HXColumnItemModel *)columnItemModel{
    _columnItemModel = columnItemModel;
}

#pragma mark - UI
-(void)createUI{
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.sc_navigationBar.title = self.columnItemModel.name;
    
    [self.view addSubview:self.mainScrollView];
    [self.mainScrollView addSubview:self.showImageView];
    self.mainScrollView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(kNavigationBarHeight, 0, 0, 0));
    self.showImageView.sd_layout
    .topSpaceToView(self.mainScrollView, 0)
    .leftEqualToView(self.mainScrollView)
    .rightEqualToView(self.mainScrollView)
    .heightIs(kScreenHeight);
    
    [self.mainScrollView setupAutoContentSizeWithBottomView:self.showImageView bottomMargin:kScreenBottomMargin];
    
    [self.showImageView sd_setImageWithURL:HXSafeURL(self.columnItemModel.url) placeholderImage:nil completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.showImageView.sd_layout.heightIs(image.size.height*kScreenWidth*1.0/image.size.width);
        });
    }];
}



#pragma mark - LazyLoad
-(UIScrollView *)mainScrollView{
    if (!_mainScrollView) {
        _mainScrollView = [[UIScrollView alloc] init];
    }
    return _mainScrollView;
}
-(UIImageView *)showImageView{
    if (!_showImageView) {
        _showImageView = [[UIImageView alloc] init];
        _showImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _showImageView;
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
