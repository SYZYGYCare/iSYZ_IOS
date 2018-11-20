//
//  ProfileViewController.m
//  Syzygy
//
//  Created by Kamal Gupta on 12/2/17.
//  Copyright © 2017 kamal gupta. All rights reserved.
//

#import "ProfileViewController.h"
#import "UISuporterINApp.h"
#import "MBProgressHUD.h"
#import "SYUserDefault.h"
#import "UserLoginServices.h"
#import "Constant.h"
#import "UserRunningServices.h"
#import <AVFoundation/AVFoundation.h>

@interface ProfileViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    
    UIImagePickerController *imagePicker;
}


@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor =  [UIColor colorWithPatternImage:[UIImage imageNamed:@"viewBg"]];
    self.title = @"Update Profile";
    if ([[[SYUserDefault sharedManager] getUserAuthorityId] intValue] == USER_TYPE) {
        self.profileImageBackView.backgroundColor = USER_COLOR;
    }
    [UISuporterINApp SetTextFieldBorder:_nameTextField withView:self.view];
    [UISuporterINApp SetTextFieldBorder:_emailTextField withView:self.view];
    [UISuporterINApp SetTextFieldBorder:_mobileTextField withView:self.view];
    [UISuporterINApp SetTextFieldBorder:_addressTextField withView:self.view];
    [UISuporterINApp SetTextFieldBorder:_aadharNumberTextField withView:self.view];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    tapRecognizer.numberOfTapsRequired = 1;
    [_profileImageView setUserInteractionEnabled:YES];
    _profileImageView.layer.cornerRadius = _profileImageView.frame.size.height/2;
    _profileImageView.layer.masksToBounds = YES;
    [_profileImageView addGestureRecognizer:tapRecognizer];
    [self getProfileDetail];

    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [doneButton setTitle:@"Save" forState:UIControlStateNormal];
    [doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    doneButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    doneButton.frame = CGRectMake(0, 0, 50, 40);
    [doneButton addTarget:self action:@selector(saveButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rigthButton = [[UIBarButtonItem alloc]initWithCustomView:doneButton];
   self.navigationItem.rightBarButtonItem = rigthButton;
    // Do any additional setup after loading the view.
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)saveButtonTapped:(id)sender {
    
    NSMutableDictionary *parameter = [NSMutableDictionary new];
    
    NSString *message = @"";
    
    if ([UISuporterINApp isValidString:_nameTextField.text]) {
        
        [parameter setObject:_nameTextField.text forKey:@"full_name"];
    } else {
        
        message = @"Enter Name";
    }
    
    if ([UISuporterINApp isValidString:_emailTextField.text]) {
        [parameter setObject:_emailTextField.text forKey:@"email_id"];
        
    } else {
        
        message = [NSString stringWithFormat:@"%@ \n%@" , message , @"Enter Email"];
    }
    if ([UISuporterINApp isValidString:_mobileTextField.text]) {
        
        [parameter setObject:_mobileTextField.text forKey:@"phone"];
    } else {
        
        message = [NSString stringWithFormat:@"%@ \n%@" , message , @"Enter Mobile Number"];
    }
    
    if ([UISuporterINApp isValidString:_addressTextField.text]) {
        [parameter setObject:_addressTextField.text forKey:@"address"];
        
    } else {
        
        message = [NSString stringWithFormat:@"%@ \n%@" , message , @"Enter Address"];
    }

    
    if ([_addressTextField .text length] > 0) {
        [parameter setObject:_aadharNumberTextField.text forKey:@"aadharNumber"];
        
    } else {
        
        message = [NSString stringWithFormat:@"%@ \n%@" , message , @"Enter aadhar number"];
    }
    
    if (_maleButton.isSelected) {
        [parameter setObject:@"male" forKey:@"gender"];
        
    } else{
        [parameter setObject:@"female" forKey:@"gender"];
        
    }
    /*token
     full_name
     email_id
     address
     gender
     aadharNumber
     profile_pic*/
//    if (_profileImageView.image != nil) {
//
//        NSData *imageData = UIImageJPEGRepresentation(_profileImageView.image, 0.5);
//        NSLog(@" file size is : %.2f mb",(float)imageData.length/1024.0f/1024.0f);
//        [parameter setObject:[UISuporterINApp encodeToBase64String:[UIImage imageWithData:imageData]] forKey:@"profile_pic"];
//    }
    
    if ([message isEqualToString:@""]) {
        
        [parameter setObject:[[SYUserDefault sharedManager] getAppToken] forKey:@"token"];
        [self updateProfile:parameter];
        
    } else {
        
        [self presentViewController:[UISuporterINApp generateAlert:message] animated:YES completion:nil];
        
    }

}

- (IBAction)genderButtonTapped:(UIButton *)sender {
    
    if (sender.tag == 11) {
        _maleButton.selected = YES;
        _femaleButton.selected = NO;
    } else {
        
        _maleButton.selected = NO;
        _femaleButton.selected = YES;
    }
}

- (void)tapAction:(UITapGestureRecognizer *)tap {
    
    [self showImageSourceSelectionActionSheet];
}

- (void)showImageSourceSelectionActionSheet {
    
    UIAlertController *actionSheetForImage = [UIAlertController alertControllerWithTitle:@"Add Photo" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *useCamera = [UIAlertAction actionWithTitle:@"Take photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self useCamera];
    }];
    
    UIAlertAction *useGallery = [UIAlertAction actionWithTitle:@"Choose from Gallery" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self useGallery];
    }];
    
    UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:@"CANCEL" style:UIAlertActionStyleCancel handler:nil];
    
    
    [actionSheetForImage addAction:useCamera];
    [actionSheetForImage addAction:useGallery];
    [actionSheetForImage addAction:cancelButton];
    
    [self presentViewController:actionSheetForImage animated:YES completion:nil];
    
}

