//
//  HXExamDetailViewController.m
//  HXMinedu
//
//  Created by Mac on 2020/12/25.
//

#import "HXExamDetailViewController.h"

@interface HXExamDetailViewController ()

@property (nonatomic, strong)HXBarButtonItem *leftBarItem;

@end

@implementation HXExamDetailViewController

-(void)loadView
{
    [super loadView];
    
    @weakify(self);
    self.leftBarItem = [[HXBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navi_back"] style:HXBarButtonItemStylePlain handler:^(id sender) {
        
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //设置导航栏透明度
    [self sc_setNavigationBarBackgroundAlpha:0];
    [self setSc_navigationBarHidden:YES];
    
    self.sc_navigationBar.leftBarButtonItem = self.leftBarItem;

    self.sc_navigationBar.title = @"考试详情";
    
    [self initTopView];
}

- (void)initTopView {
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"exam_top_bg"]];
    imageView.frame = CGRectMake(0, 0, kScreenWidth, kScreenWidth*0.48);
    [self.view addSubview:imageView];
    
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(30,kNavigationBarHeight + 30,kScreenWidth-60,148);
    view.layer.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor;
    view.layer.cornerRadius = 8;
    view.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.15].CGColor;
    view.layer.shadowOffset = CGSizeMake(0,0);
    view.layer.shadowOpacity = 1;
    view.layer.shadowRadius = 4;
    [self.view addSubview:view];
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
