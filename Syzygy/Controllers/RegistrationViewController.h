//
//  RegistrationViewController.h
//  Syzygy
//
//  Created by Kamal Gupta on 12/8/17.
//  Copyright © 2017 kamal gupta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegistrationViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *fullNameTextField;

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

- (IBAction)sabmitButtonTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@property (strong , nonatomic) NSString * contact_number;

@end
