//
//  HXConfirmViewController.m
//  HXMinedu
//
//  Created by mac on 2021/4/9.
//

#import "HXConfirmViewController.h"
#import "SDWebImage.h"

@interface HXConfirmViewController ()
@property(nonatomic,strong) UIScrollView *mainScrollView;
@property(nonatomic,strong) UIImageView *topImageView;
@property(nonatomic,strong) UIButton *topConfirmBtn;
@property(nonatomic,strong) UIImageView *bottomImageView;
@property(nonatomic,strong) UIButton *bottomConfirmBtn;

@end

@implementation HXConfirmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //UI
    [self createUI];
}

#pragma mark - Event
-(void)confirm:(UIButton *)sender{
    
    sender.userInteractionEnabled = NO;
    [self confirmStudentStatu];
}

#pragma mark - 学生确认图片信息
-(void)confirmStudentStatu{
    
    [HXBaseURLSessionManager postDataWithNSString:HXPOST_UpdateStudentStatu  withDictionary:@{@"studentFile_id":HXSafeString(self.pictureInfoModel.fileId)} success:^(NSDictionary * _Nonnull dictionary) {
        self.topConfirmBtn.userInteractionEnabled = YES;
        BOOL success = [dictionary boolValueForKey:@"Success"];
        if (success) {
            [self.view showTostWithMessage:[dictionary stringValueForKey:@"Message"]];
            self.topConfirmBtn.hidden  = YES;
            ///通知外部刷新
            if (self.refreshInforBlock) {
                self.refreshInforBlock();
            }
        }else{
            [self.view showErrorWithMessage:[dictionary stringValueForKey:@"Message"]];
        }
    } failure:^(NSError * _Nonnull error) {
       
    }];
}

#pragma mark - UI
-(void)createUI{
   
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.sc_navigationBar.title = self.pictureInfoModel.fileTypeName;
    
    [self.view addSubview:self.mainScrollView];
    [self.mainScrollView addSubview:self.topImageView];
    [self.mainScrollView addSubview:self.topConfirmBtn];
    [self.mainScrollView addSubview:self.bottomImageView];
    [self.mainScrollView addSubview:self.bottomConfirmBtn];
    
    self.mainScrollView.sd_layout
    .topSpaceToView(self.view, kNavigationBarHeight)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomEqualToView(self.view);
    
    self.topImageView.sd_layout
    .topSpaceToView(self.mainScrollView, 20)
    .rightSpaceToView(self.mainScrollView, 20)
    .leftSpaceToView(self.mainScrollView, 20)
    .heightIs(190);
    
    self.topConfirmBtn.sd_layout
    .topSpaceToView(self.topImageView, 24)
    .centerXEqualToView(self.mainScrollView)
    .widthIs(164)
    .heightIs(30);
    self.topConfirmBtn.sd_cornerRadius = @6;
    
    self.bottomImageView.sd_layout
    .topSpaceToView(self.topConfirmBtn, 24)
    .leftEqualToView(self.topImageView)
    .rightEqualToView(self.topImageView)
    .heightRatioToView(self.topImageView, 1);
    
    self.bottomConfirmBtn.sd_layout
    .topSpaceToView(self.bottomImageView, 24)
    .leftEqualToView(self.topConfirmBtn)
    .rightEqualToView(self.topConfirmBtn)
    .heightRatioToView(self.topConfirmBtn, 1);
    self.bottomConfirmBtn.sd_cornerRadius = @6;
    
    [self.mainScrollView setupAutoContentSizeWithBottomView:self.bottomConfirmBtn bottomMargin:30];
    
    if (self.pictureInfoModel.studentstatus == 1) {//已确认隐藏确认按钮
        self.topConfirmBtn.hidden  = YES;
    }else{
        self.topConfirmBtn.hidden  = NO;
    }
    
    [self.topImageView sd_setImageWithURL:[NSURL URLWithString:HXSafeString(self.pictureInfoModel.imgurl)] placeholderImage:[UIImage imageNamed:@"uploaddash"]];
    
}

-(void)setPictureInfoModel:(HXPictureInfoModel *)pictureInfoModel{
    _pictureInfoModel = pictureInfoModel;

//#ifdef DEBUG
//    pictureInfoModel.imgurl = @"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fattach.bbs.miui.com%2Fforum%2F201312%2F03%2F165526ophx4l6c6ll3cnpl.jpg&refer=http%3A%2F%2Fattach.bbs.miui.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1620976710&t=566f7981b25825ceea5fe566812f05be";
//#endif
    
}


#pragma mark - lazyLoad

-(UIScrollView *)mainScrollView{
    if (!_mainScrollView) {
        _mainScrollView = [[UIScrollView alloc] init];
        _mainScrollView.backgroundColor = COLOR_WITH_ALPHA(0xffffff, 1);
    }
    return _mainScrollView;
}
-(UIImageView *)topImageView{
    if (!_topImageView) {
        _topImageView = [[UIImageView alloc] init];
        _topImageView.clipsToBounds = YES;
        _topImageView.image = [UIImage imageNamed:@"uploaddash"];
        _topImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _topImageView;
}

-(UIButton *)topConfirmBtn{
    if (!_topConfirmBtn) {
        _topConfirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _topConfirmBtn.titleLabel.font = HXBoldFont(16);
        [_topConfirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_topConfirmBtn setBackgroundImage:[UIImage createImageWithColor:COLOR_WITH_ALPHA(0x07C160, 1)] forState:UIControlStateNormal];
        [_topConfirmBtn setBackgroundImage:[UIImage createImageWithColor:COLOR_WITH_ALPHA(0x079A4D, 1)] forState:UIControlStateHighlighted];
        [_topConfirmBtn setTitle:@"确认无误" forState:UIControlStateNormal];
        [_topConfirmBtn addTarget:self action:@selector(confirm:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _topConfirmBtn;
}

-(UIImageView *)bottomImageView{
    if (!_bottomImageView) {
        _bottomImageView = [[UIImageView alloc] init];
        _bottomImageView.clipsToBounds = YES;
        _bottomImageView.image = [UIImage imageNamed:@"uploaddash"];
        _bottomImageView.contentMode = UIViewContentModeScaleAspectFit;
        _bottomImageView.hidden = YES;
    }
    return _bottomImageView;
}
-(UIButton *)bottomConfirmBtn{
    if (!_bottomConfirmBtn) {
        _bottomConfirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _bottomConfirmBtn.titleLabel.font = HXBoldFont(16);
        [_bottomConfirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_bottomConfirmBtn setBackgroundImage:[UIImage createImageWithColor:COLOR_WITH_ALPHA(0x07C160, 1)] forState:UIControlStateNormal];
        [_bottomConfirmBtn setBackgroundImage:[UIImage createImageWithColor:COLOR_WITH_ALPHA(0x079A4D, 1)] forState:UIControlStateHighlighted];
        [_bottomConfirmBtn setTitle:@"确认无误" forState:UIControlStateNormal];
        [_bottomConfirmBtn addTarget:self action:@selector(confirm:) forControlEvents:UIControlEventTouchUpInside];
        _bottomConfirmBtn.hidden = YES;
    }
    return _bottomConfirmBtn;
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
