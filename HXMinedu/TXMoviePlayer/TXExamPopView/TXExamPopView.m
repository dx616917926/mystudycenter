//
//  TXExamPopView.m
//  TXMoviePlayer
//
//  Created by Mac on 2019/5/27.
//  Copyright © 2019 华夏大地教育网. All rights reserved.
//

#import "TXExamPopView.h"
#import <WebKit/WebKit.h>

#define HXExamPopBundle [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"txexampop.bundle"]

@interface TXExamPopView ()<WKNavigationDelegate>
{
    WKWebView * webview;
}

@property (nonatomic, strong) UIImageView *contentView;
@property (nonatomic, strong) UIButton *btnCancel;
@property (nonatomic, strong) UIButton *btnUse;
@property (nonatomic, strong) UIButton *btnContinueLearn;
@property (nonatomic, strong) UIImageView *resultImageView;
@property (nonatomic, strong) UIActivityIndicatorView *waitActView; //转圈圈

@end

@implementation TXExamPopView


-(id)init
{
    if (self = [super init]) {
        self.tag = 99;
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect frame = self.frame;
    if (IS_IPAD) {
        frame.size.height *= 0.7;
        frame.size.width *= 0.7;
    }else
    {
        //竖屏的时候，需要适配
        if (frame.size.height>frame.size.width) {
            frame.size.height *= 0.8;
            frame.size.width *= 0.95;
        }else
        {
            frame.size.height *= 0.93;
            frame.size.width *= 0.8;
        }
    }
    
    self.contentView.frame = frame;
    self.contentView.center = self.center;
}

-(void)showInView:(UIView *)view
{
    if(!self.superview)
        [view addSubview:self];
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo([UIApplication sharedApplication].keyWindow);
    }];
    
    self.userInteractionEnabled = YES;
    
    if (!self.contentView) {
        
        CGRect frame = self.frame;
        if (IS_IPAD) {
            frame.size.height *= 0.7;
            frame.size.width *= 0.7;
        }else
        {
            //竖屏的时候，需要适配
            if (frame.size.height>frame.size.width) {
                frame.size.height *= 0.8;
                frame.size.width *= 0.95;
            }else
            {
                frame.size.height *= 0.93;
                frame.size.width *= 0.8;
            }
        }
        
        self.contentView = [[UIImageView alloc]initWithFrame:frame];
        self.contentView.center = self.center;
        [self.contentView setImage:[UIImage imageNamed:@"tx_pop_exampopbg"]];
        self.contentView.userInteractionEnabled = YES;
        [self addSubview:self.contentView];
    }
    
    if (!webview) {
        webview = [[WKWebView alloc]init];
        [webview setBackgroundColor:[UIColor whiteColor]];
        [webview setOpaque:NO];
        [webview setNavigationDelegate:self];
        [self.contentView addSubview:webview];
        
        [webview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.offset(20);
            make.right.offset(-20);
            make.bottom.offset(-60);
        }];
    }
    
