//
//  careGiverBill.h
//  Syzygy
//
//  Created by manisha panse on 2/28/18.
//  Copyright © 2018 kamal gupta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCSStarRatingView.h"
@class careGiverBill;

@protocol careGiverBillDelegate<NSObject>
-(void)finishedBillCash;
-(void)skipBillCash;

@end
@interface careGiverBill : UIView
@property (strong, nonatomic) id<careGiverBillDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *amountLab;
@property (weak, nonatomic) IBOutlet UIImageView *paidImage;
@property (weak, nonatomic) IBOutlet UILabel *greenCircle;
@property (weak, nonatomic) IBOutlet UILabel *redCircle;
@property (weak, nonatomic) IBOutlet UILabel *startTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet HCSStarRatingView *ratingView;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *totalTImeLab;
@property (assign) BOOL isCash;

@property (strong, nonatomic) NSDictionary *requestDictionary;
@property (strong, nonatomic) NSDictionary *billDictionary;
- (IBAction)ActionOnSkip:(id)sender;
- (IBAction)ActionOnSubmit:(id)sender;
@end
