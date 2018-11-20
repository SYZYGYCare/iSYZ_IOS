//
//  RegistrationViewController.m
//  Syzygy
//
//  Created by Kamal Gupta on 12/8/17.
//  Copyright © 2017 kamal gupta. All rights reserved.
//

#import "RegistrationViewController.h"
#import "UISuporterINApp.h"
#import "MBProgressHUD.h"
#import "UserLoginServices.h"
#import "SYUserDefault.h"
#import "MFSideMenu.h"
#import "Constant.h"


@interface RegistrationViewController ()

@end

@implementation RegistrationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor =  [UIColor colorWithPatternImage:[UIImage imageNamed:@"viewBg"]];
    self.title = @"Regstartion";
    [UISuporterINApp SetTextFieldBorder:_fullNameTextField withView:self.view];
    [UISuporterINApp SetTextFieldBorder:_emailTextField withView:self.view];
    [UISuporterINApp SetTextFieldBorder:_passwordTextField withView:self.view];
    
    // Do any additional setup after loading the view.
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([[[SYUserDefault sharedManager] getUserAuthorityId] intValue] == USER_TYPE) {
        
        _submitButton.backgroundColor = USER_COLOR;
    } else {
        
        _submitButton.backgroundColor = CAREGIVER_COLOR;
        
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

- (IBAction)sabmitButtonTapped:(id)sender {
    
    [self registrationProcess];
}

- (void) registrationProcess {
    
    BOOL validation = true;
    
    if ([_emailTextField.text isEqualToString:@""]) {
        validation = false;
    }
    if ([_fullNameTextField.text isEqualToString:@""]) {
        validation = false;
    }
    if ([_passwordTextField.text isEqualToString:@""]) {
        validation = false;
    }
    
    if (validation) {
        [self sendDataToServerForRegistarion];
    } else {
        
        [self presentViewController:[UISuporterINApp generateAlert:@"All field are Mandatory."] animated:YES completion:nil];
    }
    
    
}

- (void) sendDataToServerForRegistarion {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.label.text = NSLocalizedString(@"Please Wait...", @"HUD loading title");
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        
        NSMutableDictionary *parameter = [NSMutableDictionary new];
        
        [parameter setObject:_fullNameTextField.text forKey:@"full_name"];
        [parameter setObject:_emailTextField.text forKey:@"email_id"];
        [parameter setObject:_passwordTextField.text forKey:@"password"];
        [parameter setObject: [[SYUserDefault sharedManager] getUserAuthorityId] forKey:@"authority_id"];
        [parameter setObject:_contact_number forKey:@"contact_no"];
        [parameter setObject: [[SYUserDefault sharedManager] getDeviceTokenForNotification] forKey:@"fcm_id"];
        [parameter setObject: @"2" forKey:@"device_type"];
        
        
        NSMutableDictionary *responceDict = [UserLoginServices userRegistartion:parameter];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
            
            if ([[responceDict objectForKey:@"status"] intValue] == 200) {
                
                [[SYUserDefault sharedManager] setAppToken:[[responceDict objectForKey:@"data"] objectForKey:@"token"]];
                [[SYUserDefault sharedManager] setUserLogging:@YES];
                [self moveTOMainPage];
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

@end
