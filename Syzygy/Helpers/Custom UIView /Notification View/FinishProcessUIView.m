//
//  FinishProcessUIView.m
//  Syzygy
//
//  Created by Kamal Gupta on 12/30/17.
//  Copyright © 2017 kamal gupta. All rights reserved.
//

#import "FinishProcessUIView.h"
#import "Constant.h"
#import "SYUserDefault.h"
#import "YourBillView.h"
#import "MBProgressHUD.h"
#import "UserRunningServices.h"
#import "careGiverBill.h"
@implementation FinishProcessUIView
{
    
    CGFloat interval;
    NSString *type;
    double payableAmount;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (void)drawRect:(CGRect)rect{
    if ([[[SYUserDefault sharedManager] getUserAuthorityId] intValue] == USER_TYPE) {
        [self GetWalletAmount];
    }else{
        _walletImage.hidden = YES;
        _walletValue.hidden = YES;
    }
    if (![_RececitDict[@"type"] isKindOfClass:[NSNull class]]) {
        // amount
        type = _RececitDict[@"type"];
    }
    if ([type isEqualToString:@"caregiver"])
    {
        if (![_RececitDict[@"profile_pic"] isKindOfClass:[NSNull class]]) {
            
            NSString *url= [NSString stringWithFormat:@"%@%@" , kProfileBaseUrl , _RececitDict[@"profile_pic"]];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                UIImage * img = [UIImage imageWithData:[NSData dataWithContentsOfURL: [NSURL URLWithString:url]]];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    _profileImageView.image = img;
                });
            });
        }
        
        // type
        if (![_RececitDict[@"full_name"] isKindOfClass:[NSNull class]]) {
            // amount
            _nameValue.text = _RececitDict[@"full_name"];
        }
        if (![_RececitDict[@"amount"] isKindOfClass:[NSNull class]]) {
            // amount
            //_nameValue.text = _RececitDict[@"full_name"];
            NSString *a = _RececitDict[@"amount"];;
            double b = [a doubleValue];
            interval = (b/60);
            NSLog(@"interval = %.2f",interval);
            
        }
        if (![_RececitDict[@"start_time"] isKindOfClass:[NSNull class]]) {
            
            _startTimeValue.text = [NSString stringWithFormat:@"%@" , _RececitDict[@"start_time"]];
        }
        if (![_RececitDict[@"stop_time"] isKindOfClass:[NSNull class]]) {
            
            _endTimeValue.text = [NSString stringWithFormat:@"%@" , _RececitDict[@"stop_time"]];
        }
        if (![_RececitDict[@"total_time"] isKindOfClass:[NSNull class]]) {
            
            _totalWorklingValue.text = [NSString stringWithFormat:@"%@ min" , _RececitDict[@"total_time"]];
        }
        if (![_RececitDict[@"min_charges"] isKindOfClass:[NSNull class]]) {
            
            
            NSString *min_charges = _RececitDict[@"min_charges"];;
            NSString *myString = [[NSNumber numberWithFloat:interval] stringValue];
            double x = ([min_charges doubleValue]);
            double y = ([myString doubleValue]);
            double amount = [[_RececitDict objectForKey:@"amount"] doubleValue];
            if (y > 60) {
                double extraTime = y - 60;
                double amountInExtra = amount/60;
                double totalExtraAmount = amountInExtra * extraTime;
                payableAmount = totalExtraAmount;
                _amountValue.text = [NSString stringWithFormat:@"%.2f", x + totalExtraAmount];
                [_finishButton setTitle:[NSString stringWithFormat:@"Hire Amount %.2f",(x + totalExtraAmount)] forState:UIControlStateNormal];
                
            }else{
                payableAmount = x;
                _amountValue.text = [NSString stringWithFormat:@"%.2f", x];
                [_finishButton setTitle:[NSString stringWithFormat:@"Hire Amount %.2f",x] forState:UIControlStateNormal];
                
            }
            
            /*NSString *min_charges = _RececitDict[@"min_charges"];;
            NSString *myString = [[NSNumber numberWithFloat:interval] stringValue];
            float x = ([min_charges floatValue]);
            float y = ([myString floatValue]);
            
            _amountValue.text = [NSString stringWithFormat:@"%.2f", x + y];
            [_finishButton setTitle:[NSString stringWithFormat:@"Hire Amount %@",_amountValue.text] forState:UIControlStateNormal];*/
        }
        _byWalletValue.hidden = true;
        _byWalletTitle.hidden = true;
        _walletTop.constant = 0;
        _walletTop2.constant = 0;
        _walletHeight.constant = 0;
        _walletHeight2.constant = 0;
        _remainingTop.constant = 0;
        _remainigHeight.constant = 0;
        _remainingHeight2.constant = 0;
        _remingAmountValue.hidden = true;
        _remingAmountTitle.hidden = true;
       
