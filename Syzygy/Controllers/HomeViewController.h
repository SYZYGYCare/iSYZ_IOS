//
//  HomeViewController.h
//  Syzygy
//
//  Created by kamal gupta on 12/1/17.
//  Copyright © 2017 kamal gupta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopupForBookCareGiver.h"

@interface HomeViewController : UIViewController <ReturnToAddServiceDelegate>
{
    NSString *hire_caregiver_id;
    NSString *strBookingStatus;
    NSDictionary *dictBookingStatus;
}
@property (weak, nonatomic) IBOutlet UIView *Loctionview;
@property (weak, nonatomic) IBOutlet UICollectionView *careGiverCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *minimumChargeLabel;
@property (weak, nonatomic) IBOutlet UITextField *Searchtextfiled;
@property (weak, nonatomic) IBOutlet UIButton *ambulanceButton;
@property (weak, nonatomic) IBOutlet UIButton *careGiverButton;
@property (weak, nonatomic) IBOutlet UIView *mapView;
- (IBAction)ambulanceButtonTapped:(id)sender;
- (IBAction)careGiverButtonTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *confirmHireView;
@property (weak, nonatomic) IBOutlet UIButton *laterButtonTapped;
- (IBAction)hireNowButtonTapped:(id)sender;
- (IBAction)laterButtonTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *reConfirmHireView;
- (IBAction)finalConfirmButtonTapped:(id)sender;
- (IBAction)ActionOnFav:(id)sender;

@property (strong, nonatomic) IBOutlet UIView *datePickerView;
@property (weak, nonatomic) IBOutlet UIDatePicker *dtPicker;
- (IBAction)ActionOnDone:(id)sender;

@end
