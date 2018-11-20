 //
//  AppDelegate.m
//  Syzygy
//
//  Created by kamal gupta on 11/29/17.
//  Copyright © 2017 kamal gupta. All rights reserved.
//

#import "AppDelegate.h"
#import "MFSideMenu.h"
#import "SYUserDefault.h"
#import "Constant.h"
#import "ClientNotificationUIView.h"
#import "RequestNotificationUIView.h"
#import "UserRunningServices.h"
#import "MBProgressHUD.h"
#import "UserLoginServices.h"
#import "SYUserDefault.h"
#import "UISuporterINApp.h"
#import "FinishProcessUIView.h"
#import "ChatViewController.h"
#import "CancelReasonVC.h"
#import <Firebase.h>

@import GoogleMaps;
@import GooglePlaces;
NSString *const kGCMMessageIDKey = @"722217676949";
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

@interface AppDelegate ()<CLLocationManagerDelegate,FIRMessagingDelegate>{
    CLLocationCoordinate2D centernew;
    CLLocationManager *locationManager;;
    NSString* Cureentlat;
    NSString* Cureentlong;
    NSMutableDictionary *startRideCareGiverData;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"onchat"];
    
    [FIRApp configure];
   // [self pushNotifcationPopup];
    [self registerForRemoteNotification];
    
    [GMSServices provideAPIKey:@"AIzaSyDzAU0OL8ys7yMhHtgL2U7HXUiAHd4TCc8"];
    [GMSPlacesClient provideAPIKey:@"AIzaSyAOLqapRD0bQb_DhPJ1cTx_XHpt2-Glh6I"];
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
    [application registerUserNotificationSettings:mySettings];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        
        [self->locationManager requestWhenInUseAuthorization];
   // [self->locationManager setAllowsBackgroundLocationUpdates:YES];
   // [locationManager startUpdatingLocation];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(startChat:) name:@"startChat" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(startChat:) name:@"endChat" object:nil];
    //
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveCancelRequestNotification:)
                                                 name:@"cancelRequest"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveCancelRequestNotification:)
                                                 name:@"endCancelRequest"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveCancelRequestNotification:)
                                                 name:@"endCancelRequest2"
                                               object:nil];
    if ([[SYUserDefault sharedManager] isUserLogging]) {
        //[self Cancerequestbyclint];;
      //  [self moveTOMainPage];
        UIStoryboard *launch = [UIStoryboard storyboardWithName:@"LaunchScreen" bundle:nil];
        UIViewController * myStoryBoardInitialViewController = [launch instantiateInitialViewController];
        [self.window setRootViewController:myStoryBoardInitialViewController];
        [self.window makeKeyAndVisible];
        [self performSelectorOnMainThread:@selector(getProfileDetail) withObject:nil waitUntilDone:YES];
        
    }else{
        //loginNavigation
        UIStoryboard *mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UINavigationController *mainContorller = [mainSB instantiateViewControllerWithIdentifier:@"loginNavigation"];
        [self.window setRootViewController:mainContorller];
        [self.window makeKeyAndVisible];
    }
    
   

    //
    /*    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"startChat"
     object:_dataNotificationDict];
*/
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)getProfileDetail {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.window animated:YES];
    
    hud.label.text = NSLocalizedString(@"Please Wait...", @"HUD loading title");
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        
        NSMutableDictionary *parameter = [NSMutableDictionary new];
        
        [parameter setObject:[[SYUserDefault sharedManager] getAppToken] forKey:@"token"];
        [parameter setObject: [[SYUserDefault sharedManager] getUserAuthorityId] forKey:@"authority_id"];
        
        NSLog(@"Parameter : %@" , parameter);
        NSMutableDictionary *responceDict = [UserLoginServices userDetail:parameter];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
            
            
            NSLog(@"%@" , responceDict);
            
            if ([[responceDict objectForKey:@"message"] isEqualToString:@"sucess"]) {
                [[SYUserDefault sharedManager] setUserLogging:@YES];
                [[SYUserDefault sharedManager] setUserName:[[responceDict objectForKey:@"data"] objectForKey:@"full_name"]];
                [[SYUserDefault sharedManager] setUserNumber:[[responceDict objectForKey:@"data"] objectForKey:@"phone"]];
                [[SYUserDefault sharedManager] setProfilePic:[[responceDict objectForKey:@"data"] objectForKey:@"profile_pic"]];
                [self moveTOMainPage];
            } else {
                
                UIStoryboard *mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                UINavigationController *mainContorller = [mainSB instantiateViewControllerWithIdentifier:@"loginNavigation"];
                [self.window setRootViewController:mainContorller];
                [self.window makeKeyAndVisible];
              //  [self presentViewController:[UISuporterINApp generateAlert:[responceDict objectForKey:@"message"]] animated:YES completion:nil];
            }
            
        });
    });
    
}

- (void)moveTOMainPage {
    
    UIStoryboard *mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *mainContorller = [mainSB instantiateViewControllerWithIdentifier:@"mainNavigation"];
    
    UIViewController *leftSideMenuViewController = [mainSB instantiateViewControllerWithIdentifier:@"leftSideMenuViewController"];
    
    
    MFSideMenuContainerViewController *container = [MFSideMenuContainerViewController containerWithCenterViewController:mainContorller leftMenuViewController:leftSideMenuViewController rightMenuViewController:nil];
    
    [self.window setRootViewController:container];
}


#pragma mark - Remote Notification Delegate // <= iOS 9.x

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *strDevicetoken = [[NSString alloc]initWithFormat:@"%@",[[[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]] stringByReplacingOccurrencesOfString:@" " withString:@""]];
    NSLog(@"Device Token = %@",strDevicetoken);
    [FIRMessaging messaging].APNSToken = deviceToken;
    
}



-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"%@ = %@", NSStringFromSelector(_cmd), error);
    NSLog(@"Error = %@",error);
}
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0

