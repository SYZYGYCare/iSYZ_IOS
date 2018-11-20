//
//  SYUserDefault.h
//  Syzygy
//
//  Created by kamal gupta on 12/2/17.
//  Copyright © 2017 kamal gupta. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYUserDefault : NSObject

+ (SYUserDefault*) sharedManager;

- (void) setAppToken :(NSString *)token;
- (NSString *) getAppToken;

- (void) setUserLogging :(NSNumber *)isLogging ;
- (BOOL) isUserLogging ;

- (void) setUserAuthorityId :(NSNumber *)userAuthorityId;
- (NSNumber *) getUserAuthorityId ;
- (void) removeUserDefaultValue;


- (void) setUserName :(NSString *)userName ;
- (NSString *) getUserName ;
- (void) setUserNumber :(NSString *)userNumber ;
- (NSString *) getUserNumber ;

- (void) setDeviceTokenForNotification :(NSString *)deviceToken;
- (NSString *) getDeviceTokenForNotification;



- (void) setCareGiverType :(NSString *)deviceToken;
- (NSString *) getCareGiverType;

- (void) setProfilePic :(NSString *)deviceToken;
- (NSString *) getProfilePic;

- (void) setCurrentLat :(NSString *)lat;
- (NSString *) getCurrentLat;
- (void) setCurrentLng :(NSString *)Lng;
- (NSString *) getCurrentLng;

- (void) setSourceLat :(NSString *)lat;
- (NSString *) getSourceLat;
- (void) setSourceLng :(NSString *)Lng;
- (NSString *) getSourceLng;
@end
