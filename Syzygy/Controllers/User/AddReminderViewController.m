//
//  AddReminderViewController.m
//  Syzygy
//
//  Created by Kamal Gupta on 12/24/17.
//  Copyright © 2017 kamal gupta. All rights reserved.
//

#import "AddReminderViewController.h"
#import "SYUserDefault.h"
#import "UserRunningServices.h"
#import "MBProgressHUD.h"
#import "UISuporterINApp.h"

@interface AddReminderViewController ()

@end

@implementation AddReminderViewController {
    
    NSMutableDictionary *reminderListDict;
    NSArray *reminderCareArr;
    NSDate *seletedDate;
    BOOL goToReminder;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =  [UIColor colorWithPatternImage:[UIImage imageNamed:@"viewBg"]];

    UIButton *itemBarButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    itemBarButton.frame = CGRectMake(0, 0, 100, 30);
    [itemBarButton setTitle:@"Reminders" forState:UIControlStateNormal];
    [itemBarButton.titleLabel setFont:[UIFont boldSystemFontOfSize:15.f]];
    [itemBarButton addTarget:self action:@selector(showReminders) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:itemBarButton];

    [self getReminderDetails];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    if (goToReminder) {
//        [self.navigationController popViewControllerAnimated:YES];
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)showReminders {
   // goToReminder = YES;
    //[self performSegueWithIdentifier:@"reminderListSegue" sender:self];
    [self.navigationController popViewControllerAnimated:NO];

    if ([self.delegate respondsToSelector:@selector(reminderAddedSuccessfully)]) {
        [self.delegate reminderAddedSuccessfully];
    }
}


- (IBAction)donePickerButtonTapped:(id)sender {
    
    _datePickerView.hidden = YES;
    
    seletedDate = _reminderDatePicker.date;
    NSString *str = [self convertDateToStr:_reminderDatePicker.date withFormate:@"dd/MM/yyyy HH:mm"];
    if (str != nil) {
        [_selecteDateButton setTitle:str forState:UIControlStateNormal];
    }

}

- (IBAction)addReminderButtonTapped:(id)sender {
    
    if (seletedDate != nil) {
        
        NSString *start_date = [self convertDateToStr:_reminderDatePicker.date withFormate:@"yyyy/MM/dd"];
        NSString *timeStr = [self convertDateToStr:_reminderDatePicker.date withFormate:@"H:mm"];
        
        NSString *remimderFor = _reminderForButton.titleLabel.text;
        NSString *careType = _careTypeButton.titleLabel.text;
        NSString *requireType = _requiredCareButton.titleLabel.text;
        NSString *anyType = _anyTypeButton.titleLabel.text;
        
        NSMutableDictionary *parameter = [NSMutableDictionary new];
        [parameter setObject:start_date forKey:@"start_date"];
        [parameter setObject:remimderFor forKey:@"reminder_for"];
        [parameter setObject:requireType forKey:@"required_care"];
        [parameter setObject:anyType forKey:@"any_reminder"];
        [parameter setObject:timeStr forKey:@"time"];
        [parameter setObject:careType forKey:@"reminder_type"];
        
//        if ([careType isEqualToString:@"OB"]) {
//            [parameter setObject:@"1" forKey:@"reminder_type"];
//
//        } else {
//            [parameter setObject:@"2" forKey:@"reminder_type"];
//
//        }
        [self setLocalReminder:parameter];
        [parameter setObject:[[SYUserDefault sharedManager] getAppToken] forKey:@"token"];
        [self saveReminderDetails:parameter];

    } else {
        
        [self presentViewController:[UISuporterINApp generateAlert:@"Select time"] animated:YES completion:nil];
    }
    
}
-(void)setLocalReminder:(NSDictionary*)parameters{
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    if (notification)
    {
        NSMutableDictionary *newParameter = [parameters mutableCopy];
        [newParameter setObject:@"localNotification" forKey:@"action"];
        [newParameter setObject:@"reminder" forKey:@"type"];

        notification.fireDate = _reminderDatePicker.date;
        notification.alertBody = @"Reminder!!!";
        //notification.alertAction = @"localNotification";
        notification.timeZone = [NSTimeZone defaultTimeZone];
        notification.applicationIconBadgeNumber = 1;
        notification.soundName = UILocalNotificationDefaultSoundName;
     //   notification.repeatInterval = NSCalendarUnitDay;
        notification.userInfo = newParameter;
        // this will schedule the notification to fire at the fire date
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
        // this will fire the notification right away, it will still also fire at the date we set
     //   [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
      //  notification.alertBody = _customMessage.text;

    }
}
- (IBAction)selecteDateButtonTapped:(id)sender {
    
    _datePickerView.hidden = NO;
}

- (IBAction)anyTypeButtonTapped:(id)sender {
    
    [self openActionSheet:@"any_reminder" withButtonType:_anyTypeButton];
}

- (IBAction)careTypeButtonTapped:(id)sender {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Select any" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    
    for (int i=0; i<reminderCareArr.count; i++) {
        NSDictionary *careDic = [reminderCareArr objectAtIndex:i];
        UIAlertAction *btn1 =  [UIAlertAction actionWithTitle:[careDic objectForKey:@"care_type_1"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [_careTypeButton setTitle:[careDic objectForKey:@"care_type_1"] forState:UIControlStateNormal];
        }];
        [alertController addAction:btn1];
    }
    
   /* UIAlertAction *btn1 =  [UIAlertAction actionWithTitle:@"OB" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [_careTypeButton setTitle:@"OB" forState:UIControlStateNormal];
    }];
    UIAlertAction *btn2 =  [UIAlertAction actionWithTitle:@"DB" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [_careTypeButton setTitle:@"DB" forState:UIControlStateNormal];
    }];
    
    [alertController addAction:btn1];
    
    [alertController addAction:btn2];*/
    [alertController addAction:[UIAlertAction actionWithTitle:@"CANCEL" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)requiredCareButtonTapped:(id)sender {
    
    [self openActionSheet:@"reminder_care" withButtonType:_requiredCareButton];

}

- (IBAction)reminderForButtonTapped:(id)sender {
    
    [self openActionSheet:@"reminder_for" withButtonType:_reminderForButton];
}


#pragma mark - APIs


- (void) getReminderDetails {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.label.text = NSLocalizedString(@"Please Wait...", @"HUD loading title");
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        
        NSMutableDictionary *parameter = [NSMutableDictionary new];
        
        [parameter setObject:[[SYUserDefault sharedManager] getAppToken] forKey:@"token"];
        
        
        NSMutableDictionary *responceDict = [UserRunningServices getOtherServices:parameter witServiceName:@"get_reminder_cat"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
            
            if ([[responceDict objectForKey:@"status"] intValue] ==  200) {
                
                reminderListDict = [responceDict objectForKey:@"data"];
               NSArray* listArray = [reminderListDict objectForKey:@"reminder_care"];
               NSDictionary* listDict =  listArray.firstObject;
                [self getReminderCareDetailsForId:[listDict objectForKey:@"reminder_category_id"]];
                [self setUI];
            }
            
        });
    });
}

