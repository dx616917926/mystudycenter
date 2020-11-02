//
//  TXCatalogListViewController.h
//  TXMoviePlayer
//
//  Created by Mac on 2019/5/23.
//  Copyright © 2019 华夏大地教育网. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXCatalog.h"

@protocol TXCatalogListViewControllerDelegate <NSObject>

/**
 *  章节点击事件
 */
- (void)didSelectCatalog:(TXCatalog *)catalog;

/**
*  下载管理按钮点击事件
*/
- (void)downloadManagerButtonCliecked;

@end

///课件目录列表
@interface TXCatalogListViewController : UIViewController

@property(nonatomic, strong) NSArray<TXCatalog *> *catalogArray;   //目录信息
@property(nonatomic,strong) TXCatalog *currentCatalog;             //当前正在播放的节

@property(nonatomic, weak) id<TXCatalogListViewControllerDelegate> delegate;

@property(nonatomic, assign) BOOL canDownload;  //是否支持下载功能，默认NO

/**
 准备播放指定章节
 
 @param catalog 章节
 */
- (void)prepareToPlayCatalog:(TXCatalog *)catalog;

@end
