//
//  SideMenuViewController.m
//  Syzygy
//
//  Created by kamal gupta on 11/29/17.
//  Copyright © 2017 kamal gupta. All rights reserved.
//

#import "SideMenuViewController.h"
#import "ToDoListViewController.h"
#import "MFSideMenu.h"
#import "ProfileViewInSliderMenuTableViewCell.h"
#import "menuTableViewCell.h"
#import "ProfileViewController.h"
#import "SettingsViewController.h"
#import "SYUserDefault.h"
#import "Constant.h"
#import "CareGiverHiresViewController.h"
#import "TrustBadgesViewController.h"
#import "RegisterForCareGiverOrAmbulanceViewController.h"
#import "CommonWebViewViewController.h"
#import "AccountInfoViewController.h"
#import "EmergencyContactViewController.h"
#import "SeniorListViewController.h"
#import "MBProgressHUD.h"
#import "UserRunningServices.h"
#import "UIView+Toast.h"
#import "ChangePasswordViewController.h"
#import "ReferEarnViewController.h"
#import "SupportViewController.h"
@interface SideMenuViewController ()<MFSideMenuContainerViewControllerDelegate>{
    BOOL isRegisterOpen;
    BOOL isSettingsOpen;
    NSArray *registerFor;
    NSArray *settingsArr;
}
@end

