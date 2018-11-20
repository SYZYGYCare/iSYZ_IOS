//
//  ShowCustomAlert.h
//  Dating
//
//  Created by Earl Kameron G. Arcilla on 1/23/15.
//  Copyright (c) 2015 AppVenture. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ShowCustomAlert : NSObject
+ (void) showWithMessage: (NSString*)message;

+ (void) showAboveWithMessage: (NSString*)message;

+ (void) showCenterWithMessage: (NSString*)message;

+ (void) showWithMessage: (NSString*)message WithCompletion: (void(^)(void))completion;

+ (void) showWithMessage: (NSString*)message Position: (CGFloat)position WithCompletion: (void(^)(void))completion;

+ (void) removeMessage;
@end
