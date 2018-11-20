//
//  RegisterForCareGiverOrAmbulanceViewController.h
//  Syzygy
//
//  Created by Kamal Gupta on 12/10/17.
//  Copyright © 2017 kamal gupta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterForCareGiverOrAmbulanceViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *CareGiverListView;
@property (weak, nonatomic) IBOutlet UIView *ambulanceTypeView;
@property (weak, nonatomic) IBOutlet UIView *careGiverTypeView;


// Ambulance
@property (weak, nonatomic) IBOutlet UIButton *ambCityButton;

@property (weak, nonatomic) IBOutlet UIButton *ambSelectType;
@property (weak, nonatomic) IBOutlet UITextField *ambModelNumTextField;
@property (weak, nonatomic) IBOutlet UITextField *ambModelNoTextField;
@property (weak, nonatomic) IBOutlet UITextField *ambDriverTextField;

@property (weak, nonatomic) IBOutlet UIButton *ambUploadBtn;
@property (weak, nonatomic) IBOutlet UIImageView *ambExpand1;
@property (weak, nonatomic) IBOutlet UIImageView *ambExpand2;
@property (weak, nonatomic) IBOutlet UIImageView *ambExpand3;
@property (weak, nonatomic) IBOutlet UIImageView *ambExpand4;
@property (weak, nonatomic) IBOutlet UIButton *ambDocButton;
@property (weak, nonatomic) IBOutlet UIButton *ambDocButton2;

@property (weak, nonatomic) IBOutlet UIButton *ambDocumentBtn;
- (IBAction)ambSelecteTypeBtnTapped:(id)sender;
- (IBAction)ambUploadDocBtnTapped:(id)sender;
- (IBAction)ambUploadLinBtnTApped:(id)sender;
- (IBAction)submitBtnTapped:(id)sender;

// CareGiver

@property (weak, nonatomic) IBOutlet UIButton *careGiverTypeBtn;
@property (weak, nonatomic) IBOutlet UIButton *specilistBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *specialistHeight;
@property (weak, nonatomic) IBOutlet UIImageView *specialExapand;

@property (weak, nonatomic) IBOutlet UILabel *specialistLab;
@property (weak, nonatomic) IBOutlet UITextField *QulificationTextField;
@property (weak, nonatomic) IBOutlet UITextField *regTextField;
@property (weak, nonatomic) IBOutlet UIButton *uploadBtn;
@property (weak, nonatomic) IBOutlet UIImageView *documentExapandIcon;
@property (weak, nonatomic) IBOutlet UIButton *cityButton;
@property (weak, nonatomic) IBOutlet UIImageView *documentIcon2;
@property (weak, nonatomic) IBOutlet UIButton *uploadButton2;
@property (weak, nonatomic) IBOutlet UIImageView *documentIcon3;
@property (weak, nonatomic) IBOutlet UIButton *uploadButton3;
@property (weak, nonatomic) IBOutlet UIImageView *documentIcon4;
@property (weak, nonatomic) IBOutlet UIButton *uploadButton4;



@property (assign) BOOL isAmbulance;
- (IBAction)submitCareGiverBtn:(id)sender;
- (IBAction)careGiverTypeButtonTapped:(id)sender;
- (IBAction)specialBtnTapped:(id)sender;

- (IBAction)ActionOnCityButton:(id)sender;

- (IBAction)careGiverButtonTapped:(id)sender;
- (IBAction)ambulanceButttonTapped:(id)sender;


@end
