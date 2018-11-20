//
//  RequestNotificationUIView.m
//  Syzygy
//
//  Created by Kamal Gupta on 12/30/17.
//  Copyright © 2017 kamal gupta. All rights reserved.
//

#import "RequestNotificationUIView.h"
#import "MBProgressHUD.h"
#import "SYUserDefault.h"
#import "UserRunningServices.h"
#import "Constant.h"
#import "ClientNotificationUIView.h"
#import "ShowCustomAlert.h"
#import "FinishProcessUIView.h"
#import <CoreLocation/CoreLocation.h>

@implementation RequestNotificationUIView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)drawRect:(CGRect)rect {
    
    if ([_cancelnoti isEqualToString:@"startRide"])
    {
        // Do stuff...
        _requestView.hidden = YES;
        _acceptView.hidden = YES;
        self.EndRideView.hidden = NO;
        self.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height-50, [UIScreen mainScreen].bounds.size.width, 50);

        
    }else if ([_cancelnoti isEqualToString:@"Clientcancel"])
    {
        // Do stuff...
        _requestView.hidden = YES;
        _acceptView.hidden = YES;
        [ShowCustomAlert showWithMessage:@"Client cancel your last appointment."];
        
        
    }else{
        
        _requestView.hidden = NO;
        _acceptView.hidden = YES;
        
        _requestedImageView.layer.cornerRadius = 40.0;
        
        if (![[_requestDataDict[@"data"] objectForKey:@"profile_pic"] isKindOfClass:[NSNull class]]) {
            
            NSString *url= [NSString stringWithFormat:@"%@%@" , kProfileBaseUrl , [_requestDataDict[@"data"] objectForKey:@"profile_pic"]];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                UIImage * img = [UIImage imageWithData:[NSData dataWithContentsOfURL: [NSURL URLWithString:url]]];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    _requestedImageView.image = img;
                    _acceptedImageView.image = img;
                });
            });
        }
        
        if (![[_requestDataDict[@"data"] objectForKey:@"full_name"] isKindOfClass:[NSNull class]]) {
            
            _requestNameLabel.text = [_requestDataDict[@"data"] objectForKey:@"full_name"];
            _acceptedNameLabell.text= [_requestDataDict[@"data"] objectForKey:@"full_name"];
        }else{
            
            _acceptedNameLabell.text = @"";
        }
        if (![[_requestDataDict[@"data"] objectForKey:@"gender"] isKindOfClass:[NSNull class]]) {
            
            _requestedGenderLabel.text = [_requestDataDict[@"data"] objectForKey:@"gender"];
            _acceptedGenderLabel.text = [_requestDataDict[@"data"] objectForKey:@"gender"];
        }else{
            
            _requestedGenderLabel.text = @"";
        }
    }
    
    
}

- (IBAction)denyBtnTapped:(id)sender {
    
    [self removeFromSuperview];
    
}

- (IBAction)acceptedBtnTapped:(id)sender {
    
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    
    hud.label.text = NSLocalizedString(@"Please Wait...", @"HUD loading title");
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        
        NSMutableDictionary *parameter = [NSMutableDictionary new];
        
        [parameter setObject:[[SYUserDefault sharedManager] getAppToken] forKey:@"token"];
        [parameter setObject:[_requestDataDict[@"data"] objectForKey:@"client_id"] forKey:@"client_id"];
        [parameter setObject:_requestDataDict[@"latitude"]  forKey:@"latitude"];
        [parameter setObject:_requestDataDict[@"longitud"] forKey:@"longitud"];
        [parameter setObject:[[SYUserDefault sharedManager] getCareGiverType] forKey:@"type"];

        NSMutableDictionary *responceDict = [UserRunningServices addSomeOne:parameter witServiceName:@"acceptClientRequest"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
        
            [hud hideAnimated:YES];
            
            if ([[responceDict objectForKey:@"status"] intValue] ==  200) {
                
                _requestView.hidden = YES;
                _acceptView.hidden = NO;
                
                [_requestDataDict setObject:[responceDict[@"data"] objectForKey:@"hire_caregiver_id"] forKey:@"hire_caregiver_id"];
            }
            
        });
    });
    
}
- (IBAction)callBtnTapped:(id)sender {
    NSString *telStr = [NSString stringWithFormat:@"tel:+%@",[_requestDataDict[@"data"] objectForKey:@"phone"]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telStr]];

}

