//
//  HXNavigationBar.h
//  HXNavigationController
//
//  Created by iMac on 16/7/21.
//  Copyright © 2016年 TheLittleBoy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXNavigationBar : UIView

@property (nonatomic, assign  ) BOOL isTransition;
@property (nonatomic, assign  ) BOOL notNeedLayoutSubviews;
@property (nonatomic, assign  ) CGFloat backgroundAlpha;
@property (nonatomic, strong  ) HXBarButtonItem *leftBarButtonItem;
@property (nonatomic, strong  ) HXBarButtonItem *rightBarButtonItem;
@property (nonatomic, copy    ) NSString        *title;

@property (nonatomic, strong  ) UIView          *titleView; //如果设置了titleView，则隐藏titleLabel,只能二选一

@property (nonatomic, strong  ) UIView *customRigthView;//自定义rigthItem 
@property (nonatomic, readonly) UILabel         *titleLabel;

@end
