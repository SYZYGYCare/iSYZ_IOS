//
//  ChangePasswordViewController.m
//  Syzygy
//
//  Created by Kamal Gupta on 12/2/17.
//  Copyright © 2017 kamal gupta. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "UISuporterINApp.h"
#import "MBProgressHUD.h"
#import "SYUserDefault.h"
#import "UserLoginServices.h"
//
@interface ChangePasswordViewController ()<UITextFieldDelegate>

@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =  [UIColor colorWithPatternImage:[UIImage imageNamed:@"viewBg"]];
    self.title = @"Change Password";
    [UISuporterINApp SetTextFieldBorder:_currentPasswordTextField withView:self.view];
    [UISuporterINApp SetTextFieldBorder:_passwordTextFeild withView:self.view];
    [UISuporterINApp SetTextFieldBorder:_confirmPasswordTextFeild withView:self.view];

    [UISuporterINApp setCustomeLeftViewForTextField:_currentPasswordTextField withView:self.view];
    [UISuporterINApp setCustomeLeftViewForTextField:_passwordTextFeild withView:self.view];
    [UISuporterINApp setCustomeLeftViewForTextField:_confirmPasswordTextFeild withView:self.view];
    [self setupRightViewHidePasswordForField:_currentPasswordTextField withTag:1];
    
     [self setupRightViewHidePasswordForField:_passwordTextFeild withTag:2];
    
    [self setupRightViewHidePasswordForField:_confirmPasswordTextFeild withTag:3];

//    [UISuporterINApp setCustomeRightViewForTextField:_currentPasswordTextField withView:self.view withImageName:@"view"];
//    [UISuporterINApp setCustomeRightViewForTextField:_passwordTextFeild withView:self.view  withImageName:@"view"];
//    [UISuporterINApp setCustomeRightViewForTextField:_confirmPasswordTextFeild withView:self.view withImageName:@"view"];
    // Do any additional setup after loading the view.
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

/*-(void)setupRightViewShowPasswordForField:(UITextField*)textField withTag:(NSInteger)butonTag{
    UIButton *firstFieldButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [firstFieldButton setImage:[UIImage imageNamed:@"hide"] forState:UIControlStateNormal];
    [firstFieldButton addTarget:self action:@selector(actionOnViewButton:) forControlEvents:UIControlEventTouchUpInside];
    firstFieldButton.tag = butonTag;
    UIView *LView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    firstFieldButton.frame = CGRectMake(5, 5, 30, 40);
    textField.contentMode = UIViewContentModeScaleAspectFill;
    [LView addSubview:firstFieldButton];
    textField.rightView = LView;
    textField.rightViewMode = UITextFieldViewModeAlways;
}*/

-(void)actionOnViewButton:(UIButton*)button{
    button.selected = !button.selected;
    switch (button.tag) {
        case 1:
            if (button.isSelected) {
                _currentPasswordTextField.secureTextEntry = NO;
            }else{
                _currentPasswordTextField.secureTextEntry = YES;
            }
            break;
        case 2:
            if (button.isSelected) {
                _passwordTextFeild.secureTextEntry = NO;
            }else{
                _passwordTextFeild.secureTextEntry = YES;
            }
            break;
        case 3:
            if (button.isSelected) {
                _confirmPasswordTextFeild.secureTextEntry = NO;
            }else{
                _confirmPasswordTextFeild.secureTextEntry = YES;
            }
            break;
        default:
            break;
    }
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


- (IBAction)changePasswordButtonTapped:(id)sender {
    [self.view endEditing:YES];
    NSString *oldPassword = _currentPasswordTextField.text;
    NSString *newPassword = _passwordTextFeild.text;
    
    if ([newPassword isEqualToString:_confirmPasswordTextFeild.text]) {
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        hud.label.text = NSLocalizedString(@"Please Wait...", @"HUD loading title");
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
            
            NSMutableDictionary *parameter = [NSMutableDictionary new];
            
            [parameter setObject:[[SYUserDefault sharedManager] getAppToken] forKey:@"token"];
            [parameter setObject: oldPassword forKey:@"old_password"];
            [parameter setObject: newPassword forKey:@"new_password"];
            
            NSLog(@"Parameter : %@" , parameter);
            NSMutableDictionary *responceDict = [UserLoginServices changePassword:parameter];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES];
                
                NSLog(@"%@" , responceDict);
                
                if ([[responceDict objectForKey:@"message"] isEqualToString:@"success"]) {
                    
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }else if (([[responceDict objectForKey:@"message"] caseInsensitiveCompare:@"Token DoesN't Matched"] == NSOrderedSame) || ([[responceDict objectForKey:@"message"] caseInsensitiveCompare:@"Invalid Token"] == NSOrderedSame)) {
                    UIStoryboard *mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    UINavigationController *mainContorller = [mainSB instantiateViewControllerWithIdentifier:@"loginNavigation"];
                    [UIApplication sharedApplication].delegate.window.rootViewController = mainContorller;
                } else {
                    
                    [self presentViewController:[UISuporterINApp generateAlert:[responceDict objectForKey:@"message"]] animated:YES completion:nil];
                }
                
            });
        });
    } else{
        
        
        [self presentViewController:[UISuporterINApp generateAlert:@"comfirm password not matched."] animated:YES completion:nil];
    }
}

#pragma mark - UITextField Delegates

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

@end
