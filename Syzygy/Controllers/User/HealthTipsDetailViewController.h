//
//  HealthTipsDetailViewController.h
//  Syzygy
//
//  Created by Kamal Gupta on 12/15/17.
//  Copyright © 2017 kamal gupta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HealthTipsDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *healthTipsDetailTableView;


@property(strong , nonatomic) NSString * sub_category_id;

@end
