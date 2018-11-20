//
//  RegisterForCareGiverOrAmbulanceViewController.m
//  Syzygy
//
//  Created by Kamal Gupta on 12/10/17.
//  Copyright © 2017 kamal gupta. All rights reserved.
//

#import "RegisterForCareGiverOrAmbulanceViewController.h"
#import "SYUserDefault.h"
#import "UserRunningServices.h"
#import "UserLoginServices.h"
#import "MBProgressHUD.h"
#import "UISuporterINApp.h"
#import "UIView+Toast.h"
#import <AVFoundation/AVFoundation.h>


@interface RegisterForCareGiverOrAmbulanceViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate> {
    
    UIImagePickerController *imagePicker;
    
}


@property (strong, nonatomic)  NSArray *ambulanceTypeInfoArray;
@property (strong, nonatomic)  NSArray *careGiverType;
@property (strong, nonatomic)  NSArray *careGiverDetails;
@property (strong, nonatomic)  NSArray *citiesArray;


@end

@implementation RegisterForCareGiverOrAmbulanceViewController {
    UIImage *ambDocument;
    UIImage *ambLincence;
    UIImage *ambDocument3;
    UIImage *ambDocument4;
    UIImage *doctorLince;
    UIImage *doctorDoc2;
    UIImage *doctorDoc3;
    UIImage *doctorDoc4;
    NSString *isAmbLince;
    NSInteger imageTag;
    NSInteger ambImageTag;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    imageTag = 0;
    self.view.backgroundColor =  [UIColor colorWithPatternImage:[UIImage imageNamed:@"viewBg"]];
    self.title = @"Register";
    
    [UISuporterINApp SetTextFieldBorder:_regTextField withView:self.view];
    [UISuporterINApp SetTextFieldBorder:_ambDriverTextField withView:self.view];
    [UISuporterINApp SetTextFieldBorder:_ambModelNumTextField withView:self.view];
    [UISuporterINApp SetTextFieldBorder:_ambModelNoTextField withView:self.view];
    [UISuporterINApp SetTextFieldBorder:_QulificationTextField withView:self.view];

    
    if ([[[SYUserDefault sharedManager] getCareGiverType] isEqualToString:@""]) {
        
        if (_isAmbulance) {
            _CareGiverListView.hidden = YES;
            _careGiverTypeView.hidden = YES;
            _ambulanceTypeView.hidden = NO;
            
            [self getAmbulanceInfo];
        }else{
            _CareGiverListView.hidden = YES;
            _careGiverTypeView.hidden = NO;
            _ambulanceTypeView.hidden = YES;
            
            [self getCareGiverInfo];
            [self getCityInfo];
        }
//        _CareGiverListView.hidden = NO;
//        _careGiverTypeView.hidden = YES;
//        _ambulanceTypeView.hidden = YES;
        
        
    } else if ([[[SYUserDefault sharedManager] getCareGiverType] isEqualToString:@"1"]) {
        
        _CareGiverListView.hidden = YES;
        _careGiverTypeView.hidden = NO;
        _ambulanceTypeView.hidden = YES;
        
         [self getCareGiverInfo];
        
        [self getSavedCareGiver];
        [self getCityInfo];
        
    } else {
        
        _CareGiverListView.hidden = YES;
        _careGiverTypeView.hidden = YES;
        _ambulanceTypeView.hidden = NO;
        
        [self getSavedCareGiver];
        [self getAmbulanceInfo];
        [self getCityInfo];

    }

    
   

    // Do any additional setup after loading the view.
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

- (IBAction)ambSelecteTypeBtnTapped:(id)sender {
    [self.view endEditing:YES];
    if (_ambulanceTypeInfoArray.count > 0) {
        
        [self openActionSheet:_ambulanceTypeInfoArray withButtonName:_ambSelectType];
    } else {
        
        [self.view makeToast:@"Reload Page" duration:0.5 position:CSToastPositionCenter];
        
    }
    
}

- (IBAction)ambUploadDocBtnTapped:(id)sender {
     [self.view endEditing:YES];
     isAmbLince = @"Doc";
    [self showImageSourceSelectionActionSheet];
}

- (IBAction)ambUploadLinBtnTApped:(id)sender {
    UIButton *btn = (UIButton*)sender;
     [self.view endEditing:YES];
    ambImageTag = btn.tag;
    isAmbLince = @"Lin";
    [self showImageSourceSelectionActionSheet];
}
- (IBAction)doctorDocButtonTapped:(id)sender {
    UIButton *btn = (UIButton*)sender;
     [self.view endEditing:YES];
    isAmbLince = @"";
    isAmbLince = @"";
    imageTag = btn.tag;
    [self showImageSourceSelectionActionSheet];
}

- (IBAction)submitBtnTapped:(id)sender {
    
    if ([UISuporterINApp isValidString:_ambModelNumTextField.text] && [UISuporterINApp isValidString:_ambModelNumTextField.text] && ambLincence != nil && ambDocument != nil && ambDocument3 != nil && ambDocument4 != nil) {
     
        NSArray *imageArr = @[ambDocument3,ambDocument4];
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        hud.label.text = NSLocalizedString(@"Please Wait...", @"HUD loading title");
        NSData *imageData = UIImageJPEGRepresentation(ambDocument, 0.5);
        NSData *licenceImageData = UIImageJPEGRepresentation(ambDocument4, 0.5);
        NSData *imageData1 = UIImageJPEGRepresentation(ambDocument3, 0.5);
        NSData *imageData2 = UIImageJPEGRepresentation(ambLincence, 0.5);

        NSString *btnTitle = _ambSelectType.titleLabel.text;
        NSMutableDictionary *parameter = [NSMutableDictionary new];
        [parameter setObject:[[SYUserDefault sharedManager] getAppToken] forKey:@"token"];
        [parameter setObject:_ambModelNumTextField.text forKey:@"vehical_registration_no"];
        [parameter setObject:_ambModelNoTextField.text forKey:@"vehical_model_no"];
        [parameter setObject:_ambDriverTextField.text forKey:@"path"];
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
            
          
            
            
            for (NSDictionary *tempDict in _ambulanceTypeInfoArray) {
                
                if ([btnTitle isEqualToString:tempDict[@"specialization"]]) {
                    
                    [parameter setObject:tempDict[@"caregiver_specialization_id"] forKey:@"ambulance_type"];
                    break;
                }
            }
            
            

            [parameter setObject:@"2" forKey:@"type"];
            
          //  NSMutableDictionary *responceDict = [UserRunningServices addSomeOne:parameter witServiceName:@"addAmbulance"];
            //+ (NSMutableDictionary *) UpdateAmbulanceProfile :(NSMutableDictionary *) parameter andImageData:(NSData*)imageData andLincenceImageData:(NSData*)licenceImageData documentArr:(NSArray*)docArr
            NSMutableDictionary *responceDict = [UserLoginServices UpdateAmbulanceProfile:parameter andImageData:imageData andLincenceImageData:licenceImageData andImage1Data:imageData1 andImage2Data:imageData2];

            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES];
                
                if ([responceDict[@"status"] intValue] == 200) {
                    
                    [[SYUserDefault sharedManager] setCareGiverType:@"2"];
                    [self.view makeToast:@"Ambulance data saved." duration:0.5 position:CSToastPositionCenter];
                    [self.navigationController popViewControllerAnimated:YES];
                    
                }
            });
        });

    }else {
        
        [self.view makeToast:@"Fill All Feilds" duration:0.5 position:CSToastPositionCenter];
    }
    
    
    
}