//    //关闭按钮
//    if (!self.btnCancel) {
//        self.btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
//        [self.btnCancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [self.btnCancel setBackgroundImage:[UIImage imageNamed:@"tx_pop_closebutton"] forState:UIControlStateNormal];
//        [self.btnCancel addTarget:self action:@selector(btnCancelPressed) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:self.btnCancel];
//
//        [self.btnCancel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(self.contentView).offset(-12);
//            make.top.mas_equalTo(self.contentView).offset(-8);
//            make.size.mas_equalTo(CGSizeMake(35, 35));
//        }];
//    }
    
    if (!self.resultImageView) {
        self.resultImageView = [[UIImageView alloc] init];
        self.resultImageView.hidden = YES;
        [self addSubview:self.resultImageView];
        
        [self.resultImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView).offset(8);
            make.top.mas_equalTo(self.contentView).offset(-8);
            make.size.mas_equalTo(CGSizeMake(80, 80));
        }];
    }
    
    if (!self.btnUse) {
        self.btnUse = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.btnUse setTitle:@"提交" forState:UIControlStateNormal];
        [self.btnUse setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.btnUse setBackgroundColor:[UIColor colorWithRed:0.18 green:0.55 blue:0.94 alpha:1.00]];
        [self.btnUse.titleLabel setFont:[UIFont systemFontOfSize:17]];
        self.btnUse.layer.cornerRadius = 2.0;
        [self.btnUse addTarget:self action:@selector(btnUsePressed) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.btnUse];
        
        [self.btnUse mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(42);
            make.left.offset(40);
            make.right.offset(-40);
            make.bottom.offset(-12);
        }];
    }
    
    if (!self.btnContinueLearn) {
        self.btnContinueLearn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.btnContinueLearn setTitle:@"关闭" forState:UIControlStateNormal];
        self.btnContinueLearn.layer.borderWidth = 1;
        self.btnContinueLearn.layer.borderColor = [UIColor colorWithRed:0.18 green:0.55 blue:0.94 alpha:1.00].CGColor;
        self.btnContinueLearn.layer.cornerRadius = 3;
        self.btnContinueLearn.layer.masksToBounds = YES;
        self.btnContinueLearn.titleLabel.font = [UIFont systemFontOfSize:17];
        [self.btnContinueLearn setTitleColor:[UIColor colorWithRed:0.18 green:0.55 blue:0.94 alpha:1.00] forState:UIControlStateNormal];
        [self.btnContinueLearn addTarget:self action:@selector(btnContinueLearnPressed) forControlEvents:UIControlEventTouchUpInside];
        self.btnContinueLearn.hidden = YES;
        [self.contentView addSubview:self.btnContinueLearn];
        
        [self.btnContinueLearn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(42);
            make.left.offset(40);
            make.right.offset(-40);
            make.bottom.offset(-12);
        }];
    }
    
    if (!self.waitActView) {
        //转圈圈
        self.waitActView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self.waitActView setHidesWhenStopped:YES];
        [self.waitActView startAnimating];
        [self.contentView addSubview:self.waitActView];
        [self.waitActView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.offset(0);
        }];
    }
    
    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.alpha = 1;
                     }
                     completion:^(BOOL finished){
                         
                     }];
    
    [self loadExamQuestion];
    
    [self setNeedsDisplay];
}

-(void)loadExamQuestion
{
    if (webview) {
        //head
        NSMutableString * htmlString = [[NSMutableString alloc] initWithString:@"<html><head><meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\"/><meta name=\"viewport\" content=\"width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1, user-scalable=no\">"];
        
        //css
        [htmlString appendString:@"<link href=\"paper_cellphone.css\" rel=\"stylesheet\" type=\"text/css\"/>"];
        //js
        [htmlString appendString:@"<script src=\"jquery-1.9.0.min.js\" type=\"text/javascript\"></script>"];
        [htmlString appendString:@"<script src=\"paper_cellphone.js\" type=\"text/javascript\"></script>"];
        [htmlString appendString:@"</head><body>"];
        
        //开始
        NSString *html1 = @"<div class=\"popup-questions\"><p class=\"popup-questions-title\">请认真答题，答题结果将记入知识点测评的成绩！</p><div class=\"question\" ";
        [htmlString appendString:html1];
        
        if ([self.questionItem.questionType isEqualToString:@"1"]) {
            //单选
            [htmlString appendString:[NSString stringWithFormat:@"type=\"single_choice\" answer=\"%@\" score=\"100\"><p>单选题</p>",self.questionItem.answer]];
        }else
        {
            [htmlString appendString:[NSString stringWithFormat:@"type=\"multi_choice\" answer=\"%@\" score=\"100\"><p>多选题</p>",self.questionItem.answer]];
        }
        
        //题干
        [htmlString appendString:[NSString stringWithFormat:@"<div class=\"label\">%@</div>",self.questionItem.questionStem]];

        //选项
        NSString *html3 = @"<ul class=\"options\">";
        [htmlString appendString:html3];
        
        for (TXQuestionOption *option in self.questionItem.optionList) {
            NSString *optionHtml = [NSString stringWithFormat:@"<li code=\"%@\"><table><tr><td><div class=\"mark\">%@</div></td><td>%@</td></tr></table></li>",option.quesValue,option.quesValue,option.quesOption];
            [htmlString appendString:optionHtml];
        }
        
        //答案
        NSString *html4 = @"</ul> <div class=\"answer\">";
        [htmlString appendString:html4];

        [htmlString appendString:[NSString stringWithFormat:@"<p>【答案】%@</p>",self.questionItem.answer]];
        [htmlString appendString:[NSString stringWithFormat:@"<p>【解析】<div style=\"margin-left:10px\">%@</div></p>",self.questionItem.analysis]];
        [htmlString appendString:[NSString stringWithFormat:@"<p>【考核点】%@</p>",self.questionItem.examinePoint]];
        
        NSString *html5 = @"</div></div></div>";
        [htmlString appendString:html5];
        
        //foot
        [htmlString appendString:@"<script type=\"text/javascript\">(function(){$(document).ready(function(){prepare();});})();</script></body></html>"];
        
        [webview loadHTMLString:htmlString baseURL:[NSURL fileURLWithPath:HXExamPopBundle]];
    }
}

