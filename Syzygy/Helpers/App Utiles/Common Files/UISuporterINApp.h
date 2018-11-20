//
//  UISuporterINApp.h
//  Syzygy
//
//  Created by Kamal Gupta on 12/2/17.
//  Copyright © 2017 kamal gupta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface UISuporterINApp : NSObject

+ (void)SetTextFieldBorder :(UITextField *)textField withView:(UIView*)myView;
+ (UIAlertController *) generateAlert :(NSString *)message;
+ (BOOL) isValidString :(NSString *)strText ;
+ (BOOL) isValidPhoneString :(NSString *)strText;
+ (NSString *)encodeToBase64String:(UIImage *)image;
+(void)setCustomeLeftViewForTextField:(UITextField*)textField withView:(UIView*)myView;
@end
