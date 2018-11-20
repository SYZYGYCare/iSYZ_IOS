//
//  AddSeniorViewController.h
//  Syzygy
//
//  Created by Kamal Gupta on 12/2/17.
//  Copyright © 2017 kamal gupta. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AddSeniorViewController;

@protocol AddSeniorViewControllerDelegate <NSObject>
@optional
-(void)didAddSomeOne:(NSDictionary*)addedDic;
@end

@interface AddSeniorViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *ageTextField;

@property (weak, nonatomic) IBOutlet UITextField *mobileTextField;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@property (weak, nonatomic) IBOutlet UITextField *specialInstTextField;

@property (weak, nonatomic) IBOutlet UITextField *specialNeedsTextField;
@property (weak, nonatomic) IBOutlet UITextField *descriptionTextField;
@property (weak, nonatomic) IBOutlet UITextField *reletionTextField;
- (IBAction)checkGender:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *maleButton;
@property (weak, nonatomic) IBOutlet UIButton *femaleButton;
@property (strong, nonatomic) id <AddSeniorViewControllerDelegate> delegate;

- (IBAction)addSomeOne:(id)sender;

@property (strong, nonatomic) NSMutableDictionary *confirmArray;


@end
