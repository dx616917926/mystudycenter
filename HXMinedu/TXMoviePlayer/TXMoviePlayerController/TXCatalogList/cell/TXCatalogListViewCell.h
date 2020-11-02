//
//  TXCatalogListViewCell.h
//  TXMoviePlayer
//
//  Created by Mac on 2019/5/24.
//  Copyright © 2019 华夏大地教育网. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXCatalog.h"

@interface TXCatalogListViewCell : UITableViewCell

@property(nonatomic, strong) TXCatalog *catalogModel;

@property(nonatomic, assign) BOOL isSelected;

@property(nonatomic, assign) BOOL isDownload;

@end
