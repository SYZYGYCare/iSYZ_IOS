//
//  RequestNotificationUIView.h
//  Syzygy
//
//  Created by Kamal Gupta on 12/30/17.
//  Copyright © 2017 kamal gupta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RequestNotificationUIView : UIView
@property (weak, nonatomic) IBOutlet UIView *requestView;
@property (weak, nonatomic) IBOutlet UIImageView *requestedImageView;
@property (weak, nonatomic) IBOutlet UILabel *requestNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *requestedGenderLabel;
- (IBAction)denyBtnTapped:(id)sender;

- (IBAction)acceptedBtnTapped:(id)sender;


@property (weak, nonatomic) IBOutlet UIView *acceptView;
@property (weak, nonatomic) IBOutlet UIImageView *acceptedImageView;
@property (weak, nonatomic) IBOutlet UILabel *acceptedNameLabell;
@property (weak, nonatomic) IBOutlet UILabel *acceptedGenderLabel;
- (IBAction)callBtnTapped:(id)sender;

- (IBAction)chatBtnTapped:(id)sender;
- (IBAction)cancelBtnTapped:(id)sender;
- (IBAction)startBtnTapped:(id)sender;


@property (strong,nonatomic) NSMutableDictionary *requestDataDict;
@property (strong,nonatomic) NSString *cancelnoti;

@property (weak, nonatomic) IBOutlet UIView *EndRideView;
- (IBAction)ActionOnEndRide:(id)sender;


@end