#pragma mark - UNUserNotificationCenter Delegate // >= iOS 10

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler {
 //   completionHandler(UNNotificationPresentationOptionAlert + UNNotificationPresentationOptionSound);

    // completionHandler(UNNotificationPresentationOptionAlert | UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound);
    NSLog(@"User Info = %@",notification.request.content.userInfo);
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;

    NSDictionary *userInfo = notification.request.content.userInfo;
    if ([[userInfo objectForKey:@"action"] isEqualToString:@"localNotification"]) {
        //        [newParameter setObject:@"reminder" forKey:@"type"];
        if ([[userInfo objectForKey:@"type"]isEqualToString:@"reminder"]) {
            [self showReminderAlert:userInfo];
        }else if ([[userInfo objectForKey:@"type"]isEqualToString:@"hire_later"]){
            [self showReminderHireLaterAlert:userInfo];
        }
    }else{
        NSDictionary *apsDict = userInfo[@"aps"];
        if ([[SYUserDefault sharedManager] isUserLogging]) {
            
            if ([[[SYUserDefault sharedManager] getUserAuthorityId] intValue] == USER_TYPE) {
                
                if ([userInfo[@"gcm.notification.action"] isEqualToString:@"client Request Accepted"]) {
                    [[NSNotificationCenter defaultCenter]
                     postNotificationName:@"acceptRequest"
                     object:nil];
                    NSString *receiveData = userInfo[@"gcm.notification.message"];
                    NSData *data = [receiveData dataUsingEncoding:NSUTF8StringEncoding];
                    NSMutableDictionary *requestData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                    [self gettingAcceptedHireCaregiverNotification:requestData];
                    
                }else if ([userInfo[@"gcm.notification.action"] isEqualToString:@"sendChat"]) {
                    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"onchat"]) {
                        [[NSNotificationCenter defaultCenter]
                         postNotificationName:@"chatCome"
                         object:nil];
                    }else{
                        [[NSNotificationCenter defaultCenter]
                         postNotificationName:@"startChat"
                         object:startRideCareGiverData];
                    }
                } else {
                    //On start
                    NSString *receiveData = userInfo[@"gcm.notification.message"];
                    NSData *data = [receiveData dataUsingEncoding:NSUTF8StringEncoding];
                    NSMutableDictionary *requestData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                    int caseValue = [requestData[@"user_type"] intValue];
                    //        action = "Start rides";
                    //
                    if ([userInfo[@"gcm.notification.action"] isEqualToString:@"Start rides"]) {
                        //[self StartRide:requestData];
                        [self gettingStartRideNotification:requestData];
                        
                    }else if ([userInfo[@"gcm.notification.action"] isEqualToString:@"Stop rides"]) {
                        //[self EndRide:requestData];
                        [self gettingEndRideNotification:requestData];
                        
                    }else{
                        
                        switch (caseValue) {
                            case 8:{
                                
                                [self gettingStartTimeNotification:requestData];
                                
                            }
                                
                                break;
                            case 9:{
                                //                        ClientNotificationUIView *clentVc =  [ClientNotificationUIView new];
                                //                        [clentVc stopTimer];
                                [self gettingPauseTimeNotification:requestData];
                                
                            }
                                break;
                            case 5:{
                                NSString *timeStr = requestData[@"time"];
                                NSArray *timeINMint = [timeStr componentsSeparatedByString:@":"];
                                
                                int timeInSec = (([[timeINMint objectAtIndex:0] intValue] * 60) + [[timeINMint objectAtIndex:0] intValue]);
                                [self gettingStartTimeNotification:requestData];
                                //                        ClientNotificationUIView *clentVc =  [ClientNotificationUIView new];
                                
                            }
                                
                                break;
                            case 6:{
                                //                        ClientNotificationUIView *clentVc =  [ClientNotificationUIView new];
                                //                        [clentVc stopTimer];
                                [self gettingStopTimeNotification:requestData];
                                
                                
                            }
                                break;
                            case 7:{
                                [self Cancerequestbyclint];
                            }
                                break;
                            case 2:{
                                //if one of them caregive or ambulance accept request notification come to remove request from another caregiver
                                //AcceptAnotherCaregiver();
                            }
                                break;
                            case 10:{
                                //reminder notification it is showing to do list
                                //remainderNotification();
                            }
                                break;
                                
                            default:
                                break;
                        }
                    }
                    
                }
                
                
            } else {
                
                NSString *receiveData = userInfo[@"gcm.notification.message"];
                NSData *data = [receiveData dataUsingEncoding:NSUTF8StringEncoding];
                NSMutableDictionary *requestData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                int caseValue = [requestData[@"user_type"] intValue];
                
                if ([userInfo[@"gcm.notification.action"] isEqualToString:@"Request Hire Caregiver"]) {
                    
                    [self gettingRequestHireCaregiverNotification:requestData];
                    
                }else if ([userInfo[@"gcm.notification.action"] isEqualToString:@"sendChat"]) {
                    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"onchat"]) {
                        [[NSNotificationCenter defaultCenter]
                         postNotificationName:@"chatCome"
                         object:nil];
                    }else{
                        [[NSNotificationCenter defaultCenter]
                         postNotificationName:@"startChat"
                         object:startRideCareGiverData];
                    }
                    
                }else {
                    switch (caseValue) {
                        case 5:{
                            NSString *timeStr = requestData[@"time"];
                            NSArray *timeINMint = [timeStr componentsSeparatedByString:@":"];
                            
                            int timeInSec = (([[timeINMint objectAtIndex:0] intValue] * 60) + [[timeINMint objectAtIndex:0] intValue]);
                            
                            ClientNotificationUIView *clentVc =  [ClientNotificationUIView new];
                            clentVc.timerInt = timeInSec;
                            [clentVc startTimer];
                        }
                            
                            break;
                        case 6:{
                            ClientNotificationUIView *clentVc =  [ClientNotificationUIView new];
                            [clentVc stopTimer];
                        }
                            break;
                        case 7:{
                            [self Cancerequestbyclint];
                        }
                            break;
                        case 8:{
                            ClientNotificationUIView *clentVc =  [ClientNotificationUIView new];
                            [clentVc startTimer];
                        }
                            break;
                        case 9:{
                            ClientNotificationUIView *clentVc =  [ClientNotificationUIView new];
                            [clentVc stopTimer];
                        }
                            break;
                        case 2:{
                            //if one of them caregive or ambulance accept request notification come to remove request from another caregiver
                            //AcceptAnotherCaregiver();
                            [self Cancerequestbyclint];
                        }
                            break;
                        case 10:{
                            //reminder notification it is showing to do list
                            //remainderNotification();
                        }
                            break;
                            
                        default:
                            break;
                    }
                }
            }
        }

    }
    
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)(void))completionHandler {
    
    NSLog(@"User Info = %@",response.notification.request.content.userInfo);
    
    
        //   completionHandler(UNNotificationPresentationOptionAlert + UNNotificationPresentationOptionSound);
        
        // completionHandler(UNNotificationPresentationOptionAlert | UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound);qq
    
        NSDictionary *userInfo = response.notification.request.content.userInfo;
    if ([[userInfo objectForKey:@"action"] isEqualToString:@"localNotification"]) {
        if ([[userInfo objectForKey:@"type"]isEqualToString:@"reminder"]) {
            [self showReminderAlert:userInfo];
        }else if ([[userInfo objectForKey:@"type"]isEqualToString:@"hire_later"]){
            [self showReminderHireLaterAlert:userInfo];
        }
    }else{
        NSDictionary *apsDict = userInfo[@"aps"];
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        if ([[SYUserDefault sharedManager] isUserLogging]) {
            
            if ([[[SYUserDefault sharedManager] getUserAuthorityId] intValue] == USER_TYPE) {
                
                if ([userInfo[@"gcm.notification.action"] isEqualToString:@"client Request Accepted"]) {
                    [[NSNotificationCenter defaultCenter]
                     postNotificationName:@"acceptRequest"
                     object:nil];
                    NSString *receiveData = userInfo[@"gcm.notification.message"];
                    NSData *data = [receiveData dataUsingEncoding:NSUTF8StringEncoding];
                    NSMutableDictionary *requestData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                    [self gettingAcceptedHireCaregiverNotification:requestData];
                    
                }else if ([userInfo[@"gcm.notification.action"] isEqualToString:@"sendChat"]) {
                    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"onchat"]) {
                        [[NSNotificationCenter defaultCenter]
                         postNotificationName:@"chatCome"
                         object:nil];
                    }else{
                        [[NSNotificationCenter defaultCenter]
                         postNotificationName:@"startChat"
                         object:startRideCareGiverData];
                    }
                } else {
                    //onchat
                    NSString *receiveData = userInfo[@"gcm.notification.message"];
                    NSData *data = [receiveData dataUsingEncoding:NSUTF8StringEncoding];
                    NSMutableDictionary *requestData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                    int caseValue = [requestData[@"user_type"] intValue];
                    //        action = "Start rides";
                    //
                    if ([userInfo[@"gcm.notification.action"] isEqualToString:@"Start rides"]) {
                        //[self StartRide:requestData];
                        [self gettingStartRideNotification:requestData];
                        
                    }else if ([userInfo[@"gcm.notification.action"] isEqualToString:@"Stop rides"]) {
                        //[self EndRide:requestData];
                        [self gettingEndRideNotification:requestData];
                        
                    }else{
                        
                        switch (caseValue) {
                            case 8:{
                                
                                [self gettingStartTimeNotification:requestData];
                                
                            }
                                
                                break;
                            case 9:{
                                //                        ClientNotificationUIView *clentVc =  [ClientNotificationUIView new];
                                //                        [clentVc stopTimer];
                                [self gettingPauseTimeNotification:requestData];
                                
                            }
                                break;
                            case 5:{
                                NSString *timeStr = requestData[@"time"];
                                NSArray *timeINMint = [timeStr componentsSeparatedByString:@":"];
                                
                                int timeInSec = (([[timeINMint objectAtIndex:0] intValue] * 60) + [[timeINMint objectAtIndex:0] intValue]);
                                [self gettingStartTimeNotification:requestData];
                                //                        ClientNotificationUIView *clentVc =  [ClientNotificationUIView new];
                                
                            }
                                
                                break;
                            case 6:{
                                //                        ClientNotificationUIView *clentVc =  [ClientNotificationUIView new];
                                //                        [clentVc stopTimer];
                                [self gettingStopTimeNotification:requestData];
                                
                                
                            }
                                break;
                            case 7:{
                                [self Cancerequestbyclint];
                            }
                                break;
                            case 2:{
                                //if one of them caregive or ambulance accept request notification come to remove request from another caregiver
                                //AcceptAnotherCaregiver();
                            }
                                break;
                            case 10:{
                                //reminder notification it is showing to do list
                                //remainderNotification();
                            }
                                break;
                                
                            default:
                                break;
                        }
                    }
                    
                }
                
                
            } else {
                
                NSString *receiveData = userInfo[@"gcm.notification.message"];
                NSData *data = [receiveData dataUsingEncoding:NSUTF8StringEncoding];
                NSMutableDictionary *requestData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                int caseValue = [requestData[@"user_type"] intValue];
                
                if ([userInfo[@"gcm.notification.action"] isEqualToString:@"Request Hire Caregiver"]) {
                    
                    [self gettingRequestHireCaregiverNotification:requestData];
                    
                }else if ([userInfo[@"gcm.notification.action"] isEqualToString:@"sendChat"]) {
                    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"onchat"]) {
                        [[NSNotificationCenter defaultCenter]
                         postNotificationName:@"chatCome"
                         object:nil];
                    }else{
                        [[NSNotificationCenter defaultCenter]
                         postNotificationName:@"startChat"
                         object:startRideCareGiverData];
                    }
                }else {
                    switch (caseValue) {
                        case 5:{
                            NSString *timeStr = requestData[@"time"];
                            NSArray *timeINMint = [timeStr componentsSeparatedByString:@":"];
                            
                            int timeInSec = (([[timeINMint objectAtIndex:0] intValue] * 60) + [[timeINMint objectAtIndex:0] intValue]);
                            
                            ClientNotificationUIView *clentVc =  [ClientNotificationUIView new];
                            clentVc.timerInt = timeInSec;
                            [clentVc startTimer];
                        }
                            
                            break;
                        case 6:{
                            ClientNotificationUIView *clentVc =  [ClientNotificationUIView new];
                            [clentVc stopTimer];
                        }
                            break;
                        case 7:{
                            [self Cancerequestbyclint];
                        }
                            break;
                        case 8:{
                            ClientNotificationUIView *clentVc =  [ClientNotificationUIView new];
                            [clentVc startTimer];
                        }
                            break;
                        case 9:{
                            ClientNotificationUIView *clentVc =  [ClientNotificationUIView new];
                            [clentVc stopTimer];
                        }
                            break;
                        case 2:{
                            //if one of them caregive or ambulance accept request notification come to remove request from another caregiver
                            //AcceptAnotherCaregiver();
                            [self Cancerequestbyclint];
                        }
                            break;
                        case 10:{
                            //reminder notification it is showing to do list
                            //remainderNotification();
                        }
                            break;
                            
                        default:
                            break;
                    }
                }
            }
        }
        
    }
    
        
    
    completionHandler();
}

