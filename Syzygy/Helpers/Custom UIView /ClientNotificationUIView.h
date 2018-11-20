//
//  ClientNotificationUIView.h
//  Syzygy
//
//  Created by Kamal Gupta on 12/24/17.
//  Copyright © 2017 kamal gupta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClientNotificationUIView : UIView

@property (weak, nonatomic) IBOutlet UIView *timerView;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (weak, nonatomic) IBOutlet UIButton *denyButton;
@property (weak, nonatomic) IBOutlet UIButton *acceptButton;
@property (weak, nonatomic) IBOutlet UIView *buttonView;
@property (weak, nonatomic) IBOutlet UIView *waitingView;

- (IBAction)endButtonTapped:(id)sender;
- (IBAction)startButtonTapped:(id)sender;

@property (strong, nonatomic) NSMutableDictionary *dataNotificationDict;

@property (weak, nonatomic) IBOutlet UIView *userRequestShowView;

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *genderLabel;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

- (IBAction)cancelButtonTapped:(id)sender;
- (IBAction)chatButtonTapped:(id)sender;
- (IBAction)callButtonTapped:(id)sender;


- (void) stopTimer;
- (void) startTimer;
-(void)endTimer;

@property    int timerInt;

@property BOOL isUserView;
@property BOOL hideButtons;
@property BOOL isStartTimer;
@property BOOL startRide;

- (void)showUserRequestView;
-(void)showWaitingView;
-(void)removeWaitingView;
@property (weak, nonatomic) IBOutlet UILabel *ridingLab;

@end
