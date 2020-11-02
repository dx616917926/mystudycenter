//
//  TXLectureViewController.m
//  TXMoviePlayer
//
//  Created by Mac on 2019/5/23.
//  Copyright © 2019 华夏大地教育网. All rights reserved.
//

#import "TXLectureViewController.h"

@interface TXLectureViewController ()

@end

@implementation TXLectureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //设置空白界面
    UIView *blankBg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
    blankBg.backgroundColor  = [UIColor whiteColor];
    UIImageView *logoImg = [[UIImageView alloc]initWithFrame:CGRectMake((kScreenWidth-120)/2, 100, 120, 100)];
    logoImg.image = [UIImage imageNamed:@"ic_no_events"];
    [blankBg addSubview:logoImg];
    UILabel *warnMsg = [[UILabel alloc]initWithFrame:CGRectMake(30, logoImg.frame.origin.y + logoImg.frame.size.height, kScreenWidth-60, 80)];
    warnMsg.numberOfLines = 2;
    warnMsg.text = @"暂无讲义";
    warnMsg.textColor = [UIColor colorWithWhite:0.5 alpha:1.000];
    warnMsg.font = [UIFont systemFontOfSize:16];
    warnMsg.textAlignment = NSTextAlignmentCenter;
    [blankBg addSubview:warnMsg];
    [self.view addSubview:blankBg];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
