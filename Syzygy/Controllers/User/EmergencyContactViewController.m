//
//  EmergencyContactViewController.m
//  Syzygy
//
//  Created by Kamal Gupta on 12/15/17.
//  Copyright © 2017 kamal gupta. All rights reserved.
//

#import "EmergencyContactViewController.h"
#import "HealthTipsTableViewCell.h"
#import "UserRunningServices.h"
#import "MBProgressHUD.h"
#import "SYUserDefault.h"
#import "UISuporterINApp.h"
#import "EmergencyTableViewCell.h"

@interface EmergencyContactViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation EmergencyContactViewController {
    NSMutableArray *emergencyListArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    emergencyListArray = [[NSMutableArray alloc]init];
    self.view.backgroundColor =  [UIColor colorWithPatternImage:[UIImage imageNamed:@"viewBg"]];
    self.title = @"Emergency Contact";
    [UISuporterINApp SetTextFieldBorder:_emergencyContactNumberTextField withView:self.view];
    [self getEmergencyList];
    UIToolbar *toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(disableKeyboard)];
    UIBarButtonItem *space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    toolbar.items = @[space,doneButton];
    self.emergencyContactNumberTextField.inputAccessoryView = toolbar;
    
   
    
    
    // Do any additional setup after loading the view.
}

-(void)disableKeyboard{
    [self.view endEditing:YES];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
    
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
    
    return emergencyListArray.count;
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
    return 80;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *tableViewCellIndetifier = @"emergencyCell";
    EmergencyTableViewCell *healthTipsTVCell = (EmergencyTableViewCell*)[tableView dequeueReusableCellWithIdentifier: tableViewCellIndetifier];
    
    if (healthTipsTVCell == nil) {
        healthTipsTVCell = [[EmergencyTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"emergencyCell"];
    }
    
    
    NSDictionary *emergencyDict = [emergencyListArray objectAtIndex:indexPath.section];
    healthTipsTVCell.contactLab.text = [NSString stringWithFormat:@" %@",[emergencyDict objectForKey:@"emergency_no"]];
   
    healthTipsTVCell.emergencyDelete.tag = indexPath.section;
    healthTipsTVCell.telephoneimage.tag = indexPath.section;
    healthTipsTVCell.telephoneimage.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(callTheUser:)];
    [healthTipsTVCell.telephoneimage addGestureRecognizer:tap];
//    healthTipsTVCell.deleteButton.tag = indexPath.section;
//    [healthTipsTVCell.deleteButton addTarget:self action:@selector(ActionOnDeleteButton:) forControlEvents:UIControlEventTouchUpInside];
    healthTipsTVCell.emergencyBackView.layer.cornerRadius = 10;
    [healthTipsTVCell.emergencyBackView.layer setShadowColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.11].CGColor];
    [healthTipsTVCell.emergencyBackView.layer setShadowOpacity:0.8];
    [healthTipsTVCell.emergencyBackView.layer setShadowRadius:4.0];
    [healthTipsTVCell.emergencyBackView.layer setShadowOffset:CGSizeMake(0.0, 2.0)];
    return healthTipsTVCell;
}

//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
//    // Return NO if you do not want the specified item to be editable.
//
//    return YES;
//}
//
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//        if (editingStyle == UITableViewCellEditingStyleDelete) {
//
//            [self DeleteEmergencyList:indexPath];
//
////            NSMutableArray *oldArr=[[NSMutableArray alloc]initWithArray:[[messagesArr objectAtIndex:indexPath.section]objectForKey:@"Messages"]];
////            dinGInfo *dingur=[oldArr objectAtIndex:indexPath.row];
////            //BOOL dele=[[Database getSharedInstance]deleteMessageWhereId:dingur];
////            BOOL isChanged=NO;
////            [oldArr removeObjectAtIndex:indexPath.row];
////
////            NSDictionary *newDict=[[NSDictionary alloc]initWithObjectsAndKeys:[[messagesArr objectAtIndex:indexPath.section]objectForKey:@"Date"],@"Date",oldArr,@"Messages", nil];
////            [messagesArr replaceObjectAtIndex:indexPath.section withObject:newDict];
//
//            // [messagesArr removeObjectAtIndex:indexPath.row];
//        //
//        } else if (editingStyle == UITableViewCellEditingStyleInsert) {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
//        }
//
//
//}

