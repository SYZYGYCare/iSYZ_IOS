//
//  ProfileViewController.h
//  Syzygy
//
//  Created by Kamal Gupta on 12/2/17.
//  Copyright © 2017 kamal gupta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *mobileTextField;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@property (weak, nonatomic) IBOutlet UITextField *aadharNumberTextField;
@property (weak, nonatomic) IBOutlet UIButton *maleButton;
@property (weak, nonatomic) IBOutlet UIButton *femaleButton;
@property (weak, nonatomic) IBOutlet UIView *profileImageBackView;


@property (weak, nonatomic) IBOutlet UIButton *saveButton;
- (IBAction)saveButtonTapped:(id)sender;
- (IBAction)genderButtonTapped:(id)sender;

@end
