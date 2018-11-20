//
//  ReferEarnViewController.h
//  Syzygy
//
//  Created by manisha panse on 1/14/18.
//  Copyright © 2018 kamal gupta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReferEarnViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *walletAmount;
@property (weak, nonatomic) IBOutlet UILabel *referCode;
@property (weak, nonatomic) IBOutlet UITextField *EnterCodeTF;
- (IBAction)ActiononInvitefreands:(id)sender;
- (IBAction)ActiononGo:(id)sender;

@end
