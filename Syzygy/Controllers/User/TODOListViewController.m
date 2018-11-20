//
//  TODOListViewController.m
//  Syzygy
//
//  Created by Kamal Gupta on 12/24/17.
//  Copyright © 2017 kamal gupta. All rights reserved.
//

#import "TODOListViewController.h"
#import "HealthTipsTableViewCell.h"
#import "UserRunningServices.h"
#import "MBProgressHUD.h"
#import "SYUserDefault.h"


@interface TODOListViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation TODOListViewController {
    
    NSArray *todoListArray;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"To Do List";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self getTODOList];
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


- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    
    return todoListArray.count;
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
    
    NSDictionary *healthTipsDict = [todoListArray objectAtIndex:indexPath.section];
    healthTipsTVCell.healthTipsLabel.text = [healthTipsDict objectForKey:@"category_name"];
    
    healthTipsTVCell.healthTipsImageView.image = [UIImage imageNamed:@""];
    
    healthTipsTVCell.accessoryType = UITableViewCellAccessoryNone;
    
    return healthTipsTVCell;
}


#pragma mark  - APIs

- (void) getTODOList {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.label.text = NSLocalizedString(@"Please Wait...", @"HUD loading title");
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        
        NSMutableDictionary *parameter = [NSMutableDictionary new];
        
        [parameter setObject:[[SYUserDefault sharedManager] getAppToken] forKey:@"token"];
        
        NSMutableDictionary *responceDict = [UserRunningServices getOtherServices:parameter witServiceName:@""];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
            
            if ([[responceDict objectForKey:@"status"] intValue] ==  200) {
                
            }
        });
    });
}

@end