- (IBAction)addContactButtonTapped:(id)sender {
    
    if ([UISuporterINApp isValidPhoneString:_emergencyContactNumberTextField.text]) {
        [self disableKeyboard];
        [self addEmergencyContact];
    }
    
}

- (void) addEmergencyContact {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.label.text = NSLocalizedString(@"Please Wait...", @"HUD loading title");
    NSMutableDictionary *parameter = [NSMutableDictionary new];
    
    [parameter setObject:[[SYUserDefault sharedManager] getAppToken] forKey:@"token"];
    [parameter setObject:_emergencyContactNumberTextField.text forKey:@"emergency_no"];
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        
        NSMutableDictionary *responceDict = [UserRunningServices addSomeOne:parameter witServiceName:@"addEmergencyNo"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
            
            if ([[responceDict objectForKey:@"status"] intValue] ==  200) {
                _emergencyContactNumberTextField.text = @"";
                _emergencyContectTableView.hidden = NO;
                [self getEmergencyList];

            } else {
                
                _emergencyContectTableView.hidden = YES;
            }
            
        });
    });
    
}


- (void) getEmergencyList {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.label.text = NSLocalizedString(@"Please Wait...", @"HUD loading title");
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        
        NSMutableDictionary *parameter = [NSMutableDictionary new];
        
        [parameter setObject:[[SYUserDefault sharedManager] getAppToken] forKey:@"token"];
        
        NSMutableDictionary *responceDict = [UserRunningServices getOtherServices:parameter witServiceName:@"getEmergencyNo"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
            
            if ([[responceDict objectForKey:@"status"] intValue] ==  200) {
                emergencyListArray = [[responceDict objectForKey:@"data"] mutableCopy];
                [self.emergencyContectTableView reloadData];
            } else {
                
            }
            
        });
    });
    
}



- (void) DeleteEmergencyList:(NSInteger)deleteIndex {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.label.text = NSLocalizedString(@"Please Wait...", @"HUD loading title");
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        
        NSMutableDictionary *parameter = [NSMutableDictionary new];
        NSDictionary *emergencyDict = [emergencyListArray objectAtIndex:deleteIndex];

        [parameter setObject:[[SYUserDefault sharedManager] getAppToken] forKey:@"token"];
        [parameter setObject:[emergencyDict objectForKey:@"emergency_no_id"] forKey:@"emergency_no_id"];
        
        NSMutableDictionary *responceDict = [UserRunningServices getOtherServices:parameter witServiceName:@"deleteEmergencyNo"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
            
            if ([[responceDict objectForKey:@"status"] intValue] ==  200) {
               // [self.emergencyContectTableView deleteRowsAtIndexPaths:@[deleteIndex] withRowAnimation:UITableViewRowAnimationFade];
                [emergencyListArray removeObjectAtIndex:deleteIndex];
                [self.emergencyContectTableView reloadData];
            } else {
                
            }
            
        });
    });
    
}

- (IBAction)ActionEmergencyDelete:(id)sender {
    UIButton *deleteButton = (UIButton*)sender;
    [self DeleteEmergencyList:deleteButton.tag];

}

-(void)callTheUser:(UITapGestureRecognizer*)tapped{
    UIImageView *v = (UIImageView*)tapped.view;
    NSDictionary *emergencyDict = [emergencyListArray objectAtIndex:v.tag];
    NSString *telStr = [NSString stringWithFormat:@"tel:%@",[emergencyDict objectForKey:@"emergency_no"]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telStr]];
}
@end
