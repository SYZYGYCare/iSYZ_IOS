//
//  ReferEarnViewController.m
//  Syzygy
//
//  Created by manisha panse on 1/14/18.
//  Copyright © 2018 kamal gupta. All rights reserved.
//

#import "ReferEarnViewController.h"
#import "UISuporterINApp.h"
#import "MBProgressHUD.h"
#import "SYUserDefault.h"
#import "UserLoginServices.h"
#import "Constant.h"
#import "UserRunningServices.h"

@interface ReferEarnViewController ()

@end

@implementation ReferEarnViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Refer & Earn";
    // Do any additional setup after loading the view.
    [self getReferCode];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    CAShapeLayer *yourViewBorder = [CAShapeLayer layer];
    yourViewBorder.strokeColor = [UIColor blackColor].CGColor;
    yourViewBorder.fillColor = nil;
    yourViewBorder.lineDashPattern = @[@4, @4];
    yourViewBorder.frame = self.referCode.bounds;
    yourViewBorder.path = [UIBezierPath bezierPathWithRect:self.referCode.bounds].CGPath;
    [self.referCode.layer addSublayer:yourViewBorder];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (void) getReferCode {
    
    
    
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.label.text = NSLocalizedString(@"Please Wait...", @"HUD loading title");
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        
        NSMutableDictionary *parameter = [NSMutableDictionary new];
        
        [parameter setObject:[[SYUserDefault sharedManager] getAppToken] forKey:@"token"];
        [parameter setObject: [[SYUserDefault sharedManager] getUserAuthorityId] forKey:@"authority_id"];
        
        NSLog(@"Parameter : %@" , parameter);
        NSMutableDictionary *responceDict = [UserLoginServices GetReferCode:parameter];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
            
            NSLog(@"%@" , responceDict);
            
            if ([[responceDict objectForKey:@"message"] isEqualToString:@"success"]) {
                self.referCode.text = [responceDict objectForKey:@"refer_code"];
                //[self setUI:[responceDict objectForKey:@"data"]];
                
            }else if (([[responceDict objectForKey:@"message"] caseInsensitiveCompare:@"Token DoesN't Matched"] == NSOrderedSame) || ([[responceDict objectForKey:@"message"] caseInsensitiveCompare:@"Invalid Token"] == NSOrderedSame)) {
                UIStoryboard *mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                UINavigationController *mainContorller = [mainSB instantiateViewControllerWithIdentifier:@"loginNavigation"];
                [UIApplication sharedApplication].delegate.window.rootViewController = mainContorller;
            }else {
                
                [self presentViewController:[UISuporterINApp generateAlert:[responceDict objectForKey:@"message"]] animated:YES completion:nil];
            }
        });
    });
}

- (IBAction)ActiononInvitefreands:(id)sender {
    [self.view endEditing:YES];
    NSString *textToShare = [NSString stringWithFormat:@"Hey! Join me on iSyzygyCare Use My code %@ and earn signup bonus. To Download : -", self.referCode.text];
    NSURL *myWebsite = [NSURL URLWithString:@"http://en.india.tradechina.com/NewSite/index.aspx"];
    
    NSArray *objectsToShare = @[textToShare, myWebsite];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
    
    NSArray *excludeActivities = @[UIActivityTypeAirDrop,
                                   UIActivityTypePrint,
                                   UIActivityTypeAssignToContact,
                                   UIActivityTypeSaveToCameraRoll,
                                   UIActivityTypeAddToReadingList,
                                   UIActivityTypePostToFlickr,
                                   UIActivityTypePostToVimeo,
                                   UIActivityTypePostToFacebook,
                                   UIActivityTypePostToTwitter];
    
    activityVC.excludedActivityTypes = excludeActivities;
    
    [self presentViewController:activityVC animated:YES completion:nil];
}

- (IBAction)ActiononGo:(id)sender {
    [self.view endEditing:YES];
    if (self.EnterCodeTF.text.length > 0) {
        NSMutableDictionary *parameter = [NSMutableDictionary new];
        
        [parameter setObject:[[SYUserDefault sharedManager] getAppToken] forKey:@"token"];
        [parameter setObject: [[SYUserDefault sharedManager] getUserAuthorityId] forKey:@"authority_id"];
        [parameter setObject:self.EnterCodeTF.text forKey:@"refferal_code"];
        [self InviteFriend:parameter];
    }else{
        [self presentViewController:[UISuporterINApp generateAlert:@"Please enter referal code"] animated:YES completion:nil];

    }
    
    
}


-(void) InviteFriend:(NSMutableDictionary *)parameter {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.label.text = NSLocalizedString(@"Please Wait...", @"HUD loading title");
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        
        NSMutableDictionary *responceDict = [UserRunningServices addSomeOne:parameter witServiceName:@"invite_friend"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
            
            if ([[responceDict objectForKey:@"status"] intValue] ==  200) {
                
             
                
            }else{
                [self presentViewController:[UISuporterINApp generateAlert:[responceDict objectForKey:@"message"]] animated:YES completion:nil];
            }
            
        });
    });
    
}
@end
