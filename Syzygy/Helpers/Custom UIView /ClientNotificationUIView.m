//
//  ClientNotificationUIView.m
//  Syzygy
//
//  Created by Kamal Gupta on 12/24/17.
//  Copyright © 2017 kamal gupta. All rights reserved.
//

#import "ClientNotificationUIView.h"
#import "MBProgressHUD.h"
#import "SYUserDefault.h"
#import "UserRunningServices.h"
#import "Constant.h"
#import "FinishProcessUIView.h"
#import "ChatViewController.h"
@implementation ClientNotificationUIView {
    NSTimer *myTimer;
    
    int isPose;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)drawRect:(CGRect)rect {
    
    self.timerLabel.text = @"0:0";
    if (_isUserView) {
        _userRequestShowView.hidden = NO;
        
        _profileImageView.layer.cornerRadius = _profileImageView.frame.size.height/2;
        _profileImageView.layer.masksToBounds = YES;
        _profileImageView.layer.borderWidth = 1;
        _profileImageView.layer.borderColor = [UIColor blackColor].CGColor;
        if (![_dataNotificationDict[@"profile_pic"] isKindOfClass:[NSNull class]]) {
            
            NSString *url= [NSString stringWithFormat:@"%@%@" , kProfileBaseUrl , _dataNotificationDict[@"profile_pic"]];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                UIImage * img = [UIImage imageWithData:[NSData dataWithContentsOfURL: [NSURL URLWithString:url]]];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    _profileImageView.image = img;
                });
            });
        }
        
        if (![_dataNotificationDict[@"full_name"] isKindOfClass:[NSNull class]]) {
            
            _nameLabel.text = _dataNotificationDict[@"full_name"];
        }
        if (![_dataNotificationDict[@"ratingReview"] isKindOfClass:[NSNull class]]) {
            
            _genderLabel.text = [NSString stringWithFormat:@"%d",[_dataNotificationDict[@"ratingReview"] intValue]];
        }
        
    } else {
        _userRequestShowView.hidden = YES;
    }
    
    if (_isStartTimer) {
        _timerView.hidden = NO;
    }
    
    if (_hideButtons) {
        _buttonView.hidden = YES;
    }
    
    if (_startRide) {
        _ridingLab.hidden = NO;
    }
}

-(void) theAction {
   
    _timerInt += 1;
    double seconds = fmod(_timerInt, 60.0);
    double minutes = fmod(trunc(_timerInt / 60.0), 60.0);
    double hours = trunc(_timerInt / 3600.0);
    self.timerLabel.text = [NSString stringWithFormat:@"%01.0f:%01.0f:%01.0f", hours, minutes, seconds];
    
}

- (NSString *) convertSecondsToMint {
    
    double seconds = fmod(_timerInt, 60.0);
    double minutes = fmod(trunc(_timerInt / 60.0), 60.0);
    double hours = trunc(_timerInt / 3600.0);
    return  [NSString stringWithFormat:@"%01.0f:%01.0f:%01.0f",hours, minutes, seconds];

   // return  [NSString stringWithFormat:@"%02.0f:%02.0f:%02.0f",hours, minutes, seconds];

}


- (IBAction)endButtonTapped:(id)sender {
    [self stopTimer];
    [self endStoping];
    
}

-(void)endTimer{
    [self stopTimer];
   // [self endStoping];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    [self removeFromSuperview];

    FinishProcessUIView *requestNotificationUIView = [[[NSBundle mainBundle] loadNibNamed:@"FinishProcessUIView" owner:self options:nil] objectAtIndex:0];
    
    [requestNotificationUIView setFrame:CGRectMake(0, 0 , screenWidth, screenHeight)];
    requestNotificationUIView.RececitDict = _dataNotificationDict;
    [[UIApplication sharedApplication].keyWindow addSubview:requestNotificationUIView];
}

- (IBAction)startButtonTapped:(id)sender {
    
   
    NSString *titleStr = _acceptButton.titleLabel.text ;
    
    if ([titleStr isEqualToString:@"Start"]) {
        
        [_acceptButton setTitle:@"Pause" forState:UIControlStateNormal];
        _timerInt = 0;
        [self startStopHirning];
        
    } else if([titleStr isEqualToString:@"Pause"]) {
        
        [_acceptButton setTitle:@"Resume" forState:UIControlStateNormal];
        isPose = 2;
         [self stopTimer];
        [self pouseResume];
       
        
    } else if ([titleStr isEqualToString:@"Resume"]) {
        
        [_acceptButton setTitle:@"Pause" forState:UIControlStateNormal];
        isPose = 1;
        [self startTimer];

        [self pouseResume];
    }
}

