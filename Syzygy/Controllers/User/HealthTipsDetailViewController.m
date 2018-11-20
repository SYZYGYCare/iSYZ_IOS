//
//  HealthTipsDetailViewController.m
//  Syzygy
//
//  Created by Kamal Gupta on 12/15/17.
//  Copyright © 2017 kamal gupta. All rights reserved.
//

#import "HealthTipsDetailViewController.h"
#import "MBProgressHUD.h"
#import "Constant.h"
#import "SYUserDefault.h"
#import "UserLoginServices.h"
#import "HealthTipsTableViewCell.h"
#import "HealthCoSubCategoryViewController.h"

@interface HealthTipsDetailViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation HealthTipsDetailViewController {
    
    NSArray *healthSubCategoryArray;
    NSString *subCatagoryId;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Health Tips Details";
    self.automaticallyAdjustsScrollViewInsets = NO;

    [self getHealthSubCategory];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    HealthCoSubCategoryViewController *vc= segue.destinationViewController;
    vc.subCoCatogaryId = subCatagoryId;
}


#pragma mark - Table View Delegate



- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    
    return healthSubCategoryArray.count;
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
    HealthTipsTableViewCell *healthTipsTVCell = (HealthTipsTableViewCell*)[tableView dequeueReusableCellWithIdentifier: tableViewCellIndetifier];
    
    if (healthTipsTVCell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HealthTipsTableViewCell" owner:self options:nil];
        healthTipsTVCell = [nib objectAtIndex:0];
    }
    
    healthTipsTVCell.layer.cornerRadius = 10;
    
    NSDictionary *healthTipsDict = [healthSubCategoryArray objectAtIndex:indexPath.section];
    healthTipsTVCell.healthTipsLabel.text = [healthTipsDict objectForKey:@"subCategory_name"];
    
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
    
    return healthTipsTVCell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *healthDict = [healthSubCategoryArray objectAtIndex:indexPath.section];
    subCatagoryId = [healthDict objectForKey:@"subCategory_id"];
    
    [self performSegueWithIdentifier:@"coSubCategorySegue" sender:self];
    
}


- (void) getHealthSubCategory {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.label.text = NSLocalizedString(@"Please Wait...", @"HUD loading title");
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        
        NSMutableDictionary *parameter = [NSMutableDictionary new];
        
        [parameter setObject:[[SYUserDefault sharedManager] getAppToken] forKey:@"token"];
        [parameter setObject:_sub_category_id forKey:@"category_id"];
        
        
        NSMutableDictionary *responceDict = [UserLoginServices getUserProperties:parameter withEndPoint:@"getHealthSubCategory"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
            
            if ([[responceDict objectForKey:@"status"] intValue] ==  200) {
                healthSubCategoryArray = [responceDict objectForKey:@"data"];
                [_healthTipsDetailTableView reloadData];
                
            }
            
        });
    });
    
    
}

@end
