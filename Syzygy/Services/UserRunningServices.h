//
//  UserRunningServices.h
//  Syzygy
//
//  Created by Kamal Gupta on 12/23/17.
//  Copyright © 2017 kamal gupta. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserRunningServices : NSObject


+ (NSMutableDictionary *) getAllCareGiver :(NSMutableDictionary *) parameter;
+ (NSMutableDictionary *) addSomeOne :(NSMutableDictionary *) parameter  witServiceName :(NSString *)serviceName;
+ (NSMutableDictionary *) getOtherServices :(NSMutableDictionary *) parameter  witServiceName :(NSString *)serviceName;
@end
