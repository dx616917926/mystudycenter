//
//  HXGradeDropDownMenu.h
//  gaojijiao
//
//  Created by iMac on 2017/4/21.
//  Copyright © 2017年 华夏大地教育网. All rights reserved.
//

#import <UIKit/UIKit.h>


@class HXGradeDropDownMenu;

@protocol HXGradeDropDownMenuDataSource <NSObject>

@required
- (NSInteger)menu:(HXGradeDropDownMenu *)menu numberOfRowsInSection:(NSInteger)section;
- (NSString *)menu:(HXGradeDropDownMenu *)menu collegeForRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@protocol HXGradeDropDownMenuDelegate <NSObject>
@optional
- (void)menu:(HXGradeDropDownMenu *)menu didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
@end

//下拉菜单，选择年级
@interface HXGradeDropDownMenu : UIView<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UILabel *gradeNameLable; //年级名次
@property (nonatomic, weak) UIView *destinationView; //下拉菜单要显示的view，默认是superview
@property (nonatomic, strong) NSIndexPath * selectIndexPath; //默认选中哪一个

@property (nonatomic, weak) id <HXGradeDropDownMenuDataSource> dataSource;
@property (nonatomic, weak) id <HXGradeDropDownMenuDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame;

- (void)dismiss;

- (void)reloadData;

@end
