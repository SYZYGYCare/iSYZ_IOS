//
//  CheckUserAuthViewController.h
//  Syzygy
//
//  Created by Kamal Gupta on 12/2/17.
//  Copyright © 2017 kamal gupta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckUserAuthViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *PasswordView;
@property (weak, nonatomic) IBOutlet UIView *OTPView;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *OtpTextField;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;


@property (strong, nonatomic) NSString * contact_number;
@property BOOL isOtpView;
- (IBAction)ActionOnForgotPassword:(id)sender;


@end
