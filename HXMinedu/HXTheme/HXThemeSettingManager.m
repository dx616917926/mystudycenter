//
//  HXThemeSettingManager.m
//  HXNavigationController
//
//  Created by iMac on 16/7/22.
//  Copyright © 2016年 TheLittleBoy. All rights reserved.
//

#import "HXThemeSettingManager.h"

#define userDefaults [NSUserDefaults standardUserDefaults]

#define RGB(c,a)    [UIColor colorWithRed:((c>>16)&0xFF)/256.0  green:((c>>8)&0xFF)/256.0   blue:((c)&0xFF)/256.0   alpha:a]

static NSString *const kTheme           = @"ThemeNew";
static NSString *const kThemeAutoChange = @"ThemeAutoChange";

static NSString *const kNavigationBarHidden   = @"NavigationBarHidden";


@interface HXThemeSettingManager (){
    
}

@end

@implementation HXThemeSettingManager

- (instancetype)init {
    if (self = [super init]) {
        
        _theme = [[userDefaults objectForKey:kTheme] integerValue];
        
        if (_theme == 0) {
            _theme = Default_Theme;
        }
        
        id themeAutoChange = [userDefaults objectForKey:kThemeAutoChange];
        if (themeAutoChange) {
            _themeAutoChange = [themeAutoChange boolValue];
        } else {
            _themeAutoChange = YES;
        }
        
        id navigationBarHidden = [userDefaults objectForKey:kNavigationBarHidden];
        if (navigationBarHidden) {
            _navigationBarAutoHidden = [navigationBarHidden boolValue];
        } else {
            _navigationBarAutoHidden = YES;
        }
        
        _navigationBarHeight = IS_iPhoneX?(IsIOS14?92:88):64;   //iPhone X高88(iOS 14高92)，其它的高64
        _statusBarHeight = IS_iPhoneX?(IsIOS14?48:44):20;       //iPhone X高44(iOS 14高48)，其它的高20
        _tabBarHeight = IS_iPhoneX?83:49;                       //iPhone X高83，其它的高49
        _screenBottomMargin = IS_iPhoneX?34:0;                  //iPhone X底部边距34，其它的0
        
        [self configureTheme:_theme];
        
    }
    return self;
}

+ (instancetype)manager {
    
    static HXThemeSettingManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[HXThemeSettingManager alloc] init];
    });
    
    return manager;
}

#pragma mark - Theme

- (void)setTheme:(HXTheme)theme {
    
    _theme = theme;
    
    [userDefaults setObject:@(theme) forKey:kTheme];
    [userDefaults synchronize];
    
    [self configureTheme:theme];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kThemeDidChangeNotification object:nil];
}

