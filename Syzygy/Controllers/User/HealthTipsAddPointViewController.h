//
//  HealthTipsAddPointViewController.h
//  Syzygy
//
//  Created by Kamal Gupta on 12/16/17.
//  Copyright © 2017 kamal gupta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HealthTipsAddPointViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *heathImage;
@property (weak, nonatomic) IBOutlet UITableView *healthPointTableView;

@property (strong, nonatomic) NSMutableDictionary * subCoCatagoryDict;

- (IBAction)addPointForHealth:(id)sender;


@end
