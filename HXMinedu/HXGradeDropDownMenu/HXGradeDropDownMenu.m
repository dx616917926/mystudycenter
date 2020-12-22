//
//  HXGradeDropDownMenu.m
//  gaojijiao
//
//  Created by iMac on 2017/4/21.
//  Copyright © 2017年 华夏大地教育网. All rights reserved.
//

#import "HXGradeDropDownMenu.h"

@interface HXGradeDropDownMenu ()
{
    NSString * currentName;
}
@property (nonatomic, assign) BOOL show;
@property (nonatomic, strong) UIView *backGroundView;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation HXGradeDropDownMenu

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        _show = NO;
        
        currentName = @"";
        
        _gradeNameLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _gradeNameLable.textColor = kNavigationBarTintColor;
        _gradeNameLable.textAlignment = NSTextAlignmentCenter;
        _gradeNameLable.font = [UIFont systemFontOfSize:17];
        [self addSubview:_gradeNameLable];
        
        //tableView init
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.frame.origin.y + self.frame.size.height, kScreenWidth, 0) style:UITableViewStylePlain];
        _tableView.rowHeight = 50;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.cellLayoutMarginsFollowReadableWidth = NO;
        //self tapped
        self.backgroundColor = [UIColor clearColor];
        UIGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(menuTapped:)];
        [self addGestureRecognizer:tapGesture];
        
        //background init and tapped
        _backGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, self.bottom, kScreenWidth, kScreenHeight)];
        _backGroundView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
        _backGroundView.opaque = NO;
        UIGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [_backGroundView addGestureRecognizer:gesture];
        //添加分割线
        UIView *lineView =[[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height, kScreenWidth, .5)];
        [self addSubview:lineView];
        lineView.backgroundColor = [UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1.00];

    }
    return self;
}
- (void)setSelectIndexPath:(NSIndexPath *)selectIndexPath{
    _selectIndexPath = selectIndexPath;
    [self confiMenuWithSelectRow:self.selectIndexPath];
    if ([self.dataSource respondsToSelector:@selector(menu:collegeForRowAtIndexPath:)]) {
        
        _gradeNameLable.text = [NSString stringWithFormat:@"%@ ▼",[self.dataSource menu:self collegeForRowAtIndexPath:selectIndexPath]];
        
    }
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    _gradeNameLable.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    _backGroundView.frame = CGRectMake(0, self.bottom, kScreenWidth, kScreenHeight);
    _tableView.frame = CGRectMake(0, self.frame.origin.y + self.frame.size.height, kScreenWidth, 0);
}

#pragma mark - table datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSAssert(self.dataSource != nil, @"menu's dataSource shouldn't be nil");
    if ([self.dataSource respondsToSelector:@selector(menu:numberOfRowsInSection:)]) {
        return [self.dataSource menu:self
               numberOfRowsInSection:section];
    } else {
        NSAssert(0 == 1, @"required method of dataSource protocol should be implemented");
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"DropDownMenuCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = kCellHighlightedColor;
    }
    
    NSAssert(self.dataSource != nil, @"menu's datasource shouldn't be nil");
    if ([self.dataSource respondsToSelector:@selector(menu:collegeForRowAtIndexPath:)]) {
        
        cell.textLabel.text = [self.dataSource menu:self collegeForRowAtIndexPath:indexPath];
        
         
    } else {
        NSAssert(0 == 1, @"dataSource method needs to be implemented");
    }
    
    if (self.selectIndexPath && indexPath.row == self.selectIndexPath.row) {
        cell.textLabel.textColor = [UIColor blueColor];
    }else
    {
        cell.textLabel.textColor = [UIColor blackColor];
    }
    
    cell.backgroundColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont systemFontOfSize:17.0];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.separatorInset = UIEdgeInsetsZero;
    
    return cell;
}

#pragma mark - tableview delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self confiMenuWithSelectRow:indexPath];
    
    self.selectIndexPath = [indexPath copy];
    
    if (self.delegate || [self.delegate respondsToSelector:@selector(menu:didSelectRowAtIndexPath:)]) {
        [self.delegate menu:self didSelectRowAtIndexPath:indexPath];
    }
    
    [self dismiss];
}

- (void)confiMenuWithSelectRow:(NSIndexPath *)indexPath {
    
    if (!indexPath) {
        indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    }
    
    if ([self.dataSource respondsToSelector:@selector(menu:collegeForRowAtIndexPath:)]) {
        
        currentName = [self.dataSource menu:self collegeForRowAtIndexPath:indexPath];
        
    }
}

-(void)showTableView
{
    if ([self.tableView numberOfRowsInSection:0] <= 1) {
        self.gradeNameLable.text = [NSString stringWithFormat:@"%@",currentName];
        return;
    }
    
    if (_show) {
        
        self.gradeNameLable.text = [NSString stringWithFormat:@"%@ ▲",currentName];
        
        if (self.destinationView) {
            [self.destinationView addSubview:_backGroundView];
            [self.destinationView addSubview:self.tableView];
        }else
        {
            [self.superview addSubview:_backGroundView];
            [self.superview addSubview:self.tableView];
        }
        
        [UIView animateWithDuration:0.2 animations:^{
            _backGroundView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
        }];
        
        int maxRows = 5;
        if (IS_IPAD) {
            maxRows = 10;
        }
        
        CGFloat tableViewHeight = ([self.tableView numberOfRowsInSection:0] > maxRows) ? (maxRows * self.tableView.rowHeight) : ([self.tableView numberOfRowsInSection:0] * self.tableView.rowHeight);
        
        [UIView animateWithDuration:0.2 animations:^{
            _tableView.frame = CGRectMake(0, self.frame.origin.y + self.frame.size.height, kScreenWidth, tableViewHeight);
        }];
    } else {
        
        self.gradeNameLable.text = [NSString stringWithFormat:@"%@ ▼",currentName];
        
        [UIView animateWithDuration:0.2 animations:^{
            _backGroundView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
        } completion:^(BOOL finished) {
            [_backGroundView removeFromSuperview];
        }];
        
        [UIView animateWithDuration:0.2 animations:^{
            _tableView.frame = CGRectMake(0, self.frame.origin.y + self.frame.size.height, kScreenWidth, 0);
        } completion:^(BOOL finished) {
            [self.tableView reloadData];
            [self.tableView removeFromSuperview];
        }];
    }
}

- (void)menuTapped:(UITapGestureRecognizer *)paramSender {
    _show = !_show;
    [self showTableView];
}

- (void)reloadData
{
    [self.tableView reloadData];
    [self confiMenuWithSelectRow:self.selectIndexPath];
    
    if ([self.tableView numberOfRowsInSection:0] <= 1) {
        self.gradeNameLable.text = [NSString stringWithFormat:@"%@",currentName];
        return;
    }
    
    if (_show) {
        self.gradeNameLable.text = [NSString stringWithFormat:@"%@ ▲",currentName];
    } else {
        self.gradeNameLable.text = [NSString stringWithFormat:@"%@ ▼",currentName];
    }
}

- (void)dismiss
{
    _show = NO;
    [self showTableView];
}
- (void)setGradeNameLable:(UILabel *)gradeNameLable{
    _gradeNameLable = gradeNameLable;
    currentName = gradeNameLable.text;
}

@end