- (void)configureTheme:(HXTheme)theme {
    
    if (theme == HXThemeBlue) { //blue
        
        self.articleHighlightBgColor = [UIColor colorWithRed:0.102 green:0.608 blue:0.984 alpha:1.000];
        
        self.navigationBarTintColor = [UIColor whiteColor];
        self.navigationBarColor = [UIColor colorWithRed:0.294 green:0.643 blue:0.996 alpha:1.000];
        self.navigationBarLineColor = [UIColor colorWithRed:0.216 green:0.467 blue:1.000 alpha:1.000];
        self.navigationBarBadgeBackgroundColor = [UIColor colorWithRed:0.902 green:0.200 blue:0.216 alpha:1.000];
        self.navigationBarBadgeTextColor =[UIColor whiteColor];
        
        self.cellBackgroundColor = [UIColor whiteColor];
        self.cellTitleColor = [UIColor colorWithRed:0.153 green:0.173 blue:0.196 alpha:1];
        self.cellSubTitleColor = [UIColor colorWithRed:0.384 green:0.392 blue:0.4 alpha:1];
        self.cellDateTimeColor = [UIColor blackColor] ;
        self.cellDateTimeHighlightedColor  = [UIColor orangeColor];
        
        self.textLableColor = [UIColor colorWithRed:0.153 green:0.173 blue:0.196 alpha:1];
        self.controllerViewBackgroundColor = [UIColor whiteColor];
        self.cellHighlightedColor = [UIColor colorWithRed:0.102 green:0.608 blue:0.984 alpha:0.3];
        self.productGroupBorderColor = [UIColor colorWithRed:0.000 green:0.478 blue:1.000 alpha:1.000];
        self.tableViewBackgroundColor = [UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1.00];
        
        self.statusBarStyle = UIStatusBarStyleLightContent;
    
    }else if (theme == HXThemeNight) {
        
        self.articleHighlightBgColor = [UIColor colorWithRed:202.0/255.0 green:51.0/255.0 blue:54.0/255.0 alpha:1];
        
        self.navigationBarTintColor = [UIColor colorWithRed:0.800 green:0.800 blue:0.800 alpha:1.000];
        self.navigationBarColor = [UIColor colorWithWhite:0.000 alpha:0.980];
        self.navigationBarLineColor = [UIColor colorWithWhite:0.281 alpha:1.000];
        self.navigationBarBadgeBackgroundColor = [UIColor whiteColor];
        self.navigationBarBadgeTextColor =[UIColor colorWithWhite:0.000 alpha:0.980];
        
        self.cellBackgroundColor = [UIColor whiteColor];
        self.cellTitleColor = [UIColor colorWithRed:0.153 green:0.173 blue:0.196 alpha:1];
        self.cellSubTitleColor = [UIColor colorWithRed:0.384 green:0.392 blue:0.4 alpha:1];
        self.cellDateTimeColor = [UIColor blackColor] ;
        self.cellDateTimeHighlightedColor  = [UIColor orangeColor];
        
        self.textLableColor = [UIColor colorWithWhite:0.000 alpha:0.980];
        self.controllerViewBackgroundColor = [UIColor whiteColor];
        self.cellHighlightedColor = [UIColor colorWithRed:0.200 green:0.200 blue:0.200 alpha:1.000];
        self.productGroupBorderColor = [UIColor colorWithWhite:0.000 alpha:0.980];
        self.tableViewBackgroundColor = [UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1.00];
        
        self.statusBarStyle = UIStatusBarStyleLightContent;

    }else if (theme == HXThemeRed) {
        
        self.articleHighlightBgColor = [UIColor colorWithRed:0.902 green:0.200 blue:0.216 alpha:1.000];
        
        self.navigationBarTintColor = [UIColor whiteColor];
        self.navigationBarColor = [UIColor colorWithRed:0.902 green:0.200 blue:0.216 alpha:1.000];
        self.navigationBarLineColor = [UIColor colorWithRed:0.902 green:0.200 blue:0.216 alpha:1.000];
        self.navigationBarBadgeBackgroundColor = [UIColor whiteColor];
        self.navigationBarBadgeTextColor = [UIColor colorWithRed:0.902 green:0.200 blue:0.216 alpha:1.000];;
        
        self.cellBackgroundColor = [UIColor whiteColor];
        self.cellTitleColor = [UIColor colorWithRed:0.153 green:0.173 blue:0.196 alpha:1];
        self.cellSubTitleColor = [UIColor colorWithRed:0.384 green:0.392 blue:0.4 alpha:1];
        self.cellDateTimeColor = [UIColor blackColor] ;
        self.cellDateTimeHighlightedColor  = [UIColor orangeColor];
        
        self.textLableColor = [UIColor colorWithRed:0.153 green:0.173 blue:0.196 alpha:1];
        self.controllerViewBackgroundColor = [UIColor whiteColor];
        self.cellHighlightedColor = [UIColor colorWithRed:0.902 green:0.200 blue:0.216 alpha:0.2];
        self.productGroupBorderColor = [UIColor colorWithRed:0.902 green:0.200 blue:0.216 alpha:1.000];
        self.tableViewBackgroundColor = [UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1.00];
        
        self.statusBarStyle = UIStatusBarStyleLightContent;
        
    }else if (theme == HXThemeWhite) {
        
        self.articleHighlightBgColor = [UIColor colorWithRed:202.0/255.0 green:51.0/255.0 blue:54.0/255.0 alpha:1];
        
        self.navigationBarTintColor = [UIColor blackColor];
        self.navigationBarColor = [UIColor colorWithWhite:1.00 alpha:0.980];
        self.navigationBarLineColor = [UIColor colorWithWhite:0.869 alpha:1];
        self.navigationBarBadgeBackgroundColor = [UIColor redColor];
        self.navigationBarBadgeTextColor = [UIColor whiteColor];
        
        self.cellBackgroundColor = [UIColor whiteColor];
        self.cellTitleColor = [UIColor colorWithRed:0.153 green:0.173 blue:0.196 alpha:1];
        self.cellSubTitleColor = [UIColor colorWithRed:0.384 green:0.392 blue:0.4 alpha:1];
        self.cellDateTimeColor = [UIColor blackColor] ;
        self.cellDateTimeHighlightedColor  = [UIColor orangeColor];
        
        self.textLableColor = [UIColor blackColor];
        self.controllerViewBackgroundColor = [UIColor whiteColor];
        self.cellHighlightedColor = [UIColor colorWithRed:0.859 green:0.859 blue:0.859 alpha:0.600];
        self.productGroupBorderColor = [UIColor colorWithWhite:1.00 alpha:0.980];
        self.tableViewBackgroundColor = [UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1.00];
        
        self.statusBarStyle = UIStatusBarStyleDefault;
        
    }else if (theme == HXThemeGreen) {
        
        self.articleHighlightBgColor = [UIColor colorWithRed:0.239 green:0.686 blue:0.365 alpha:1.000];
        
        self.navigationBarTintColor = [UIColor whiteColor];
        self.navigationBarColor = [UIColor colorWithRed:0.169 green:0.749 blue:0.365 alpha:1.000];
        self.navigationBarLineColor = [UIColor colorWithRed:0.239 green:0.686 blue:0.365 alpha:1.000];
        self.navigationBarBadgeBackgroundColor = [UIColor colorWithRed:0.902 green:0.200 blue:0.216 alpha:1.000];
        self.navigationBarBadgeTextColor =[UIColor whiteColor];
        
        self.cellBackgroundColor = [UIColor whiteColor];
        self.cellTitleColor = [UIColor colorWithRed:0.153 green:0.173 blue:0.196 alpha:1];
        self.cellSubTitleColor = [UIColor colorWithRed:0.384 green:0.392 blue:0.4 alpha:1];
        self.cellDateTimeColor = [UIColor blackColor] ;
        self.cellDateTimeHighlightedColor  = [UIColor orangeColor];
        
        self.textLableColor = [UIColor colorWithRed:0.153 green:0.173 blue:0.196 alpha:1];
        self.controllerViewBackgroundColor = [UIColor whiteColor];
        self.cellHighlightedColor = [UIColor colorWithRed:0.239 green:0.686 blue:0.365 alpha:0.2];
        self.productGroupBorderColor =[UIColor colorWithRed:0.239 green:0.686 blue:0.365 alpha:1.000];
        self.tableViewBackgroundColor = [UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1.00];
        
        self.statusBarStyle = UIStatusBarStyleLightContent;
    }
    
    [[UIApplication sharedApplication] setStatusBarStyle:self.statusBarStyle];
    
    [[UISwitch appearance] setOnTintColor:self.navigationBarColor];
}

- (void)setThemeAutoChange:(BOOL)themeAutoChange {
    _themeAutoChange = themeAutoChange;
    
    [userDefaults setObject:@(themeAutoChange) forKey:kThemeAutoChange];
    [userDefaults synchronize];
}

#pragma mark - Alpha

- (CGFloat)imageViewAlphaForCurrentTheme {
    if (_theme == HXThemeNight) {
        return 0.4;
    } else {
        return 1.0;
    }
}

#pragma mark - Navigation Bar

- (void)setNavigationBarAutoHidden:(BOOL)navigationBarAutoHidden {
    _navigationBarAutoHidden = navigationBarAutoHidden;
    
    [userDefaults setObject:@(navigationBarAutoHidden) forKey:kNavigationBarHidden];
    [userDefaults synchronize];
    
}

@end
