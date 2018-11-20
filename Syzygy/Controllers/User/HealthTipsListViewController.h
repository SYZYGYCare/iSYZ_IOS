//
//  HealthTipsListViewController.h
//  Syzygy
//
//  Created by Kamal Gupta on 12/15/17.
//  Copyright © 2017 kamal gupta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HealthTipsListViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *healthTipsTableView;

@property BOOL isReminder;
@property BOOL isToDo;

@end
