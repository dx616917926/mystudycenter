
//
//  HXStudyViewController.m
//  HXMinedu
//
//  Created by mac on 2021/3/26.
//

#import "HXStudyViewController.h"
#import "HXCustommNavView.h"

@interface HXStudyViewController ()
@property(nonatomic,strong) HXCustommNavView *custommNavView;
@end

@implementation HXStudyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self createUI];
}

-(void)createUI{
    self.sc_navigationBar.titleView = self.custommNavView;
}

#pragma mark - lazyload
-(HXCustommNavView *)custommNavView{
    if (!_custommNavView) {
        _custommNavView = [[HXCustommNavView alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, 44)];
    }
    return _custommNavView;
}

-(void)dealloc{
    NSLog(@"释放了");
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