- (IBAction)submitCareGiverBtn:(id)sender {
    
    if ([UISuporterINApp isValidString:_QulificationTextField.text] && [UISuporterINApp isValidString:_regTextField.text] && doctorLince != nil && doctorDoc2 != nil && doctorDoc3 != nil && doctorDoc4 != nil) {
        
        NSArray *imageArr = @[doctorLince,doctorDoc2,doctorDoc3,doctorDoc4];
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        hud.label.text = NSLocalizedString(@"Please Wait...", @"HUD loading title");
        NSData *imageData = UIImageJPEGRepresentation(doctorLince, 0.5);

        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
            
            NSMutableDictionary *parameter = [NSMutableDictionary new];
            [parameter setObject:[[SYUserDefault sharedManager] getAppToken] forKey:@"token"];
            [parameter setObject:@"1" forKey:@"type"];
            
            NSString *btnTitle = _careGiverTypeBtn.titleLabel.text;
            
            for (NSDictionary *tempDict in _careGiverType) {
                
                if ([btnTitle isEqualToString:tempDict[@"service_name"]]) {
                    
                    [parameter setObject:tempDict[@"service_id"] forKey:@"service_id"];
                    break;
                }
            }
            
            btnTitle = _specilistBtn.titleLabel.text;
            if (_careGiverDetails.count == 0) {
                [parameter setObject:@"" forKey:@"specialization_id"];
            }
            for (NSDictionary *tempDict in _careGiverDetails) {
                
                if ([btnTitle isEqualToString:tempDict[@"specialization"]]) {
                    
                    [parameter setObject:tempDict[@"caregiver_specialization_id"] forKey:@"specialization_id"];
                    break;
                }
            }
            
            [parameter setObject:_QulificationTextField.text forKey:@"qualificatin"];
            [parameter setObject:_regTextField.text forKey:@"registration_no"];
            //doctorLince
            /*service_id
             type
             specialization_id
             qualificatin
             registration_no , document*/
            NSMutableDictionary *responceDict = [UserLoginServices UpdateCaregiverProfile:parameter andImageArr:imageArr];

           // NSMutableDictionary *responceDict = [UserRunningServices addSomeOne:parameter witServiceName:@"addDetailsCaregiver"];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES];
                
                if ([responceDict[@"status"] intValue] == 200) {
                    
                    [[SYUserDefault sharedManager] setCareGiverType:@"1"];
                    [self.view makeToast:@"CareGiver data saved." duration:0.5 position:CSToastPositionCenter];
                    [self.navigationController popViewControllerAnimated:YES];
                    
                }
            });
        });
        
    }else {
        
        [self.view makeToast:@"Fill All Feilds" duration:0.5 position:CSToastPositionCenter];
    }

    
    
}

