//
//  HXSelectThemeViewController.h
//  HXNavigationController
//
//  Created by iMac on 16/7/25.
//  Copyright © 2016年 TheLittleBoy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXBaseViewController.h"

@interface HXSelectThemeViewController : HXBaseViewController<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) UITableView *myTableView;

@end
