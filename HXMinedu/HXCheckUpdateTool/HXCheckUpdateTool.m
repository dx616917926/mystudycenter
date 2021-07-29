//
//  HXCheckUpdateTool.m
//  HXMinedu
//
//  Created by Mac on 2020/11/6.
//

#import "HXCheckUpdateTool.h"
#import "CustomIOSAlertView.h"

@interface HXCheckUpdateTool ()
{
    BOOL donotCheckVersionAgain;
}
@property(nonatomic, strong) NSString *updateUrl;
@property(nonatomic, assign) BOOL forceUpgrade;
@property(nonatomic, strong) CustomIOSAlertView *myAlertView;

@property(nonatomic, assign) BOOL ishow;//正在展示

@end

@implementation HXCheckUpdateTool

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static HXCheckUpdateTool *instance = nil;
    dispatch_once(&onceToken,^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone{
    return [self sharedInstance];
}

/**
 检查是否有新版本
 */
- (void)checkUpdate {
    
    if (!donotCheckVersionAgain&&!self.ishow) {
        self.ishow = YES;
        [self checkUpdateWithInController:nil];        
    }
}

- (void)checkUpdateWithInController:(UIViewController *)viewController {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSURL *URL = [NSURL URLWithString:APP_URL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    //阿里云存储不用担心缓存问题！！
    request.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    request.HTTPMethod = @"GET";
    request.timeoutInterval = 15;

    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
        //
    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
        //
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            self.ishow = NO;
            [viewController.view showErrorWithMessage:@"检查版本更新失败！"];
        } else {
            NSLog(@"%@ %@", response, responseObject);
            NSDictionary * rightDic = responseObject;
            NSString *localVersion = APP_BUILDVERSION;
            NSString * newVersion = [rightDic objectForKey:@"version"];
            NSString * newVersionLabel = [rightDic objectForKey:@"versionLabel"];
            NSArray *features = [rightDic objectForKey:@"features"];
            NSString *isForce = [NSString stringWithFormat:@"%@",[rightDic objectForKey:@"force"]];
            
            NSMutableString *featureStr = [[NSMutableString alloc]init];
            for (int i = 0 ; i < features.count; i++) {
                NSString *str = [features objectAtIndex:i];
                if (i == 0) {
                    [featureStr appendString:[NSString stringWithFormat:@"%d、%@",i+1,str]];
                }else{
                    [featureStr appendString:[NSString stringWithFormat:@"\n%d、%@",i+1,str]];
                }
            }
            
            if (self.myAlertView) {
                [self.myAlertView close];
            }
            
            NSLog(@"\n当前版本:%@\n服务器版本:%@\n更新日志:%@",localVersion,newVersion,featureStr);

            if ([newVersion intValue] > [localVersion intValue]) {
                self.hasNewVersion = YES;
                self.updateUrl = [rightDic stringValueForKey:@"updateUrl"];
                //弹提示框
                self.myAlertView = [[CustomIOSAlertView alloc] init];
                self.myAlertView.containerView = [self createViewWith:newVersionLabel andWithFeatures:featureStr AndWithFeatureCount:features.count];
                WeakSelf(weakSelf);
                //判断是否是强制更新
                if ([isForce isEqualToString:@"1"]) {
                    
                    [self.myAlertView setButtonTitles:[NSMutableArray arrayWithObjects:@"立即更新",nil]];
                    [self.myAlertView show];
                    
                    __weak NSString *updateStr = self.updateUrl;
                    [self.myAlertView setOnButtonTouchUpInside:^(CustomIOSAlertView *alertView, int buttonIndex) {
                        weakSelf.ishow = NO;
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:updateStr]];
                    }];
                    
                }else{
                    
                    [self.myAlertView setButtonTitles:[NSMutableArray arrayWithObjects:@"暂不",@"立即更新",nil]];
                    [self.myAlertView show];
                    
                    __weak NSString *updateStr = self.updateUrl ;
                    [self.myAlertView setOnButtonTouchUpInside:^(CustomIOSAlertView *alertView, int buttonIndex) {
                        weakSelf.ishow = NO;
                        if (buttonIndex == 0)
                        {
                            [alertView close];
                            self->donotCheckVersionAgain = YES;
                        }else{
                            if(updateStr)
                            {
                                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:updateStr]];
                                [alertView close];
                            }
                        }
                    }];
                }
            }else{
                self.ishow = NO;
                self.hasNewVersion = NO;
                [viewController.view showSuccessWithMessage:@"已经是最新版本"];
            }
        }
    }];
    [dataTask resume];
}

/**
 打开新版本网页
 */
- (void)gotoUpdate {
    
    if (self.hasNewVersion && self.updateUrl) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.updateUrl]];
    }
}

//构建提示框内容view
- (UIView *)createViewWith:(NSString *)versionNum andWithFeatures:(NSString *)featureStr AndWithFeatureCount:(NSUInteger)count{
    
    //构建alertView 上的view
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 290, 150)];
    //标题
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, 290, 30)];
    titleLabel.text = @"提示";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:17];
    [contentView addSubview:titleLabel];
    
    //副标题
    UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, titleLabel.bottom, 290, 25)];
    contentLabel.text = [NSString stringWithFormat:@"最新版本为%@，是否更新？",versionNum];
    contentLabel.textAlignment = NSTextAlignmentCenter;
    contentLabel.font = [UIFont systemFontOfSize:14];
    [contentView addSubview:contentLabel];
    
    //更新详细
    UILabel *featureLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, contentLabel.bottom-5, 270, 30*count)];
    featureLabel.textAlignment = NSTextAlignmentCenter;
    featureLabel.font = [UIFont systemFontOfSize:14];
    featureLabel.numberOfLines = 0;
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:featureStr];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:2];
    [attr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attr.length)];
    featureLabel.attributedText = attr;
    
    [contentView addSubview:featureLabel];
    
    [contentView setFrame:CGRectMake(0, 0, 290, MAX(30+25+30*count,100))];
    return contentView;
}

@end
