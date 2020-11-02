//
//  HXPenPickerController.m
//  eplatform-painter
//
//  Created by  MAC on 15/7/22.
//  Copyright © 2015年 华夏大地教育. All rights reserved.
//

#import "HXPenPickerController.h"

@interface HXPenPickerController ()

@end

@implementation HXPenPickerController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    CGFloat size = [defaults integerForKey:@"LineSize"];
    
    if (size != 0) {
        _optionsSlider.value = size;
    }
    
    [self updateOptionsSettings];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) updateOptionsSettings
{
    _optionsValueLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)_optionsSlider.value];
    NSLog(@"%@",_optionsValueLabel.text);
}

- (IBAction) takeFinalSliderValueFrom:(id)sender
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setInteger:_optionsSlider.value forKey:@"LineSize"];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(penPickerDidChangeLineWidth:)]) {
        [self.delegate penPickerDidChangeLineWidth:_optionsSlider.value];
    }
    
}

- (IBAction) takeSliderValueFrom:(id)sender
{
    [self updateOptionsSettings];
}

- (IBAction)increment:(id)sender
{
    _optionsSlider.value = _optionsSlider.value + 1;
    [_optionsSlider sendActionsForControlEvents:UIControlEventTouchUpInside];
    [self updateOptionsSettings];
}

- (IBAction)decrement:(id)sender
{
    _optionsSlider.value = _optionsSlider.value - 1;
    [_optionsSlider sendActionsForControlEvents:UIControlEventTouchUpInside];
    [self updateOptionsSettings];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)toolButtonsAction:(id)sender {
    
    UIButton * btn = sender;
    if (self.delegate && [self.delegate respondsToSelector:@selector(penPickerDidSelectPenType:)]) {
        [self.delegate penPickerDidSelectPenType:btn.tag];
    }
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [self dismissViewControllerAnimated:YES completion:^{
            //
        }];
    }
}
@end
