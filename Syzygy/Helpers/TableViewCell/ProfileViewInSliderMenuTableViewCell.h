//
//  ProfileViewInSliderMenuTableViewCell.h
//  Syzygy
//
//  Created by kamal gupta on 12/2/17.
//  Copyright © 2017 kamal gupta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileViewInSliderMenuTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *mobileNumberLabel;
@property (weak, nonatomic) IBOutlet UIButton *editProfileButton;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *lineLab;

@end