- (void) startStopHirning {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.label.text = NSLocalizedString(@"Please Wait...", @"HUD loading title");
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        
        NSMutableDictionary *parameter = [NSMutableDictionary new];
        
        [parameter setObject:[[SYUserDefault sharedManager] getAppToken] forKey:@"token"];
        [parameter setObject:[_dataNotificationDict[@"data"] objectForKey:@"client_id"] forKey:@"client_id"];
        [parameter setObject:_dataNotificationDict[@"hire_caregiver_id"] forKey:@"hire_caregiver_id"];
        NSDate * now = [NSDate date];
        NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
        [outputFormatter setDateFormat:@"HH:mm"];
        NSString *newDateString = [outputFormatter stringFromDate:now];
        [parameter setObject:newDateString forKey:@"start_time"];
        
        NSMutableDictionary *responceDict = [UserRunningServices addSomeOne:parameter witServiceName:@"startStopHiringTime"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [hud hideAnimated:YES];
            
            if ([[responceDict objectForKey:@"status"] intValue] ==  200) {
                
                [self startTimer];
            }
            
        });
    });

}


- (void) pouseResume {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.label.text = NSLocalizedString(@"Please Wait...", @"HUD loading title");
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        
        NSMutableDictionary *parameter = [NSMutableDictionary new];
        
        [parameter setObject:[[SYUserDefault sharedManager] getAppToken] forKey:@"token"];
        [parameter setObject:[_dataNotificationDict[@"data"] objectForKey:@"client_id"] forKey:@"client_id"];
        [parameter setObject:_dataNotificationDict[@"hire_caregiver_id"] forKey:@"hire_caregiver_id"];
        
        NSDate * now = [NSDate date];
        NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
        [outputFormatter setDateFormat:@"HH:mm"];
        NSString *newDateString = [outputFormatter stringFromDate:now];
        
        [parameter setObject:[NSNumber numberWithInt:self.timerInt] forKey:@"current_time"];
        [parameter setObject:[NSNumber numberWithInt:isPose] forKey:@"type"];
        
        NSMutableDictionary *responceDict = [UserRunningServices addSomeOne:parameter witServiceName:@"pauseResumeHiringTime"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [hud hideAnimated:YES];
            
            if ([[responceDict objectForKey:@"status"] intValue] ==  200) {
                
            }
            
        });
    });
    
}



- (void) startTimer {
    
    _timerView.hidden = NO;
    myTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                     target:self
                                   selector:@selector(theAction)
                                   userInfo:nil
                                    repeats:YES];
    
}

- (void) stopTimer {
    self.timerLabel.text = [self convertSecondsToMint];

    [myTimer invalidate];
    myTimer = nil;
    
}

- (void) endStoping {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.label.text = NSLocalizedString(@"Please Wait...", @"HUD loading title");
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        
        NSMutableDictionary *parameter = [NSMutableDictionary new];
        
        [parameter setObject:[[SYUserDefault sharedManager] getAppToken] forKey:@"token"];
        if ([[[SYUserDefault sharedManager] getUserAuthorityId] intValue] == USER_TYPE) {
            [parameter setObject:[_dataNotificationDict objectForKey:@"user_id"] forKey:@"client_id"];

        }else
        [parameter setObject:[_dataNotificationDict[@"data"] objectForKey:@"client_id"] forKey:@"client_id"];
        [parameter setObject:_dataNotificationDict[@"hire_caregiver_id"] forKey:@"hire_caregiver_id"];
        
        
        NSDate * now = [NSDate date];
        NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
        [outputFormatter setDateFormat:@"HH:mm"];
        NSString *newDateString = [outputFormatter stringFromDate:now];
        
        [parameter setObject:newDateString forKey:@"stop_time"];
        
        [parameter setObject:@"1" forKey:@"type"];
        [parameter setObject:[NSNumber numberWithFloat:_timerInt/60] forKey:@"total_time"];

        
        NSMutableDictionary *responceDict = [UserRunningServices addSomeOne:parameter witServiceName:@"startStopHiringTime"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [hud hideAnimated:YES];
            
            if ([[responceDict objectForKey:@"status"] intValue] ==  200) {
                
                CGRect screenRect = [[UIScreen mainScreen] bounds];
                CGFloat screenWidth = screenRect.size.width;
                CGFloat screenHeight = screenRect.size.height;
                FinishProcessUIView *requestNotificationUIView = [[[NSBundle mainBundle] loadNibNamed:@"FinishProcessUIView" owner:self options:nil] objectAtIndex:0];
                
                [requestNotificationUIView setFrame:CGRectMake(0, 0 , screenWidth, screenHeight)];
                requestNotificationUIView.RececitDict = [responceDict objectForKey:@"data"];
                [[UIApplication sharedApplication].keyWindow addSubview:requestNotificationUIView];
                [self removeFromSuperview];
            }
            
        });
    });

}


