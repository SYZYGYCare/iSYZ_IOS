//
//  HiresListTableViewCell.m
//  Syzygy
//
//  Created by Kamal Gupta on 12/10/17.
//  Copyright © 2017 kamal gupta. All rights reserved.
//

#import "HiresListTableViewCell.h"

@implementation HiresListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backView.layer.cornerRadius = 10;
    [self.backView.layer setShadowColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.11].CGColor];
    [self.backView.layer setShadowOpacity:0.8];
    [self.backView.layer setShadowRadius:4.0];
    [self.backView.layer setShadowOffset:CGSizeMake(0.0, 2.0)];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
