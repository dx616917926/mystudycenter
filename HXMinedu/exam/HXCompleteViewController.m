//
//  HXCompleteViewController.m
//  Hxdd_exam
//
//  Created by Marble on 14-9-2.
//  Copyright (c) 2014年 华夏大地教育. All rights reserved.
//

#import "HXCompleteViewController.h"
#import "HXStartExamViewController.h"

@interface HXCompleteViewController ()
{
    UILabel *scoreLabel;
}
@end

@implementation HXCompleteViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //禁用全局滑动手势
    HXNavigationController * navigationController = (HXNavigationController *)self.navigationController;
    navigationController.enableInnerInactiveGesture = NO;
}

- (void)viewDidLoad
{
    NSLog(@"dic = %@",self.resultUrlDic);
    [super viewDidLoad];
    self.sc_navigationBar.title = @"答卷已提交!";
    self.navigationItem.hidesBackButton =YES;
    self.view.backgroundColor = [UIColor whiteColor];
    //分数背景图 125*125
    
    UIImageView *scoreImageView = [[UIImageView alloc]initWithFrame:CGRectMake((kScreenWidth-125)/2, kNavigationBarHeight+34, 125, 125)];
    scoreImageView.image = [UIImage imageNamed:@"exam_agoal"];
    [self.view addSubview:scoreImageView];
    
    scoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,(125-30)/2+3, 125, 30)];
    scoreLabel.textColor = [UIColor colorWithRed:0.988 green:0.545 blue:0.000 alpha:1.000];//@"#FC8B00";
    scoreLabel.text = @"交白卷";
    scoreLabel.font = [UIFont systemFontOfSize:18];
    scoreLabel.textAlignment = NSTextAlignmentCenter;
    [scoreImageView addSubview:scoreLabel];
    
    //查看分数url

    NSString *scoreUrl = [NSString stringWithFormat:@"%@%@",self.basePath,[self.resultUrlDic objectForKey:@"scoreUrl"]];

    //userExam字典
    
    NSDictionary *userExam = [self.resultUrlDic objectForKey:@"userExam"];
    
    //是否能查看试卷
    
    NSString *canCheck = [NSString stringWithFormat:@"%@",[userExam objectForKey:@"allowSeeResult"]];
    
    //是否能看分数
    
    NSString *canSeeScore = [NSString stringWithFormat:@"%@",[userExam objectForKey:@"scoreSecret"]];
    
    if ([canSeeScore isEqualToString:@"0"]) {
        [HXExamSessionManager getDataWithNSString:scoreUrl withDictionary:nil success:^(NSDictionary *dictionary) {
            NSLog(@"%@",dictionary);
            NSDictionary *obj = [dictionary objectForKey:@"userExam"];
            NSString *checked = [NSString stringWithFormat:@"%@",[obj objectForKey:@"checked"]];
            NSString *score = [NSString stringWithFormat:@"%@",[obj objectForKey:@"score"]];
            
            if ([checked isEqualToString:@"1"] && score.floatValue >= 0) {
                NSString * s = [NSString stringWithFormat:@"%.1f",score.floatValue];
                scoreLabel.text = [NSString stringWithFormat:@"%g",s.floatValue];
            }else{
                scoreLabel.text = @"处理中";
            }
            
        } failure:^(NSError *error) {
            [scoreLabel setHidden:YES];
            scoreImageView.frame = CGRectMake((kScreenWidth-85.5)/2, kNavigationBarHeight+50, 85.5, 85.5);
            scoreImageView.image = [UIImage imageNamed:@"exam_complete"];
        }];
    }else{
        [scoreLabel setHidden:YES];
        scoreImageView.frame = CGRectMake((kScreenWidth-85.5)/2, kNavigationBarHeight+50, 85.5, 85.5);
        scoreImageView.image = [UIImage imageNamed:@"exam_complete"];
    }

    //如果能查看才有查看答卷的按钮 否则没有

    if ([canCheck isEqualToString:@"1"]) {
        UIButton *checkbtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [checkbtn setTitle:@"查看答卷" forState:UIControlStateNormal];
        [checkbtn setBackgroundColor:kNavigationBarColor];
        [checkbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        checkbtn.layer.cornerRadius = 2.0;
        [checkbtn addTarget:self action:@selector(checkBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        checkbtn.frame = CGRectMake((kScreenWidth-280)/2, scoreImageView.bottom+45, 280, 40);
        [self.view addSubview:checkbtn];
        
        UIButton *backbtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [backbtn setTitle:@"返回" forState:UIControlStateNormal];
        [backbtn setBackgroundColor:kNavigationBarTintColor];
        [backbtn setTitleColor:kNavigationBarColor forState:UIControlStateNormal];
        backbtn.layer.cornerRadius = 2.0;
        backbtn.layer.borderWidth = 1;
        backbtn.layer.borderColor = kNavigationBarColor.CGColor;
        [backbtn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        backbtn.frame = CGRectMake((kScreenWidth-280)/2, checkbtn.bottom+12, 280, 40);
        [self.view addSubview:backbtn];
        
    }else{
        UIButton *backbtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [backbtn setTitle:@"返回" forState:UIControlStateNormal];
        [backbtn setBackgroundColor:kNavigationBarTintColor];
        [backbtn setTitleColor:kNavigationBarColor forState:UIControlStateNormal];
        backbtn.layer.cornerRadius = 2.0;
        backbtn.layer.borderWidth = 1;
        backbtn.layer.borderColor = kNavigationBarColor.CGColor;
        [backbtn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        backbtn.frame = CGRectMake((kScreenWidth-280)/2, scoreImageView.bottom+45, 280, 40);
        [self.view addSubview:backbtn];
    }
}

//查看试卷
- (void)checkBtnClicked{
    
    NSLog(@"%@",_resultUrlDic);
    //查看试卷
    [self.view showLoading];
    
    NSString * url = [NSString stringWithFormat:@"%@%@",self.examBasePath,[_resultUrlDic objectForKey:@"resultUrl"]];
    
    [HXExamSessionManager getDataWithNSString:url withDictionary:nil success:^(NSDictionary *dictionary) {
        
        [self.view hideLoading];
        
        NSString *success = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"success"]];
        if ([success isEqualToString:@"1"]) {
            //NSLog(@"%@",[dictionary objectForKey:@"url"]);

            HXStartExamViewController  *svc = [[HXStartExamViewController  alloc]init];
            svc.examUrl = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"url"]];
            svc.userExam = [dictionary objectForKey:@"userExam"];
            svc.examTitle = _examTitle;
            svc.isStartExam = NO;
            svc.isEnterExam = NO;
            svc.isAllowSeeAnswer = [[dictionary objectForKey:@"allowSeeAnswer"] boolValue];
            svc.examBasePath = [dictionary objectForKey:@"context"];
            
            [self.navigationController pushViewController:svc animated:YES];
            
        }else
        {
            [self.view showErrorWithMessage:@"获取数据失败,请重试!"];
            NSLog(@"%@",dictionary);
        }
    } failure:^(NSError *error) {
        [self.view showErrorWithMessage:@"获取数据失败,请重试!"];
    }];

}
- (void)backBtnClicked{
    
    //开启全局滑动手势
    HXNavigationController * navigationController = (HXNavigationController *)self.navigationController;
    navigationController.enableInnerInactiveGesture = YES;
    
    NSArray *array = self.navigationController.viewControllers;
    NSLog(@"array %@",array);
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:array.count-3] animated:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return kStatusBarStyle;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