@implementation SideMenuViewController {
    NSArray *pageArrayList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.menuContainerViewController.delegate = self;
    settingsArr = @[@"Change Password"];
    if ([[[SYUserDefault sharedManager] getUserAuthorityId] intValue] == USER_TYPE) {
        pageArrayList = @[
                          @"Profile",
                          @"Hires Your Caregiver",
                          @"Your Hires",
                          @"Refer & Earn",
                          @"Emergency Contact",
                          @"Add Someone",
                          @"Support",
                          @"About",
                          @"Settings",
                          @"Privacy Policy",
                          @"Terms & Conditions",
                          @"Logout"
                          ];

    } else {
        if ([[[SYUserDefault sharedManager] getCareGiverType] isEqualToString:@""]) {
            registerFor = @[@"Ambulance",@"Caregiver"];
        }else if ([[[SYUserDefault sharedManager] getCareGiverType] isEqualToString:@"1"]){
            registerFor = @[@"Caregiver"];
        }else{
            registerFor = @[@"Ambulance"];
        }
        
        pageArrayList = @[
                          @"Profile",
                          @"Home",
                          @"Register For",
                          @"Your Hires",
                          @"Settings",
                          @"Account Details",
                          @"Trust Badges",
                          @"About",
                          @"Privacy Policy",
                          @"Terms & Conditions",
                          @"Logout"
                          ];

    }
    
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated ];
    [self.tableView reloadData];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return pageArrayList.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        
        return 120;
    }
    
    return 50;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([[pageArrayList objectAtIndex:section] isEqualToString:@"Register For"] && isRegisterOpen) {
        return registerFor.count+1;
    }else  if ([[pageArrayList objectAtIndex:section] isEqualToString:@"Settings"] && isSettingsOpen) {
        return settingsArr.count+1;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    if (indexPath.section == 0 ) {
        
        static NSString *CellIdentifier = @"profileCell";

        ProfileViewInSliderMenuTableViewCell *profileCell = (ProfileViewInSliderMenuTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (profileCell == nil) {
            
            
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ProfileViewInSliderMenuTableViewCell" owner:self options:nil];
            profileCell = (ProfileViewInSliderMenuTableViewCell*)[nib objectAtIndex: 0];
        }
        if ([[[SYUserDefault sharedManager] getUserAuthorityId] intValue] == USER_TYPE) {
            profileCell.mobileNumberLabel.text = [NSString stringWithFormat:@"%@",[[SYUserDefault sharedManager] getUserNumber]];
            
            profileCell.nameLabel.textColor = USER_COLOR;
            profileCell.mobileNumberLabel.textColor = USER_COLOR;
            [profileCell.editProfileButton setTitleColor:USER_COLOR forState:UIControlStateNormal];
            profileCell.lineLab.backgroundColor = USER_COLOR;
        }else{
            profileCell.mobileNumberLabel.textColor = CAREGIVER_COLOR;
            profileCell.nameLabel.textColor = CAREGIVER_COLOR;
            [profileCell.editProfileButton setTitleColor:CAREGIVER_COLOR forState:UIControlStateNormal];
            profileCell.lineLab.backgroundColor = CAREGIVER_COLOR;
        }
        profileCell.nameLabel.text = [[SYUserDefault sharedManager] getUserName];
        profileCell.profileImage.layer.cornerRadius = profileCell.profileImage.frame.size.height/2;
        profileCell.profileImage.layer.masksToBounds = YES;
        profileCell.profileImage.hidden = YES;
        for (UIView *ImV in profileCell.subviews) {
            if (ImV.tag == 100) {
                [ImV removeFromSuperview];
                break;
            }
        }
        UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(10, 20, 80, 80 )];
        imageV.tag = 100;
        
        [profileCell addSubview:imageV];
       // NSLog(@"%@",profileCell.profileImage);
        if ([[SYUserDefault sharedManager] getProfilePic]) {
            
            NSString *url= [NSString stringWithFormat:@"%@%@" , kProfileBaseUrl , [[SYUserDefault sharedManager] getProfilePic]];
            [imageV sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"user"]];
            imageV.layer.cornerRadius = imageV.frame.size.width/2;
            imageV.layer.masksToBounds = YES;
        /*dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                UIImage * img = [UIImage imageWithData:[NSData dataWithContentsOfURL: [NSURL URLWithString:url]]];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    profileCell.profileImage.image = img;
                });
            });*/
        }
      //
        imageV.layer.cornerRadius = imageV.frame.size.width/2;
        imageV.layer.masksToBounds = YES;
        return profileCell;
        
    }
    
     NSString *CellIdentifier = @"menuCell";
    NSInteger index = 0;
    if ([[pageArrayList objectAtIndex:indexPath.section] isEqualToString:@"Register For"] && isRegisterOpen && indexPath.row !=0) {
        CellIdentifier = @"menuCell2";
        index = 1;
    }
    else if ([[pageArrayList objectAtIndex:indexPath.section] isEqualToString:@"Settings"] && isSettingsOpen && indexPath.row !=0) {
        CellIdentifier = @"menuCell2";
        index = 1;
    }
    menuTableViewCell *cell = (menuTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"menuTableViewCell" owner:self options:nil];
        cell = (menuTableViewCell*)[nib objectAtIndex: index];
    }
    cell.exapand.hidden = YES;
    cell.menuTitleLable.text = [pageArrayList objectAtIndex:indexPath.section];

    if ([[pageArrayList objectAtIndex:indexPath.section] isEqualToString:@"Home"]) {
       
        cell.menuImageView.image = [UIImage imageNamed:@"home"];
        
        
    }else if ([[pageArrayList objectAtIndex:indexPath.section] isEqualToString:@"About"]) {
        if ([[[SYUserDefault sharedManager] getUserAuthorityId] intValue] == USER_TYPE) {
            
            cell.menuImageView.image = [UIImage imageNamed:@"icon_About_User"];
        } else {
            cell.menuImageView.image = [UIImage imageNamed:@"Icon_About"];
        }
        
    } else  if ([[pageArrayList objectAtIndex:indexPath.section] isEqualToString:@"Register For"]) {
        //close  expand

        if (indexPath.row == 0) {
            cell.menuImageView.image = [UIImage imageNamed:@"profile"];
            cell.exapand.hidden = NO;
            if (isRegisterOpen) {
                cell.exapand.image = [UIImage imageNamed:@"close"];
            }else{
                cell.exapand.image = [UIImage imageNamed:@"expand"];
            }
        }else{
            
            cell.menuTitleLable.text = [registerFor objectAtIndex:indexPath.row-1];
            if ([[registerFor objectAtIndex:indexPath.row-1] isEqualToString:@"Ambulance"]) {
                cell.menuImageView.image = [UIImage imageNamed:@"Ambulance1"];
            }else{
                cell.menuImageView.image = [UIImage imageNamed:[registerFor objectAtIndex:indexPath.row-1]];
            }
        }
       
    } else  if ([[pageArrayList objectAtIndex:indexPath.section] isEqualToString:@"Your Hires"]) {
         if ([[[SYUserDefault sharedManager] getUserAuthorityId] intValue] == USER_TYPE) {\
             cell.menuImageView.image = [UIImage imageNamed:@"icon_yourHires"];
         } else {
             cell.menuImageView.image = [UIImage imageNamed:@"icon_hireing"];
         }
        
    } else  if ([[pageArrayList objectAtIndex:indexPath.section] isEqualToString:@"Settings"]) {
        if (indexPath.row == 0) {
            cell.exapand.hidden = NO;
            if ([[[SYUserDefault sharedManager] getUserAuthorityId] intValue] == USER_TYPE) {
                cell.menuImageView.image = [UIImage imageNamed:@"icon_setting_user"];
            } else {
                cell.menuImageView.image = [UIImage imageNamed:@"icon_settings"];
            }
            if (isSettingsOpen) {
                cell.exapand.image = [UIImage imageNamed:@"close"];
            }else{
                cell.exapand.image = [UIImage imageNamed:@"expand"];
            }
        }else{
            
            cell.menuTitleLable.text = [settingsArr objectAtIndex:indexPath.row-1];
            if ([[[SYUserDefault sharedManager] getUserAuthorityId] intValue] == USER_TYPE) {
                cell.menuImageView.image = [UIImage imageNamed:@"lock_red"];
            } else {
                cell.menuImageView.image = [UIImage imageNamed:[settingsArr objectAtIndex:indexPath.row-1]];
            }
        }
    } else  if ([[pageArrayList objectAtIndex:indexPath.section] isEqualToString:@"Account Details"]) {
        cell.menuImageView.image = [UIImage imageNamed:@"icon_hireing"];
    } else  if ([[pageArrayList objectAtIndex:indexPath.section] isEqualToString:@"Trust Badges"]) {
        cell.menuImageView.image = [UIImage imageNamed:@"icon_trust"];
    } else  if ([[pageArrayList objectAtIndex:indexPath.section] isEqualToString:@"Privacy Policy"]) {
        /*policy_user.png
         terms_user.png*/
        if ([[[SYUserDefault sharedManager] getUserAuthorityId] intValue] == USER_TYPE) {
            cell.menuImageView.image = [UIImage imageNamed:@"policy_user"];
        }else
            cell.menuImageView.image = [UIImage imageNamed:@"policy"];
    } else  if ([[pageArrayList objectAtIndex:indexPath.section] isEqualToString:@"Terms & Conditions"]) {
        if ([[[SYUserDefault sharedManager] getUserAuthorityId] intValue] == USER_TYPE) {
            cell.menuImageView.image = [UIImage imageNamed:@"terms_user"];
        }else
        cell.menuImageView.image = [UIImage imageNamed:@"termAndCondition"];
    } else  if ([[pageArrayList objectAtIndex:indexPath.section] isEqualToString:@"Logout"]) {
        if ([[[SYUserDefault sharedManager] getUserAuthorityId] intValue] == USER_TYPE) {
            cell.menuImageView.image = [UIImage imageNamed:@"icon_logout"];
        } else {
            cell.menuImageView.image = [UIImage imageNamed:@"icon_Logout_caregiver"];
        }
    } else  if ([[pageArrayList objectAtIndex:indexPath.section] isEqualToString:@"Hires Your Caregiver"]) {
        
        cell.menuImageView.image = [UIImage imageNamed:@"user_hire"];
    } else  if ([[pageArrayList objectAtIndex:indexPath.section] isEqualToString:@"Refer & Earn"]) {
         cell.menuImageView.image = [UIImage imageNamed:@"icon_refer"];
    } else  if ([[pageArrayList objectAtIndex:indexPath.section] isEqualToString:@"Emergency Contact"]) {
        cell.menuImageView.image = [UIImage imageNamed:@"icon_emergency"];
    } else  if ([[pageArrayList objectAtIndex:indexPath.section] isEqualToString:@"Add Someone"]) {
        cell.menuImageView.image = [UIImage imageNamed:@"icon_refer"];
    } else  if ([[pageArrayList objectAtIndex:indexPath.section] isEqualToString:@"Support"]) {
        cell.menuImageView.image = [UIImage imageNamed:@"icon_support"];
    } else  if ([[pageArrayList objectAtIndex:indexPath.section] isEqualToString:@"Add Someone"]) {
        cell.menuImageView.image = [UIImage imageNamed:@"icon_refer"];
    }
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        
        ProfileViewController *profileVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
        UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
        [navigationController pushViewController:profileVC animated:YES];
        [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];

    } else {
        
        
        NSString *pageName = [pageArrayList objectAtIndex:indexPath.section];
        
        if ([pageName isEqualToString:@"Settings"]) {
            if (indexPath.row == 0) {
                isSettingsOpen = !isSettingsOpen;
                [tableView reloadData];
            }else{
                ChangePasswordViewController *settingsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ChangePasswordViewController"];
                
                UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
                [navigationController pushViewController:settingsVC animated:YES];
                [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];

            }
            
            
        } else if ([pageName isEqualToString:@"Your Hires"]) {
            
            CareGiverHiresViewController *settingsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CareGiverHiresViewController"];
            
            UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
            [navigationController pushViewController:settingsVC animated:YES];
            [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];

        } else if ([pageName isEqualToString:@"Trust Badges"]) {
            
            TrustBadgesViewController *settingsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TrustBadgesViewController"];
            
            UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
            [navigationController pushViewController:settingsVC animated:YES];
            [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];

        } else if ([pageName isEqualToString:@"Register For"]) {
        
            if (indexPath.row == 0) {
                isRegisterOpen = !isRegisterOpen;
                [tableView reloadData];
            }else{
                BOOL isAmbulance = NO;
                if ([[registerFor objectAtIndex:indexPath.row-1] isEqualToString:@"Ambulance"]) {
                    isAmbulance = YES;
                }
                RegisterForCareGiverOrAmbulanceViewController *settingsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"RegisterForCareGiverOrAmbulanceViewController"];
                settingsVC.isAmbulance = isAmbulance;
                UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
                [navigationController pushViewController:settingsVC animated:YES];
                [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];

            }

        } else if ([pageName isEqualToString:@"About"] || [pageName isEqualToString:@"Privacy Policy"] ||[pageName isEqualToString:@"Terms & Conditions"] ) {
            
            CommonWebViewViewController *settingsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CommonWebViewViewController"];
            settingsVC.pageName = pageName;
            
            UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
            [navigationController pushViewController:settingsVC animated:YES];
            [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
//
        }else if ([pageName isEqualToString:@"Support"]) {
            SupportViewController *settingsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SupportViewController"];
            
            UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
            [navigationController pushViewController:settingsVC animated:YES];
            [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
            
        } else if ([pageName isEqualToString:@"Account Details"]) {
            AccountInfoViewController *settingsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AccountInfoViewController"];
            UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
            [navigationController pushViewController:settingsVC animated:YES];
            [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
        } else if ([pageName isEqualToString:@"Emergency Contact"]) {
            
            EmergencyContactViewController *settingsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"EmergencyContactViewController"];
            
            UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
            [navigationController pushViewController:settingsVC animated:YES];
            [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];

        } else if ([pageName isEqualToString:@"Add Someone"]) {
            
            SeniorListViewController *AddSeniorVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SeniorListViewController"];
            
            UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
            [navigationController pushViewController:AddSeniorVC animated:YES];
            [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];

        } else if ([pageName isEqualToString:@"Logout"]) {
            
            UIAlertController *Alert = [UIAlertController alertControllerWithTitle:@"Confirmation!" message:@"Are you sure? You want to Logout" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"CANCEL" style:UIAlertActionStyleDefault handler:nil];
            [Alert addAction:cancel];
            
            UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"CONFIRM" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self logout];
                [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
            }];
            [Alert addAction:confirm];
            
            [self presentViewController:Alert animated:YES completion:nil];
            //[self logout];

        } else  if ([[pageArrayList objectAtIndex:indexPath.section] isEqualToString:@"Refer & Earn"]) {
            ReferEarnViewController *AddSeniorVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ReferEarnViewController"];
            
            UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
            [navigationController pushViewController:AddSeniorVC animated:YES];
            [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];

        }else {
            
            [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];

//            ToDoListViewController *demoViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"toDoListViewController"];
//            
//            UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
//            [navigationController pushViewController:demoViewController animated:YES];
        }
        
        
        
    }
    

    
}

