//
//  BaseServices.m
//  Syzygy
//
//  Created by Kamal Gupta on 12/2/17.
//  Copyright © 2017 kamal gupta. All rights reserved.
//

#import "BaseServices.h"

@implementation BaseServices {
    
    NSString *methodType;
}


- (NSMutableDictionary *)requestSynchronousData:(NSURLRequest *)request
{
    __block NSMutableDictionary *responceDict = nil;
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *taskData, NSURLResponse *response, NSError *error) {
       
        if (error) {
            
            [responceDict setValue:@"ERROR" forKey:@"STATUS"];
            [responceDict setValue:error.localizedDescription forKey:@"REASON"];
            
            NSLog(@"Error: %@", error.localizedDescription);

        }
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
        NSMutableDictionary *dictFromData =  [NSMutableDictionary new];
        if ([httpResponse statusCode] == 200 && taskData != nil) {
            dictFromData = [NSJSONSerialization JSONObjectWithData:taskData
                                                                         options:NSJSONReadingAllowFragments
                                                                           error:&error];
            
            NSLog(@"Responce data: %@" , dictFromData);
            
            if (dictFromData) {
                
            } else {
                [dictFromData setValue:@"200" forKey:@"status"];
            }
        } else {
            
            [dictFromData setValue:[NSNumber numberWithInteger:[httpResponse statusCode]] forKey:@"status"];
        }

        responceDict = dictFromData;
        dispatch_semaphore_signal(semaphore);
    }];
    [dataTask resume];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
        
    return responceDict;
}



- (NSMutableURLRequest *) getUrlWithHeaderAndParameter :(NSString *) myUrl
{
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    BOOL isTypeGet = [methodType isEqualToString:@"GET"];
    
    if (isTypeGet)
    {
        if (_parameters.count)
        {
            NSMutableString *queryString = [NSMutableString stringWithString:@"?"];
            
            NSArray *parameterKeys = _parameters.allKeys;
            
            for (NSUInteger parameterIndex = 0; parameterIndex < parameterKeys.count; parameterIndex++)
            {
                if (parameterIndex > 0)
                {
                    [queryString appendString:@"&"];
                }
                
                NSString *parameterKey = parameterKeys[parameterIndex];
                
                NSString *parameterValue = _parameters[parameterKey];
                
                [queryString appendString:[NSString stringWithFormat:@"%@=%@", parameterKey, parameterValue]];
            }
            
            NSString *encodedQueryString = [queryString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            myUrl = [myUrl stringByAppendingString:encodedQueryString];
        }
    } else {
        if (_parameters.count) {
            
            NSMutableString *queryString = [NSMutableString stringWithString:@""];;
            
            NSArray *parameterKeys = _parameters.allKeys;
            
            for (NSUInteger parameterIndex = 0; parameterIndex < parameterKeys.count; parameterIndex++) {
                
                if (parameterIndex > 0) {
                    
                    [queryString appendString:@"&"];
                }
                NSString *parameterKey = parameterKeys[parameterIndex];
                NSString *parameterValue = _parameters[parameterKey];
                [queryString appendString:[NSString stringWithFormat:@"%@=%@", parameterKey, parameterValue]];
            }
            NSData *parameterData = [queryString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
            [request setHTTPBody:parameterData];
            NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[parameterData length]];
            [request setValue:postLength forHTTPHeaderField:@"Content-Length"];

            
        }
    }
    
    [request setHTTPMethod:methodType];
    [request setCachePolicy:NSURLRequestUseProtocolCachePolicy];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:50];
    
    NSURL *url = [NSURL URLWithString:myUrl];

    [request setURL:url];
    
    [request addValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    NSLog(@"%@" , url);
    NSLog(@"send Date : %@" , _parameters);
    
    return request;
}

- (NSMutableDictionary *) callToServerByPostMethods : (NSString *) urlStr{
    
    methodType = @"POST";
    NSURLRequest *request = [self getUrlWithHeaderAndParameter:urlStr];
    NSMutableDictionary *responce = [self requestSynchronousData: request] ;
    return responce;
}

- (NSMutableDictionary *) callToServerByGETMethods : (NSString *) urlStr{
    
    methodType = @"GET";
    NSURLRequest *request = [self getUrlWithHeaderAndParameter:urlStr];
    NSMutableDictionary *responce = [self requestSynchronousData: request] ;
    return responce;
}

- (NSMutableDictionary *) callToServerByPostMethodsWithRequest : (NSURLRequest *) request{
    
    methodType = @"POST";
   // NSURLRequest *request = [self getUrlWithHeaderAndParameter:urlStr];
    NSMutableDictionary *responce = [self requestSynchronousData: request] ;
    return responce;
}
@end
