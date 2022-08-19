//
//  HXZuoYeViewController.m
//  HXMinedu
//
//  Created by mac on 2022/8/19.
//

#import "HXZuoYeViewController.h"

@interface HXZuoYeViewController ()

@property(nonatomic,strong) UIView *noDataView;

@end

@implementation HXZuoYeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //
    [self createUI];
}

#pragma mark - UI
-(void)createUI{
    self.sc_navigationBar.title = @"我的作业";
    [self.view addSubview:self.noDataView];
    
}

-(UIView *)noDataView{
    if(!_noDataView){
        _noDataView = [[UIView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight, kScreenWidth, kScreenHeight-kNavigationBarHeight)];
        _noDataView.backgroundColor = UIColor.whiteColor;
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"kaifazhong_icon"];
        [_noDataView addSubview:imageView];
        
        UILabel *tipLabel = [[UILabel alloc] init];
        tipLabel.font = HXFont(16);
        tipLabel.textColor = COLOR_WITH_ALPHA(0x4988FD, 1);
        tipLabel.textAlignment = NSTextAlignmentCenter;
        tipLabel.text = @"正在开发中...敬请期待";
        [_noDataView addSubview:tipLabel];
        
        imageView.sd_layout
        .topSpaceToView(_noDataView, 13)
        .centerXEqualToView(_noDataView)
        .widthIs(284)
        .heightIs(337);
        
        tipLabel.sd_layout
        .topSpaceToView(imageView, 10)
        .leftEqualToView(_noDataView)
        .rightEqualToView(_noDataView)
        .heightIs(22);
    
    }
    return _noDataView;
}



@end
