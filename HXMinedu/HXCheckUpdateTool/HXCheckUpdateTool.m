//
//  HXCheckUpdateTool.m
//  HXMinedu
//
//  Created by Mac on 2020/11/6.
//

#import "HXCheckUpdateTool.h"
#import "CustomIOSAlertView.h"

@interface HXCheckUpdateTool ()

@property(nonatomic, assign) BOOL donotCheckVersionAgain;
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
    
    //根据APP_BundleId来判断从哪里更新
    if ([APP_BundleId isEqualToString:@"com.edu-edu.minedu"]) {
        //edu-edu.xiaoguan
        [self checkUpdateWithInController:nil];
    }else{//App Store
        //com.min-edu1.mystudycenter
        [self checkAPPStoreUpdateWithInController:nil];
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
                self.ishow = NO;
                self.donotCheckVersionAgain = NO;
                //退出登录
                [HXNotificationCenter postNotificationName:SHOWLOGIN object:nil];
                
                self.hasNewVersion = YES;
                self.updateUrl = [rightDic stringValueForKey:@"updateUrl"];
                NSString *message = [NSString stringWithFormat:@"最新版本为%@，是否更新？",newVersionLabel];
                NSString *contents= [features componentsJoinedByString:@"\n"];
                NSString *showContent = [NSString stringWithFormat:@"%@\n%@",message,contents];
                //判断是否是强制更新
                if ([isForce isEqualToString:@"1"]) {
                    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:showContent preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"立即更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.updateUrl]];
                        
                    }];
                    [alertVC addAction:okAction];
                    if ([UIApplication sharedApplication].keyWindow.rootViewController.presentedViewController) {
                        [[UIApplication sharedApplication].keyWindow.rootViewController.presentedViewController presentViewController:alertVC animated:YES completion:nil];
                    }else{
                        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertVC animated:YES completion:nil];
                    }
                    
                }else{
                    
                    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:showContent preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"立即更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.updateUrl]];
                    }];
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"暂不" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        
                    }];
                    [alertVC addAction:okAction];
                    [alertVC addAction:cancelAction];
                    [[UIApplication sharedApplication].keyWindow.rootViewController.presentedViewController presentViewController:alertVC animated:YES completion:nil];
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

#pragma mark - 检查APP Store是否有新版本，适用于手动检测
- (void)checkAPPStoreUpdateWithInController:(UIViewController *)viewController{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 15;
    
    [manager POST:APPStore_URL parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSUInteger resultCount = [responseObject[@"resultCount"] integerValue];
        
        if (resultCount){
            
            NSDictionary *appDetails = [responseObject[@"results"] firstObject];
            NSString *appItunesUrl = [appDetails[@"trackViewUrl"] stringByReplacingOccurrencesOfString:@"&uo=4" withString:@""];
            //最新版本
            NSString *latestVersion = appDetails[@"version"];
            //比较本地版本与最新版本
            if ([latestVersion compare:APP_VERSION options:NSNumericSearch] == NSOrderedDescending){
                self.ishow = NO;
                self.donotCheckVersionAgain = NO;
                //退出登录
                [HXNotificationCenter postNotificationName:SHOWLOGIN object:nil];
                NSString *showContent = [NSString stringWithFormat:@"新版本V%@已经上线，快来更新吧!",latestVersion];
                self.hasNewVersion = YES;
                UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:showContent preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"前往更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    if (@available(iOS 10.0, *)) {
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appItunesUrl] options:@{} completionHandler:nil];
                    } else {
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appItunesUrl]];
                    }
                }];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"暂不更新" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                [alertVC addAction:okAction];
                [alertVC addAction:cancelAction];
                if ([UIApplication sharedApplication].keyWindow.rootViewController.presentedViewController) {
                    [[UIApplication sharedApplication].keyWindow.rootViewController.presentedViewController presentViewController:alertVC animated:YES completion:nil];
                }else{
                    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertVC animated:YES completion:nil];
                }
                
            }else{
                self.ishow = NO;
                self.hasNewVersion = NO;
                [viewController.view showSuccessWithMessage:@"已经是最新版本"];
            }
        }else{
            self.ishow = NO;
            self.hasNewVersion = NO;
            [viewController.view showSuccessWithMessage:@"已经是最新版本"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
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
