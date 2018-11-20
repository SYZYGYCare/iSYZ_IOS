//
//  ReminderListViewController.m
//  Syzygy
//
//  Created by Kamal Gupta on 12/24/17.
//  Copyright © 2017 kamal gupta. All rights reserved.
//

#import "ReminderListViewController.h"
#import "ReminderListTableViewCell.h"
#import "UserRunningServices.h"
#import "SYUserDefault.h"
#import "MBProgressHUD.h"
#import "Constant.h"


@interface ReminderListViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation ReminderListViewController {
    
    NSMutableArray *reminderListArray;
    NSDateFormatter *dateFormater;
    NSDateFormatter *timeFormater;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    dateFormater = [[NSDateFormatter alloc]init];
    dateFormater.dateFormat = @"HH:mm";
    timeFormater = [[NSDateFormatter alloc]init];
    timeFormater.dateFormat = @"hh:mm a";
    self.title = @"Reminder List";
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self getReminderList];
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


#pragma mark - Table View Delegate



- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    
    return reminderListArray.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *blankview = [UIView new];
    blankview.backgroundColor = [UIColor clearColor];
    return blankview;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 130;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *tableViewCellIndetifier = @"reminderCell";
    ReminderListTableViewCell *healthTipsTVCell = (ReminderListTableViewCell*)[tableView dequeueReusableCellWithIdentifier: tableViewCellIndetifier];
    
    if (healthTipsTVCell == nil) {
        NSArray  *nib = [[NSBundle mainBundle] loadNibNamed:@"ReminderListTableViewCell" owner:self options:nil];
        healthTipsTVCell = [nib objectAtIndex:0];
    }
    
    healthTipsTVCell.layer.cornerRadius = 10;
    
    healthTipsTVCell.accessoryType = UITableViewCellAccessoryNone;
    
    NSDictionary *reminderDict = [reminderListArray objectAtIndex:indexPath.section];
    //healthTipsTVCell.contentView.backgroundColor =  [UIColor colorWithPatternImage:[UIImage imageNamed:@"watch_image"]];

    healthTipsTVCell.timeLabel.text = [self reminderTime:reminderDict[@"time"]];
    healthTipsTVCell.reminderForLabel.text = [NSString stringWithFormat:@": %@",reminderDict[@"reminder_for"]];
    healthTipsTVCell.requiredCareLabel.text = [NSString stringWithFormat:@": %@",reminderDict[@"required_care"]];
    healthTipsTVCell.anyTypeLabel.text = [NSString stringWithFormat:@": %@ / %@",reminderDict[@"start_date"],[self reminderTime:reminderDict[@"time"]]];
    
    [healthTipsTVCell.cancelButton addTarget:self action:@selector(deleteReminder:) forControlEvents:UIControlEventTouchUpInside];
    healthTipsTVCell.cancelButton.layer.cornerRadius = 15;
    healthTipsTVCell.cancelButton.layer.borderColor = [UIColor darkGrayColor].CGColor;
    healthTipsTVCell.cancelButton.layer.borderWidth = 1;
    healthTipsTVCell.cancelButton.layer.masksToBounds = YES;
    healthTipsTVCell.cancelButton.tag = indexPath.section;
    healthTipsTVCell.contentView.layer.cornerRadius = 5;

    return healthTipsTVCell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

-(NSString*)reminderTime:(NSString*)time{
    NSDate *dateTime = [dateFormater dateFromString:time];
    if (dateTime == nil) {
        dateTime = [timeFormater dateFromString:time];
    }
    timeFormater.dateFormat = @"h:mm a";
    NSString *returnTime = [timeFormater stringFromDate:dateTime];
    return returnTime;
}

- (IBAction)deleteReminder:(UIButton *)sender {
    
    NSInteger btnTag = sender.tag;
    
    UIAlertController *myalertAction =  [UIAlertController alertControllerWithTitle:@"SYZYGY saying" message:@"do you sure for delete this?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okBtn = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self deleteReminderOnserver:btnTag];
    }];
    
    [myalertAction addAction:okBtn];
    [myalertAction addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:myalertAction animated:YES completion:nil];
    
    
}


- (void) deleteReminderOnserver:(NSInteger) idStr{
    
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.label.text = NSLocalizedString(@"Please Wait...", @"HUD loading title");
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        
        NSMutableDictionary *parameter = [NSMutableDictionary new];
        
        [parameter setObject:[[SYUserDefault sharedManager] getAppToken] forKey:@"token"];
        
        NSDictionary *dict = [reminderListArray objectAtIndex:idStr];
        [parameter setObject:[NSNumber numberWithInteger:[dict[@"notification_id"] integerValue]] forKey:@"notification_id"];

        
        
        NSMutableDictionary *responceDict = [UserRunningServices addSomeOne:parameter witServiceName:@"delete_reminders"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
            
            if ([[responceDict objectForKey:@"status"] intValue] ==  200) {
                
                [self getReminderList];
            }
            
        });
    });

}

- (void) getReminderList {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.label.text = NSLocalizedString(@"Please Wait...", @"HUD loading title");
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        
        NSMutableDictionary *parameter = [NSMutableDictionary new];
        
        [parameter setObject:[[SYUserDefault sharedManager] getAppToken] forKey:@"token"];
        
        
        NSMutableDictionary *responceDict = [UserRunningServices getOtherServices:parameter witServiceName:@"get_reminders"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
            
            if ([[responceDict objectForKey:@"status"] intValue] ==  200) {
                
                reminderListArray = [NSMutableArray new];
                reminderListArray = [responceDict objectForKey:@"data"];
                [_reminderListTableView reloadData];
            }
            
        });
    });
}

@end
