//
//  AccountInfoViewController.m
//  Syzygy
//
//  Created by Kamal Gupta on 12/10/17.
//  Copyright © 2017 kamal gupta. All rights reserved.
//

#import "AccountInfoViewController.h"
#import "UISuporterINApp.h"
#import "UserRunningServices.h"
#import "MBProgressHUD.h"
#import "UIView+Toast.h"
#import "SYUserDefault.h"
#import "UserLoginServices.h"
#import "UIView+Toast.h"

@interface AccountInfoViewController ()<UITextFieldDelegate>

@end

@implementation AccountInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor =  [UIColor colorWithPatternImage:[UIImage imageNamed:@"viewBg"]];
    self.title = @"iSYZYGY";
    
    [UISuporterINApp SetTextFieldBorder:_accountNumberTextField withView:self.view];
    [UISuporterINApp SetTextFieldBorder:_ifcCodeTextField withView:self.view];
    [UISuporterINApp SetTextFieldBorder:_AcHolderNameLabel withView:self.view];
    self.AccountInfoView.layer.cornerRadius = 10;
    [self.AccountInfoView.layer setShadowColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.11].CGColor];
    [self.AccountInfoView.layer setShadowOpacity:0.8];
    [self.AccountInfoView.layer setShadowRadius:4.0];
    [self.AccountInfoView.layer setShadowOffset:CGSizeMake(0.0, 2.0)];
    [self getProfileDetail];
    
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


- (IBAction)saveAccountDetails:(id)sender {
    
    [self.view endEditing:YES];
    if ([UISuporterINApp isValidString:_ifcCodeTextField.text] && [UISuporterINApp isValidString:_AcHolderNameLabel.text] &&[UISuporterINApp isValidString:_accountNumberTextField.text]) {
        NSMutableDictionary *parameter = [NSMutableDictionary new];
        [parameter setObject:_ifcCodeTextField.text forKey:@"bank_ifsc_code"];
        [parameter setObject:_AcHolderNameLabel.text forKey:@"ac_holder_name"];
        [parameter setObject:_accountNumberTextField.text forKey:@"bank_account_no"];
        [parameter setObject:[[SYUserDefault sharedManager] getAppToken] forKey:@"token"];
        [self updateProfile:parameter];
    } else {
        [self.view makeToast:@"Enter all field." duration:0.5 position: CSToastPositionCenter];
    }
}

-(void) updateProfile:(NSMutableDictionary *)parameter {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.label.text = NSLocalizedString(@"Please Wait...", @"HUD loading title");
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        
        NSMutableDictionary *responceDict = [UserRunningServices addSomeOne:parameter witServiceName:@"updateProfile"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
            
            if ([[responceDict objectForKey:@"status"] intValue] ==  200) {
                
                [[SYUserDefault sharedManager] setUserName:parameter[@"full_name"]];
                [[SYUserDefault sharedManager] setUserNumber:parameter[@"phone"]];
                
                
                [self.navigationController popViewControllerAnimated:YES];
            }
            
        });
    });
    
}

- (void) getProfileDetail {
    
    
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
                
                [self setUI:[responceDict objectForKey:@"data"]];
                
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

- (void) setUI :(NSMutableDictionary *) profileDetailDict {
    
    if (![profileDetailDict[@"ac_holder_name"] isKindOfClass:[NSNull class]]) {
        _AcHolderNameLabel.text =  profileDetailDict[@"ac_holder_name"];
        _accountHolderName.text =  profileDetailDict[@"ac_holder_name"];
    }
    if (![profileDetailDict[@"bank_account_no"] isKindOfClass:[NSNull class]]) {
        _accountNumberTextField.text =  profileDetailDict[@"bank_account_no"];
        _accountNoLab.text =  profileDetailDict[@"bank_account_no"];
    }
    if (![profileDetailDict[@"bank_ifsc_code"] isKindOfClass:[NSNull class]]) {
        _ifcCodeTextField.text = profileDetailDict[@"bank_ifsc_code"];
        _IfcCodeLab.text = profileDetailDict[@"bank_ifsc_code"];
    }
}

- (IBAction)ActionOnEdit:(id)sender {
    self.AccountInfoView.hidden = YES;
}

#pragma mark - UITextField delegates

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
@end
