//
//  AddSeniorViewController.m
//  Syzygy
//
//  Created by Kamal Gupta on 12/2/17.
//  Copyright © 2017 kamal gupta. All rights reserved.
//

#import "AddSeniorViewController.h"
#import "UISuporterINApp.h"
#import "SYUserDefault.h"
#import "Constant.h"
#import "MBProgressHUD.h"
#import "UserRunningServices.h"
#import <AVFoundation/AVFoundation.h>


@interface AddSeniorViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITextFieldDelegate>

@end

@implementation AddSeniorViewController {
    
    UIImagePickerController *imagePicker;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor =  [UIColor colorWithPatternImage:[UIImage imageNamed:@"viewBg"]];
    self.title = @"Add Someone";
    
    [UISuporterINApp SetTextFieldBorder:_nameTextField withView:self.view];
    [UISuporterINApp SetTextFieldBorder:_ageTextField withView:self.view];
    [UISuporterINApp SetTextFieldBorder:_mobileTextField withView:self.view];
    [UISuporterINApp SetTextFieldBorder:_addressTextField withView:self.view];
    [UISuporterINApp SetTextFieldBorder:_specialInstTextField withView:self.view];
    [UISuporterINApp SetTextFieldBorder:_specialNeedsTextField withView:self.view];
    [UISuporterINApp SetTextFieldBorder:_reletionTextField withView:self.view];
    [UISuporterINApp SetTextFieldBorder:_descriptionTextField withView:self.view];

    _maleButton.selected = YES;
    _femaleButton.selected = NO;
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    tapRecognizer.numberOfTapsRequired = 1;
    [_profileImageView setUserInteractionEnabled:YES];

    [_profileImageView addGestureRecognizer:tapRecognizer];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)checkGender:(UIButton *)sender {
    
    if (sender.tag == 11) {
        _maleButton.selected = YES;
        _femaleButton.selected = NO;
    } else {
        
        _maleButton.selected = NO;
        _femaleButton.selected = YES;
    }
}

- (IBAction)addSomeOne:(id)sender {
    
    NSMutableDictionary *parameter = [NSMutableDictionary new];
    
    NSString *message = @"";

    if ([UISuporterINApp isValidString:_nameTextField.text]) {
        
        [parameter setObject:_nameTextField.text forKey:@"senior_name"];
    } else {
        
        message = @"Enter Name";
    }
    
    if ([UISuporterINApp isValidString:_ageTextField.text]) {
        [parameter setObject:_ageTextField.text forKey:@"senior_age"];
        
    } else {
        
        message = [NSString stringWithFormat:@"%@ \n%@" , message , @"Enter Age"];
    }
    if ([UISuporterINApp isValidPhoneString:_mobileTextField.text]) {
        
        [parameter setObject:_mobileTextField.text forKey:@"senior_phone"];
    } else {
        
        message = [NSString stringWithFormat:@"%@ \n%@" , message , @"Enter Mobile Number"];
    }
    if ([UISuporterINApp isValidString:_addressTextField.text]) {
        [parameter setObject:_addressTextField.text forKey:@"address"];
        
    } else {
        
        message = [NSString stringWithFormat:@"%@ \n%@" , message , @"Enter Address"];
    }
    if ([UISuporterINApp isValidString:_specialInstTextField.text]) {
        [parameter setObject:_specialInstTextField.text forKey:@"special_instruction"];
        
    } else {
        
        message = [NSString stringWithFormat:@"%@ \n%@" , message , @"Enter special Instruction"];
    }
    if ([UISuporterINApp isValidString:_specialInstTextField.text]) {
        [parameter setObject:_specialNeedsTextField.text forKey:@"special_needs"];
        
    } else {
        
        message = [NSString stringWithFormat:@"%@ \n%@" , message , @"Enter special needs"];
    }
    if ([UISuporterINApp isValidString:_reletionTextField.text]) {
        //[parameter setObject:_reletionTextField.text forKey:@""];
        
    } else {
        
        message = [NSString stringWithFormat:@"%@ \n%@" , message , @"Enter reletion"];
    }
    
    if ([_descriptionTextField .text length] > 0) {
        [parameter setObject:_descriptionTextField.text forKey:@"description"];
        
    } else {
        
        message = [NSString stringWithFormat:@"%@ \n%@" , message , @"Enter description"];
    }
    
    if (_maleButton.isSelected) {
        [parameter setObject:@"male" forKey:@"senior_gender"];
        
    } else{
        [parameter setObject:@"female" forKey:@"senior_gender"];
        
    }
    if (_profileImageView.image != nil) {
//        [parameter setObject:[UISuporterINApp encodeToBase64String:_profileImageView.image] forKey:@"profile_pic"];
    }

    if ([message isEqualToString:@""]) {
        
        [parameter setObject:[[SYUserDefault sharedManager] getAppToken] forKey:@"token"];
        [self addSomeOneToserver:parameter];

    } else {
        
        [self presentViewController:[UISuporterINApp generateAlert:message] animated:YES completion:nil];

    }
    
}

-(void) addSomeOneToserver:(NSMutableDictionary *)parameter {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.label.text = NSLocalizedString(@"Please Wait...", @"HUD loading title");
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        
        NSMutableDictionary *responceDict = [UserRunningServices addSomeOne:parameter witServiceName:@"addSenior"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
            
            if ([[responceDict objectForKey:@"status"] intValue] ==  200) {
                if ([self.delegate respondsToSelector:@selector(didAddSomeOne:)]) {
                    [self.delegate didAddSomeOne:parameter];
                }
                [self.navigationController popViewControllerAnimated:YES];
            }
            
        });
    });
    
}

#pragma mark : UITextField delegates

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString * searchStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSLog(@"%@",searchStr);
    if (textField == _mobileTextField) {
        NSCharacterSet* notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
        if ([string rangeOfCharacterFromSet:notDigits].location != NSNotFound)
        {
            // newString consists only of the digits 0 through 9
            return NO;
        }else if (searchStr.length > 10){
            return NO;
        }
    }else if (textField == _ageTextField){
        NSCharacterSet* notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
        if ([string rangeOfCharacterFromSet:notDigits].location != NSNotFound)
        {
            // newString consists only of the digits 0 through 9
            return NO;
        }else if ([searchStr intValue] > 100){
            return NO;
        }
    }
    return YES;
}

@end
