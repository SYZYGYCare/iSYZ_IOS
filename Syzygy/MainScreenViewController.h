//
//  MainScreenViewController.h
//  Syzygy
//
//  Created by kamal gupta on 11/29/17.
//  Copyright © 2017 kamal gupta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLAnimatedImageView.h"

@interface MainScreenViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *partnerButton;
@property (weak, nonatomic) IBOutlet UIButton *hireButton;
@property (weak, nonatomic) IBOutlet FLAnimatedImageView *sliderImageView;
@property (weak, nonatomic) IBOutlet UIScrollView *sliderScrollView;

- (IBAction)partnerCareButtonTapped:(id)sender;
- (IBAction)HireCareGiverButtonTapped:(id)sender;

@end
