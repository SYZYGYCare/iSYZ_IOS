//
//  CareGiverHiresViewController.m
//  Syzygy
//
//  Created by Kamal Gupta on 12/10/17.
//  Copyright © 2017 kamal gupta. All rights reserved.
//

#import "CareGiverHiresViewController.h"
#import "HiresListTableViewCell.h"
#import "MBProgressHUD.h"
#import "UserLoginServices.h"
#import "SYUserDefault.h"
#import "Constant.h"
#import "UserRunningServices.h"

@interface CareGiverHiresViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation CareGiverHiresViewController {
    NSArray *hireCareGiverList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Your Hire";
    
    if ([[[SYUserDefault sharedManager] getUserAuthorityId] intValue] == USER_TYPE) {
        self.tableTopHeight.constant = 0;
    }
    [self hireList];
    [self GetRremainingAmount];
    // Do any additional setup after loading the view.
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


#pragma mark - TableView Delegates

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return hireCareGiverList.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *tableViewCellIndetifier = @"HireListCell";
    HiresListTableViewCell *HiresTVCell = (HiresListTableViewCell*)[tableView dequeueReusableCellWithIdentifier: tableViewCellIndetifier];
    
    if (HiresTVCell == nil) {
        NSArray  *nib = [[NSBundle mainBundle] loadNibNamed:@"HiresListTableViewCell" owner:self options:nil];
        HiresTVCell = [nib objectAtIndex:0];
    }
    
    NSDictionary *listInfo = [hireCareGiverList objectAtIndex:indexPath.row];
    if (![listInfo[@"full_name"] isKindOfClass:[NSNull class]]) {
        HiresTVCell.nameLabel.text = [NSString stringWithFormat:@"Name: %@", listInfo[@"full_name"]];
    }
    if ([listInfo objectForKey:@"start_time"]) {
        HiresTVCell.startTimeLabel.text = [NSString stringWithFormat:@"Start Time : %@", listInfo[@"start_time"]];
    }else if (![listInfo[@"source"] isKindOfClass:[NSNull class]]) {
        HiresTVCell.startTimeLabel.text = [NSString stringWithFormat:@"Source : %@", listInfo[@"source"]];
    }
    if ([listInfo objectForKey:@"end_time"]) {
        HiresTVCell.endTimeLabel.text = [NSString stringWithFormat:@"End Time : %@", listInfo[@"end_time"]];
    }else if (![listInfo[@"destination"] isKindOfClass:[NSNull class]]) {
        HiresTVCell.endTimeLabel.text = [NSString stringWithFormat:@"Destination : %@", listInfo[@"destination"]];
    }
    if ([listInfo objectForKey:@"total_time"]) {
        HiresTVCell.totalLabel.text = [NSString stringWithFormat:@"Total time : %@", listInfo[@"total_time"]];
    }else if (![listInfo[@"total_kilometer"] isKindOfClass:[NSNull class]]) {
        HiresTVCell.totalLabel.text = [NSString stringWithFormat:@"Total Km : %@", listInfo[@"total_kilometer"]];
    }
    if (![listInfo[@"caregiver_id"] isKindOfClass:[NSNull class]]) {
        HiresTVCell.hireServiceId.text = [NSString stringWithFormat:@"Hired Service Id : %@", listInfo[@"caregiver_id"]];
    }
    if (![listInfo[@"amount"] isKindOfClass:[NSNull class]]) {
        HiresTVCell.amountLabel.text = [NSString stringWithFormat:@"₹ %@", listInfo[@"amount"]];
    }

    HiresTVCell.ratingReview.value = [listInfo[@"ratingReview"] floatValue];
    
    
    if (![[listInfo objectForKey:@"profile_pic"] isKindOfClass:[NSNull class]] && [listInfo objectForKey:@"profile_pic"]) {
        NSString *url= [NSString stringWithFormat:@"%@%@" , kProfileBaseUrl , [listInfo objectForKey:@"profile_pic"]];
        [HiresTVCell.profileImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"user"]];
    }
    
    return HiresTVCell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *listInfo = [hireCareGiverList objectAtIndex:indexPath.row];
    NSString *str;
    NSString *str2;
    if ([listInfo objectForKey:@"source"]) {
        str = [NSString stringWithFormat:@"Source : %@", listInfo[@"source"]];
    }
    if ([listInfo objectForKey:@"destination"]) {
        str2 = [NSString stringWithFormat:@"Destination : %@", listInfo[@"destination"]];
    }
    if ([listInfo objectForKey:@"start_time"]) {
        str = [NSString stringWithFormat:@"Start Time : %@", listInfo[@"start_time"]];
    }
    if ([listInfo objectForKey:@"end_time"]) {
        str2 = [NSString stringWithFormat:@"End Time : %@", listInfo[@"end_time"]];
    }
    CGSize size = [str sizeWithFont:[UIFont fontWithName:@"Helvetica" size:14] constrainedToSize:CGSizeMake(self.view.frame.size.width-150, 999) lineBreakMode:NSLineBreakByWordWrapping];
    CGSize size2 = [str2 sizeWithFont:[UIFont fontWithName:@"Helvetica" size:14] constrainedToSize:CGSizeMake(self.view.frame.size.width-150, 999) lineBreakMode:NSLineBreakByWordWrapping];

    NSLog(@"%f",size.height);
    if ([listInfo objectForKey:@"source"]) {
        return size.height + size2.height + 110;
    }else
    return size.height + size2.height + 120;
}

-(void) hireList {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.label.text = NSLocalizedString(@"Loading...", @"HUD loading title");
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        
        NSMutableDictionary *parameter = [NSMutableDictionary new];
        [parameter setObject:[[SYUserDefault sharedManager] getAppToken] forKey:@"token"];

        NSMutableDictionary *responceDict = [UserLoginServices hireCareGiverList:parameter];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
            NSLog(@"%@" , responceDict);

             if ([[responceDict objectForKey:@"message"] isEqualToString:@"success"]) {
                 
                 hireCareGiverList = [responceDict objectForKey:@"data"];
                 [_hireListTAbleView reloadData];
             }else if (([[responceDict objectForKey:@"message"] caseInsensitiveCompare:@"Token DoesN't Matched"] == NSOrderedSame) || ([[responceDict objectForKey:@"message"] caseInsensitiveCompare:@"Invalid Token"] == NSOrderedSame)) {
                 UIStoryboard *mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                 UINavigationController *mainContorller = [mainSB instantiateViewControllerWithIdentifier:@"loginNavigation"];
                 [UIApplication sharedApplication].delegate.window.rootViewController = mainContorller;
             }
            
        });
    });
    
    
}

-(void)GetRremainingAmount{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.label.text = NSLocalizedString(@"Please Wait...", @"HUD loading title");
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        
        NSMutableDictionary *parameter = [NSMutableDictionary new];
        
        [parameter setObject:[[SYUserDefault sharedManager] getAppToken] forKey:@"token"];
      
        NSMutableDictionary *responceDict = [UserRunningServices addSomeOne:parameter witServiceName:@"getCargiverRemainingPayment"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [hud hideAnimated:YES];
            
            if ([[responceDict objectForKey:@"status"] intValue] ==  200) {
                self.amountLabel.text = [NSString stringWithFormat:@"₹ %@ /-",[responceDict objectForKey:@"remaining amount"]];
             //amountLabel
            }
            
        });
    });
}

@end
