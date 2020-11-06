//
//  HXIntroViewManager.m
//  HXMinedu
//
//  Created by Mac on 2020/11/3.
//

#import "HXIntroViewManager.h"

NSString * const HXIntroViewDismissNotification = @"HXIntroViewDismissNotification";

@interface HXIntroViewManager ()
{
    UIView *contentVie1w;
}
@property(nonatomic, strong) UIView *contentView;
@end

@implementation HXIntroViewManager

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static HXIntroViewManager *instance = nil;
    dispatch_once(&onceToken,^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone{
    return [self sharedInstance];
}

- (void)checkAndShowIntroViewInView:(UIView *)view
{
    //如何知道是否是第一次使用这个版本？可以通过比较上次使用的版本进行判断
    NSString *versionKey = @"HXLastShortVersionString";
    //从沙盒中取出上次存储的软件版本号
    NSUserDefaults *defaults = [[NSUserDefaults alloc] init];
    NSString *lastVersion = [defaults objectForKey:versionKey];
    //获得当前打开软件的版本号
    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    //当前版本号 != 上次使用的版本号
    if ([currentVersion isEqualToString:lastVersion]) {
        
        [self showIntroViewInView:view];
        
        //存储这个使用的软件版本
        [defaults setObject:currentVersion forKey:versionKey];
        //立刻写入
        [defaults synchronize];
    }
}

- (void)showIntroViewInView:(UIView *)view
{
    if (!view) {
        return;
    }
    
    if (self.contentView) {
        [self.contentView removeFromSuperview];
    }
    
    self.contentView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth*1.3)];
    imageView1.image = [UIImage imageNamed:@"guide"];
    [self.contentView addSubview:imageView1];
    
    UIButton *useButton = [UIButton buttonWithType:UIButtonTypeCustom];
    useButton.frame = CGRectMake((kScreenWidth-160)/2, kScreenHeight-100-kScreenBottomMargin, 160, 48);
    [useButton setTitle:@"立即使用" forState:UIControlStateNormal];
    [useButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [useButton setBackgroundColor:[UIColor colorWithRed:0.38 green:0.64 blue:0.97 alpha:1.00]];
    [useButton.titleLabel setFont:[UIFont systemFontOfSize:19]];
    [useButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    useButton.layer.cornerRadius = 24.f;
    [useButton addTarget:self action:@selector(useButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:useButton];
    
    [view addSubview:self.contentView];
}

- (void)useButtonPressed {

    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.alpha = 0;
    } completion:^(BOOL finished){
        [self.contentView removeFromSuperview];
        [[NSNotificationCenter defaultCenter] postNotificationName:HXIntroViewDismissNotification object:nil];
    }];
}
@end
