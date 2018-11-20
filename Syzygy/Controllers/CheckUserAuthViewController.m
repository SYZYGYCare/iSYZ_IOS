//
//  CheckUserAuthViewController.m
//  Syzygy
//
//  Created by Kamal Gupta on 12/2/17.
//  Copyright © 2017 kamal gupta. All rights reserved.
//

#import "CheckUserAuthViewController.h"
#import "MFSideMenu.h"
#import "MBProgressHUD.h"
#import "UserLoginServices.h"
#import "SYUserDefault.h"
#import "RegistrationViewController.h"
#import "UISuporterINApp.h"
#import "Constant.h"
#import "ForgetPasswordViewController.h"

@interface CheckUserAuthViewController ()
- (IBAction)checkAuthButtonTapped:(id)sender;

@end

@implementation CheckUserAuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _PasswordView.hidden = YES;
    self.view.backgroundColor =  [UIColor colorWithPatternImage:[UIImage imageNamed:@"viewBg"]];
    [UISuporterINApp SetTextFieldBorder:_OtpTextField  withView:self.view];
    [UISuporterINApp SetTextFieldBorder:_passwordTextField withView:self.view];
    [self setupRightViewHidePasswordForField:_OtpTextField withTag:1];
    [self setupRightViewHidePasswordForField:_passwordTextField withTag:2];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (_isOtpView) {
        _OTPView.hidden = NO;
        _PasswordView.hidden = YES;
    } else {
        
        _OTPView.hidden = YES;
        _PasswordView.hidden = NO;
    }
    
    if ([[[SYUserDefault sharedManager] getUserAuthorityId] intValue] == USER_TYPE) {
        
        _nextButton.backgroundColor = USER_COLOR;
    } else {
        
        _nextButton.backgroundColor = CAREGIVER_COLOR;
        
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"forgotPassword"]) {
        ForgetPasswordViewController *forgotPass = [segue destinationViewController];
        forgotPass.contactNumber = _contact_number;
    }else{
    RegistrationViewController *registratiionVC = [segue destinationViewController];
        registratiionVC.contact_number = _contact_number;
    }
}


- (IBAction)checkAuthButtonTapped:(id)sender {
    
    if (_isOtpView) {
        
        [self checkOTPMatchedOrNot];
    } else {
        [self login];
    }
    
}

- (void) login {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.label.text = NSLocalizedString(@"Please Wait...", @"HUD loading title");
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        
        NSMutableDictionary *parameter = [NSMutableDictionary new];
        
        [parameter setObject:[NSString stringWithFormat:@"%@" , _passwordTextField.text] forKey:@"password"];
        [parameter setObject:_contact_number forKey:@"user_name"];
        [parameter setObject: [[SYUserDefault sharedManager] getUserAuthorityId] forKey:@"authority_id"];
        [parameter setObject: [[SYUserDefault sharedManager] getDeviceTokenForNotification] forKey:@"fcm_id"];
        [parameter setObject: @"2" forKey:@"device_type"];


        
        NSLog(@"Parameter : %@" , parameter);
        NSMutableDictionary *responceDict = [UserLoginServices userLogin:parameter];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
            
            
            NSLog(@"%@" , responceDict);
            
            if ([[responceDict objectForKey:@"message"] isEqualToString:@"success"]) {
                
                [[SYUserDefault sharedManager] setAppToken:[[responceDict objectForKey:@"Token"] objectForKey:@"token"]];
                [[SYUserDefault sharedManager] setCareGiverType:[[responceDict objectForKey:@"Token"] objectForKey:@"caregiver_type"]];
                [self getProfileDetail];
            }else if (([[responceDict objectForKey:@"message"] caseInsensitiveCompare:@"Token DoesN't Matched"] == NSOrderedSame) || ([[responceDict objectForKey:@"message"] caseInsensitiveCompare:@"Invalid Token"] == NSOrderedSame)) {
                UIStoryboard *mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                UINavigationController *mainContorller = [mainSB instantiateViewControllerWithIdentifier:@"loginNavigation"];
                [UIApplication sharedApplication].delegate.window.rootViewController = mainContorller;
            } else {
                
                [self presentViewController:[UISuporterINApp generateAlert:[responceDict objectForKey:@"message"]] animated:YES completion:nil];
            }
            
        });
    });
    
}

