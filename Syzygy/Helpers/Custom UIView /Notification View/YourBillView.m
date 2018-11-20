//
//  YourBillView.m
//  Syzygy
//
//  Created by manisha panse on 1/19/18.
//  Copyright © 2018 kamal gupta. All rights reserved.
//

#import "YourBillView.h"
#import "Constant.h"
#import "MBProgressHUD.h"
#import "SYUserDefault.h"
#import "UserRunningServices.h"
@implementation YourBillView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    //
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(cashNotifcation:)
                                                 name:@"Cashsucces"
                                               object:nil];
    self.descriptionTextView.layer.cornerRadius = 5;
    self.descriptionTextView.layer.masksToBounds = YES;
    self.descriptionTextView.layer.borderWidth = 1;
    self.descriptionTextView.layer.borderColor = USER_COLOR.CGColor;
    self.paidImage.transform = CGAffineTransformMakeRotation( 45 );
    self.redCircle.layer.cornerRadius = self.redCircle.frame.size.height/2;
    self.redCircle.layer.masksToBounds = YES;
    self.greenCircle.layer.cornerRadius = self.redCircle.frame.size.height/2;
    self.greenCircle.layer.masksToBounds = YES;
    
    if (![_billDictionary[@"profile_pic"] isKindOfClass:[NSNull class]]) {
        
        NSString *url= [NSString stringWithFormat:@"%@%@" , kProfileBaseUrl , _billDictionary[@"profile_pic"]];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            UIImage * img = [UIImage imageWithData:[NSData dataWithContentsOfURL: [NSURL URLWithString:url]]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                _profileImageView.image = img;
            });
        });
    }
    if (![[_billDictionary objectForKey:@"min_charges"] isKindOfClass:[NSNull class]]) {
        _amountLab.text = [NSString stringWithFormat:@"Rs. %@",[_billDictionary objectForKey:@"min_charges"]];
    }
    
    if (![[_billDictionary objectForKey:@"full_name"] isKindOfClass:[NSNull class]]) {
        _nameLab.text = [_billDictionary objectForKey:@"full_name"];
    }
    
    if (![[_billDictionary objectForKey:@"source_location"] isKindOfClass:[NSNull class]]) {
        _sourceAddress.text = [_billDictionary objectForKey:@"source_location"];
    }
    
    if (![[_billDictionary objectForKey:@"destination_location"] isKindOfClass:[NSNull class]]) {
        _destinationAddress.text = [_billDictionary objectForKey:@"destination_location"];
    }
}

-(void)cashNotifcation:(NSNotification*)notification{
    if ([[notification name]isEqualToString:@"Cashsucces"]){
        self.requestDictionary = notification.object;
        self.isCash =  YES;
    }
}

- (IBAction)ActionOnSkip:(id)sender {
    if (self.isCash) {
    //    [[NSNotificationCenter defaultCenter]postNotificationName:@"CashSuccess" object:self.requestDictionary];
        if ([self.delegate respondsToSelector:@selector(skipYourBillCash)]) {
            [self.delegate skipYourBillCash];
        }
    }
    [self removeFromSuperview];
}

- (IBAction)ActionOnSubmit:(id)sender {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];

    hud.label.text = NSLocalizedString(@"Please Wait...", @"HUD loading title");
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        
        NSMutableDictionary *parameter = [NSMutableDictionary new];
        
        [parameter setObject:[[SYUserDefault sharedManager] getAppToken] forKey:@"token"];
        if ([_billDictionary objectForKey:@"caregiver_id"]) {
            [parameter setObject:[_billDictionary objectForKey:@"caregiver_id"] forKey:@"caregiver_id"];
        }else{
            [parameter setObject:[_billDictionary objectForKey:@"client_id"] forKey:@"client_id"];
        }
        [parameter setObject:[NSNumber numberWithInt:self.ratingView.value] forKey:@"rating"];
        [parameter setObject:self.descriptionTextView.text forKey:@"feedback"];
        
        
        NSMutableDictionary *responceDict = [UserRunningServices addSomeOne:parameter witServiceName:@"rating"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [hud hideAnimated:YES];
            
            if ([[responceDict objectForKey:@"status"] intValue] ==  200) {
                if (self.isCash) {
                 //   [[NSNotificationCenter defaultCenter]postNotificationName:@"CashSuccess" object:self.requestDictionary];
                    if ([self.delegate respondsToSelector:@selector(finishedYourBillCash)]) {
                        [self.delegate finishedYourBillCash];
                    }
                }
                [self removeFromSuperview];
            }else{
                if (self.isCash) {
                   // [[NSNotificationCenter defaultCenter]postNotificationName:@"CashSuccess" object:self.requestDictionary];
                    if ([self.delegate respondsToSelector:@selector(finishedYourBillCash)]) {
                        [self.delegate finishedYourBillCash];
                    }
                }
                if ([_billDictionary objectForKey:@"client_id"]) {
                    [self removeFromSuperview];
                }
            }
            
        });
    });
}
@end
