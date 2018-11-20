//
//  CareGiverListCollectionViewCell.h
//  Syzygy
//
//  Created by Kamal Gupta on 12/2/17.
//  Copyright © 2017 kamal gupta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CareGiverListCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIView *careView;

@property (weak, nonatomic) IBOutlet UIImageView *collectionImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end
