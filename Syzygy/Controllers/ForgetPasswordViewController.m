//
//  ForgetPasswordViewController.m
//  Syzygy
//
//  Created by manisha panse on 4/25/18.
//  Copyright © 2018 kamal gupta. All rights reserved.
//

#import "ForgetPasswordViewController.h"
#import "MBProgressHUD.h"
#import "UserLoginServices.h"
#import "UISuporterINApp.h"
#import "LoginViewController.h"
@interface ForgetPasswordViewController ()<UITextFieldDelegate>
{
    NSString *token;
}
@end

@implementation ForgetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =  [UIColor colorWithPatternImage:[UIImage imageNamed:@"viewBg"]];
    [UISuporterINApp SetTextFieldBorder:_otpTF  withView:self.view];
    [UISuporterINApp SetTextFieldBorder:_mobileTF withView:self.view];
    self.view.backgroundColor =  [UIColor colorWithPatternImage:[UIImage imageNamed:@"viewBg"]];
    [UISuporterINApp SetTextFieldBorder:_cMobileTf  withView:self.view];
    [UISuporterINApp SetTextFieldBorder:_confirmPassword withView:self.view];
    [UISuporterINApp SetTextFieldBorder:_NewPassword withView:self.view];
    self.mobileTF.text = _contactNumber;
    [self setupRightViewHidePasswordForField:_otpTF withTag:1];
    [self setupRightViewHidePasswordForField:_NewPassword withTag:2];
    [self setupRightViewHidePasswordForField:_confirmPassword withTag:3];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void) generateOTP {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = NSLocalizedString(@"Loading...", @"HUD loading title");
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        //NSString *newStr = [_contactNumber substringFromIndex:2];
        NSMutableDictionary *parameter = [NSMutableDictionary new];
        [parameter setObject:_contactNumber forKey:@"contact_no"];
        
        NSMutableDictionary *responceDict = [UserLoginServices ForgotPasswordOTP:parameter];
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
            NSLog(@"%@" , responceDict);
            if ([[responceDict objectForKey:@"message"] isEqualToString:@"success"]) {
                self.forgetViewHeight.constant = 120;
                self.otpTF.hidden = NO;
                self.otpImage.hidden = NO;
                [self.OTPButton setTitle:@"Save" forState:UIControlStateNormal];
            }else {
                [self presentViewController:[UISuporterINApp generateAlert:@"Something Wrong"] animated:YES completion:nil];
            }
        });
    });
}
//matchOTP


- (void) MatchOTP {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = NSLocalizedString(@"Loading...", @"HUD loading title");
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
       // NSString *newStr = [_contactNumber substringFromIndex:2];
        NSMutableDictionary *parameter = [NSMutableDictionary new];
        [parameter setObject:_contactNumber forKey:@"contact_no"];
        [parameter setObject:_otpTF.text forKey:@"otp"];

        NSMutableDictionary *responceDict = [UserLoginServices matchOTP:parameter];
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
            NSLog(@"%@" , responceDict);
            if ([[responceDict objectForKey:@"message"] isEqualToString:@"success"]) {
                token = [responceDict objectForKey:@"token"];
                self.forgotView.hidden = YES;
                self.OTPButton.hidden = YES;
                self.changePasswordView.hidden = NO;
                self.cMobileTf.text = _contactNumber;
                
            }else {
                [self presentViewController:[UISuporterINApp generateAlert:@"Something Wrong"] animated:YES completion:nil];
            }
        });
    });
}


- (IBAction)ActionOnGetOTP:(id)sender {
    [self.view endEditing:YES];
    if ([self.OTPButton.titleLabel.text isEqualToString:@"Save"] && _otpTF.text.length > 0) {
        [self MatchOTP];
    }else{
        [self generateOTP];
    }
}

- (IBAction)ActionOnSave:(id)sender {
    [self.view endEditing:YES];
    NSString *oldPassword = _NewPassword.text;
    NSString *newPassword = _confirmPassword.text;
    
    if ([oldPassword isEqualToString:newPassword]) {
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        hud.label.text = NSLocalizedString(@"Please Wait...", @"HUD loading title");
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
            
            NSMutableDictionary *parameter = [NSMutableDictionary new];
            
            [parameter setObject:token forKey:@"token"];
            [parameter setObject: _contactNumber forKey:@"contact_no"];
            [parameter setObject: newPassword forKey:@"new_password"];
            
            NSLog(@"Parameter : %@" , parameter);
            NSMutableDictionary *responceDict = [UserLoginServices ForgotPassword:parameter];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES];
                
                NSLog(@"%@" , responceDict);
                
                if ([[responceDict objectForKey:@"status"] intValue] == 200) {
                    
                    NSArray *viewControllers = [[self navigationController] viewControllers];
                    for( int i=0;i<[viewControllers count];i++){
                        id obj=[viewControllers objectAtIndex:i];
                        if([obj isKindOfClass:[LoginViewController class]]){
                            [[self navigationController] popToViewController:obj animated:YES];
                            return;
                        }
                    }
                } else {
                    
                    [self presentViewController:[UISuporterINApp generateAlert:[responceDict objectForKey:@"message"]] animated:YES completion:nil];
                }
                
            });
        });
    } else{
        
        
        [self presentViewController:[UISuporterINApp generateAlert:@"comfirm password not matched."] animated:YES completion:nil];
    }
}

-(void)setupRightViewHidePasswordForField:(UITextField*)textField withTag:(NSInteger)butonTag{
    UIButton *firstFieldButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [firstFieldButton setImage:[UIImage imageNamed:@"view"] forState:UIControlStateNormal];
    [firstFieldButton setImage:[UIImage imageNamed:@"hide"] forState:UIControlStateSelected];
    
    [firstFieldButton addTarget:self action:@selector(actionOnViewButton:) forControlEvents:UIControlEventTouchUpInside];
    firstFieldButton.tag = butonTag;
    UIView *LView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    firstFieldButton.frame = CGRectMake(5, 5, 30, 40);
    textField.contentMode = UIViewContentModeScaleAspectFill;
    [LView addSubview:firstFieldButton];
    textField.rightView = LView;
    textField.rightViewMode = UITextFieldViewModeAlways;
}
-(void)actionOnViewButton:(UIButton*)button{
    button.selected = !button.selected;
    switch (button.tag) {
        case 1:
            if (button.isSelected) {
                _otpTF.secureTextEntry = NO;
            }else{
                _otpTF.secureTextEntry = YES;
            }
            break;
        case 2:
            if (button.isSelected) {
                _NewPassword.secureTextEntry = NO;
            }else{
                _NewPassword.secureTextEntry = YES;
            }
            break;
        case 3:
            if (button.isSelected) {
                _confirmPassword.secureTextEntry = NO;
            }else{
                _confirmPassword.secureTextEntry = YES;
            }
            break;
        default:
            break;
    }
}

#pragma mark - UITextField Delegates

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

@end
