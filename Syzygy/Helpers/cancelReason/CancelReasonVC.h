//
//  CancelReasonVC.h
//  Syzygy
//
//  Created by manisha panse on 2/24/18.
//  Copyright © 2018 kamal gupta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CancelReasonVC : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *cancelReasonTable;
@property (weak, nonatomic) IBOutlet UITextField *anyReasonTF;
@property (weak, nonatomic) IBOutlet UIButton *dontCancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIView *cancelView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHieght;
@property (strong, nonatomic) NSDictionary *requestDic;
- (IBAction)ActionOnDontCancel:(id)sender;
- (IBAction)ActionOnCancelHire:(id)sender;
-(void)setupInitialViews;
@end
