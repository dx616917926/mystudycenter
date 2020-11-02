//
//  HXBarButtonItem.h
//  HXNavigationController
//
//  Created by iMac on 16/7/21.
//  Copyright © 2016年 TheLittleBoy. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, SCBarButtonItemStyle) {  // for future use
    HXBarButtonItemStylePlain,
    HXBarButtonItemStyleBordered,
    HXBarButtonItemStyleDone,
};

@interface HXBarButtonItem : NSObject

@property (nonatomic, strong) UIButton *view;
@property (nonatomic, strong) UIView *customView;

@property (nonatomic, assign, getter = isEnabled) BOOL enabled;
@property (nonatomic, copy) NSString *badge;

- (instancetype)initWithTitle:(NSString *)title style:(SCBarButtonItemStyle)style handler:(void (^)(id sender))action;

- (instancetype)initWithImage:(UIImage *)image style:(SCBarButtonItemStyle)style handler:(void (^)(id sender))action;

- (instancetype)initWithCustsRigthItem:(UIView *)customView style:(SCBarButtonItemStyle)style;

@end
