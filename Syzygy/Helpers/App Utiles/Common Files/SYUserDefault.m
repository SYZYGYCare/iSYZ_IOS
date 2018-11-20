//
//  SYUserDefault.m
//  Syzygy
//
//  Created by kamal gupta on 12/2/17.
//  Copyright © 2017 kamal gupta. All rights reserved.
//

#import "SYUserDefault.h"

@implementation SYUserDefault

+ (SYUserDefault*) sharedManager {
    
    static SYUserDefault *singleton;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^
                  {
                      singleton = [[SYUserDefault alloc] init];
                  });
    
    return singleton;
    
}


- (void) saveUserDefaultValue:(id)value withKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (id) getBackUserDefaultValue :(NSString *) key {
    
    id value = [[NSUserDefaults standardUserDefaults] stringForKey:key];
    
    return value;
}

- (void) removeUserDefaultValue {
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"appToken"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"isLogging"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userAuthorityId"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    
}

- (void) setAppToken :(NSString *)token {
    
    [self saveUserDefaultValue:token withKey:@"appToken"];
}

- (NSString *) getAppToken {
    
    NSString *appToken = [self getBackUserDefaultValue:@"appToken"];
    return appToken;
}

- (void) setUserLogging :(NSNumber *)isLogging {
    
    [self saveUserDefaultValue:isLogging withKey:@"isLogging"];
}

- (BOOL) isUserLogging {
    
    NSNumber *isUserLogging = [self getBackUserDefaultValue:@"isLogging"];
    return isUserLogging.boolValue;
}

- (void) setUserAuthorityId :(NSNumber *)userAuthorityId {
    
    [self saveUserDefaultValue:userAuthorityId withKey:@"userAuthorityId"];
}

- (NSNumber *) getUserAuthorityId {
    
    NSNumber *userAuthorityId = [self getBackUserDefaultValue:@"userAuthorityId"];
    return userAuthorityId;
}

- (void) setUserName :(NSString *)userName {
    
    [self saveUserDefaultValue:userName withKey:@"userName"];
}

- (NSString *) getUserName {
    
    NSString *userName = [self getBackUserDefaultValue:@"userName"];
    return userName;
}
- (void) setUserNumber :(NSString *)userNumber {
    
    [self saveUserDefaultValue:userNumber withKey:@"userNumber"];
}

- (NSString *) getUserNumber {
    
    NSString *userNumber = [self getBackUserDefaultValue:@"userNumber"];
    return userNumber;
}

- (void) setDeviceTokenForNotification :(NSString *)deviceToken {
    
    [self saveUserDefaultValue:deviceToken withKey:@"deviceToken"];
}

- (NSString *) getDeviceTokenForNotification {
    
    NSString *deviceToken = [self getBackUserDefaultValue:@"deviceToken"];
    
    if (deviceToken == nil) {
        
        deviceToken = @"dhgdfg";
    }
    
    return deviceToken;
}

- (void) setCareGiverType :(NSString *)deviceToken {
    
    [self saveUserDefaultValue:deviceToken withKey:@"isAmbulanece"];
}

- (NSString *) getCareGiverType {
    
    NSString *deviceToken = [self getBackUserDefaultValue:@"isAmbulanece"];
    
    if (deviceToken == nil) {
        
        deviceToken = @"";
    }
    
    return deviceToken;
}

- (void) setProfilePic :(NSString *)deviceToken {
    if ([deviceToken isKindOfClass:[NSNull class]]) {
        [self saveUserDefaultValue:@"" withKey:@"profile_pic"];

    }else
    [self saveUserDefaultValue:deviceToken withKey:@"profile_pic"];
}

- (NSString *) getProfilePic {
    
    NSString *deviceToken = [self getBackUserDefaultValue:@"profile_pic"];
    
    if (deviceToken == nil) {
        
        deviceToken = @"";
    }
    
    return deviceToken;
}

- (void) setCurrentLat :(NSString *)lat{
    if ([lat isKindOfClass:[NSNull class]]) {
        [self saveUserDefaultValue:@"" withKey:@"lat"];
    }else
        [self saveUserDefaultValue:lat withKey:@"lat"];
}
- (NSString *) getCurrentLat{
    NSString *lat = [self getBackUserDefaultValue:@"lat"];
    
    if (lat == nil) {
        
        lat = @"";
    }
    
    return lat;
}
- (void) setCurrentLng :(NSString *)Lng{
    if ([Lng isKindOfClass:[NSNull class]]) {
        [self saveUserDefaultValue:@"" withKey:@"Lng"];
    }else
        [self saveUserDefaultValue:Lng withKey:@"Lng"];
}
- (NSString *) getCurrentLng{
    NSString *lng = [self getBackUserDefaultValue:@"Lng"];
    
    if (lng == nil) {
        
        lng = @"";
    }
    
    return lng;
}

- (void) setSourceLat :(NSString *)lat{
    if ([lat isKindOfClass:[NSNull class]]) {
        [self saveUserDefaultValue:@"" withKey:@"sourceLat"];
    }else
        [self saveUserDefaultValue:lat withKey:@"sourceLat"];
}
- (NSString *) getSourceLat{
    NSString *lat = [self getBackUserDefaultValue:@"sourceLat"];
    
    if (lat == nil) {
        
        lat = @"";
    }
    
    return lat;
}
- (void) setSourceLng :(NSString *)Lng{
    if ([Lng isKindOfClass:[NSNull class]]) {
        [self saveUserDefaultValue:@"" withKey:@"sourceLng"];
    }else
        [self saveUserDefaultValue:Lng withKey:@"sourceLng"];
}
- (NSString *) getSourceLng{
    NSString *lng = [self getBackUserDefaultValue:@"sourceLng"];
    
    if (lng == nil) {
        
        lng = @"";
    }
    
    return lng;
}

@end
