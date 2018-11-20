//
//  HiresListTableViewCell.h
//  Syzygy
//
//  Created by Kamal Gupta on 12/10/17.
//  Copyright © 2017 kamal gupta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCSStarRatingView.h"

@interface HiresListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet HCSStarRatingView *ratingReview;
@property (weak, nonatomic) IBOutlet UILabel *hireServiceId;
@property (weak, nonatomic) IBOutlet UIView *backView;

@end