- (void)logout{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.label.text = NSLocalizedString(@"Please Wait...", @"HUD loading title");
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        
        NSMutableDictionary *parameter = [NSMutableDictionary new];
        
        [parameter setObject:[[SYUserDefault sharedManager] getAppToken] forKey:@"token"];
        
        NSMutableDictionary *responceDict = [UserRunningServices addSomeOne:parameter witServiceName:@"logout"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [hud hideAnimated:YES];
            
            if ([[responceDict objectForKey:@"status"] intValue] ==  200) {
                
                [[SYUserDefault sharedManager] removeUserDefaultValue];
                
                UIStoryboard *mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                UINavigationController *mainContorller = [mainSB instantiateViewControllerWithIdentifier:@"loginNavigation"];
                [UIApplication sharedApplication].delegate.window.rootViewController = mainContorller;

            }else if (([[responceDict objectForKey:@"message"] caseInsensitiveCompare:@"Token DoesN't Matched"] == NSOrderedSame) || ([[responceDict objectForKey:@"message"] caseInsensitiveCompare:@"Invalid Token"] == NSOrderedSame)) {
                UIStoryboard *mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                UINavigationController *mainContorller = [mainSB instantiateViewControllerWithIdentifier:@"loginNavigation"];
                [UIApplication sharedApplication].delegate.window.rootViewController = mainContorller;
            } else {
                //Token Doesn't matched
                [self.view makeToast:@"Seems to something wrong, Please try again" duration:0.5 position:CSToastPositionCenter];
            }
            
        });
    });
}

