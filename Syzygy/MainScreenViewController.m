//
//  MainScreenViewController.m
//  Syzygy
//
//  Created by kamal gupta on 11/29/17.
//  Copyright © 2017 kamal gupta. All rights reserved.
//

#import "MainScreenViewController.h"
#import "SYUserDefault.h"
#import "Constant.h"
#import "FLAnimatedImage.h"
@interface MainScreenViewController ()

@end

@implementation MainScreenViewController{
    int count;
}

- (void)viewDidLoad {
    [super viewDidLoad];
  
    _partnerButton.layer.borderWidth = 2.0;
    _hireButton.layer.borderWidth = 2.0;
    _partnerButton.layer.cornerRadius = 4;
    _hireButton.layer.cornerRadius = 4;
    _partnerButton.layer.borderColor = [UIColor greenColor].CGColor;
    _hireButton.layer.borderColor = [UIColor colorWithRed:0/255.0 green:128/255.0 blue:64/255.0 alpha:1.0].CGColor;
    _partnerButton.layer.borderColor = [UIColor colorWithRed:0/255.0 green:128/255.0 blue:64/255.0 alpha:1.0].CGColor;

    [_hireButton setTitle:@"Hire Your Caregiver" forState:UIControlStateNormal];
   // [_partnerButton setTitle:@"SYZYGY Partner Care Giver" forState:UIControlStateNormal];
    [_partnerButton setTitle:@"Register Caregiver, Ambulance" forState:UIControlStateNormal];

    _partnerButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _partnerButton.titleLabel.numberOfLines = 2;

    count = 0;
    
    CGFloat screenWidth = self.view.frame.size.width;
    CGFloat screenHeight = self.view.frame.size.height;
    
    for (int i = 0; i<4; i++) {
        if (i==0 || i==3) {
            FLAnimatedImage *lightningImage = [[FLAnimatedImage alloc] initWithAnimatedGIFData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"gif%d",i] ofType:@"gif"]]];
            FLAnimatedImageView *sliderImage = [[FLAnimatedImageView alloc]initWithFrame:CGRectMake(i*screenWidth, 0, screenWidth, screenHeight)];
            sliderImage.animatedImage = lightningImage;
            [self.sliderScrollView addSubview:sliderImage];
          //  NSData *data = [NSData dataWithContentsOfURL:[NSURL ur]]
        }else{
            UIImageView *SliderImage = [[UIImageView alloc]initWithFrame:CGRectMake(i*screenWidth, 0, screenWidth, screenHeight)];
            SliderImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"slider_%d", i]];
            [self.sliderScrollView addSubview:SliderImage];
        }
    }
    _sliderScrollView.contentSize = CGSizeMake(screenWidth*4, screenHeight);
   NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:2.0f repeats:YES block:^(NSTimer * _Nonnull timer) {
        
        [UIView transitionWithView:self.view duration:0.0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            
            [_sliderScrollView scrollRectToVisible:CGRectMake(count*screenWidth, 0, screenWidth, screenHeight) animated:NO];
            
            count = count + 1;
            if (count == 4) {
                count = 0;
            }
            
        } completion: nil];
        
    }];
    
//    _sliderImageView.animationImages = [NSArray arrayWithObjects:
//                                         [UIImage imageNamed:@"gif1.gif"],
//                                      /*   [UIImage imageNamed:@"slider_1.png"],
//                                         [UIImage imageNamed:@"slider_2.png"],
//                                         [UIImage imageNamed:@"gif_2.gif"],*/ nil];
//    _sliderImageView.animationDuration = 5.0f;
//    _sliderImageView.animationRepeatCount = 0;
//    [_sliderImageView startAnimating];
   // [self.view addSubview: animatedImageView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)partnerCareButtonTapped:(id)sender {
    
    // User
    
    [[SYUserDefault sharedManager] setUserAuthorityId:@2];
    [self performSegueWithIdentifier:@"moveToLoginSegue" sender:self];
    
}

- (IBAction)HireCareGiverButtonTapped:(id)sender {
    
    // care Giver
    [[SYUserDefault sharedManager] setUserAuthorityId:@1];
    [self performSegueWithIdentifier:@"moveToLoginSegue" sender:self];

}
@end
