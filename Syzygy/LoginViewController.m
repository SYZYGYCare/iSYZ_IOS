//
//  LoginViewController.m
//  Syzygy
//
//  Created by kamal gupta on 11/29/17.
//  Copyright © 2017 kamal gupta. All rights reserved.
//

#import "LoginViewController.h"
#import "MBProgressHUD.h"
#import "UserLoginServices.h"
#import "CheckUserAuthViewController.h"
#import "UISuporterINApp.h"
#import "SYUserDefault.h"
#import "Constant.h"
#import "CountryView.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *mobileNumberTextField;
@property (weak, nonatomic) IBOutlet UIImageView *flagImg;

@end

@implementation LoginViewController {
    BOOL isOtpView ;
    NSString *dialCode;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =  [UIColor colorWithPatternImage:[UIImage imageNamed:@"viewBg"]];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [UISuporterINApp SetTextFieldBorder:_mobileNumberTextField withView:self.view];
    
    if ([[[SYUserDefault sharedManager] getUserAuthorityId] intValue] == USER_TYPE) {
        
        self.navigationController.navigationBar.barTintColor = USER_COLOR;
        _nextButton.backgroundColor = USER_COLOR;
    } else {
        
        self.navigationController.navigationBar.barTintColor = CAREGIVER_COLOR;
        _nextButton.backgroundColor = CAREGIVER_COLOR;

    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actionOnCountryLab)];
    self.countryCodeLab.userInteractionEnabled = YES;
    [self.countryCodeLab addGestureRecognizer:tap];
    dialCode = @"+91";
    self.countryCodeLab.text = [NSString stringWithFormat:@"(IN) +91"];

    /*[[NSNotificationCenter defaultCenter]
     postNotificationName:@"country_selected"
     object:[self.searchedArr objectAtIndex:indexPath.row]]*/
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didSelectCountryFromPicker:)
                                                 name:@"country_selected"
                                               object:nil];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.mobileNumberTextField.text = @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    CheckUserAuthViewController *checkUserAuthVC = segue.destinationViewController;
    checkUserAuthVC.contact_number = [NSString stringWithFormat:@"%@%@",[dialCode stringByReplacingOccurrencesOfString:@"+" withString:@""],_mobileNumberTextField.text];
    checkUserAuthVC.isOtpView = isOtpView;
    
}

- (void) generateOTP {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = NSLocalizedString(@"Loading...", @"HUD loading title");
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        NSMutableDictionary *parameter = [NSMutableDictionary new];
        [parameter setObject:[NSString stringWithFormat:@"%@%@",[dialCode stringByReplacingOccurrencesOfString:@"+" withString:@""],_mobileNumberTextField.text] forKey:@"contact_no"];
        NSMutableDictionary *responceDict = [UserLoginServices generateOTPByUser:parameter];
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
            NSLog(@"%@" , responceDict);
            if ([[responceDict objectForKey:@"message"] isEqualToString:@"success"]) {
                isOtpView = YES;
                [self performSegueWithIdentifier:@"PasswordSegue" sender:self];
            } else if ([[responceDict objectForKey:@"message"] isEqualToString:@"user already registered"]) {
                isOtpView = NO;
                [self performSegueWithIdentifier:@"PasswordSegue" sender:self];
            } else {
                [self presentViewController:[UISuporterINApp generateAlert:@"Something Wrong"] animated:YES completion:nil];            }
        });
    });
}


- (IBAction)nextButtonTapped:(id)sender {
    [self.view endEditing:YES];
    NSString *mobileNumber = _mobileNumberTextField.text;
    if ([mobileNumber length] == 10) {
        [self generateOTP];
    } else {
        
        [self presentViewController:[UISuporterINApp generateAlert:@"Enter Mobile Number"] animated:YES completion:nil];

    }
    
    
}
-(void)actionOnCountryLab{
    CountryView *countryPicker = [[[NSBundle mainBundle] loadNibNamed:@"CountryView" owner:self options:nil] objectAtIndex:0];
    
    [countryPicker setFrame:CGRectMake(0, 0 , self.view.frame.size.width, self.view.frame.size.height)];
    [[UIApplication sharedApplication].keyWindow addSubview:countryPicker];
   // [self.view addSubview:countryPicker];

}

-(void)didSelectCountryFromPicker:(NSNotification*)notifcation{
    NSDictionary *object = notifcation.object;
    self.countryCodeLab.text = [NSString stringWithFormat:@"(%@) %@",[object objectForKey:@"code"],[object objectForKey:@"dial_code"]];
    dialCode = [object objectForKey:@"dial_code"];
    self.flagImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",[[object objectForKey:@"code"] lowercaseString]]];
}
@end
