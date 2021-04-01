//
//  HXCourseListModelView.m
//  HXMinedu
//
//  Created by Mac on 2021/1/20.
//

#import "HXCourseListModelView.h"
#import "HXCustomButton.h"
#import <UIButton+WebCache.h>

@interface HXCourseListModelView ()
{
    int rowNum;
    CGFloat buttonWidth;
    CGFloat buttonHeight;
}
@end

@implementation HXCourseListModelView

- (instancetype)init
{
    self = [super init];
    if (self) {
        rowNum = 3;  //每行3个
        buttonWidth = 66;
        buttonHeight = 83;
        
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        rowNum = 3;  //每行3个
        buttonWidth = 66;
        buttonHeight = 83;
        
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setListModel:(NSArray<HXModelItem *> *)listModel
{
    _listModel = listModel;
    
    //先清除所有子视图
    while (self.subviews.count) {
        [self.subviews.lastObject removeFromSuperview];
    }
    
    for (int i = 0; i<listModel.count; i++) {
        
        HXModelItem *item = [listModel objectAtIndex:i];
        
        NSString *imageName = @"course_qm";
        if ([item.Type isEqualToString:@"1"]) {
            imageName = @"course_kj";
        }
        if ([item.ModuleName isEqualToString:@"平时作业"]) {
            imageName = @"course_zy";
        }
        
        HXCustomButton *button = [HXCustomButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, buttonWidth, buttonHeight);
        
        //设置模块的图片
        if (item.ImgUrl) {
            [button sd_setImageWithURL:[NSURL URLWithString:item.ImgUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:imageName]];
        }else
        {
            [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        }
        
        [button setTitle:item.ModuleName forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.imageTitleSpace = 4;
        button.style = HXButtonEdgeInsetsStyleTop;
        button.tag = i;
        [self addSubview:button];
        
        [button addTarget:self action:@selector(modelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }

    [self invalidateIntrinsicContentSize];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat buttonSpace = (self.bounds.size.width - buttonWidth*rowNum)/(rowNum-1);
    
    for (int i = 0; i<self.subviews.count; i++) {
        UIView *subView = [self.subviews objectAtIndex:i];
        subView.frame = CGRectMake((i%rowNum)*(buttonSpace+buttonWidth), (i/rowNum)*(buttonHeight+20), buttonWidth, buttonHeight);
    }
}

- (CGSize)intrinsicContentSize {
    //ceilf() 向上取整数
    return CGSizeMake(self.bounds.size.width,(ceilf(1.0*self.subviews.count/rowNum))*(buttonHeight+20) - 20);
}

- (void)modelButtonAction:(UIButton *)button {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickButtonWithModel:)]) {
        [self.delegate didClickButtonWithModel:[self.listModel objectAtIndex:button.tag]];
    }
}

@end
