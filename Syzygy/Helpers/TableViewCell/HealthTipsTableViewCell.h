//
//  HealthTipsTableViewCell.h
//  Syzygy
//
//  Created by Kamal Gupta on 12/16/17.
//  Copyright © 2017 kamal gupta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HealthTipsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *healthTipsImageView;
@property (weak, nonatomic) IBOutlet UILabel *healthTipsLabel;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIView *emergencyBackView;

@end
