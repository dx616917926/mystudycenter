//
//  HXLoginContentView.m
//  HXMinedu
//
//  Created by Mac on 2020/12/17.
//

#import "HXLoginContentView.h"

@interface HXLoginContentView ()

@property (weak, nonatomic) IBOutlet UIButton *seeButton;
@property (weak, nonatomic) IBOutlet UIButton *userNameTypeButton;
@property (weak, nonatomic) IBOutlet UIButton *phoneTypeButton;
@property (weak, nonatomic) IBOutlet UIImageView *line1;
@property (weak, nonatomic) IBOutlet UIImageView *line2;

@end


@implementation HXLoginContentView

- (void)awakeFromNib{
    [super awakeFromNib];
    
    
}

- (HXLoginType)loginType{
    
    if (self.phoneTypeButton.selected) {
        return HXLoginTypePhone;
    }
    return HXLoginTypeUserName;
}

- (IBAction)userNameTypeAction:(id)sender {
    
    if (!self.userNameTypeButton.selected) {
        self.userNameTypeButton.selected = YES;
        self.phoneTypeButton.selected = NO;
        self.line1.hidden = NO;
        self.line2.hidden = YES;
        self.userNameTextField.placeholder = @"请输入用户名";
        self.userNameTextField.text = @"";
    }
}

- (IBAction)phoneTypeAction:(id)sender {
    
    if (!self.phoneTypeButton.selected) {
        self.userNameTypeButton.selected = NO;
        self.phoneTypeButton.selected = YES;
        self.line1.hidden = YES;
        self.line2.hidden = NO;
        self.userNameTextField.placeholder = @"请输入手机号";
        self.userNameTextField.text = @"";
    }
}

- (IBAction)loginButtonAction:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(loginButtonClick)]) {
        [self.delegate loginButtonClick];
    }
}

- (IBAction)forgetPassworkButtonAction:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(forgetPassworkButtonClick)]) {
        [self.delegate forgetPassworkButtonClick];
    }
}

- (IBAction)privacyPolicyButtonAction:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(privacyPolicyButtonClick)]) {
        [self.delegate privacyPolicyButtonClick];
    }
}

- (IBAction)selectButtonAction:(id)sender {
    
    self.selectButton.selected = !self.selectButton.selected;
    
    if (self.selectButton.selected) {
        [self.loginButton setBackgroundImage:[UIImage imageNamed:@"login_btn"] forState:UIControlStateNormal];
    }else
    {
        [self.loginButton setBackgroundImage:[UIImage imageNamed:@"login_btn_n"] forState:UIControlStateNormal];
    }
}

- (IBAction)seeButtonAction:(id)sender {
    
    self.seeButton.selected = !self.seeButton.selected;
    
    self.passWordTextField.secureTextEntry = !self.seeButton.selected;
    
}


#pragma mark ------textField代理方法------

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{

}

- (void)textFieldDidEndEditing:(UITextField *)textField
{

}

-(void)textFiledEditChanged:(NSNotification *)obj{
    if ([_userNameTextField.text isEqualToString:@""]) {
        _passWordTextField.text = @"";
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == _userNameTextField) {
        [_passWordTextField becomeFirstResponder];
    }else if (textField == _passWordTextField)
    {
        [_passWordTextField resignFirstResponder];
    }
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    if (_userNameTextField == textField) {
        _passWordTextField.text = @"";
    }
    return YES;
}


@end
