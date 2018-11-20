//
//  AppDelegate.h
//  Syzygy
//
//  Created by kamal gupta on 11/29/17.
//  Copyright © 2017 kamal gupta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, UNUserNotificationCenterDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIWindow *alertWindow;

- (void)moveTOMainPage;
- (void)Cancerequestbyclint;

- (void)StartRide:(NSMutableDictionary *)data;
    
@end