#endif

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"Push Notification Information : %@",userInfo);
    
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    NSLog(@"Push Notification Information : %@",userInfo);

    completionHandler(UIBackgroundFetchResultNewData);
   
}
#pragma mark - Class Methods

/**
 Notification Registration
 */
- (void)registerForRemoteNotification {
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
        // iOS 7.1 or earlier. Disable the deprecation warnings.
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        UIRemoteNotificationType allNotificationTypes =
        (UIRemoteNotificationTypeSound |
         UIRemoteNotificationTypeAlert |
         UIRemoteNotificationTypeBadge);
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:allNotificationTypes];
        [FIRMessaging messaging].remoteMessageDelegate = self;
        [FIRMessaging messaging].delegate = self;
        
#pragma clang diagnostic pop
    } else {
        // iOS 8 or later
        // [START register_for_notifications]
        if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_9_x_Max) {
            UIUserNotificationType allNotificationTypes =
            (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
            UIUserNotificationSettings *settings =
            [UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:nil];
            [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
           
            
        } else {
            // iOS 10 or later
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
            // For iOS 10 display notification (sent via APNS)
            [UNUserNotificationCenter currentNotificationCenter].delegate = self;
            UNAuthorizationOptions authOptions =
            UNAuthorizationOptionAlert
            | UNAuthorizationOptionSound
            | UNAuthorizationOptionBadge;
            [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:authOptions completionHandler:^(BOOL granted, NSError * _Nullable error) {
            }];
            
            // For iOS 10 data message (sent via FCM)
        
#endif
        }
        
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [FIRMessaging messaging].remoteMessageDelegate = self;
        [FIRMessaging messaging].delegate = self;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tokenRefreshNotification:)
                                                     name:kFIRInstanceIDTokenRefreshNotification object:nil];
        
        // [END register_for_notifications]
    }
}