- (IBAction)cancelButtonTapped:(id)sender {
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"cancelRequest"
     object:_dataNotificationDict];

}

-(void)cancelRequestAPI{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    
    hud.label.text = NSLocalizedString(@"Please Wait...", @"HUD loading title");
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        
        NSMutableDictionary *parameter = [NSMutableDictionary new];
        
        [parameter setObject:[[SYUserDefault sharedManager] getAppToken] forKey:@"token"];
        [parameter setObject:[_dataNotificationDict objectForKey:@"caregiver_id"] forKey:@"reciever_id"];
        [parameter setObject:[_dataNotificationDict objectForKey:@"hire_caregiver_id"] forKey:@"hire_caregiver_id"];

        [parameter setObject:@"caregiver" forKey:@"reciever_type"];
        
        NSMutableDictionary *responceDict = [UserRunningServices addSomeOne:parameter witServiceName:@"cancel_request"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [hud hideAnimated:YES];
            
            if ([[responceDict objectForKey:@"status"] intValue] ==  200) {
                
                [self removeFromSuperview];
            }
        });
    });
}

- (IBAction)chatButtonTapped:(id)sender {
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"startChat"
     object:_dataNotificationDict];

//    ChatViewController *requestNotificationUIView = [[ChatViewController alloc]initWithNibName:@"ChatViewController" bundle:nil];
//
//    [requestNotificationUIView.view setFrame:CGRectMake(0, 0 , screenWidth, screenHeight)];
//    requestNotificationUIView.requestDic = _dataNotificationDict;
//
//    self.alertWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
//     self.alertWindow.rootViewController = requestNotificationUIView;
//     self.alertWindow.windowLevel = UIWindowLevelAlert + 1;
//     [self.alertWindow makeKeyAndVisible];
//     [self.alertWindow.rootViewController presentViewController:requestNotificationUIView animated:YES completion:nil];
//    chatView *requestNotificationUIView = [[[NSBundle mainBundle] loadNibNamed:@"chatView" owner:self options:nil] objectAtIndex:0];
//
//    [requestNotificationUIView setFrame:CGRectMake(0, 0 , screenWidth, screenHeight)];
//    requestNotificationUIView.requestDic = _dataNotificationDict;
//    [[UIApplication sharedApplication].keyWindow addSubview:requestNotificationUIView];
   
  //  [[UIApplication sharedApplication].keyWindow addSubview:requestNotificationUIView.view];
}

- (IBAction)callButtonTapped:(id)sender {
    NSString *telStr = [NSString stringWithFormat:@"tel:+%@",[_dataNotificationDict objectForKey:@"phone"]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telStr]];
}
-(void)showWaitingView{
    self.waitingView.hidden = NO;
    self.buttonView.hidden = YES;
//    

}

- (void)showUserRequestView {
    
    self.userRequestShowView.hidden = NO;
    self.waitingView.hidden = YES;
    self.buttonView.hidden = YES;
}


-(void)removeWaitingView{
    self.waitingView.hidden = YES;
}

-(void)showRequestConfirmViewClientWithData:(NSDictionary*)response{
    self.waitingView.hidden = NO;
}
-(void)removeRequestConfirmView{
    self.waitingView.hidden = YES;
}


@end
