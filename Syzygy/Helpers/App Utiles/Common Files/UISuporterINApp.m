//
//  UISuporterINApp.m
//  Syzygy
//
//  Created by Kamal Gupta on 12/2/17.
//  Copyright © 2017 kamal gupta. All rights reserved.
//

#import "UISuporterINApp.h"


@implementation UISuporterINApp


+ (void)SetTextFieldBorder :(UITextField *)textField withView:(UIView*)myView{
    
    CALayer *border = [CALayer layer];
    CGFloat borderWidth = 1;
    border.borderColor = [UIColor grayColor].CGColor;
    border.frame = CGRectMake(0, textField.frame.size.height - borderWidth, (myView.frame.size.width - 30), textField.frame.size.height);
    border.borderWidth = borderWidth;
    [textField.layer addSublayer:border];
    textField.layer.masksToBounds = YES;
    
}

+(void)setCustomeLeftViewForTextField:(UITextField*)textField withView:(UIView*)myView{
    UIImageView *imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"open-lock"]];
    UIView *LView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 40, textField.frame.size.height+5)];
    imageV.frame = CGRectMake(5, 5, 30, textField.frame.size.height-10);
    imageV.contentMode = UIViewContentModeScaleAspectFill;
    [LView addSubview:imageV];
    textField.leftView = LView;
    textField.leftViewMode = UITextFieldViewModeAlways;
}



+ (UIAlertController *) generateAlert :(NSString *)message {
    
    UIAlertController *alterController = [UIAlertController alertControllerWithTitle:@"Syzygy is saying" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    [alterController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
    
    return alterController;
}


+ (BOOL) isValidString :(NSString *)strText {
    
    if ([[strText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] > 0) {
        return  true;
    }
    return false;
}

+ (BOOL) isValidPhoneString :(NSString *)strText {
    
    if ([[strText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] > 9) {
        return  true;
    }
    return false;
}

+ (NSString *)encodeToBase64String:(UIImage *)image {
    
    return [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}


@end