- (IBAction)chatBtnTapped:(id)sender {
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"startChat"
     object:_requestDataDict[@"data"]];
}

- (IBAction)cancelBtnTapped:(id)sender {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    
    hud.label.text = NSLocalizedString(@"Please Wait...", @"HUD loading title");
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        
        NSMutableDictionary *parameter = [NSMutableDictionary new];
        
        [parameter setObject:[[SYUserDefault sharedManager] getAppToken] forKey:@"token"];
        [parameter setObject:[_requestDataDict[@"data"] objectForKey:@"client_id"] forKey:@"reciever_id"];
        [parameter setObject:@"client" forKey:@"reciever_type"];
        [parameter setObject:@"cancel" forKey:@"status"];
        
        NSMutableDictionary *responceDict = [UserRunningServices addSomeOne:parameter witServiceName:@"cancel_request"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [hud hideAnimated:YES];
            
            if ([[responceDict objectForKey:@"status"] intValue] ==  200) {
                
                [self removeFromSuperview];
            }
            
        });
    });

}

- (IBAction)startBtnTapped:(id)sender {
    
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    if ([[[SYUserDefault sharedManager] getCareGiverType] isEqualToString:@"1"]){
        [self removeFromSuperview];
        ClientNotificationUIView *requestNotificationUIView = [[[NSBundle mainBundle] loadNibNamed:@"ClientNotificationUIView" owner:self options:nil] objectAtIndex:0];
        [requestNotificationUIView setFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
        
        requestNotificationUIView.dataNotificationDict = _requestDataDict;
        requestNotificationUIView.isStartTimer = YES;
        [[UIApplication sharedApplication].keyWindow addSubview:requestNotificationUIView];
    }else{
        
       // MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
        /*token
         client_id
         hire_caregiver_id
         source_location
         destination_location
         total_kilometer
         source_latitude
         destination_latitude
         source_longitude
         destination_longitude
         type*/
       // hud.label.text = NSLocalizedString(@"Please Wait...", @"HUD loading title");
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
            
            NSMutableDictionary *parameter = [NSMutableDictionary new];
            
            [parameter setObject:[[SYUserDefault sharedManager] getAppToken] forKey:@"token"];
            [parameter setObject:[_requestDataDict[@"data"] objectForKey:@"client_id"] forKey:@"client_id"];
            [parameter setObject:@"2" forKey:@"type"];
            [parameter setObject:[_requestDataDict objectForKey:@"hire_caregiver_id"] forKey:@"hire_caregiver_id"];
            [parameter setObject:[[SYUserDefault sharedManager]getCurrentLat] forKey:@"source_latitude"];
            [parameter setObject:[[SYUserDefault sharedManager]getCurrentLng] forKey:@"source_longitude"];
            [[SYUserDefault sharedManager]setSourceLat:[[SYUserDefault sharedManager]getCurrentLat]];
            [[SYUserDefault sharedManager]setSourceLng:[[SYUserDefault sharedManager]getCurrentLng]];
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"openSearchAPI"
             object:parameter];
      
//total_kilometer ,,

         /*   NSMutableDictionary *responceDict = [UserRunningServices addSomeOne:parameter witServiceName:@"startStopAmbulanceTime"];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [hud hideAnimated:YES];
                
                if ([[responceDict objectForKey:@"status"] intValue] ==  200) {
                    self.acceptView.hidden = YES;
                    self.EndRideView.hidden = NO;
                    self.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height-50, [UIScreen mainScreen].bounds.size.width, 50);
                    NSMutableDictionary *Newparameter = [NSMutableDictionary new];
                    [Newparameter setObject:[[SYUserDefault sharedManager] getAppToken] forKey:@"token"];
                    [Newparameter setObject:[_requestDataDict[@"data"] objectForKey:@"client_id"] forKey:@"client_id"];
                    [Newparameter setObject:@"2" forKey:@"type"];
                    [Newparameter setObject:[_requestDataDict objectForKey:@"hire_caregiver_id"] forKey:@"hire_caregiver_id"];
                    [Newparameter setObject:[[SYUserDefault sharedManager]getCurrentLat] forKey:@"source_latitude"];
                    [Newparameter setObject:[[SYUserDefault sharedManager]getCurrentLng] forKey:@"source_longitude"];
                    [Newparameter setObject:[_requestDataDict objectForKey:@"latitude"] forKey:@"latitude"];
                    [Newparameter setObject:[_requestDataDict objectForKey:@"longitud"] forKey:@"longitud"];
                    NSDictionary *rideDic = @{@"ride":_requestDataDict[@"data"],@"caregiver_detail":Newparameter};
                    

                    [[NSNotificationCenter defaultCenter]
                     postNotificationName:@"startRide"
                     object:rideDic];
                    //[self removeFromSuperview];
                }
                
            });*/
        });
    }
}