- (IBAction)careGiverTypeButtonTapped:(id)sender {
     [self.view endEditing:YES];
    if (_careGiverType.count > 0) {
        
        [self openActionSheet:_careGiverType withButtonName:_careGiverTypeBtn];
    } else {
        
        [self.view makeToast:@"Reload Page" duration:0.5 position:CSToastPositionCenter];

    }
    
}

- (IBAction)specialBtnTapped:(id)sender {
     [self.view endEditing:YES];
    if (_careGiverDetails.count > 0) {
        [self openActionSheet:_careGiverDetails withButtonName:_specilistBtn];
    } else {
        
        [self.view makeToast:@"select above feild." duration:0.5 position:CSToastPositionCenter];
        
    }
    
}

- (IBAction)ActionOnCityButton:(id)sender {
    [self openCityActionSheet:_citiesArray];
}

- (IBAction)careGiverButtonTapped:(id)sender {
    
    _CareGiverListView.hidden = YES;
    _careGiverTypeView.hidden = NO;
    _ambulanceTypeView.hidden = YES;
    
    [self getCareGiverInfo];
    
}

- (IBAction)ambulanceButttonTapped:(id)sender {
    
    _CareGiverListView.hidden = YES;
    _careGiverTypeView.hidden = YES;
    _ambulanceTypeView.hidden = NO;
    
    [self getAmbulanceInfo];
}


- (void)getCareGiverInfo {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.label.text = NSLocalizedString(@"Loading...", @"HUD loading title");
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        
        NSMutableDictionary *parameter = [NSMutableDictionary new];
        [parameter setObject:[[SYUserDefault sharedManager] getAppToken] forKey:@"token"];
        
        NSMutableDictionary *responceDict = [UserRunningServices getOtherServices:parameter witServiceName:@"getServices"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
            
            if ([responceDict[@"status"] intValue] == 200) {
                
                _careGiverType =  responceDict[@"data"];
            }
        });
    });
    
}

