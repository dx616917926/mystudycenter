//
//  HXPlaceholderTextView.m
//  zikaoks
//
//  Created by Mac on 2021/12/10.
//  Copyright © 2021 华夏大地教育网. All rights reserved.
//

#import "HXPlaceholderTextView.h"

@implementation HXPlaceholderTextView

- (void)commonInit
{
    self.placeholderTextColor = [UIColor lightGrayColor];
    
    // 使用通知监听文字改变
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextViewTextDidChangeNotification object:self];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)textDidChange:(NSNotification *)note
{
    // 会重新调用drawRect:方法
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    if (self.text.length)
    {
        [super drawRect:rect];
    } else {

        UIEdgeInsets inset = UIEdgeInsetsMake(8, 5, 8, 5);
        
        NSMutableParagraphStyle *textStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
        textStyle.lineBreakMode = NSLineBreakByWordWrapping;
        
        [self.placeholderText drawInRect:UIEdgeInsetsInsetRect(UIEdgeInsetsInsetRect(rect, self.contentInset), inset) withAttributes:@{NSFontAttributeName:self.font, NSParagraphStyleAttributeName:textStyle,NSForegroundColorAttributeName:self.placeholderTextColor}];
    }
}


@end