- (IBAction)ActionOnEndRide:(id)sender {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    /*token
     client_id
     hire_caregiver_id
     source_location
     destination_location
     total_kilometer
     source_latitude
     destination_latitude
     source_longitude
     destination_longitude
     type*/
    hud.label.text = NSLocalizedString(@"Please Wait...", @"HUD loading title");
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        
        NSMutableDictionary *parameter = [NSMutableDictionary new];
        
        [parameter setObject:[[SYUserDefault sharedManager] getAppToken] forKey:@"token"];
        [parameter setObject:[_requestDataDict objectForKey:@"client_id"] forKey:@"client_id"];
        [parameter setObject:@"2" forKey:@"type"];
        [parameter setObject:[_requestDataDict objectForKey:@"hire_caregiver_id"] forKey:@"hire_caregiver_id"];
        [parameter setObject:[[SYUserDefault sharedManager]getSourceLat] forKey:@"source_latitude"];
        [parameter setObject:[[SYUserDefault sharedManager]getSourceLng] forKey:@"source_longitude"];
        [parameter setObject:[_requestDataDict objectForKey:@"latitude"] forKey:@"destination_latitude"];
        [parameter setObject:[_requestDataDict objectForKey:@"longitud"] forKey:@"destination_longitude"];
        CLLocation *sL = [[CLLocation alloc]initWithLatitude:[[[SYUserDefault sharedManager]getSourceLat] doubleValue] longitude:[[[SYUserDefault sharedManager]getSourceLng] doubleValue]];
        CLLocation *DL = [[CLLocation alloc]initWithLatitude:[[[SYUserDefault sharedManager]getCurrentLat] doubleValue] longitude:[[[SYUserDefault sharedManager]getCurrentLng] doubleValue]];

        CLLocationDistance distance = [sL distanceFromLocation:DL]/1000;
        [parameter setObject:[NSString stringWithFormat:@"%.2f",distance] forKey:@"total_kilometer"];
        
        NSMutableDictionary *responceDict = [UserRunningServices addSomeOne:parameter witServiceName:@"startStopAmbulanceTime"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [hud hideAnimated:YES];
            
            if ([[responceDict objectForKey:@"status"] intValue] ==  200) {
                
                [self removeFromSuperview];
                FinishProcessUIView *requestNotificationUIView = [[[NSBundle mainBundle] loadNibNamed:@"FinishProcessUIView" owner:self options:nil] objectAtIndex:0];
                
                [requestNotificationUIView setFrame:CGRectMake(0, 0 , [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
                requestNotificationUIView.RececitDict = [responceDict objectForKey:@"data"];
                [[UIApplication sharedApplication].keyWindow addSubview:requestNotificationUIView];
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:@"endRide"
                 object:nil];

            }
            
        });
    });
}
@end
