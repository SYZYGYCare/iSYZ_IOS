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

@end
