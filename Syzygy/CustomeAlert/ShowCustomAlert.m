//
//  ShowCustomAlert.m
//  Dating
//
//  Created by Earl Kameron G. Arcilla on 1/23/15.
//  Copyright (c) 2015 AppVenture. All rights reserved.
//

#import "ShowCustomAlert.h"

static ShowCustomAlert* _sharedInstance = nil;

@interface ShowCustomAlert ()
@property (retain) UILabel* label;
@end

@implementation ShowCustomAlert

+ (ShowCustomAlert*) sharedInstance
{
    @synchronized(self)
    {
        if(_sharedInstance == nil)
        {
            _sharedInstance = [[ShowCustomAlert alloc] init];
        }
    }
    return _sharedInstance;
}

+ (void) showWithMessage: (NSString*)message
{
    [ShowCustomAlert showWithMessage:message
                             Position:0.8
                      WithCompletion:nil];
}

+ (void) showAboveWithMessage:(NSString *)message
{
    [ShowCustomAlert showWithMessage:message
                             Position:0.2
                      WithCompletion:nil];
}

+ (void) showCenterWithMessage:(NSString *)message
{
    [ShowCustomAlert showWithMessage:message
                            Position:0.5
                      WithCompletion:nil];
}

+ (void) showWithMessage:(NSString *)message WithCompletion:(void (^)(void))completion
{
    [ShowCustomAlert showWithMessage:message
                             Position:0.8
                      WithCompletion:completion];
}

+ (void) showWithMessage: (NSString*)message
                Position:(CGFloat)position
          WithCompletion:(void (^)(void))completion
{
    [[ShowCustomAlert sharedInstance] instanceWithMessage:message
                                                  Position:position
                                           WithCompletion:completion];
}

+ (void) removeMessage
{
    [[ShowCustomAlert sharedInstance].label removeFromSuperview];
}

- (void) instanceWithMessage: (NSString*)message
                    Position: (CGFloat)position
              WithCompletion: (void(^)(void))completion
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    CGRect screenSize = [UIScreen mainScreen].bounds;
    CGPoint center = CGPointMake(CGRectGetMidX(screenSize),
                                 CGRectGetMidY(screenSize));
    
    [self.label removeFromSuperview];
    
    UIFont* font = [UIFont systemFontOfSize:14];
    
    CGSize viewSize = [message sizeWithFont:font
                          constrainedToSize:CGSizeMake(280, CGFLOAT_MAX)
                              lineBreakMode:NSLineBreakByTruncatingMiddle];
    
    CGRect finalFrame;
    CGRect initialFrame;
    
    finalFrame = CGRectMake(center.x - viewSize.width / 2.0,
                            screenSize.size.height * position,
                            viewSize.width + 16,
                            viewSize.height + 16);
    initialFrame = CGRectMake(center.x,
                              screenSize.size.height * position + (viewSize.height + 16) / 2.0,
                              1, 1);
    
    
    self.label = [[UILabel alloc]initWithFrame:initialFrame];
    
    [[[[UIApplication sharedApplication] delegate] window] addSubview:self.label];
    
    self.label.text = message;
    self.label.userInteractionEnabled = NO;
    self.label.numberOfLines = 0;
    self.label.baselineAdjustment = YES;
    self.label.adjustsFontSizeToFitWidth = YES;
    self.label.adjustsLetterSpacingToFitWidth = YES;
    self.label.font = [UIFont systemFontOfSize:14];
    self.label.clipsToBounds = YES;
    self.label.layer.cornerRadius = 8;
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.backgroundColor = [UIColor colorWithRed:65/255.0
                                                 green:64/255.0
                                                  blue:66/255.0
                                                 alpha:0.8];
    
    self.label.textColor = [UIColor whiteColor];
    [UIView animateWithDuration:0.1
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^(void)
     {
         self.label.frame = finalFrame;
     }
                     completion:^(BOOL finished)
     {
         self.label.frame = finalFrame;
         if(completion)
         {
             completion();
         }
         [self performSelector:@selector(hideLabel)
                    withObject:nil
                    afterDelay:2];
     }];
}

- (void) hideLabel
{
    [UIView animateWithDuration:0.1
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^(void)
     {
         self.label.bounds = CGRectZero;
         
     }
                     completion:^(BOOL finished)
     {
         if(finished)
         {
             [self.label removeFromSuperview];
             self.label = nil;
         }
     }];
}

@end
