//
//  LoginViewController.h
//  Syzygy
//
//  Created by kamal gupta on 11/29/17.
//  Copyright © 2017 kamal gupta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *mobileNumberView;

@property (weak, nonatomic) IBOutlet UIView *passwordView;
@property (weak, nonatomic) IBOutlet UILabel *countryCodeLab;


- (IBAction)nextButtonTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;


@end
