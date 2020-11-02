//
//  HXThemeSettingManager.h
//  HXNavigationController
//
//  Created by iMac on 16/7/22.
//  Copyright © 2016年 TheLittleBoy. All rights reserved.
//

#import <Foundation/Foundation.h>

//defines
#define kThemeSetting              [HXThemeSettingManager manager]

#define kCurrentTheme              kThemeSetting.theme

//底部边距
#define kScreenBottomMargin        kThemeSetting.screenBottomMargin  //屏幕底部边距  iPhone X边距34，其它的0

//状态栏
#define kStatusBarStyle            kThemeSetting.statusBarStyle
#define kStatusBarHeight           kThemeSetting.statusBarHeight  //状态高度  iPhone X高44(iOS 14高48)，其它的高20

//tabbar
#define kTabBarHeight              kThemeSetting.tabBarHeight  //tabbar高度  iPhone X高83，其它的高49
//文章
#define kArticleHighlightBgColor      kThemeSetting.articleHighlightBgColor  //文章bar高亮颜色

//导航栏
#define kNavigationBarHeight            kThemeSetting.navigationBarHeight  //导航栏高度  iPhone X高88(iOS 14高92)，其它的高64
#define kNavigationBarTintColor         kThemeSetting.navigationBarTintColor  //字体颜色
#define kNavigationBarColor             kThemeSetting.navigationBarColor      //背景色
#define kNavigationBarLineColor         kThemeSetting.navigationBarLineColor  //分割线颜色
#define kNavigationBarBadgeBgColor      kThemeSetting.navigationBarBadgeBackgroundColor //badge背景色
#define kNavigationBarBadgeTextColor    kThemeSetting.navigationBarBadgeTextColor       //badge字体颜色

//cell
#define kCellBackgroundColor           kThemeSetting.cellBackgroundColor    //cell背景颜色
#define kCellHighlightedColor          kThemeSetting.cellHighlightedColor   //cell高亮显示背景颜色
#define kCellTitleColor                kThemeSetting.cellTitleColor         //cell主title字体颜色
#define kCellSubTitleColor             kThemeSetting.cellSubTitleColor      //cell次title字体颜色
#define kCellDateTimeColor             kThemeSetting.cellDateTimeColor      //cell日期默认字体颜色
#define kCellDateTimeHighlightedColor  kThemeSetting.cellDateTimeHighlightedColor      //cell日期高亮字体颜色

//其他的默认颜色
#define kTextLableColor                kThemeSetting.textLableColor                 //普通label字体颜色
#define kControllerViewBackgroundColor kThemeSetting.controllerViewBackgroundColor  //普通Controller的view背景色
#define kImageViewAlpahForCurrentTheme kThemeSetting.imageViewAlphaForCurrentTheme  //普通imageView的透明度
#define kProductGroupBorderColor       kThemeSetting.productGroupBorderColor        //首页产品分组的竖线颜色

static NSString * const kThemeDidChangeNotification = @"ThemeDidChangeNotification";


typedef NS_ENUM(NSInteger, HXTheme) {
    HXThemeBlue = 1,
    HXThemeNight,
    HXThemeWhite,
    HXThemeRed,
    HXThemeGreen,
};

@interface HXThemeSettingManager : NSObject

+ (instancetype)manager;

#pragma mark - Theme

@property (nonatomic, assign) HXTheme theme;
@property (nonatomic, assign) BOOL themeAutoChange;

@property (nonatomic, assign) CGFloat navigationBarHeight;

//底部边距
@property (nonatomic, assign) CGFloat screenBottomMargin;

//状态栏
@property (nonatomic, assign) UIStatusBarStyle statusBarStyle;
@property (nonatomic, assign) CGFloat statusBarHeight;

//tabbar
@property (nonatomic, assign) CGFloat tabBarHeight;

//文章
@property (nonatomic, copy) UIColor *articleHighlightBgColor;

//导航栏
@property (nonatomic, copy) UIColor *navigationBarColor;
@property (nonatomic, copy) UIColor *navigationBarLineColor;
@property (nonatomic, copy) UIColor *navigationBarTintColor;
@property (nonatomic, copy) UIColor *navigationBarBadgeBackgroundColor;
@property (nonatomic, copy) UIColor *navigationBarBadgeTextColor;

//cell
@property (nonatomic, copy) UIColor *cellBackgroundColor;
@property (nonatomic, copy) UIColor *cellTitleColor;
@property (nonatomic, copy) UIColor *cellSubTitleColor;
@property (nonatomic, copy) UIColor *cellDateTimeColor;
@property (nonatomic, copy) UIColor *cellDateTimeHighlightedColor;


//其他
@property (nonatomic, copy) UIColor *textLableColor;
@property (nonatomic, copy) UIColor *controllerViewBackgroundColor;
@property (nonatomic, copy) UIColor *cellHighlightedColor;

@property (nonatomic, copy) UIColor *productGroupBorderColor;

//alpha
@property (nonatomic, assign) CGFloat imageViewAlphaForCurrentTheme;


//NavigationBar
@property (nonatomic, assign) BOOL navigationBarAutoHidden;


@end

