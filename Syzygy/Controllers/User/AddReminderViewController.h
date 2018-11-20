//
//  AddReminderViewController.h
//  Syzygy
//
//  Created by Kamal Gupta on 12/24/17.
//  Copyright © 2017 kamal gupta. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AddReminderViewController;

@protocol AddReminderViewControllerDelegates <NSObject>

@optional
-(void)reminderAddedSuccessfully;
@end

@interface AddReminderViewController : UIViewController

@property (strong, nonatomic) id <AddReminderViewControllerDelegates> delegate;
@property (weak, nonatomic) IBOutlet UIImageView *reminderImageView;
@property (weak, nonatomic) IBOutlet UIButton *reminderForButton;
@property (weak, nonatomic) IBOutlet UIButton *requiredCareButton;

@property (weak, nonatomic) IBOutlet UIButton *careTypeButton;
@property (weak, nonatomic) IBOutlet UIButton *anyTypeButton;
@property (weak, nonatomic) IBOutlet UIView *datePickerView;
@property (weak, nonatomic) IBOutlet UIDatePicker *reminderDatePicker;

- (IBAction)donePickerButtonTapped:(id)sender;
- (IBAction)addReminderButtonTapped:(id)sender;
- (IBAction)selecteDateButtonTapped:(id)sender;
- (IBAction)anyTypeButtonTapped:(id)sender;

- (IBAction)careTypeButtonTapped:(id)sender;

- (IBAction)requiredCareButtonTapped:(id)sender;

- (IBAction)reminderForButtonTapped:(id)sender;


@property (weak, nonatomic) IBOutlet UIButton *selecteDateButton;






@end