//        if (![_RececitDict[@"by_Wallet"] isKindOfClass:[NSNull class]]) {
//
//            _byWalletValue.text = _RececitDict[@"by_Wallet"];
//        } else {
//            _byWalletValue.text = @"0.0";
//
//        }
//
//        if (![_RececitDict[@"min_charges"] isKindOfClass:[NSNull class]]) {
//
//            // _amountValue.text = [NSString stringWithFormat:@"%@" , _RececitDict[@"min_charges"]];
//        }
    }else if ([type isEqualToString:@"ambulance"]){
        if (![_RececitDict[@"profile_pic"] isKindOfClass:[NSNull class]]) {
            
            NSString *url= [NSString stringWithFormat:@"%@%@" , kProfileBaseUrl , _RececitDict[@"profile_pic"]];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                UIImage * img = [UIImage imageWithData:[NSData dataWithContentsOfURL: [NSURL URLWithString:url]]];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    _profileImageView.image = img;
                });
            });
        }
        
        // type
        if (![_RececitDict[@"full_name"] isKindOfClass:[NSNull class]]) {
            // amount
            _nameValue.text = _RececitDict[@"full_name"];
        }
        
        if (![_RececitDict[@"total_kilometer"] isKindOfClass:[NSNull class]]) {
            _startTimeValue.text = [self floatToString:[_RececitDict[@"total_kilometer"] floatValue]];
            _startTimeTitle.text = @"Total Km";
        }
        
        if (![_RececitDict[@"amount"] isKindOfClass:[NSNull class]]) {
            _endTimeValue.text = [NSString stringWithFormat:@"%@" , _RececitDict[@"amount"]];
            _endTimeTitle.text = @"Km / Charges";
        }else{
            _endTimeValue.text = @"0";
            _endTimeTitle.text = @"Km / Charges";
        }
        
        if (![_RececitDict[@"min_charges"] isKindOfClass:[NSNull class]]) {
            
            NSString *min_charges = _RececitDict[@"min_charges"];;
            NSString *myString = [[NSNumber numberWithFloat:[_RececitDict[@"total_kilometer"] floatValue]] stringValue];
            double perKmCharge = [_RececitDict[@"amount"] doubleValue];
            
            float x = ([min_charges floatValue]);
            float y = ([myString floatValue]);
            if (y > 1) {
                double extraKm = y-1;
                double extraCharge = extraKm * perKmCharge;
                payableAmount = extraCharge;
                _totalWorklingValue.text = [NSString stringWithFormat:@"%.2f", x + extraCharge];
                [_finishButton setTitle:[NSString stringWithFormat:@"Hire Amount %@",_totalWorklingValue.text] forState:UIControlStateNormal];
            }else{
                payableAmount = x + y;
                _totalWorklingValue.text = [NSString stringWithFormat:@"%.2f", x + y];
                [_finishButton setTitle:[NSString stringWithFormat:@"Hire Amount %@",_amountValue.text] forState:UIControlStateNormal];
            }
     
            _totalWorkingTitle.text = @"Total Amount";

        }else{
            payableAmount = 0;
            _totalWorklingValue.text = @"0";
            _totalWorkingTitle.text = @"Total Amount";
            [_finishButton setTitle:[NSString stringWithFormat:@"Hire Amount %@",_totalWorklingValue.text] forState:UIControlStateNormal];
        }
       
        _byWalletValue.hidden = true;
        _byWalletTitle.hidden = true;
        _remingAmountValue.hidden = true;
        _remingAmountTitle.hidden = true;
        _amountValue.hidden = true;
        _amountTitle.hidden = true;
        _amountTop.constant = 0;
        _amountTop2.constant = 0;
        _amountHeight.constant = 0;
        _AmountHeight2.constant = 0;
        _walletTop.constant = 0;
        _walletTop2.constant = 0;
        _walletHeight.constant = 0;
        _walletHeight2.constant = 0;
        _remainingTop.constant = 0;
        _remainigHeight.constant = 0;
        _remainingHeight2.constant = 0;
    }
}

