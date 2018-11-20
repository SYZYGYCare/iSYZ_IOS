//
//  ForgetPasswordViewController.h
//  Syzygy
//
//  Created by manisha panse on 4/25/18.
//  Copyright © 2018 kamal gupta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgetPasswordViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *mobileTF;
@property (weak, nonatomic) IBOutlet UITextField *otpTF;
@property (weak, nonatomic) IBOutlet UIImageView *otpImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *forgetViewHeight;
@property (assign) NSString *contactNumber;
@property (weak, nonatomic) IBOutlet UIButton *OTPButton;
@property (weak, nonatomic) IBOutlet UIView *changePasswordView;
@property (weak, nonatomic) IBOutlet UITextField *cMobileTf;
@property (weak, nonatomic) IBOutlet UITextField *NewPassword;
@property (weak, nonatomic) IBOutlet UITextField *confirmPassword;
@property (weak, nonatomic) IBOutlet UIView *forgotView;

- (IBAction)ActionOnGetOTP:(id)sender;
- (IBAction)ActionOnSave:(id)sender;

@end
