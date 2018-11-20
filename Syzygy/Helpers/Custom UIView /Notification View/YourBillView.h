//
//  YourBillView.h
//  Syzygy
//
//  Created by manisha panse on 1/19/18.
//  Copyright © 2018 kamal gupta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCSStarRatingView.h"
@class YourBillView;

@protocol YourBillViewDelegate<NSObject>
-(void)finishedYourBillCash;
-(void)skipYourBillCash;

@end
@interface YourBillView : UIView
@property (strong, nonatomic) id<YourBillViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *amountLab;
@property (weak, nonatomic) IBOutlet UIImageView *paidImage;
@property (weak, nonatomic) IBOutlet UILabel *greenCircle;
@property (weak, nonatomic) IBOutlet UILabel *redCircle;
@property (weak, nonatomic) IBOutlet UILabel *sourceAddress;
@property (weak, nonatomic) IBOutlet UILabel *destinationAddress;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet HCSStarRatingView *ratingView;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (assign) BOOL isCash;

@property (strong, nonatomic) NSDictionary *requestDictionary;
@property (strong, nonatomic) NSDictionary *billDictionary;
- (IBAction)ActionOnSkip:(id)sender;
- (IBAction)ActionOnSubmit:(id)sender;

@end