- (NSString *) floatToString:(float) val {
    NSString *ret = [NSString stringWithFormat:@"%.5f", val];
    unichar c = [ret characterAtIndex:[ret length] - 1];
    while (c == 48 || c == 46) { // 0 or .
        ret = [ret substringToIndex:[ret length] - 1];
        c = [ret characterAtIndex:[ret length] - 1];
    }
    return ret;
}

- (IBAction)FinishButtonTapped:(id)sender {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"endRide" object:nil];
    if ([[[SYUserDefault sharedManager] getUserAuthorityId] intValue] == USER_TYPE) {
        _buttonView = [[[NSBundle mainBundle] loadNibNamed:@"FinishProcessUIView" owner:self options:nil] objectAtIndex:1];
        _buttonView.frame = self.frame;
        self.optionsView.layer.cornerRadius = 10;
        self.optionsView.layer.borderWidth = 2;
        self.optionsView.layer.borderColor = USER_COLOR.CGColor;
        [self addSubview:_buttonView];
    }else{
//        YourBillView *requestNotificationUIView = [[[NSBundle mainBundle] loadNibNamed:@"YourBillView" owner:self options:nil] objectAtIndex:0];
//        [requestNotificationUIView setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
//        requestNotificationUIView.billDictionary = _RececitDict;
//        [[UIApplication sharedApplication].keyWindow addSubview:requestNotificationUIView];
//        [self removeFromSuperview];
        if ([type isEqualToString:@"caregiver"])
        {
            careGiverBill *requestNotificationUIView = [[[NSBundle mainBundle] loadNibNamed:@"careGiverBill" owner:self options:nil] objectAtIndex:0];
            [requestNotificationUIView setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
            requestNotificationUIView.billDictionary = _RececitDict;
            [[UIApplication sharedApplication].keyWindow addSubview:requestNotificationUIView];
            [self removeFromSuperview];
        }else if ([type isEqualToString:@"ambulance"]){
            YourBillView *requestNotificationUIView = [[[NSBundle mainBundle] loadNibNamed:@"YourBillView" owner:self options:nil] objectAtIndex:0];
            [requestNotificationUIView setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
            requestNotificationUIView.billDictionary = _RececitDict;
            [[UIApplication sharedApplication].keyWindow addSubview:requestNotificationUIView];
            [self removeFromSuperview];
        }
    }
}
- (IBAction)ActionOnCash:(id)sender {
    NSMutableDictionary *onlineDic =[[NSMutableDictionary alloc]init];
    for (id key in _RececitDict.allKeys) {
        if (![[_RececitDict objectForKey:key] isKindOfClass:[NSNull class]]) {
            [onlineDic setObject:[_RececitDict objectForKey:key] forKey:key];
        }
    }
    [onlineDic setObject:[NSNumber numberWithDouble:payableAmount] forKey:@"payable"];
    self.cashDic = onlineDic;
  //  [[NSNotificationCenter defaultCenter]postNotificationName:@"CashSuccess" object:onlineDic];

    if ([type isEqualToString:@"caregiver"])
    {
        careGiverBill *requestNotificationUIView = [[[NSBundle mainBundle] loadNibNamed:@"careGiverBill" owner:self options:nil] objectAtIndex:0];
        requestNotificationUIView.isCash = YES;
        requestNotificationUIView.delegate = self;
        [requestNotificationUIView setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        requestNotificationUIView.billDictionary = _RececitDict;
        [[UIApplication sharedApplication].keyWindow addSubview:requestNotificationUIView];
       // [self removeFromSuperview];
    }else if ([type isEqualToString:@"ambulance"]){
        YourBillView *requestNotificationUIView = [[[NSBundle mainBundle] loadNibNamed:@"YourBillView" owner:self options:nil] objectAtIndex:0];
        requestNotificationUIView.isCash = YES;
        requestNotificationUIView.delegate = self;
        [requestNotificationUIView setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        requestNotificationUIView.billDictionary = _RececitDict;
        [[UIApplication sharedApplication].keyWindow addSubview:requestNotificationUIView];
       // [self removeFromSuperview];
    }
}

- (IBAction)ActionOnOnline:(id)sender {
   // [self removeFromSuperview];
    
    NSMutableDictionary *onlineDic =[[NSMutableDictionary alloc]init];
    for (id key in _RececitDict.allKeys) {
        if (![[_RececitDict objectForKey:key] isKindOfClass:[NSNull class]]) {
            [onlineDic setObject:[_RececitDict objectForKey:key] forKey:key];
        }
    }
    [onlineDic setObject:[NSNumber numberWithDouble:payableAmount] forKey:@"payable"];
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"online"
     object:onlineDic];
}

-(void)GetWalletAmount{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    
    hud.label.text = NSLocalizedString(@"Please Wait...", @"HUD loading title");
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        
        NSMutableDictionary *parameter = [NSMutableDictionary new];
        
        [parameter setObject:[[SYUserDefault sharedManager] getAppToken] forKey:@"token"];
        
        NSMutableDictionary *responceDict = [UserRunningServices addSomeOne:parameter witServiceName:@"get_wallet"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [hud hideAnimated:YES];
            
            if ([[responceDict objectForKey:@"status"] intValue] ==  200) {
                if ([type isEqualToString:@"ambulance"]){
                    self.amountTitle.text = @"By Wallet";
                    self.amountValue.text = [NSString stringWithFormat:@"%.2f",[[responceDict objectForKey:@"wallet"]doubleValue]];
                    double total = [_totalWorklingValue.text doubleValue];
                    double wallet = [[responceDict objectForKey:@"wallet"]doubleValue];
                    _byWalletTitle.text = @"Payable Amount";

                    if (total >= wallet) {
                        double remain = total - wallet;
                        payableAmount = remain;
                        _byWalletValue.text = [NSString stringWithFormat:@"%.2f",remain];
                    }else{
                        _byWalletValue.text = @"0";

                    }
                    _walletValue.text = [NSString stringWithFormat:@"₹ %@",_amountValue.text];
                    _byWalletValue.hidden = false;
                    _byWalletTitle.hidden = false;
                    _amountValue.hidden = false;
                    _amountTitle.hidden = false;
                    _amountTop.constant = 11;
                    _amountTop2.constant = 11;
                    _amountHeight.constant = 21;
                    _AmountHeight2.constant = 21;
                    _walletTop.constant = 11;
                    _walletTop2.constant = 11;
                    _walletHeight.constant = 21;
                    _walletHeight2.constant = 21;
                   
                }else if ([type isEqualToString:@"caregiver"]){
                    _byWalletTitle.text = @"By Wallet";
                    _byWalletValue.text = [NSString stringWithFormat:@"%.2f",[[responceDict objectForKey:@"wallet"]doubleValue]];
                    double total = [_amountValue.text doubleValue];
                    double wallet = [[responceDict objectForKey:@"wallet"]doubleValue];
                    _remingAmountTitle.text = @"Payable Amount";

                    if (total >= wallet) {
                        double remain = total - wallet;
                        payableAmount = remain;
                        _remingAmountValue.text = [NSString stringWithFormat:@"%.2f",remain];
                        
                    }else{
                        _remingAmountValue.text = @"0";
                    }
                    _walletValue.text = [NSString stringWithFormat:@"₹ %@",_byWalletValue.text];

                    _byWalletValue.hidden = false;
                    _byWalletTitle.hidden = false;
                    _walletTop.constant = 11;
                    _walletTop2.constant = 11;
                    _walletHeight.constant = 21;
                    _walletHeight2.constant = 21;
                    _remainingTop.constant = 11;
                    _remainigHeight.constant = 21;
                    _remainingHeight2.constant = 21;
                    _remingAmountValue.hidden = false;
                    _remingAmountTitle.hidden = false;
                }
                /*{
                 message = success;
                 status = 200;
                 wallet = 0;
                 }*/
                //By Wallet amountTitle amountValue
                //Payable Amount byWallet bayWalletValue
            }
            
        });
    });
}

#pragma mark :- bill delegates

-(void)finishedYourBillCash{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"CashSuccess" object:self.cashDic];
    [self removeFromSuperview];
}

-(void)finishedBillCash{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"CashSuccess" object:self.cashDic];
    [self removeFromSuperview];
}

-(void)skipYourBillCash{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"CashSuccess" object:nil];
    [self removeFromSuperview];
}

-(void)skipBillCash{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"CashSuccess" object:nil];
    [self removeFromSuperview];
}
@end