- (void) comeUserRequestNotifiction:(NSMutableDictionary *)data {
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    for (UIView *views in [self.window subviews]) {
        
        if ([views isKindOfClass: [RequestNotificationUIView class]] || [views isKindOfClass: [ClientNotificationUIView class]]) {
            [views removeFromSuperview];

           // return;
        }
    }
    
    RequestNotificationUIView *requestNotificationUIView = [[[NSBundle mainBundle] loadNibNamed:@"RequestNotificationUIView" owner:self options:nil] objectAtIndex:0];
    
    [requestNotificationUIView setFrame:CGRectMake(0, screenHeight - 150, screenWidth, 150)];
    
    requestNotificationUIView.requestDataDict = data;
    
    [[UIApplication sharedApplication].keyWindow addSubview:requestNotificationUIView];
}

- (void) gettingRequestHireCaregiverNotification :(NSMutableDictionary *)responceData {
    
    NSMutableDictionary *parameter = [NSMutableDictionary new];
    [parameter setObject:responceData[@"t_name"] forKey:@"t_name"];
    if ([responceData objectForKey:@"user_senior_id"]) {
        [parameter setObject:@"client" forKey:@"t_name"];
    }
    [parameter setObject:responceData[@"client_id"] forKey:@"client_id"];
    
    NSMutableDictionary *resultDict = [UserRunningServices getOtherServices:parameter witServiceName:@"get_notification_data"];

    if ([resultDict[@"status"] intValue] == 200) {
        startRideCareGiverData = resultDict[@"data"];
        NSMutableDictionary *finalResponce = [NSMutableDictionary new];
        [finalResponce setObject:resultDict[@"data"] forKey:@"data"];
        [finalResponce setObject:responceData[@"longitud"] forKey:@"longitud"];
        [finalResponce setObject:responceData[@"latitude"] forKey:@"latitude"];
        
        [self comeUserRequestNotifiction:finalResponce];
    }
    
}

