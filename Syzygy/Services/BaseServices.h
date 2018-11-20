//
//  BaseServices.h
//  Syzygy
//
//  Created by Kamal Gupta on 12/2/17.
//  Copyright © 2017 kamal gupta. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseServices : NSObject

@property (nonatomic, strong ) NSMutableDictionary *parameters;


- (NSMutableDictionary *) callToServerByPostMethods : (NSString *) urlStr;
- (NSMutableDictionary *) callToServerByGETMethods : (NSString *) urlStr;
- (NSMutableDictionary *) callToServerByPostMethodsWithRequest : (NSURLRequest *) request;
@end