- (void)presentImagePicker {
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}



- (void)takePhotoUsingCamera {
    
    imagePicker = [UIImagePickerController new];
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.delegate = self;
    [self presentImagePicker];
}


- (void)useGallery {
    
    imagePicker = [UIImagePickerController new];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *imageFromPicker = info[UIImagePickerControllerOriginalImage];
    
    _profileImageView.image = imageFromPicker;
    
    [picker dismissViewControllerAnimated:YES completion:Nil];
    
}

- (void)useCamera {
    
    AVAuthorizationStatus cameraAuthorizationStatus = 0;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
    {
        cameraAuthorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    }
    
    BOOL cameraIsAvailable = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    
    if (cameraIsAvailable)
    {
        if (cameraAuthorizationStatus == AVAuthorizationStatusDenied)
        {
            [self presentViewController:[UISuporterINApp generateAlert:@"Kindly enable your camera from Settings > SYZYGY > Camera"] animated:YES completion:nil];
        }
        else if (cameraAuthorizationStatus == AVAuthorizationStatusNotDetermined || cameraAuthorizationStatus == AVAuthorizationStatusAuthorized){
            
            [self takePhotoUsingCamera];
        }
        else if (cameraAuthorizationStatus == AVAuthorizationStatusRestricted){
            [self presentViewController:[UISuporterINApp generateAlert:@"Camera restricted"] animated:YES completion:nil];
        }
    }
    else
    {
        [self takeAppropriateActionWhenCameraIsNotAvailableWithStatus:cameraAuthorizationStatus];
    }
}

- (void)takeAppropriateActionWhenCameraIsNotAvailableWithStatus:(AVAuthorizationStatus)cameraAuthorizationStatus {
    if (cameraAuthorizationStatus == AVAuthorizationStatusNotDetermined)
    {
        [self presentViewController:[UISuporterINApp generateAlert:@"Camera restricted or not available"] animated:YES completion:nil];
    }
    else if (cameraAuthorizationStatus == AVAuthorizationStatusAuthorized)
    {
        [self presentViewController:[UISuporterINApp generateAlert:@"Kindly enable your camera from Settings > General > Restrictions"] animated:YES completion:nil];
    }
    else if (cameraAuthorizationStatus == AVAuthorizationStatusDenied)
    {
        [self presentViewController:[UISuporterINApp generateAlert:@"Kindly enable your camera from Settings > General > Restrictions and from Settings > SYZYGY > Camera"] animated:YES completion:nil];
    }
    else if (cameraAuthorizationStatus == AVAuthorizationStatusRestricted)
    {
        [self presentViewController:[UISuporterINApp generateAlert:@"Camera restricted"] animated:YES completion:nil];
    }
}

