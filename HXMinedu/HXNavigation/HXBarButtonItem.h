//
//  HXBarButtonItem.h
//  HXNavigationController
//
//  Created by iMac on 16/7/21.
//  Copyright © 2016年 TheLittleBoy. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, HXBarButtonItemStyle) {
    HXBarButtonItemStylePlain,  //默认配置
    HXBarButtonItemStyleCustom, //自定义
    HXBarButtonItemStyleDone,
};

@interface HXBarButtonItem : NSObject

@property (nonatomic, strong) UIButton *view;
@property (nonatomic, strong) UIView *customView;

@property (nonatomic, assign, getter = isEnabled) BOOL enabled;
@property (nonatomic, copy) NSString *badge;

- (instancetype)initWithTitle:(NSString *)title style:(HXBarButtonItemStyle)style handler:(void (^)(id sender))action;

- (instancetype)initWithImage:(UIImage *)image style:(HXBarButtonItemStyle)style handler:(void (^)(id sender))action;

- (instancetype)initWithCustsRigthItem:(UIView *)customView style:(HXBarButtonItemStyle)style;

@end