- (void)getProfileDetail {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.label.text = NSLocalizedString(@"Please Wait...", @"HUD loading title");
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        
        NSMutableDictionary *parameter = [NSMutableDictionary new];
        
        [parameter setObject:[[SYUserDefault sharedManager] getAppToken] forKey:@"token"];
        [parameter setObject: [[SYUserDefault sharedManager] getUserAuthorityId] forKey:@"authority_id"];
        
        NSLog(@"Parameter : %@" , parameter);
        NSMutableDictionary *responceDict = [UserLoginServices userDetail:parameter];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
            
            NSLog(@"%@" , responceDict);
            
            if ([[responceDict objectForKey:@"message"] isEqualToString:@"sucess"]) {
                [[SYUserDefault sharedManager] setUserLogging:@YES];
                [[SYUserDefault sharedManager] setUserName:[[responceDict objectForKey:@"data"] objectForKey:@"full_name"]];
                [[SYUserDefault sharedManager] setUserNumber:_contact_number];
                [[SYUserDefault sharedManager] setProfilePic:[[responceDict objectForKey:@"data"] objectForKey:@"profile_pic"]];
                [self moveTOMainPage];
            } else {
                [self presentViewController:[UISuporterINApp generateAlert:[responceDict objectForKey:@"message"]] animated:YES completion:nil];
            }
        });
    });
}

-(void) checkOTPMatchedOrNot {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.label.text = NSLocalizedString(@"Loading...", @"HUD loading title");
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        
        NSMutableDictionary *parameter = [NSMutableDictionary new];
        
        [parameter setObject:[NSString stringWithFormat:@"%@" , _OtpTextField.text] forKey:@"otp"];
        [parameter setObject:_contact_number forKey:@"contact_no"];
        [parameter setObject:_OtpTextField.text forKey:@"otp"];

        NSLog(@"Parameter : %@" , parameter);
        NSMutableDictionary *responceDict = [UserLoginServices matchOTP:parameter];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
            
            
            NSLog(@"%@" , responceDict);
            
            if ([[responceDict objectForKey:@"message"] isEqualToString:@"success"]) {
                [[SYUserDefault sharedManager] setAppToken:[responceDict objectForKey:@"token"]];
                 [self performSegueWithIdentifier:@"registrationSegue" sender:self];
            }else if (([[responceDict objectForKey:@"message"] caseInsensitiveCompare:@"Token DoesN't Matched"] == NSOrderedSame) || ([[responceDict objectForKey:@"message"] caseInsensitiveCompare:@"Invalid Token"] == NSOrderedSame)) {
                UIStoryboard *mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                UINavigationController *mainContorller = [mainSB instantiateViewControllerWithIdentifier:@"loginNavigation"];
                [UIApplication sharedApplication].delegate.window.rootViewController = mainContorller;
            } else {
                
                [self presentViewController:[UISuporterINApp generateAlert:[responceDict objectForKey:@"message"]] animated:YES completion:nil];
            }
            
        });
    });

    
}

- (void) moveTOMainPage {
    
    UIStoryboard *mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *mainContorller = [mainSB instantiateViewControllerWithIdentifier:@"mainNavigation"];
    
    UIViewController *leftSideMenuViewController = [mainSB instantiateViewControllerWithIdentifier:@"leftSideMenuViewController"];
    
    
    MFSideMenuContainerViewController *container = [MFSideMenuContainerViewController containerWithCenterViewController:mainContorller leftMenuViewController:leftSideMenuViewController rightMenuViewController:nil];
    
    [[UIApplication sharedApplication] .keyWindow setRootViewController:container];
}


- (IBAction)ActionOnForgotPassword:(id)sender {
    [self performSegueWithIdentifier:@"forgotPassword" sender:self];
}

-(void)setupRightViewHidePasswordForField:(UITextField*)textField withTag:(NSInteger)butonTag{
    UIButton *firstFieldButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [firstFieldButton setImage:[UIImage imageNamed:@"view"] forState:UIControlStateNormal];
    [firstFieldButton setImage:[UIImage imageNamed:@"hide"] forState:UIControlStateSelected];
    
    [firstFieldButton addTarget:self action:@selector(actionOnViewButton:) forControlEvents:UIControlEventTouchUpInside];
    firstFieldButton.tag = butonTag;
    UIView *LView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    firstFieldButton.frame = CGRectMake(5, 5, 50, 40);
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
                _OtpTextField.secureTextEntry = NO;
            }else{
                _OtpTextField.secureTextEntry = YES;
            }
            break;
        case 2:
            if (button.isSelected) {
                _passwordTextField.secureTextEntry = NO;
            }else{
                _passwordTextField.secureTextEntry = YES;
            }
            break;
        
        default:
            break;
    }
}
@end
