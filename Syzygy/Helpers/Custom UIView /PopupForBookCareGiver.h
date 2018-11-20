//
//  PopupForBookCareGiver.h
//  Syzygy
//
//  Created by Kamal Gupta on 12/23/17.
//  Copyright © 2017 kamal gupta. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ReturnToAddServiceDelegate <NSObject>

- (void) returnAddService:(NSString *)serviceType;

@end

@interface PopupForBookCareGiver : UIView

- (IBAction)cancelButtonTapped:(id)sender;

- (IBAction)currentLocationTapped:(id)sender;
- (IBAction)addSomeOneTapped:(id)sender;

@property (weak, nonatomic) id<ReturnToAddServiceDelegate> addServiceDelegate;

@end