- (void)getCareGiverDetail :(NSString *)serviceId{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.label.text = NSLocalizedString(@"Loading...", @"HUD loading title");
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        
        NSMutableDictionary *parameter = [NSMutableDictionary new];
        [parameter setObject:[[SYUserDefault sharedManager] getAppToken] forKey:@"token"];
        [parameter setObject:serviceId forKey:@"service_id"];

        
        NSMutableDictionary *responceDict = [UserRunningServices getOtherServices:parameter witServiceName:@"specializationList"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
            
            if ([responceDict[@"status"] intValue] == 200) {
                self.specilistBtn.hidden = NO;
                self.specialistLab.hidden = NO;
                self.specialistHeight.constant = 40;
                self.specialExapand.hidden = NO;
                _careGiverDetails =  responceDict[@"data"];
                NSDictionary *firstObj = [_careGiverDetails firstObject];
                [self.specilistBtn setTitle:[firstObj objectForKey:@"specialization"] forState:UIControlStateNormal];
            }else {
                self.specilistBtn.hidden = YES;
                self.specialistLab.hidden = YES;
                self.specialistHeight.constant = 0;
                self.specialExapand.hidden = YES;
                _careGiverDetails = nil;
                [self.view makeToast:@"No Specialization Found" duration:0.5 position:CSToastPositionCenter];

            }
        });
    });
    
}


- (void)getAmbulanceInfo {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.label.text = NSLocalizedString(@"Loading...", @"HUD loading title");
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        
        NSMutableDictionary *parameter = [NSMutableDictionary new];
        [parameter setObject:[[SYUserDefault sharedManager] getAppToken] forKey:@"token"];
        [parameter setObject:@"2" forKey:@"type"];//DILIP

        NSMutableDictionary *responceDict = [UserRunningServices getOtherServices:parameter witServiceName:@"getAmbulanceType"];

        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
            
            if ([responceDict[@"status"] intValue] == 200) {
                
                _ambulanceTypeInfoArray =  responceDict[@"data"];
            }
        });
    });
}

- (void)getCityInfo {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.label.text = NSLocalizedString(@"Loading...", @"HUD loading title");
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        
        NSMutableDictionary *parameter = [NSMutableDictionary new];
        [parameter setObject:[[SYUserDefault sharedManager] getAppToken] forKey:@"token"];
        
        NSMutableDictionary *responceDict = [UserRunningServices getOtherServices:parameter witServiceName:@"getCityList"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
            
            if ([responceDict[@"status"] intValue] == 200) {
                
                _citiesArray =  responceDict[@"data"];
                if ([[[SYUserDefault sharedManager] getCareGiverType] isEqualToString:@"1"]) {
                    [self.cityButton setTitle:[[_citiesArray firstObject] objectForKey:@"city_name"] forState:UIControlStateNormal];
                }else{
                    [self.ambCityButton setTitle:[[_citiesArray firstObject] objectForKey:@"city_name"] forState:UIControlStateNormal];

                }
            }
        });
    });
}


- (void)openActionSheet :(NSArray *)arrayList withButtonName:(UIButton *) btnName{
    
    UIAlertController *myActionSheet = [UIAlertController alertControllerWithTitle:@"Select " message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    for (NSDictionary *dict in arrayList) {
        NSString *title =  @"";
        NSString *serviceId = @"";
        if (dict[@"specialization"]) {
            title = dict[@"specialization"];
        }
        
        if (dict[@"service_name"]) {
            title = dict[@"service_name"];
            serviceId = dict[@"service_id"];
        }
        
        UIAlertAction *addBtn = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [btnName setTitle:title forState:UIControlStateNormal];
            
            if (![serviceId isEqualToString:@""]) {
                
                [self getCareGiverDetail:serviceId];
            }
            
        }];
        [myActionSheet addAction:addBtn];
        
    }
    
    [myActionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:myActionSheet animated:YES completion:nil];
    
    
}