//- (void) gettingRequestcanceNotification :(NSMutableDictionary *)responceData {
//
//    NSMutableDictionary *parameter = [NSMutableDictionary new];
//    [parameter setObject:responceData[@"t_name"] forKey:@"t_name"];
//    [parameter setObject:responceData[@"client_id"] forKey:@"client_id"];
//    NSMutableDictionary *resultDict = [UserRunningServices getOtherServices:parameter witServiceName:@"cancel_request"];
//
//    if ([resultDict[@"status"] intValue] == 200) {
//
//        NSMutableDictionary *finalResponce = [NSMutableDictionary new];
//        [finalResponce setObject:resultDict[@"data"] forKey:@"data"];
//        [finalResponce setObject:responceData[@"longitud"] forKey:@"longitud"];
//        [finalResponce setObject:responceData[@"latitude"] forKey:@"latitude"];
//
//        [self comeUserRequestNotifiction:finalResponce];
//    }
//
//}
- (void)Cancerequestbyclint {
    for (UIView *views in [self.window subviews]) {
        
        if ([views isKindOfClass: [RequestNotificationUIView class]] || [views isKindOfClass: [ClientNotificationUIView class]]) {
            [views removeFromSuperview];
            //return;
        }
    }

    //[self.requestNotificationUIView removeFromSuperview];
    
}
- (void) gettingAcceptedHireCaregiverNotification :(NSMutableDictionary *)responceData {
    
    NSMutableDictionary *parameter = [NSMutableDictionary new];
    [parameter setObject:responceData[@"t_name"] forKey:@"t_name"];
    [parameter setObject:responceData[@"caregiver_id"] forKey:@"caregiver_id"];
    [parameter setObject:responceData[@"hire_caregiver_id"] forKey:@"hire_caregiver_id"];
    NSString *strHCGID = responceData[@"hire_caregiver_id"];
    
    [[NSUserDefaults standardUserDefaults] setObject:responceData[@"hire_caregiver_id"] forKey:@"hire_caregiver_id"];

    NSDictionary *resultDict = [UserRunningServices getOtherServices:parameter witServiceName:@"get_notification_data"];
    NSMutableDictionary *resultMutableDict = [[NSMutableDictionary alloc] initWithDictionary:resultDict];

    [resultMutableDict setObject:strHCGID forKey:@"hire_caregiver_id"];
    
    if ([resultDict[@"status"] intValue] == 200) {
       // [self comeUserRequestNotifiction:resultDict];
        [self acceptUserRequest:resultMutableDict];
    }
}

- (void) gettingStartTimeNotification :(NSMutableDictionary *)responceData {
    
    NSMutableDictionary *parameter = [NSMutableDictionary new];
    [parameter setObject:responceData[@"t_name"] forKey:@"t_name"];
    [parameter setObject:responceData[@"msg_history_id"] forKey:@"msg_history_id"];
    NSMutableDictionary *resultDict = [UserRunningServices getOtherServices:parameter witServiceName:@"get_notification_data"];
    
    if ([resultDict[@"status"] intValue] == 200) {
        // [self comeUserRequestNotifiction:resultDict];
        [self ShowTimerView:resultDict];
    }
}

- (void) gettingStopTimeNotification :(NSMutableDictionary *)responceData {
    
    NSMutableDictionary *parameter = [NSMutableDictionary new];
    [parameter setObject:responceData[@"t_name"] forKey:@"t_name"];
    [parameter setObject:responceData[@"msg_history_id"] forKey:@"msg_history_id"];
    NSMutableDictionary *resultDict = [UserRunningServices getOtherServices:parameter witServiceName:@"get_notification_data"];
    
    if ([resultDict[@"status"] intValue] == 200) {
        // [self comeUserRequestNotifiction:resultDict];
        [self EndTimerView:resultDict];
    }
}

- (void) gettingPauseTimeNotification :(NSMutableDictionary *)responceData {
    
    NSMutableDictionary *parameter = [NSMutableDictionary new];
    [parameter setObject:responceData[@"t_name"] forKey:@"t_name"];
    [parameter setObject:responceData[@"msg_history_id"] forKey:@"msg_history_id"];
    NSMutableDictionary *resultDict = [UserRunningServices getOtherServices:parameter witServiceName:@"get_notification_data"];
    
    if ([resultDict[@"status"] intValue] == 200) {
        // [self comeUserRequestNotifiction:resultDict];
        [self PauseTimerView:resultDict];
    }
}

- (void) acceptUserRequest:(NSMutableDictionary *)data {
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    for (UIView *views in [self.window subviews]) {
        
        if ([views isKindOfClass: [RequestNotificationUIView class]] || [views isKindOfClass: [ClientNotificationUIView class]]) {
            [views removeFromSuperview];

          //  return;
        }
    }
    
    ClientNotificationUIView *requestNotificationUIView = [[[NSBundle mainBundle] loadNibNamed:@"ClientNotificationUIView" owner:self options:nil] objectAtIndex:0];
    
    [requestNotificationUIView setFrame:CGRectMake(0, screenHeight-110 , screenWidth, 110)];
    startRideCareGiverData = [[data objectForKey:@"data"] mutableCopy];
    
    NSDictionary *dictData = [data objectForKey:@"data"];
    requestNotificationUIView.dataNotificationDict = [[NSMutableDictionary alloc] initWithDictionary:dictData];
    
    NSString *strHCI = [requestNotificationUIView.dataNotificationDict objectForKey:@"hire_caregiver_id"];
    
    
    if(strHCI == nil || strHCI == NULL)
    {
        strHCI = [data objectForKey:@"hire_caregiver_id"];
        [requestNotificationUIView.dataNotificationDict setObject:strHCI forKey:@"hire_caregiver_id"];
    }
    requestNotificationUIView.isUserView =  YES;
    
    [[UIApplication sharedApplication].keyWindow addSubview:requestNotificationUIView];
}