- (void) getProfileDetail {
    
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.label.text = NSLocalizedString(@"Please Wait...", @"HUD loading title");
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        
        NSMutableDictionary *parameter = [NSMutableDictionary new];
        
        [parameter setObject:[[SYUserDefault sharedManager] getAppToken] forKey:@"token"];
        [parameter setObject: [[SYUserDefault sharedManager] getUserAuthorityId] forKey:@"authority_id"];
        
        NSLog(@"Parameter : %@" , parameter);
        NSMutableDictionary *responceDict = [UserLoginServices userDetail:parameter];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
            
            NSLog(@"%@" , responceDict);
            
            if ([[responceDict objectForKey:@"message"] isEqualToString:@"sucess"]) {
                [[SYUserDefault sharedManager] setProfilePic:[[responceDict objectForKey:@"data"] objectForKey:@"profile_pic"]];

                [self setUI:[responceDict objectForKey:@"data"]];
                
            }else if (([[responceDict objectForKey:@"message"] caseInsensitiveCompare:@"Token DoesN't Matched"] == NSOrderedSame) || ([[responceDict objectForKey:@"message"] caseInsensitiveCompare:@"Invalid Token"] == NSOrderedSame)) {
                UIStoryboard *mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                UINavigationController *mainContorller = [mainSB instantiateViewControllerWithIdentifier:@"loginNavigation"];
                [UIApplication sharedApplication].delegate.window.rootViewController = mainContorller;
            } else {
                
                [self presentViewController:[UISuporterINApp generateAlert:[responceDict objectForKey:@"message"]] animated:YES completion:nil];
            }
            
        });
    });
}

- (void) setUI :(NSMutableDictionary *) profileDetailDict {
    
    if (![profileDetailDict[@"aadharNumber"] isKindOfClass:[NSNull class]]) {
        _aadharNumberTextField.text = profileDetailDict[@"aadharNumber"];
    }
    if (![profileDetailDict[@"address"] isKindOfClass:[NSNull class]]) {
        _addressTextField.text = profileDetailDict[@"address"];
    }
    if (![profileDetailDict[@"email_id"] isKindOfClass:[NSNull class]]) {
        _emailTextField.text = profileDetailDict[@"email_id"];
    }
    if (![profileDetailDict[@"full_name"] isKindOfClass:[NSNull class]]) {
        _nameTextField.text = profileDetailDict[@"full_name"];
        [[SYUserDefault sharedManager] setUserName:profileDetailDict[@"full_name"]];
    }
    if (![profileDetailDict[@"phone"] isKindOfClass:[NSNull class]]) {
        _mobileTextField.text = profileDetailDict[@"phone"];
        [[SYUserDefault sharedManager] setUserNumber:profileDetailDict[@"phone"]];
    }
    
    if (![profileDetailDict[@"gender"] isKindOfClass:[NSNull class]]) {
        NSString *gender = profileDetailDict[@"gender"];
        if ([gender isEqualToString:@"female"]) {
            _femaleButton.selected = YES;
            _maleButton.selected = NO;
        } else {
            _maleButton.selected = YES;
            _femaleButton.selected = NO;
        }
        [[SYUserDefault sharedManager] setUserNumber:profileDetailDict[@"phone"]];
    }
    
    if (![profileDetailDict[@"profile_pic"] isKindOfClass:[NSNull class]]) {
        
         NSString *url= [NSString stringWithFormat:@"%@%@" , kProfileBaseUrl , [profileDetailDict objectForKey:@"profile_pic"]];
        [_profileImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"user"]];

       /* dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            UIImage * img = [UIImage imageWithData:[NSData dataWithContentsOfURL: [NSURL URLWithString:url]]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                _profileImageView.image = img;
            });
        });*/
    }
    
}

-(void) updateProfile:(NSMutableDictionary *)parameter {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.label.text = NSLocalizedString(@"Please Wait...", @"HUD loading title");
    NSData *imageData = UIImageJPEGRepresentation(_profileImageView.image, 0.5);

    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{

        //[UserRunningServices addSomeOne:parameter witServiceName:@"updateProfile"]
        NSMutableDictionary *responceDict = [UserLoginServices UpdateUserProfile:parameter andImageData:imageData];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
            
            if ([[responceDict objectForKey:@"status"] intValue] ==  200) {
                
                [[SYUserDefault sharedManager] setUserName:parameter[@"full_name"]];
                [[SYUserDefault sharedManager] setUserNumber:parameter[@"phone"]];
                [[SYUserDefault sharedManager] setProfilePic:[[responceDict objectForKey:@"data"] objectForKey:@"profile_pic"]];


                [self.navigationController popViewControllerAnimated:YES];
            }
            
        });
    });
    
}


@end
