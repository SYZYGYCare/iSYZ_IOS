//
//  FinishProcessUIView.h
//  Syzygy
//
//  Created by Kamal Gupta on 12/30/17.
//  Copyright © 2017 kamal gupta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YourBillView.h"
#import "careGiverBill.h"

@interface FinishProcessUIView : UIView <YourBillViewDelegate,careGiverBillDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameTitle;
@property (weak, nonatomic) IBOutlet UILabel *nameValue;

@property (weak, nonatomic) IBOutlet UILabel *startTimeTitle;
@property (weak, nonatomic) IBOutlet UILabel *startTimeValue;
@property (weak, nonatomic) IBOutlet UILabel *endTimeTitle;

@property (weak, nonatomic) IBOutlet UILabel *endTimeValue;
@property (weak, nonatomic) IBOutlet UILabel *totalWorkingTitle;
@property (weak, nonatomic) IBOutlet UILabel *totalWorklingValue;

@property (weak, nonatomic) IBOutlet UILabel *amountTitle;

@property (weak, nonatomic) IBOutlet UILabel *amountValue;
@property (weak, nonatomic) IBOutlet UILabel *byWalletTitle;

@property (weak, nonatomic) IBOutlet UILabel *byWalletValue;
@property (weak, nonatomic) IBOutlet UILabel *remingAmountTitle;
@property (weak, nonatomic) IBOutlet UILabel *remingAmountValue;
@property (strong, nonatomic) NSDictionary *cashDic;

- (IBAction)FinishButtonTapped:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *optionsView;

@property (strong, nonatomic) NSMutableDictionary *RececitDict;

@property (weak, nonatomic) IBOutlet UIView *buttonView;
@property (weak, nonatomic) IBOutlet UIButton *finishButton;

@property (assign) BOOL isAmulance;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *amountHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *AmountHeight2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *walletHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *walletHeight2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *remainigHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *remainingHeight2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *amountTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *amountTop2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *walletTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *walletTop2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *remainingTop;

@property (weak, nonatomic) IBOutlet UILabel *walletValue;
@property (weak, nonatomic) IBOutlet UIImageView *walletImage;

- (IBAction)ActionOnCash:(id)sender;

- (IBAction)ActionOnOnline:(id)sender;

@end
