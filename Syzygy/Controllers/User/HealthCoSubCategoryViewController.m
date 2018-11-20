//
//  HealthCoSubCategoryViewController.m
//  Syzygy
//
//  Created by Kamal Gupta on 12/16/17.
//  Copyright © 2017 kamal gupta. All rights reserved.
//

#import "HealthCoSubCategoryViewController.h"
#import "MBProgressHUD.h"
#import "Constant.h"
#import "SYUserDefault.h"
#import "UserLoginServices.h"
#import "HealthTipsTableViewCell.h"
#import "HealthTipsAddPointViewController.h"

@interface HealthCoSubCategoryViewController ()

@end

@implementation HealthCoSubCategoryViewController {
    
    NSArray *healthCoSubCategoryArray;
    NSDictionary *coSubCategoryDict;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getHealthSubCategoryDetail];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    HealthTipsAddPointViewController *vc = segue.destinationViewController;
    vc.subCoCatagoryDict = [coSubCategoryDict mutableCopy];
    
}


#pragma mark - Table View Delegate



- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    
    return healthCoSubCategoryArray.count;
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
        NSArray  *nib = [[NSBundle mainBundle] loadNibNamed:@"HealthTipsTableViewCell" owner:self options:nil];
        healthTipsTVCell = [nib objectAtIndex:0];
    }
    
    healthTipsTVCell.layer.cornerRadius = 10;
    
    NSDictionary *healthTipsDict = [healthCoSubCategoryArray objectAtIndex:indexPath.section];
    
    healthTipsTVCell.healthTipsLabel.text = healthTipsDict[@"CoSubCategory_name"];
    
    
    if (![[healthTipsDict objectForKey:@"image"] isKindOfClass:[NSNull class]] && [healthTipsDict objectForKey:@"image"]) {
        NSString *url= [NSString stringWithFormat:@"%@%@" , kHealthBaseUrl , [healthTipsDict objectForKey:@"image"]];
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // retrive image on global queue
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
    
    coSubCategoryDict = [healthCoSubCategoryArray objectAtIndex:indexPath.section];
    
    [self performSegueWithIdentifier:@"addPointSegue" sender:self];
    
}



- (void) getHealthSubCategoryDetail {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.label.text = NSLocalizedString(@"Please Wait...", @"HUD loading title");
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        
        NSMutableDictionary *parameter = [NSMutableDictionary new];
        
        [parameter setObject:[[SYUserDefault sharedManager] getAppToken] forKey:@"token"];
        [parameter setObject:_subCoCatogaryId forKey:@"subCategory_id"];
        
        
        NSMutableDictionary *responceDict = [UserLoginServices getUserProperties:parameter withEndPoint:@"getHealthCoSubCategory"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
            
            if ([[responceDict objectForKey:@"status"] intValue] ==  200) {
                healthCoSubCategoryArray = [responceDict objectForKey:@"data"];
                [_coSubCategoryTableView reloadData];
                
            }
            
        });
    });
    
    
}


@end
