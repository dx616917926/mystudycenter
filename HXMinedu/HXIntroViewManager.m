//
//  HXIntroViewManager.m
//  HXMinedu
//
//  Created by Mac on 2020/11/3.
//

#import "HXIntroViewManager.h"
#import "HXPageControl.h"

NSString * const HXIntroViewDismissNotification = @"HXIntroViewDismissNotification";

@interface HXIntroViewManager ()<UIScrollViewDelegate>
{
    HXPageControl *pageControl;
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
    
    //
    CGFloat imageCount = 3;
    
    UIScrollView *scrollView=[[UIScrollView alloc]init];
    scrollView.frame=[UIScreen mainScreen].bounds;
    scrollView.pagingEnabled=YES;//设置分页
    scrollView.showsHorizontalScrollIndicator=NO;
    scrollView.bounces=NO;//设置不能弹回
    scrollView.delegate=self;
    scrollView.contentSize=CGSizeMake(scrollView.frame.size.width*(imageCount+1), 0);
    //添加图片
    for (int i=0; i<imageCount; i++) {
        UIImageView *imageViewTop=[[UIImageView alloc] init];
        NSString *strImageName=[NSString stringWithFormat:@"intro_top_%d",i];
        imageViewTop.image=[UIImage imageNamed:strImageName];
        CGFloat width = kScreenWidth>334?334:320;
        CGFloat height = 334/width*273;
        imageViewTop.frame=CGRectMake(i*scrollView.frame.size.width + (kScreenWidth-width)/2.0, kScreenHeight/2.0-height, width, height);
        [scrollView addSubview:imageViewTop];
        
        UIImageView *lineView = [[UIImageView alloc] init];
        NSString *lineImageName=[NSString stringWithFormat:@"intro_line_%d",i];
        lineView.image=[UIImage imageNamed:lineImageName];
        lineView.frame = CGRectMake(i*scrollView.frame.size.width, kScreenHeight/2.0, kScreenWidth, 126);
        [scrollView addSubview:lineView];
        
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(i*scrollView.frame.size.width, lineView.bottom, kScreenWidth, kScreenHeight-lineView.bottom)];
        bottomView.backgroundColor = [UIColor colorWithRed:33.0/255.0 green:131.0/255.0 blue:235.0/255.0 alpha:1.00];
        [scrollView addSubview:bottomView];
        
        UIImageView *labelView = [[UIImageView alloc] init];
        NSString *imageName=[NSString stringWithFormat:@"intro_label_%d",i];
        labelView.image=[UIImage imageNamed:imageName];
        labelView.frame=CGRectMake(i*scrollView.frame.size.width + (kScreenWidth-285)/2.0, lineView.bottom+20, 285, 86);
        [scrollView addSubview:labelView];
    }
    
    //最后一页
    UIImageView *logoView = [[UIImageView alloc] init];
    logoView.image = [UIImage imageNamed:@"intro_logo"];
    logoView.frame = CGRectMake(3*scrollView.frame.size.width+(kScreenWidth-175)/2.0, kScreenHeight/2.0-165, 175, 165);
    [scrollView addSubview:logoView];
    
    UIButton *useButton = [UIButton buttonWithType:UIButtonTypeCustom];
    useButton.frame = CGRectMake(3*scrollView.frame.size.width + (kScreenWidth-284)/2, kScreenHeight-100-kScreenBottomMargin, 284, 40);
    [useButton setBackgroundImage:[UIImage imageNamed:@"intro_button"] forState:UIControlStateNormal];
    [useButton addTarget:self action:@selector(useButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:useButton];
    
    [self.contentView addSubview:scrollView];//将ScrollView添加到控制器的View上面
    
    pageControl = [[HXPageControl alloc] initWithFrame:CGRectMake(0, kScreenHeight-30-kScreenBottomMargin, kScreenWidth, 20) indicatorMargin:8.f indicatorWidth:10.f currentIndicatorWidth:20.f indicatorHeight:10];
    pageControl.currentPageIndicatorColor = [UIColor whiteColor];
    pageControl.pageIndicatorColor = [UIColor whiteColor];
    pageControl.numberOfPages = 3;
    pageControl.scrollView = scrollView;
    [self.contentView addSubview:pageControl];
    
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

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger currentPage = scrollView.contentOffset.x / scrollView.frame.size.width;
    if(currentPage==3){
        pageControl.hidden=YES;
    }
    else{
        pageControl.hidden=NO;
    }
}
@end
