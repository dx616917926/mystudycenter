//
//  HXPictureInforConfirmViewController.m
//  HXMinedu
//
//  Created by mac on 2021/12/7.
//

#import "HXPictureInforConfirmViewController.h"
#import "HXSelectStudyTypeViewController.h"
#import "HXCommonSelectView.h"

@interface HXPictureInforConfirmViewController ()

@property(nonatomic,strong) UIControl *majorSwitchControl;///汉语言文学
@property(nonatomic,strong) UILabel *majorLabel;
@property(nonatomic,strong) UIImageView *triangleImageView;

@property(nonatomic,strong) HXCommonSelectView *commonSelectView;

@end

@implementation HXPictureInforConfirmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.sc_navigationBar.titleView = self.majorSwitchControl;
    
    HXMajorModel *selectMajorModel = [HXPublicParamTool sharedInstance].selectMajorModel;
    self.majorLabel.text = selectMajorModel.majorName;
    
}
#pragma mark - Event
//切换专业
-(void)selectType:(UIControl *)sender{
    
    HXSelectStudyTypeViewController *vc =[[HXSelectStudyTypeViewController alloc] init];
    //选择完成回调
    WeakSelf(weakSelf)
    vc.selectFinishCallBack = ^(HXVersionModel * _Nonnull selectVersionModel, HXMajorModel * _Nonnull selectMajorModel) {
        StrongSelf(strongSelf)
        strongSelf.majorLabel.text = selectMajorModel.majorName;
        [HXPublicParamTool sharedInstance].selectMajorModel = selectMajorModel;
    };
    [self presentViewController:vc animated:YES completion:nil];
}

///切换资料
-(void)ziLiaoSwitch:(UIButton *)sender{
    
    [self.commonSelectView show];
    self.commonSelectView.dataArray = @[];
    self.commonSelectView.title = @"选择资料类型";
    WeakSelf(weakSelf);
    self.commonSelectView.seletConfirmBlock = ^(HXCommonSelectModel * _Nonnull selectModel) {
        StrongSelf(strongSelf);
        ///
        
       
        
       
    };
}

#pragma mark - LazyLoad
-(UIControl *)majorSwitchControl{
    if (!_majorSwitchControl) {
        _majorSwitchControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
        [_majorSwitchControl addSubview:self.majorLabel];
        [_majorSwitchControl addSubview:self.triangleImageView];
        [_majorSwitchControl addTarget:self action:@selector(selectType:) forControlEvents:UIControlEventTouchUpInside];
        
        self.majorLabel.sd_layout
        .centerXEqualToView(_majorSwitchControl).offset(-20)
        .topEqualToView(_majorSwitchControl)
        .heightIs(25);
        [self.majorLabel setSingleLineAutoResizeWithMaxWidth: kScreenWidth-80];
        
        self.triangleImageView.sd_layout
        .leftSpaceToView(self.majorLabel, 3)
        .bottomEqualToView(self.majorLabel).offset(-5)
        .widthIs(6)
        .heightEqualToWidth();
        
    }
    return _majorSwitchControl;
}

-(UILabel *)majorLabel{
    if (!_majorLabel) {
        _majorLabel = [[UILabel alloc] init];
        _majorLabel.font = HXBoldFont(18);
        _majorLabel.textColor = COLOR_WITH_ALPHA(0x2C2C2E, 1);
        _majorLabel.textAlignment = NSTextAlignmentCenter;
        _majorLabel.numberOfLines = 1;
        
    }
    return _majorLabel;
}

-(UIImageView *)triangleImageView{
    if (!_triangleImageView) {
        _triangleImageView = [[UIImageView alloc] init];
        _triangleImageView.image = [[UIImage imageNamed:@"white_triangle"] imageWithTintColor:UIColor.blackColor];
        _triangleImageView.hidden = NO;
    }
    return _triangleImageView;
}


-(HXCommonSelectView *)commonSelectView{
    if (!_commonSelectView) {
        _commonSelectView = [[HXCommonSelectView alloc] init];
    }
    return _commonSelectView;
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
