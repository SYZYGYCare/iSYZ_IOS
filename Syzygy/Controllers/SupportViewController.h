//
//  SupportViewController.h
//  Syzygy
//
//  Created by manisha panse on 2/14/18.
//  Copyright © 2018 kamal gupta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SAMTextView.h"
@interface SupportViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *HireServiceId;
@property (weak, nonatomic) IBOutlet UITextField *HourReported;
@property (weak, nonatomic) IBOutlet UITextField *HourActual;
@property (weak, nonatomic) IBOutlet SAMTextView *reason;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
- (IBAction)addClaim:(id)sender;
@end
