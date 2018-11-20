//
//  HealthTipsListViewController.m
//  Syzygy
//
//  Created by Kamal Gupta on 12/15/17.
//  Copyright © 2017 kamal gupta. All rights reserved.
//

#import "HealthTipsListViewController.h"
#import "HealthTipsTableViewCell.h"
#import "MBProgressHUD.h"
#import "SYUserDefault.h"
#import "Constant.h"
#import "UserLoginServices.h"
#import "HealthTipsDetailViewController.h"

@interface HealthTipsListViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation HealthTipsListViewController {
    
    NSArray *healthTipsArray;
    NSString *category_id;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Health Tips";
    self.automaticallyAdjustsScrollViewInsets = NO;
    // Do any additional setup after loading the view.
    
    if (_isReminder) {
        self.title = @"To Do";

        [self getHealthPoints];

    } else {
        [self getHealthTips];

    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    HealthTipsDetailViewController *vc = segue.destinationViewController;
    vc.sub_category_id = category_id;
    
}

#pragma mark - Table View Delegate



- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    
    return healthTipsArray.count;
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
    return 60;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *tableViewCellIndetifier = @"HealthTipsCell";
    if (_isReminder) {
        tableViewCellIndetifier = @"HealthTipsCell2";
    }
    HealthTipsTableViewCell *healthTipsTVCell = (HealthTipsTableViewCell*)[tableView dequeueReusableCellWithIdentifier: tableViewCellIndetifier];
    
    if (healthTipsTVCell == nil) {
        //HealthTipsCell2
       
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HealthTipsTableViewCell" owner:self options:nil];
        if (_isReminder) {
            healthTipsTVCell = [nib objectAtIndex:1];
        }else
            healthTipsTVCell = [nib objectAtIndex:0];
    }
    
    healthTipsTVCell.layer.cornerRadius = 10;
    
    NSDictionary *healthTipsDict = [healthTipsArray objectAtIndex:indexPath.section];
    if (_isReminder) {

        healthTipsTVCell.healthTipsLabel.text =   [[NSAttributedString alloc] initWithData:[[healthTipsDict objectForKey:@"point_name"] dataUsingEncoding:NSUTF8StringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: [NSNumber numberWithInt:NSUTF8StringEncoding]} documentAttributes:nil error:nil].string;
        healthTipsTVCell.healthTipsImageView.image = [UIImage imageNamed:@"ic_chacked"];
    }else{
        healthTipsTVCell.healthTipsLabel.text = [healthTipsDict objectForKey:@"category_name"];
        
        if (![[healthTipsDict objectForKey:@"image"] isKindOfClass:[NSNull class]] && [healthTipsDict objectForKey:@"image"]) {
            NSString *url= [NSString stringWithFormat:@"%@%@" , kHealthBaseUrl , [healthTipsDict objectForKey:@"image"]];
            
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                UIImage * img = [UIImage imageWithData:[NSData dataWithContentsOfURL: [NSURL URLWithString:url]]];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    healthTipsTVCell.healthTipsImageView.image = img;
                });
            });
            
        }
        
        healthTipsTVCell.healthTipsImageView.layer.cornerRadius = 27.5;
        healthTipsTVCell.healthTipsImageView.clipsToBounds = YES;
        
        
        healthTipsTVCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return healthTipsTVCell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (!_isReminder) {
        NSDictionary *healthDict = [healthTipsArray objectAtIndex:indexPath.section];
        category_id = [healthDict objectForKey:@"category_id"];
        [self performSegueWithIdentifier:@"healthDetailSegue" sender:self];
    }

}


#pragma mark  - APIs

- (void) getHealthTips {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.label.text = NSLocalizedString(@"Please Wait...", @"HUD loading title");
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        
        NSMutableDictionary *parameter = [NSMutableDictionary new];
        
        [parameter setObject:[[SYUserDefault sharedManager] getAppToken] forKey:@"token"];
        
        NSMutableDictionary *responceDict = [UserLoginServices getUserProperties:parameter withEndPoint:@"getHealthCategory"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
            
            if ([[responceDict objectForKey:@"status"] intValue] ==  200) {
                healthTipsArray = [responceDict objectForKey:@"data"];
                [_healthTipsTableView reloadData];
                
            }
            
        });
    });
}


- (void)getHealthPoints {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.label.text = NSLocalizedString(@"Please Wait...", @"HUD loading title");
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        
        NSMutableDictionary *parameter = [NSMutableDictionary new];
        
        [parameter setObject:[[SYUserDefault sharedManager] getAppToken] forKey:@"token"];
        
        NSMutableDictionary *responceDict = [UserLoginServices GetCheckList:parameter];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
            
            if ([[responceDict objectForKey:@"status"] intValue] ==  200) {
                healthTipsArray = [responceDict objectForKey:@"data"];
                [_healthTipsTableView reloadData];
            }
        });
    });
    
}

@end