- (void)openCityActionSheet :(NSArray *)arrayList{
    
    UIAlertController *myActionSheet = [UIAlertController alertControllerWithTitle:@"Select " message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    for (NSDictionary *dict in arrayList) {
        NSString *title =  [dict objectForKey:@"city_name"];
     
        
        UIAlertAction *addBtn = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if ([[[SYUserDefault sharedManager] getCareGiverType] isEqualToString:@"1"]) {
                [self.cityButton setTitle:title forState:UIControlStateNormal];
            }else{
                [self.ambCityButton setTitle:title forState:UIControlStateNormal];
            }
        }];
        [myActionSheet addAction:addBtn];
        
    }
    
    [myActionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:myActionSheet animated:YES completion:nil];
    
}

- (void) getSavedCareGiver {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.label.text = NSLocalizedString(@"Loading...", @"HUD loading title");
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        
        NSMutableDictionary *parameter = [NSMutableDictionary new];
        [parameter setObject:[[SYUserDefault sharedManager] getAppToken] forKey:@"token"];
        
        NSMutableDictionary *responceDict = [UserRunningServices addSomeOne:parameter witServiceName:@"getCaregiverDetail"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
            
            if ([responceDict[@"status"] intValue] == 200) {
                NSDictionary *dataDic = [[responceDict objectForKey:@"dada"]firstObject];
                [self setDataFromResponse:dataDic];
              /*  NSData *data = [NSJSONSerialization dataWithJSONObject:responceDict options:kNilOptions error:nil];
                NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"%@",str);*/
                
            }
        });
    });
}

-(void)setDataFromResponse:(NSDictionary*)response{
    //document
      //  self.documentExapandIcon.image = [UIImage imageNamed:@"checked"];
        [self.careGiverTypeBtn setTitle:[response objectForKey:@"service_name"] forState:UIControlStateNormal];
    
    self.specilistBtn.hidden = YES;
    self.specialistLab.hidden = YES;
    self.specialistHeight.constant = 0;
    self.specialExapand.hidden = YES;
    self.regTextField.text = [response objectForKey:@"registration_no"];
    self.QulificationTextField.text = [response objectForKey:@"service_detail"];
    NSString *btnTitle = [response objectForKey:@"service_name"];
    NSString *serviceId = @"";
    for (NSDictionary *tempDict in _careGiverType) {
        
        if ([btnTitle isEqualToString:tempDict[@"service_name"]]) {
            serviceId = [tempDict objectForKey:@"service_id"];
            break;
        }
    }
    [self getCareGiverDetail:serviceId];

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
    
    if ([isAmbLince isEqualToString:@"Doc"]) {
        
        ambDocument = imageFromPicker;
        _ambExpand1.image = [UIImage imageNamed:@"checked"];
    } else if ([isAmbLince isEqualToString:@"Lin"]) {
        
        switch (ambImageTag) {
            case 2:
                _ambExpand2.image = [UIImage imageNamed:@"checked"];
                ambLincence = imageFromPicker;
                break;
            case 3:
                _ambExpand3.image = [UIImage imageNamed:@"checked"];
                ambDocument3 = imageFromPicker;
                break;
            case 4:
                _ambExpand4.image = [UIImage imageNamed:@"checked"];
                ambDocument4 = imageFromPicker;
                break;
            default:
                break;
        }
    } else {
        switch (imageTag) {
            case 1:
                doctorLince = imageFromPicker;
                self.documentExapandIcon.image = [UIImage imageNamed:@"checked"];
                break;
            case 2:
                doctorDoc2 = imageFromPicker;
                self.documentIcon2.image = [UIImage imageNamed:@"checked"];
                break;
            case 3:
                doctorDoc3 = imageFromPicker;
                self.documentIcon3.image = [UIImage imageNamed:@"checked"];
                break;
            case 4:
                doctorDoc4 = imageFromPicker;
                self.documentIcon4.image = [UIImage imageNamed:@"checked"];
                break;
                
            default:
                break;
        }
        
    }
    
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

#pragma mark - UITextField delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

//http://activegrowthinc.com/careApp/getCityList
@end
