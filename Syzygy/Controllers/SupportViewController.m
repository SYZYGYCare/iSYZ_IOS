//
//  SupportViewController.m
//  Syzygy
//
//  Created by manisha panse on 2/14/18.
//  Copyright © 2018 kamal gupta. All rights reserved.
//

#import "SupportViewController.h"
#import "Constant.h"
#import "UISuporterINApp.h"
#import "SYUserDefault.h"
#import "MBProgressHUD.h"
#import "UserRunningServices.h"
@interface SupportViewController ()

@end

@implementation SupportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =  [UIColor colorWithPatternImage:[UIImage imageNamed:@"viewBg"]];
    self.title = @"Support";
    self.reason.placeholder = @"Reason Description";
    self.reason.layer.borderWidth = 1;
    self.reason.layer.borderColor = USER_COLOR.CGColor;
    self.reason.layer.cornerRadius = 4;
    
    self.submitBtn.layer.cornerRadius = 4;
   
    UIToolbar *toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(disableKeyboard)];
    UIBarButtonItem *space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    toolbar.items = @[space,doneButton];
    self.HireServiceId.inputAccessoryView = toolbar;
    self.HourReported.inputAccessoryView = toolbar;
    self.HourActual.inputAccessoryView = toolbar;
    self.reason.inputAccessoryView = toolbar;

    // Do any additional setup after loading the view.
}
-(void)disableKeyboard{
    [self.view endEditing:YES];
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


- (IBAction)addClaim:(id)sender {
    
    NSMutableDictionary *parameter = [NSMutableDictionary new];
    
    NSString *message = @"";
    if ([UISuporterINApp isValidString:_reason.text]) {
        [parameter setObject:_reason.text forKey:@"reason_discrepancy"];
        
    } else {
        
        message = @"Enter Reson description";
    }
    
    if ([UISuporterINApp isValidString:_HourActual.text]) {
        
        [parameter setObject:_HourActual.text forKey:@"hour_actual_work"];
    } else {
        
        message = @"Enter Actual Hours";
    }
    
    if ([UISuporterINApp isValidString:_HourReported.text]) {
        [parameter setObject:_HourReported.text forKey:@"hour_reported"];
        
    } else {
        message = @"Enter Reported Hours";
    }
    
    if ([UISuporterINApp isValidString:_HireServiceId.text]) {
        
        [parameter setObject:_HireServiceId.text forKey:@"caregiver_id"];
    } else {
        
        message = @"Enter Hired Service Id";
    }
  
    if ([message isEqualToString:@""]) {
        
        [parameter setObject:[[SYUserDefault sharedManager] getAppToken] forKey:@"token"];
        NSString *start_date = [self convertDateToStr:[NSDate date] withFormate:@"yyyy/MM/dd"];
        [parameter setObject:start_date forKey:@"report_register_date"];

        [self addClaimToserver:parameter];
        
    } else {
        [self presentViewController:[UISuporterINApp generateAlert:message] animated:YES completion:nil];
    }
}

-(void) addClaimToserver:(NSMutableDictionary *)parameter {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.label.text = NSLocalizedString(@"Please Wait...", @"HUD loading title");
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        
        NSMutableDictionary *responceDict = [UserRunningServices addSomeOne:parameter witServiceName:@"user_claim"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
            
            if ([[responceDict objectForKey:@"status"] intValue] ==  200) {
                
                [self.navigationController popViewControllerAnimated:YES];
            }
            
        });
    });
    
}

- (NSString *)convertDateToStr :(NSDate *)date  withFormate:(NSString *) formet {
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat: formet];
    
    NSString *convertedString = [dateFormatter stringFromDate:date];
    NSLog(@"Converted String : %@",convertedString);
    return convertedString;
}
@end