- (void) saveReminderDetails:(NSMutableDictionary *)parameter{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.label.text = NSLocalizedString(@"Please Wait...", @"HUD loading title");
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        
        NSMutableDictionary *responceDict = [UserRunningServices addSomeOne:parameter witServiceName:@"addRemainder"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
            
            if ([[responceDict objectForKey:@"status"] intValue] ==  200) {
               // [self.navigationController popViewControllerAnimated:NO];

                [self showReminders];
            }
            
        });
    });
}


-(void) setUI {
    
    NSArray *listArray = [NSArray new];
    NSMutableDictionary *listDict = [NSMutableDictionary new];

    listArray = [reminderListDict objectForKey:@"reminder_for"];
    listDict =  listArray.firstObject;
    [_reminderForButton setTitle:listDict[@"category_name"] forState:UIControlStateNormal];
    
    listArray = [reminderListDict objectForKey:@"reminder_care"];
    listDict =  listArray.firstObject;
    [_requiredCareButton setTitle:listDict[@"category_name"] forState:UIControlStateNormal];
    
    listArray = [reminderListDict objectForKey:@"any_reminder"];
    listDict =  listArray.firstObject;
    [_anyTypeButton setTitle:listDict[@"category_name"] forState:UIControlStateNormal];
    
    if (reminderCareArr.count > 0) {
        [_careTypeButton setTitle:[[reminderCareArr objectAtIndex:0]objectForKey:@"care_type_1"] forState:UIControlStateNormal];
    }else
        [_careTypeButton setTitle:@"" forState:UIControlStateNormal];

    
}

-(void) openActionSheet :(NSString *)typeOFActionSheet withButtonType:(UIButton *)btnType {
    
    NSArray *listArray = [reminderListDict objectForKey:typeOFActionSheet];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Select any" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    for (NSDictionary *dict in listArray) {
        
        UIAlertAction *btn =  [UIAlertAction actionWithTitle:dict[@"category_name"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [btnType setTitle:dict[@"category_name"] forState:UIControlStateNormal];
            if ([typeOFActionSheet isEqualToString:@"reminder_care"]) {
              //  [self getReminderCareDetailsForId:dict[@"reminder_category_id"]];
            }
        }];
        
        [alertController addAction:btn];
    }
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"CANCEL" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
    
}

- (NSString *)convertDateToStr :(NSDate *)date  withFormate:(NSString *) formet {
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat: formet];
    
    NSString *convertedString = [dateFormatter stringFromDate:date];
    NSLog(@"Converted String : %@",convertedString);
    return convertedString;
}



- (void) getReminderCareDetailsForId:(NSString*)reminderCareId {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.label.text = NSLocalizedString(@"Please Wait...", @"HUD loading title");
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        
        NSMutableDictionary *parameter = [NSMutableDictionary new];
        
        [parameter setObject:reminderCareId forKey:@"reminder_category_id"];
        
        
        NSMutableDictionary *responceDict = [UserRunningServices getOtherServices:parameter witServiceName:@"get_reminder_care"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
            
            if ([[responceDict objectForKey:@"status"] intValue] ==  200) {
                
                reminderCareArr = [responceDict objectForKey:@"data"];
                [self setUI];
            }
            
        });
    });
}

@end
