//
//  SeniorListViewController.m
//  Syzygy
//
//  Created by Kamal Gupta on 12/15/17.
//  Copyright © 2017 kamal gupta. All rights reserved.
//

#import "SeniorListViewController.h"
#import "SeniorListTableViewCell.h"
#import "SYUserDefault.h"
#import "UserLoginServices.h"
#import "MBProgressHUD.h"
#import "Constant.h"
#import "AddSeniorViewController.h"

@interface SeniorListViewController () <UITableViewDataSource, UITableViewDelegate,AddSeniorViewControllerDelegate>

@end

@implementation SeniorListViewController {
    
    NSMutableArray *seniorListArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.view.backgroundColor =  [UIColor colorWithPatternImage:[UIImage imageNamed:@"viewBg"]];
    self.title = @"Senior List";
    
    UIButton *itemBarButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    itemBarButton.frame = CGRectMake(0, 0, 30, 30);
    [itemBarButton setTitle:@"Add" forState:UIControlStateNormal];
    [itemBarButton.titleLabel setFont:[UIFont boldSystemFontOfSize:15.f]];
    [itemBarButton addTarget:self action:@selector(addSeniorList) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:itemBarButton];
    [_seniorListTableView setDelegate:self];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getSeniorList];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"addSeniorSegue"]) {
        AddSeniorViewController *addSenior = [segue destinationViewController];
        addSenior.delegate = self;
    }
}



#pragma mark - Table View Delegate

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return seniorListArray.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *tableViewCellIndetifier = @"seniorListCell";
    SeniorListTableViewCell *seniorListTVCell = (SeniorListTableViewCell*)[tableView dequeueReusableCellWithIdentifier: tableViewCellIndetifier];
    
    if (seniorListTVCell == nil) {
        seniorListTVCell = (SeniorListTableViewCell *)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableViewCellIndetifier];
    }
    
    seniorListTVCell.layer.cornerRadius = 10;
    
    
    NSDictionary *seniorListDict = [seniorListArray objectAtIndex:indexPath.row];
    
    if (![[seniorListDict objectForKey:@"profile_pic"] isKindOfClass:[NSNull class]] && ![[seniorListDict objectForKey:@"profile_pic"] isEqualToString:@""]) {
        
        NSString *url= [NSString stringWithFormat:@"%@%@" , kHealthBaseUrl , [seniorListDict objectForKey:@"profile_pic"]];
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            UIImage * img = [UIImage imageWithData:[NSData dataWithContentsOfURL: [NSURL URLWithString:url]]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                seniorListTVCell.profileImage.image = img;
            });
        });
        
    }
    
    
    if (![[seniorListDict objectForKey:@"senior_name"] isKindOfClass:[NSNull class]] && [seniorListDict objectForKey:@"senior_name"]) {
        
        seniorListTVCell.nameLabel.text = [seniorListDict objectForKey:@"senior_name"];
    }
    if (![[seniorListDict objectForKey:@"senior_age"] isKindOfClass:[NSNull class]] && [seniorListDict objectForKey:@"senior_age"]) {
        
        seniorListTVCell.ageLabel.text = [seniorListDict objectForKey:@"senior_age"];
    }
    if (![[seniorListDict objectForKey:@"senior_gender"] isKindOfClass:[NSNull class]] && [seniorListDict objectForKey:@"senior_gender"]) {
        
        seniorListTVCell.genderLabel.text = [seniorListDict objectForKey:@"senior_gender"];
    }
    if (![[seniorListDict objectForKey:@"description"] isKindOfClass:[NSNull class]] && [seniorListDict objectForKey:@"description"]) {
        
        seniorListTVCell.detailTextLabel.text = [seniorListDict objectForKey:@"description"];
    }
    if (![[seniorListDict objectForKey:@"senior_relation"] isKindOfClass:[NSNull class]] && [seniorListDict objectForKey:@"senior_relation"]) {
        
        seniorListTVCell.reletionShipLabel.text = [seniorListDict objectForKey:@"senior_relation"];
    }
    

    return seniorListTVCell;
}

#pragma mark - UITableView delegates

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_isAddSomeOne && [self.delegate respondsToSelector:@selector(didSelectSenior:)]) {
        [self.navigationController popViewControllerAnimated:YES];
        NSDictionary *seniorListDict = [seniorListArray objectAtIndex:indexPath.row];
        [self.delegate didSelectSenior:seniorListDict];
    }
}


- (void) getSeniorList {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.label.text = NSLocalizedString(@"Please Wait...", @"HUD loading title");
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        
        NSMutableDictionary *parameter = [NSMutableDictionary new];
        
        [parameter setObject:[[SYUserDefault sharedManager] getAppToken] forKey:@"token"];
        
        NSMutableDictionary *responceDict = [UserLoginServices getUserProperties:parameter withEndPoint:@"getSenior"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
            
            if ([[responceDict objectForKey:@"status"] intValue] ==  200) {
                NSArray *listArr = [responceDict objectForKey:@"data"];
                seniorListArray = [listArr mutableCopy];
                [_seniorListTableView reloadData];
            }else{
                _seniorListTableView.hidden = YES;
            }
            
        });
    });

}

- (void)addSeniorList {
    [self performSegueWithIdentifier:@"addSeniorSegue" sender:self];
}

#pragma mark - AddSenior Delegats

-(void)didAddSomeOne:(NSDictionary *)addedDic{
    [self getSeniorList];
}

@end
