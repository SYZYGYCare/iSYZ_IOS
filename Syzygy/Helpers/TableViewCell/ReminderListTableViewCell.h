//
//  ReminderListTableViewCell.h
//  Syzygy
//
//  Created by Kamal Gupta on 12/24/17.
//  Copyright © 2017 kamal gupta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReminderListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UILabel *reminderForLabel;
@property (weak, nonatomic) IBOutlet UILabel *requiredCareLabel;
@property (weak, nonatomic) IBOutlet UILabel *anyTypeLabel;


@end
