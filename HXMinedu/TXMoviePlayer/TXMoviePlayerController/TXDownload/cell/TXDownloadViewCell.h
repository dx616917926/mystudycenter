//
//  TXDownloadViewCell.h
//  TXMoviePlayer
//
//  Created by Mac on 2019/10/21.
//  Copyright © 2019 华夏大地教育网. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXCatalog.h"
#import "DownloadManager.h"

@interface TXDownloadViewCell : UITableViewCell

@property(nonatomic, strong) TXCatalog *catalogModel;
@property(nonatomic, strong) DownloadSource *downloadSourceModel;

@property(nonatomic, assign) BOOL isSelected;

@end
