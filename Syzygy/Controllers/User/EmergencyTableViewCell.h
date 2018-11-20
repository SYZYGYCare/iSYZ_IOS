//
//  EmergencyTableViewCell.h
//  Syzygy
//
//  Created by manisha panse on 2/13/18.
//  Copyright © 2018 kamal gupta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmergencyTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *emergencyBackView;
@property (weak, nonatomic) IBOutlet UILabel *contactLab;
@property (weak, nonatomic) IBOutlet UIButton *emergencyDelete;
@property (weak, nonatomic) IBOutlet UIImageView *telephoneimage;

@end