-(void)btnCancelPressed
{
    [self dismiss:@"取消"];
}

-(void)btnUsePressed
{
    [webview evaluateJavaScript:@"javascript:submit()" completionHandler:^(id _Nullable answer, NSError * _Nullable error) {
        //
        if ([answer isEqualToString:@"1"]) {
            [self answerSuccess];
        }else if([answer isEqualToString:@"0"]){
            [self answerError];
        }
    }];
    
    [self.resultImageView setHidden:NO];
    [self.btnUse setHidden:YES];
    [self.btnContinueLearn setHidden:NO];
}

-(void)answerSuccess
{
    [self.resultImageView setImage:[UIImage imageNamed:@"tx_pop_rightImage"]];
    [self showSuccessWithMessage:@"回答正确！"];
    
    if ([self.delegate respondsToSelector:@selector(examQuestion:withResult:)]) {
        [self.delegate examQuestion:self.questionItem withResult:YES];
    }
}

-(void)answerError
{
    [self.resultImageView setImage:[UIImage imageNamed:@"tx_pop_wrongImage"]];
    [self showErrorWithMessage:@"回答错误！"];
    
    if ([self.delegate respondsToSelector:@selector(examQuestion:withResult:)]) {
        [self.delegate examQuestion:self.questionItem withResult:NO];
    }
}

/**
 *  继续学习
 */
-(void)btnContinueLearnPressed
{
    [self dismiss:@"继续学习"];
}

/**
 *  重新学习
 */
-(void)btnRLearnPressed
{
    [self dismiss:@"重新学习"];
}

- (void)dismiss:(NSString *)state {
    
    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationCurveEaseIn | UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         self.alpha = 0;
                     }
                     completion:^(BOOL finished){
                         
                         if ([self.delegate respondsToSelector:@selector(continuePlay)]) {
                             [self.delegate continuePlay];
                         }
                         
                         [self.contentView removeFromSuperview];
                         self.contentView = nil;
                         [self removeFromSuperview];
                     }];
}

#pragma mark - Delegate-WKWebView

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation
{
    [self.waitActView startAnimating];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    [self.waitActView stopAnimating];
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    [self showErrorWithMessage:@"获取数据失败！"];
    
    [self dismiss:@"继续学习"];
}


- (void)showErrorWithMessage:(NSString *)str {
    NSLog(@"%@",str);
}

- (void)showSuccessWithMessage:(NSString *)str {
    NSLog(@"%@",str);
}

@end