- (void) ShowTimerView:(NSMutableDictionary *)data {
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    for (UIView *views in [self.window subviews]) {
        
        if ([views isKindOfClass: [RequestNotificationUIView class]] || [views isKindOfClass: [ClientNotificationUIView class]]) {
            [views removeFromSuperview];
            
            //  return;
        }
    }
    
    NSString *receiveData = data[@"data"][@"test_msg"];
    NSData *datad = [receiveData dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *requestData = [NSJSONSerialization JSONObjectWithData:datad options:0 error:nil];
    NSString *timeStr = [requestData objectForKey:@"time"];
    NSArray *timeINMint = [timeStr componentsSeparatedByString:@":"];
    
    int timeInSec = [[requestData objectForKey:@"time"] intValue];
    ClientNotificationUIView *requestNotificationUIView = [[[NSBundle mainBundle] loadNibNamed:@"ClientNotificationUIView" owner:self options:nil] objectAtIndex:0];
    
    [requestNotificationUIView setFrame:CGRectMake(0, 0 , screenWidth, screenHeight)];
    
    requestNotificationUIView.dataNotificationDict = requestData;
    requestNotificationUIView.hideButtons = YES;
    requestNotificationUIView.timerInt = timeInSec;
    [requestNotificationUIView startTimer];
    [[UIApplication sharedApplication].keyWindow addSubview:requestNotificationUIView];
}

- (void) PauseTimerView:(NSMutableDictionary *)data {
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    for (UIView *views in [self.window subviews]) {
        
        if ([views isKindOfClass: [RequestNotificationUIView class]] || [views isKindOfClass: [ClientNotificationUIView class]]) {
            [views removeFromSuperview];
            
            //  return;
        }
    }
    
    NSString *receiveData = data[@"data"][@"test_msg"];
    NSData *datad = [receiveData dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *requestData = [NSJSONSerialization JSONObjectWithData:datad options:0 error:nil];
    NSString *timeStr = [requestData objectForKey:@"time"];
    NSArray *timeINMint = [timeStr componentsSeparatedByString:@":"];
    
    int timeInSec = [[requestData objectForKey:@"time"] intValue];
    ClientNotificationUIView *requestNotificationUIView = [[[NSBundle mainBundle] loadNibNamed:@"ClientNotificationUIView" owner:self options:nil] objectAtIndex:0];
    
    [requestNotificationUIView setFrame:CGRectMake(0, 0 , screenWidth, screenHeight)];
    
    requestNotificationUIView.dataNotificationDict = requestData;
    requestNotificationUIView.hideButtons = YES;
    requestNotificationUIView.timerInt = timeInSec;
    [requestNotificationUIView startTimer];
    [requestNotificationUIView performSelector:@selector(stopTimer) withObject:nil afterDelay:0.5];
    [[UIApplication sharedApplication].keyWindow addSubview:requestNotificationUIView];
}

- (void)EndTimerView:(NSMutableDictionary *)data {
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    for (UIView *views in [self.window subviews]) {
        
        if ([views isKindOfClass: [RequestNotificationUIView class]] || [views isKindOfClass: [ClientNotificationUIView class]]) {
            [views removeFromSuperview];
            
            //  return;
        }
    }
    
    NSString *receiveData = data[@"data"][@"test_msg"];
    NSData *datad = [receiveData dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *requestData = [NSJSONSerialization JSONObjectWithData:datad options:0 error:nil];
  
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"CaregiverEndRide"
     object:requestData];
    /*FinishProcessUIView *requestNotificationUIView = [[[NSBundle mainBundle] loadNibNamed:@"FinishProcessUIView" owner:self options:nil] objectAtIndex:0];
    
    [requestNotificationUIView setFrame:CGRectMake(0, 0 , screenWidth, screenHeight)];
    requestNotificationUIView.RececitDict = requestData;
    [[UIApplication sharedApplication].keyWindow addSubview:requestNotificationUIView];*/
}

- (void) gettingEndRideNotification :(NSMutableDictionary *)responceData {
    
    NSMutableDictionary *parameter = [NSMutableDictionary new];
    [parameter setObject:responceData[@"t_name"] forKey:@"t_name"];
    [parameter setObject:responceData[@"msg_history_id"] forKey:@"msg_history_id"];
    NSMutableDictionary *resultDict = [UserRunningServices getOtherServices:parameter witServiceName:@"get_notification_data"];
    
    if ([resultDict[@"status"] intValue] == 200) {
        // [self comeUserRequestNotifiction:resultDict];
        [self EndRide:resultDict];
    }
}
- (void)EndRide:(NSMutableDictionary *)data {
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    for (UIView *views in [self.window subviews]) {
        
        if ([views isKindOfClass: [RequestNotificationUIView class]] || [views isKindOfClass: [ClientNotificationUIView class]]) {
            [views removeFromSuperview];
            
            //  return;
        }
    }
    
    NSString *receiveData = data[@"data"][@"test_msg"];
    NSData *datad = [receiveData dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *requestData = [NSJSONSerialization JSONObjectWithData:datad options:0 error:nil];
    
   /* FinishProcessUIView *requestNotificationUIView = [[[NSBundle mainBundle] loadNibNamed:@"FinishProcessUIView" owner:self options:nil] objectAtIndex:0];
    
    [requestNotificationUIView setFrame:CGRectMake(0, 0 , screenWidth, screenHeight)];
    requestNotificationUIView.RececitDict = requestData;
    [[UIApplication sharedApplication].keyWindow addSubview:requestNotificationUIView];*/
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"endRide"
     object:requestData];

}

- (void) gettingStartRideNotification :(NSMutableDictionary *)responceData {
    
    NSMutableDictionary *parameter = [NSMutableDictionary new];
    [parameter setObject:responceData[@"t_name"] forKey:@"t_name"];
    [parameter setObject:responceData[@"msg_history_id"] forKey:@"msg_history_id"];
    NSMutableDictionary *resultDict = [UserRunningServices getOtherServices:parameter witServiceName:@"get_notification_data"];
    
    if ([resultDict[@"status"] intValue] == 200) {
        // [self comeUserRequestNotifiction:resultDict];
        [self StartRide:resultDict];
    }
}
- (void)StartRide:(NSMutableDictionary *)data {
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    for (UIView *views in [self.window subviews]) {
        
        if ([views isKindOfClass: [RequestNotificationUIView class]] || [views isKindOfClass: [ClientNotificationUIView class]]) {
            [views removeFromSuperview];
            
            //  return;
        }
    }
    
    NSString *receiveData = data[@"data"][@"test_msg"];
    NSData *datad = [receiveData dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *requestData = [NSJSONSerialization JSONObjectWithData:datad options:0 error:nil];
    [startRideCareGiverData setObject:[requestData objectForKey:@"source_latitude"] forKey:@"latitude"];
    [startRideCareGiverData setObject:[requestData objectForKey:@"source_longitude"] forKey:@"longitud"];
    ClientNotificationUIView *requestNotificationUIView = [[[NSBundle mainBundle] loadNibNamed:@"ClientNotificationUIView" owner:self options:nil] objectAtIndex:0];
    
    [requestNotificationUIView setFrame:CGRectMake(0, screenHeight-50 , screenWidth, 50)];
    requestNotificationUIView.startRide = YES;
    requestNotificationUIView.dataNotificationDict = requestData;
    NSDictionary *rideDic = @{@"ride":requestData,@"caregiver_detail":startRideCareGiverData};
    [[UIApplication sharedApplication].keyWindow addSubview:requestNotificationUIView];
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"startRide"
     object:rideDic];
}

-(void) startLocation {
    locationManager = [[CLLocationManager alloc] init];
    //[self checkws];
    
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    if ([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [locationManager requestAlwaysAuthorization];
    }
    // for iOS 9
    if ([self->locationManager respondsToSelector:@selector(setAllowsBackgroundLocationUpdates:)])
    {
        [self->locationManager setAllowsBackgroundLocationUpdates:YES];
    }
    
    [locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    
    CLLocation *currentLocation = newLocation;
    Cureentlat = [NSString stringWithFormat:@"%f",
                  newLocation.coordinate.latitude];
    
    Cureentlong = [NSString stringWithFormat:@"%f",
                   newLocation.coordinate.longitude];
    
    
    [[NSUserDefaults standardUserDefaults] setObject:Cureentlat forKey:@"userLatitude"];
    [[NSUserDefaults standardUserDefaults] setObject:Cureentlong forKey:@"userlongitude"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSLog(@"Mahi Baground");
}

#pragma mark - start notification

- (void) startChat:(NSNotification *) notification
{
    // [notification name] should always be @"TestNotification"
    // unless you use this method for observation of other notifications
    // as well.
    
    if ([[notification name] isEqualToString:@"startChat"]){
       // NSDictionary *caregiverDetail = [notification.object objectForKey:@"caregiver_detail"];
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGFloat screenWidth = screenRect.size.width;
        CGFloat screenHeight = screenRect.size.height;
        ChatViewController *requestNotificationUIView = [[ChatViewController alloc]initWithNibName:@"ChatViewController" bundle:nil];
        
        [requestNotificationUIView.view setFrame:CGRectMake(0, 0 , screenWidth, screenHeight)];
        requestNotificationUIView.requestDic = notification.object;
        
        self.alertWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        self.alertWindow.rootViewController = requestNotificationUIView;
        self.alertWindow.windowLevel = UIWindowLevelAlert + 1;
        [self.alertWindow makeKeyAndVisible];
//        [self.alertWindow.rootViewController presentViewController:requestNotificationUIView animated:YES completion:nil];
        
    }else{
        //endChat
        self.alertWindow.hidden = YES;
    }
}

#pragma mark - start notification

- (void) receiveCancelRequestNotification:(NSNotification *) notification
{
    // [notification name] should always be @"TestNotification"
    // unless you use this method for observation of other notifications
    // as well.
    
 
    if ([[notification name] isEqualToString:@"cancelRequest"]){
        
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGFloat screenWidth = screenRect.size.width;
        CGFloat screenHeight = screenRect.size.height;
        CancelReasonVC *requestNotificationUIView = [[CancelReasonVC alloc]initWithNibName:@"CancelReasonVC" bundle:nil];
        [requestNotificationUIView.view setFrame:CGRectMake(0, 0 , screenWidth, screenHeight)];
        requestNotificationUIView.requestDic = notification.object;
        [requestNotificationUIView setupInitialViews];
        self.alertWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        self.alertWindow.rootViewController = requestNotificationUIView;
        self.alertWindow.windowLevel = UIWindowLevelAlert + 1;
        [self.alertWindow makeKeyAndVisible];
    }else if ([[notification name] isEqualToString:@"endCancelRequest2"]){
        self.alertWindow.hidden = YES;
        [self Cancerequestbyclint];
    }else{
        //endChat
        self.alertWindow.hidden = YES;

    }
   
    //
}

- (void)tokenRefreshNotification:(NSNotification *)notification {
    // Note that this callback will be fired everytime a new token is generated, including the first
    // time. So if you need to retrieve the token as soon as it is available this is where that
    // should be done.
    NSString *refreshedToken = [[FIRInstanceID instanceID] token];
    NSLog(@"InstanceID token: %@", refreshedToken);
    [[SYUserDefault sharedManager] setDeviceTokenForNotification:refreshedToken];

    [[NSUserDefaults standardUserDefaults] setObject:refreshedToken forKey:@"devicetoken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    //[self pushNotifcationPopup];
    // Connect to FCM since connection may have failed when attempted before having a token.
    [self connectToFcm];
    
    // TODO: If necessary send token to application server.
}

- (void)connectToFcm {
    // Won't connect since there is no token
    if (![[FIRInstanceID instanceID] token]) {
        return;
    }
    
    // Disconnect previous FCM connection if it exists.
    [[FIRMessaging messaging] disconnect];
    // [[FIRMessaging messaging]setShouldEstablishDirectChannel:YES];
    [[FIRMessaging messaging] connectWithCompletion:^(NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Unable to connect to FCM. %@", error);
        } else {
            NSLog(@"Connected to FCM. FCM token - %@", [[FIRInstanceID instanceID] token] );
        }
    }];
}


-(void)pushNotifcationPopup{
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
        // iOS 7.1 or earlier. Disable the deprecation warnings.
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        UIRemoteNotificationType allNotificationTypes =
        (UIRemoteNotificationTypeSound |
         UIRemoteNotificationTypeAlert |
         UIRemoteNotificationTypeBadge);
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:allNotificationTypes];
        [FIRMessaging messaging].remoteMessageDelegate = self;
        [FIRMessaging messaging].delegate = self;
        
#pragma clang diagnostic pop
    } else {
        // iOS 8 or later
        // [START register_for_notifications]
        if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_9_x_Max) {
            UIUserNotificationType allNotificationTypes =
            (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
            UIUserNotificationSettings *settings =
            [UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:nil];
            [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
            [FIRMessaging messaging].remoteMessageDelegate = self;
            [FIRMessaging messaging].delegate = self;
            
        } else {
            // iOS 10 or later
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
            // For iOS 10 display notification (sent via APNS)
            [UNUserNotificationCenter currentNotificationCenter].delegate = self;
            UNAuthorizationOptions authOptions =
            UNAuthorizationOptionAlert
            | UNAuthorizationOptionSound
            | UNAuthorizationOptionBadge;
            [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:authOptions completionHandler:^(BOOL granted, NSError * _Nullable error) {
            }];
            
            // For iOS 10 data message (sent via FCM)
            [FIRMessaging messaging].remoteMessageDelegate = self;
            [FIRMessaging messaging].delegate = self;
#endif
        }
        
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tokenRefreshNotification:)
                                                     name:kFIRInstanceIDTokenRefreshNotification object:nil];
        
        // [END register_for_notifications]
    }
}

- (void)messaging:(nonnull FIRMessaging *)messaging didRefreshRegistrationToken:(nonnull NSString *)fcmToken {
    // Note that this callback will be fired everytime a new token is generated, including the first
    // time. So if you need to retrieve the token as soon as it is available this is where that
    // should be done.
    NSLog(@"FCM registration token: %@", fcmToken);
    
    // TODO: If necessary send token to application server.
} //uncomment this after pod update

//- (void)applicationReceivedRemoteMessage:(nonnull FIRMessagingRemoteMessage *)remoteMessage{
//
//}

- (void)messaging:(nonnull FIRMessaging *)messaging didReceiveMessage:(nonnull FIRMessagingRemoteMessage *)remoteMessage{}

#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
// Receive data message on iOS 10 devices while app is in the foreground.
- (void)applicationReceivedRemoteMessage:(FIRMessagingRemoteMessage *)remoteMessage
{
    
    /*
     {
     "collapse_key" = "com.behindbars";
     from = 229893426842;
     notification =     {
     body = "Bear island knows no king but the king in the north, whose name is stark.";
     e = 1;
     title = Carbon;
     };
     }
     
     */
    NSLog(@"%@", remoteMessage.appData);
    
    NSMutableDictionary *dictGet = [[NSMutableDictionary alloc]init];
    
    dictGet = [remoteMessage.appData mutableCopy];
    
}
#endif

-(void)showReminderAlert:(NSDictionary*)reminderDic{
    
  __block UIWindow* topWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    topWindow.rootViewController = [UIViewController new];
    topWindow.windowLevel = UIWindowLevelAlert + 1;
    NSString *message = [NSString stringWithFormat:@"Reminder For : %@\nRequired Care : %@\nDate & Time : %@",[reminderDic objectForKey:@"reminder_for"],[reminderDic objectForKey:@"required_care"],[NSString stringWithFormat:@"%@ / %@",[self returnDate:[reminderDic objectForKey:@"start_date"]],[self returnTime:[reminderDic objectForKey:@"time"]]]];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Reminder!!" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        topWindow = nil;
    }];
    [alert addAction:ok];
    
    [topWindow makeKeyAndVisible];
    [topWindow.rootViewController presentViewController:alert animated:YES completion:nil];
}

