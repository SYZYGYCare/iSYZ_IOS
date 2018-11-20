//
//  CareGiverHiresViewController.h
//  Syzygy
//
//  Created by Kamal Gupta on 12/10/17.
//  Copyright © 2017 kamal gupta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CareGiverHiresViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UITableView *hireListTAbleView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableTopHeight;

@end
