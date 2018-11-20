//
//  EmergencyContactViewController.h
//  Syzygy
//
//  Created by Kamal Gupta on 12/15/17.
//  Copyright © 2017 kamal gupta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmergencyContactViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *emergencyContactNumberTextField;
- (IBAction)addContactButtonTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *emergencyContectTableView;
- (IBAction)ActionEmergencyDelete:(id)sender;

@end
