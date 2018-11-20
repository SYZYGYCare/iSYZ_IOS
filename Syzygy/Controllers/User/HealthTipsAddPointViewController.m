//
//  HealthTipsAddPointViewController.m
//  Syzygy
//
//  Created by Kamal Gupta on 12/16/17.
//  Copyright © 2017 kamal gupta. All rights reserved.
//

#import "HealthTipsAddPointViewController.h"
#import "MBProgressHUD.h"
#import "Constant.h"
#import "SYUserDefault.h"
#import "UserLoginServices.h"
#import "HealthTipsTableViewCell.h"
#import "UserRunningServices.h"
#import "UIView+Toast.h"

@interface HealthTipsAddPointViewController ()

@end

@implementation HealthTipsAddPointViewController {
    
    NSMutableArray *healthSubCategoryArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self getHealthSubCategoryDetail];
    
    if (![[_subCoCatagoryDict objectForKey:@"image"] isKindOfClass:NULL] && ![[_subCoCatagoryDict objectForKey:@"image"] isKindOfClass:nil]) {
        NSString *url= [NSString stringWithFormat:@"%@%@" , kHealthBaseUrl , [_subCoCatagoryDict objectForKey:@"image"]];
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // retrive image on global queue
            UIImage * img = [UIImage imageWithData:[NSData dataWithContentsOfURL: [NSURL URLWithString:url]]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                _heathImage.image = img;
            });
        });
        
    }
    
    
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


#pragma mark - Table View Delegate



- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    
    return healthSubCategoryArray.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15;
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
    
    static NSString *tableViewCellIndetifier = @"HealthTipsCell2";
    HealthTipsTableViewCell *healthTipsTVCell = (HealthTipsTableViewCell*)[tableView dequeueReusableCellWithIdentifier: tableViewCellIndetifier];
    
    if (healthTipsTVCell == nil) {
        NSArray  *nib = [[NSBundle mainBundle] loadNibNamed:@"HealthTipsTableViewCell" owner:self options:nil];
        healthTipsTVCell = [nib objectAtIndex:1];
    }
    
    healthTipsTVCell.layer.cornerRadius = 5;
    healthTipsTVCell.layer.masksToBounds = YES;
    NSDictionary *healthTipsDict = [healthSubCategoryArray objectAtIndex:indexPath.section];
    
    healthTipsTVCell.healthTipsLabel.text = [self stringByStrippingHTML:healthTipsDict[@"point_name"]];
    
    healthTipsTVCell.healthTipsImageView.tag = indexPath.section;
    if ([healthTipsDict[@"status"] boolValue]) {
        healthTipsTVCell.healthTipsImageView.image = [UIImage imageNamed:@"like"];
        
    } else {
        healthTipsTVCell.healthTipsImageView.image = [UIImage imageNamed:@"unlike"];
        
    }
    
    healthTipsTVCell.healthTipsImageView.contentMode = UIViewContentModeScaleAspectFit;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addPoint:)];
    singleTap.numberOfTapsRequired = 1;
    [healthTipsTVCell.healthTipsImageView setUserInteractionEnabled:YES];
    [healthTipsTVCell.healthTipsImageView addGestureRecognizer:singleTap];
    
    healthTipsTVCell.accessoryType = UITableViewCellAccessoryNone;
    
    return healthTipsTVCell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (void)addPoint:(UITapGestureRecognizer *)sender {
    
    NSInteger selectedIndex = sender.view.tag;
    
    NSMutableDictionary *selectedDict = [[healthSubCategoryArray objectAtIndex:selectedIndex] mutableCopy];
    
    BOOL status = [selectedDict[@"status"] boolValue];
    [selectedDict setObject:[NSNumber numberWithBool:!status] forKey:@"status"];
    
    [healthSubCategoryArray replaceObjectAtIndex:selectedIndex withObject:selectedDict];
    
    [_healthPointTableView reloadData];
    
    
}

- (void) getHealthSubCategoryDetail {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.label.text = NSLocalizedString(@"Please Wait...", @"HUD loading title");
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        
        NSMutableDictionary *parameter = [NSMutableDictionary new];
        
        [parameter setObject:[[SYUserDefault sharedManager] getAppToken] forKey:@"token"];
        [parameter setObject:[_subCoCatagoryDict objectForKey:@"CoSubCategory_id"] forKey:@"CoSubCategory_id"];
        
        
        NSMutableDictionary *responceDict = [UserLoginServices getUserProperties:parameter withEndPoint:@"getHealthPoints"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
            
            if ([[responceDict objectForKey:@"status"] intValue] ==  200) {
                healthSubCategoryArray = [NSMutableArray new];
                healthSubCategoryArray = [[responceDict objectForKey:@"data"] mutableCopy];
                [_healthPointTableView reloadData];
                
            }
            
        });
    });
}
- (NSString *) stringByStrippingHTML: (NSString *)s {
    NSRange r;
    
    while ((r = [s rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        s = [s stringByReplacingCharactersInRange:r withString:@""];
    
    s = [s stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
    s = [s stringByReplacingOccurrencesOfString:@"&amp;" withString:@""];

    return s;
}

- (IBAction)addPointForHealth:(id)sender {
    
    NSString *pointIds = @"";
    for (NSDictionary *tempDict in healthSubCategoryArray) {
        
        if ([tempDict[@"status"] boolValue]) {
            pointIds = [NSString stringWithFormat:@"%@,%@", pointIds,tempDict[@"point_id"]];
        }
    }
    
    if (pointIds.length > 0) {
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        hud.label.text = NSLocalizedString(@"Please Wait...", @"HUD loading title");
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
            
            NSMutableDictionary *parameter = [NSMutableDictionary new];
            
            [parameter setObject:[[SYUserDefault sharedManager] getAppToken] forKey:@"token"];
            [parameter setObject:[_subCoCatagoryDict objectForKey:@"CoSubCategory_id"] forKey:@"CoSubCategory_id"];
            [parameter setObject:pointIds forKey:@"points_ids"];
            
            NSMutableDictionary *responceDict = [UserRunningServices addSomeOne:parameter witServiceName:@"addPoints"];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES];
                
                if ([[responceDict objectForKey:@"status"] intValue] ==  200) {
                   
                    [self.view makeToast:@"Point added sucessfully." duration:0.2 position:CSToastPositionCenter];
                    
                }
                
            });
        });

        
    }
    
    
}
@end
