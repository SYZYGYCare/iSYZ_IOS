//
//  ChangePasswordViewController.h
//  Syzygy
//
//  Created by Kamal Gupta on 12/2/17.
//  Copyright © 2017 kamal gupta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangePasswordViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *currentPasswordTextField;

@property (weak, nonatomic) IBOutlet UITextField *passwordTextFeild;

@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTextFeild;

- (IBAction)changePasswordButtonTapped:(id)sender;

@end
