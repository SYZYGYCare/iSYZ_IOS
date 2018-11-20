//
//  AccountInfoViewController.h
//  Syzygy
//
//  Created by Kamal Gupta on 12/10/17.
//  Copyright © 2017 kamal gupta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountInfoViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *AcHolderNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *ifcCodeTextField;
@property (weak, nonatomic) IBOutlet UIView *AccountInfoView;
@property (weak, nonatomic) IBOutlet UILabel *accountHolderName;
@property (weak, nonatomic) IBOutlet UILabel *IfcCodeLab;
@property (weak, nonatomic) IBOutlet UILabel *accountNoLab;

@property (weak, nonatomic) IBOutlet UITextField *accountNumberTextField;
- (IBAction)ActionOnEdit:(id)sender;


@end
