//
//  TXDownloadViewController.h
//  TXMoviePlayer
//
//  Created by Mac on 2019/10/18.
//  Copyright © 2019 华夏大地教育网. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXCatalog.h"

FOUNDATION_EXPORT NSString * const TXDownloadViewPepareToDownloadNotification;

@class TXDownloadViewController;

@protocol TXDownloadViewControllerDelegate <NSObject>

/**
 *  关闭按钮点击事件
 */
- (void)closeButtonAction:(TXDownloadViewController *_Nonnull)viewController;

@end

NS_ASSUME_NONNULL_BEGIN

//课件下载
@interface TXDownloadViewController : UIViewController

@property(nonatomic, strong) NSArray<TXCatalog *> *catalogArray;   //目录信息
@property(nonatomic, strong) TXCatalog *currentCatalog;            //当前正在播放的节
@property(nonatomic, strong) NSDictionary *cws_param;              //验证参数，必传

@property (nonatomic,copy) NSString *coursewareTitle;     //课件大标题名称
@property (nonatomic,copy) NSString *coursewareId;        //ID
@property (nonatomic,copy) NSString *classID;             //班级ID

@property(nonatomic, weak) id<TXDownloadViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
