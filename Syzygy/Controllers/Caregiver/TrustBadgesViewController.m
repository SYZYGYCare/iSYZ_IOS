//
//  TrustBadgesViewController.m
//  Syzygy
//
//  Created by Kamal Gupta on 12/10/17.
//  Copyright © 2017 kamal gupta. All rights reserved.
//

#import "TrustBadgesViewController.h"
#import "menuTableViewCell.h"
#import "UISuporterINApp.h"
#import "MBProgressHUD.h"
#import "SYUserDefault.h"
#import "UserLoginServices.h"
#import "Constant.h"
#import "UserRunningServices.h"
@interface TrustBadgesViewController ()<UITableViewDataSource, UITableViewDelegate>{
    NSArray *trustBadgesArr;
    NSDictionary *trustBadges;
}

@end

@implementation TrustBadgesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   // trustBadgesArr = @[@"Verify Mobile No.",@"Verify Email Id",@"Account(Bank Info)",@"Document Verification",@"Profile Picture",@"Social Links"];
    trustBadgesArr = @[@"Verify Mobile No.",@"Verify Email Id",@"Account(Bank Info)",@"Document Verification",@"Profile Picture"];
    self.title = @"Trust Badges";
    
    [self getTrustBadges];
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
    return trustBadgesArr.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *tableViewCellIndetifier = @"menuCell";
    menuTableViewCell *cell = (menuTableViewCell*)[tableView dequeueReusableCellWithIdentifier:tableViewCellIndetifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"menuTableViewCell" owner:self options:nil];
        cell = (menuTableViewCell*)[nib objectAtIndex: 0];
    }
    
    cell.menuTitleLable.text = [trustBadgesArr objectAtIndex:indexPath.row];
    cell.exapand.image = [UIImage imageNamed:@"close-button"];
    cell.exapand.hidden = NO;
    
    switch (indexPath.row) {
        case 0:
            cell.menuImageView.image = [UIImage imageNamed:@"smartphone"];
            if ([[trustBadges objectForKey:@"no_verified"] intValue] == 1) {
                cell.exapand.image = [UIImage imageNamed:@"checked"];
            }
            break;
        case 1:
            cell.menuImageView.image = [UIImage imageNamed:@"gmail"];
            if ([[trustBadges objectForKey:@"email_verified"] intValue] == 1) {
                cell.exapand.image = [UIImage imageNamed:@"checked"];
            }
            break;
        case 2:
            cell.menuImageView.image = [UIImage imageNamed:@"museum"];
            if ([[trustBadges objectForKey:@"bank_verified"] intValue] == 1) {
                cell.exapand.image = [UIImage imageNamed:@"checked"];
            }
            break;
        case 3:
            cell.menuImageView.image = [UIImage imageNamed:@"tags"];
            if ([[trustBadges objectForKey:@"police_verified"] intValue] == 1) {
                cell.exapand.image = [UIImage imageNamed:@"checked"];
            }
            break;
        case 4:
            cell.menuImageView.image = [UIImage imageNamed:@"image"];
            if ([[trustBadges objectForKey:@"profile_pic_verified"] intValue] == 1) {
                cell.exapand.image = [UIImage imageNamed:@"checked"];
            }
            break;
        case 5:
            cell.menuImageView.image = [UIImage imageNamed:@"share"];
            if ([[trustBadges objectForKey:@"social_link_verified"] intValue] == 1) {
                cell.exapand.image = [UIImage imageNamed:@"checked"];
            }
            break;
        default:
            break;
    }
   
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (void) getTrustBadges {
    
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.label.text = NSLocalizedString(@"Please Wait...", @"HUD loading title");
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        
        NSMutableDictionary *parameter = [NSMutableDictionary new];
        
        [parameter setObject:[[SYUserDefault sharedManager] getAppToken] forKey:@"token"];
       [parameter setObject: [[SYUserDefault sharedManager] getUserAuthorityId] forKey:@"authority_id"];
        NSLog(@"Parameter : %@" , parameter);
        NSMutableDictionary *responceDict = [UserLoginServices TrustBadges:parameter];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
            
            NSLog(@"%@" , responceDict);
            
            if ([[responceDict objectForKey:@"message"] isEqualToString:@"success"]) {
                trustBadges = [responceDict objectForKey:@"data"];
                //[self setUI:[responceDict objectForKey:@"data"]];
                [self.trustBadgesTableView reloadData];
            }else if (([[responceDict objectForKey:@"message"] caseInsensitiveCompare:@"Token DoesN't Matched"] == NSOrderedSame) || ([[responceDict objectForKey:@"message"] caseInsensitiveCompare:@"Invalid Token"] == NSOrderedSame)) {
                UIStoryboard *mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                UINavigationController *mainContorller = [mainSB instantiateViewControllerWithIdentifier:@"loginNavigation"];
                [UIApplication sharedApplication].delegate.window.rootViewController = mainContorller;
            } else {
                
                [self presentViewController:[UISuporterINApp generateAlert:[responceDict objectForKey:@"message"]] animated:YES completion:nil];
            }
            
        });
    });
}


@end