-(void)didMenuOpened:(BOOL)open{
    if (open) {
        settingsArr = @[@"Change Password"];
        if ([[[SYUserDefault sharedManager] getUserAuthorityId] intValue] == USER_TYPE) {
            pageArrayList = @[
                              @"Profile",
                              @"Hires Your Caregiver",
                              @"Your Hires",
                              @"Refer & Earn",
                              @"Emergency Contact",
                              @"Add Someone",
                              @"Support",
                              @"About",
                              @"Settings",
                              @"Privacy Policy",
                              @"Terms & Conditions",
                              @"Logout"
                              ];
            
        } else {
            if ([[[SYUserDefault sharedManager] getCareGiverType] isEqualToString:@""]) {
                registerFor = @[@"Ambulance",@"Caregiver"];
            }else if ([[[SYUserDefault sharedManager] getCareGiverType] isEqualToString:@"1"]){
                registerFor = @[@"Caregiver"];
            }else{
                registerFor = @[@"Ambulance"];
            }
            
            pageArrayList = @[
                              @"Profile",
                              @"Home",
                              @"Register For",
                              @"Your Hires",
                              @"Settings",
                              @"Account Details",
                              @"Trust Badges",
                              @"About",
                              @"Privacy Policy",
                              @"Terms & Conditions",
                              @"Logout"
                              ];
            
        }
        [self.tableView reloadData];
    }
}

@end