-(void)showReminderHireLaterAlert:(NSDictionary*)reminderDic{
    __block UIWindow* topWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    topWindow.rootViewController = [UIViewController new];
    topWindow.windowLevel = UIWindowLevelAlert + 1;
    NSString *message = [NSString stringWithFormat:@"Reminder For Book Caregiver and Ambulance! Book Your appointment"];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Reminder" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *Cancel = [UIAlertAction actionWithTitle:@"CANCEL" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        topWindow = nil;
    }];
    [alert addAction:Cancel];
    UIAlertAction *HireNow = [UIAlertAction actionWithTitle:@"HIRE NOW" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"hire_later"
         object:[reminderDic objectForKey:@"hire_later"]];
        topWindow = nil;
    }];
    [alert addAction:HireNow];
    [topWindow makeKeyAndVisible];
    [topWindow.rootViewController presentViewController:alert animated:YES completion:nil];
}

-(NSString*)returnDate:(NSString*)dateStr{
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    dateFormater.dateFormat = @"yyyy/MM/dd";
    NSDate *dated = [dateFormater dateFromString:dateStr];
    dateFormater.dateFormat = @"yyyy-MM-dd";
    dateStr = [dateFormater stringFromDate:dated];
    return dateStr;
}

-(NSString*)returnTime:(NSString*)timeStr{
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    dateFormater.dateFormat = @"HH:mm";
    NSDate *dated = [dateFormater dateFromString:timeStr];
    if (dated == nil) {
        dateFormater.dateFormat = @"hh:mm a";
        dated = [dateFormater dateFromString:timeStr];
    }
    dateFormater.dateFormat = @"h:mm a";
    timeStr = [dateFormater stringFromDate:dated];
    return timeStr;
}
@end
