//
//  UserRunningServices.m
//  Syzygy
//
//  Created by Kamal Gupta on 12/23/17.
//  Copyright © 2017 kamal gupta. All rights reserved.
//

#import "UserRunningServices.h"
#import "BaseServices.h"
#import "Constant.h"

@implementation UserRunningServices


+ (NSMutableDictionary *) getAllCareGiver :(NSMutableDictionary *) parameter {
    
    BaseServices *baseService =  [BaseServices new];
    baseService.parameters = parameter;
    
    NSString *endPointUrl = [NSString stringWithFormat:@"%@getNearestCaregiver", kBaseUrl];
    
    NSMutableDictionary *responceData = [baseService callToServerByPostMethods:endPointUrl];
    
    return responceData;
}

+ (NSMutableDictionary *) addSomeOne :(NSMutableDictionary *) parameter  witServiceName :(NSString *)serviceName{
    
    BaseServices *baseService =  [BaseServices new];
    baseService.parameters = parameter;
    
    NSString *endPointUrl = [NSString stringWithFormat:@"%@%@", kBaseUrl , serviceName];
    
    NSMutableDictionary *responceData = [baseService callToServerByPostMethods:endPointUrl];
    
    return responceData;
}

+ (NSMutableDictionary *) getOtherServices :(NSMutableDictionary *) parameter  witServiceName :(NSString *)serviceName {
    
    BaseServices *baseService =  [BaseServices new];
    baseService.parameters = parameter;
    
    NSString *endPointUrl = [NSString stringWithFormat:@"%@%@", kBaseUrl ,serviceName ];
    
    NSMutableDictionary *responceData = [baseService callToServerByGETMethods:endPointUrl];
    
    return responceData;
}


@end
