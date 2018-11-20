//
//  PopupForBookCareGiver.m
//  Syzygy
//
//  Created by Kamal Gupta on 12/23/17.
//  Copyright © 2017 kamal gupta. All rights reserved.
//

#import "PopupForBookCareGiver.h"

@implementation PopupForBookCareGiver

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)cancelButtonTapped:(id)sender {
    [self removeFromSuperview];
}

- (IBAction)currentLocationTapped:(id)sender {
    
    [self.addServiceDelegate returnAddService:@"currentLoction"];
    [self removeFromSuperview];
}

- (IBAction)addSomeOneTapped:(id)sender {
    
    [self.addServiceDelegate returnAddService:@"addSomeOne"];
    [self removeFromSuperview];

}
@end
