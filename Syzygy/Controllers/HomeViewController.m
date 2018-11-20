//
//  HomeViewController.m
//  Syzygy
//
//  Created by kamal gupta on 12/1/17.
//  Copyright © 2017 kamal gupta. All rights reserved.
//


#import "HomeViewController.h"
#import "MFSideMenu.h"
#import <GoogleMaps/GoogleMaps.h>
#import <GooglePlaces/GooglePlaces.h>
#import "SYUserDefault.h"
#import "Constant.h"
#import "LGPlusButtonsView.h"
#import "HealthTipsListViewController.h"
#import "MBProgressHUD.h"
#import "UserRunningServices.h"
#import "CareGiverListCollectionViewCell.h"
#import "UIView+Toast.h"
#import "AddSeniorViewController.h"
#import "HealthTipsListViewController.h"
#import "ClientNotificationUIView.h"
#import "YourBillView.h"
#import "AddReminderViewController.h"
//#import "PUSAStartScreenVC.h"
#import "HomeTVC.h"
#import "SeniorListViewController.h"
#import "RequestNotificationUIView.h"
#import "FinishProcessUIView.h"
#import "AppDelegate.h"
#import "careGiverBill.h"
#import "YourBillView.h"


//Pay u momy//
#import "HomeTableCell.h"
#import <PayUMoneyCoreSDK/PayUMoneyCoreSDK.h>
#import "Utils.h"
#import "iOSDefaultActivityIndicator.h"
#import "APIListVC.h"
#import "Constants.h"

//////////



@import GooglePlacePicker;



@interface HomeViewController () <UICollectionViewDataSource, UICollectionViewDelegate, CLLocationManagerDelegate,GMSAutocompleteViewControllerDelegate,UITextFieldDelegate,AddReminderViewControllerDelegates,SeniorListViewControllerDelegate,GMSMapViewDelegate>
{
    int envIndex;
}
- (IBAction)manuBarButtonTapped:(id)sender;

@property (strong, nonatomic) LGPlusButtonsView *plusButtonsViewNavBar;
@property (strong, nonatomic) NSMutableArray *buttonPositionsArr;
@property (strong, nonatomic) UIView *NavigationButtonView;
@property (retain, nonatomic) NSDictionary *requestDic;

//pay u m ony//


@property (strong, nonatomic) NSArray *arrPaymentParamKey, *arrMerchantKey, *arrMerchantID, *arrMerchantSalt, *arrEnvironment;
@property (strong, nonatomic) NSMutableArray *arrPaymentParamValue;
@property (strong, nonatomic) iOSDefaultActivityIndicator *defaultActivityIndicator;

////

@end

@implementation HomeViewController {
    GMSMapView *googleMapView;
    CLLocationManager *locationManager;
    GMSCameraPosition *camera;
    GMSPlacesClient *_placesClient;
    BOOL firstLocationUpdate_;
    NSString *segueIndentifier;
    double currentLatitude;
    double currentLongitude;
    NSMutableArray *newAllServicesArray;
    NSMutableArray *allServicesArray;
    NSMutableArray *ambulanceArray;
    NSMutableArray *careGiverArray;
    NSMutableArray *newCareGiverArray;
    NSMutableArray *careGiverServicesArr;
    NSMutableArray *careGiverSpecializationArr;
    BOOL isCareGiver;
    BOOL isServices;
    BOOL isFirstTime;
    BOOL isSpecialization;
    BOOL isCareSpecialization;
    NSMutableDictionary *confirmArray;
    NSString *selectedServiceId;
    NSString *hireType;
    NSString *seniorId;
    BOOL isForSomeone;
    float minMumCharge;
    BOOL isStartRide;
    BOOL isHealthPooint;
    ClientNotificationUIView *requestNotificationUIView;
    NSTimer *timer;
    GMSPolyline *polyline;
    NSMutableDictionary *startRideDic;
    CLLocationCoordinate2D destinationLoc;
    GMSMarker *sourceMarker;
    GMSMarker *destMarker;
    CLLocationCoordinate2D MarkerDestinationLoc;
    CLLocationCoordinate2D MarkerSourceLoc;
    FinishProcessUIView *finishVIew;
    BOOL isCash;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //pay u mony//
    self.arrMerchantKey = [NSArray arrayWithObjects:@"mdyCKV",@"40747T",@"", nil];
    self.arrMerchantID = [NSArray arrayWithObjects:@"4914106",@"396132",@"", nil];
    self.arrMerchantSalt = [NSArray arrayWithObjects:@"Je7q3652",@"cJHb2BC9",@"", nil];
    self.arrEnvironment = [NSArray arrayWithObjects:@"0",@"1",@"", nil];
    [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"PUMENVIRONMENT"];
    id env = [[NSUserDefaults standardUserDefaults] valueForKey:@"PUMENVIRONMENT"];
    if (env) {
        envIndex = [env intValue];
    }
    else{
        [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"PUMENVIRONMENT"];
        envIndex = 0;
    }
    
    
    self.arrPaymentParamKey = [NSArray arrayWithObjects:@"key",@"merchantid",@"txnID",@"amount",@"phone",@"email",@"firstname",@"surl",@"furl",@"productInfo",@"udf1",@"udf2",@"udf3",@"udf4",@"udf5",@"udf6",@"udf7",@"udf8",@"udf9",@"udf10",@"Environment", nil];
   
    
    self.defaultActivityIndicator = [iOSDefaultActivityIndicator new];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paymentCompletion:) name:PaymentCompletion object:nil];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
//    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
//    [self.view addGestureRecognizer:tapGesture];
//
    
    
    
    
    
    
    //////////////////
 //   self.menuContainerViewController.delegate = self;

    [self Adddonebtntitle];

    self.title = @"Home";
    locationManager = [[CLLocationManager alloc] init];
    camera = [GMSCameraPosition cameraWithLatitude:22.7244
                                         longitude:75.8839
                                              zoom:15];
    _placesClient = [GMSPlacesClient sharedClient];

    if ([[[SYUserDefault sharedManager] getUserAuthorityId] intValue] == USER_TYPE) {
      //  _Loctionview.hidden = YES;
        self.navigationController.navigationBar.barTintColor = USER_COLOR;
        [self navigationButtonsAdded];
    } else {
        self.navigationController.navigationBar.barTintColor = CAREGIVER_COLOR;
        self.navigationItem.rightBarButtonItem = nil;
        _Loctionview.hidden = YES;
    }
    
    self.datePickerView.frame = CGRectMake(0, self.view.frame.size.height-210, self.view.frame.size.width, 220);
    [self.view addSubview:self.datePickerView];
    self.datePickerView.hidden = YES;
    _confirmHireView.hidden = YES;
    _careGiverCollectionView.hidden = YES;
    _careGiverCollectionView.delegate = self;
    _careGiverCollectionView.dataSource = self;
    self.view.backgroundColor =  [UIColor colorWithPatternImage:[UIImage imageNamed:@"viewBg"]];
    self.menuContainerViewController.panMode = MFSideMenuPanModeNone;
    
    UIView *leftViewt = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 30, 40)];
    UIImageView *searchImage = [[UIImageView alloc]initWithFrame:CGRectMake(3, 12, 15, 15)];
    searchImage.image = [UIImage imageNamed:@"search"];
    [leftViewt addSubview:searchImage];
    self.Searchtextfiled.placeholder = @"Current location";
    self.Searchtextfiled.leftView = leftViewt;
    self.Searchtextfiled.leftViewMode = UITextFieldViewModeAlways;
    self.Loctionview.layer.cornerRadius = 5;

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveStartRideNotification:)
                                                 name:@"openSearchAPI"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveStartRideNotification:)
                                                 name:@"startRide"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveStartRideNotification:)
                                                 name:@"endRide"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveStartRideNotification:)
                                                 name:@"online"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveStartRideNotification:)
                                                 name:@"CashSuccess"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveStartRideNotification:)
                                                 name:@"paymentSuccess"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveStartRideNotification:)
                                                 name:@"paymentBack"
                                               object:nil];
    
    //
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(cancelTimer)
                                                 name:@"acceptRequest"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveStartRideNotification:)
                                                 name:@"hire_later"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveStartRideNotification:)
                                                 name:@"CaregiverEndRide"
                                               object:nil];
    //
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadviewWithEvent:) name:MFSideMenuStateNotificationEvent object:nil];
    
    [self callInitalAPI];
}

- (void)callInitalAPI
{
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.label.text = NSLocalizedString(@"Loading...", @"HUD loading title");
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        
        NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
        [parameter setObject:[[SYUserDefault sharedManager] getAppToken] forKey:@"token"];
        
        NSMutableDictionary *responceDict = [UserRunningServices addSomeOne:parameter witServiceName:@"getbookingstatusforuser"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
//            [hud hideAnimated:YES];
            NSLog(@"responceDict = %@", responceDict);
            if ([responceDict[@"status"] intValue] == 200) {
                
                NSArray *arrData = responceDict[@"data"];
                dictBookingStatus = arrData.firstObject;
                strBookingStatus = dictBookingStatus[@"bookingstatus"];
                hire_caregiver_id = dictBookingStatus[@"hire_caregiver_id"];
                
//                CareGiver_id = userCurrentStatus.getCaregiverId();
//                Hire_CareGiver_id = userCurrentStatus.getHireCaregiverId();
//                tvCaregiverId.setText(userCurrentStatus.getFullName());
//                callnumber = userCurrentStatus.getPhone();
                
                // On status payment need to show UI with title "Summary "
                // id status start than show Hiring UI
                
                //On accepted need to show this Confirm view and hide all other view
                
                if([strBookingStatus isEqualToString:@"accepted"])
                {
                    
                    [self acceptUserRequest:responceDict];
                    
                    //acceptUserRequest
//                    _confirmHireView.hidden = YES;
//                    _careGiverCollectionView.hidden= YES;
//                    _reConfirmHireView.hidden = YES;
//
//                    _requestDic = [responceDict objectForKey:@"data"];
//                    [self.view makeToast:@"Notification sending..." duration:0.10 position:CSToastPositionBottom];
//                    requestNotificationUIView = [[[NSBundle mainBundle] loadNibNamed:@"ClientNotificationUIView" owner:self options:nil] objectAtIndex:0];
//                    [requestNotificationUIView removeWaitingView];
//                    [requestNotificationUIView setFrame:CGRectMake(0, _ambulanceButton.frame.origin.y, self.view.frame.size.width, 50)];
//                    [[UIApplication sharedApplication].keyWindow addSubview:requestNotificationUIView];
//
//                    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//                    [appDelegate Cancerequestbyclint];
//
//                    hire_caregiver_id = [_requestDic objectForKey:@"hire_caregiver_id"];
                }
                else if([strBookingStatus isEqualToString:@"start"])
                {
                    
                    [self getDestinationLocation:[dictBookingStatus objectForKey:@"caregiver_id"]];
                    
                }

            }
        });
    });
}

- (void)getDestinationLocation:(NSString *)caregiver_id
{
//    getCaregiveCurrentLocation
//    prams.put("hire_caregiver_id", Hire_CareGiver_id);
//    prams.put("caregiver_id", CareGiver_id);

    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        
        NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
        [parameter setObject:hire_caregiver_id forKey:@"hire_caregiver_id"];
        [parameter setObject:caregiver_id forKey:@"caregiver_id"];
        
        NSMutableDictionary *responceDict = [UserRunningServices addSomeOne:parameter witServiceName:@"getCaregiveCurrentLocation"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //            [hud hideAnimated:YES];
            NSLog(@"responceDict = %@", responceDict);
            if ([responceDict[@"status"] intValue] == 200) {
                
                NSArray *arrData = responceDict[@"data"];
                NSMutableDictionary *dictData = arrData.firstObject;
                
                //[self StartRide:dictData];
                [self StartRide:responceDict];//responceDict
            }
        });
    });
}

- (void)StartRide:(NSMutableDictionary *)startRideCareGiverData {
    
    NSArray *arrData = startRideCareGiverData[@"data"];
    NSMutableDictionary *dictData = arrData.firstObject;

    NSString *strDLat = [dictData objectForKey:@"dest_lattitude"];
    NSString *strDLng = [dictData objectForKey:@"dest_longitude"];
    
    NSString *strLat = [dictData objectForKey:@"lattitude"];
    NSString *strLng = [dictData objectForKey:@"longitude"];

    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    for (UIView *views in [appDelegate.window subviews]) {
        
        if ([views isKindOfClass: [RequestNotificationUIView class]] || [views isKindOfClass: [ClientNotificationUIView class]]) {
            [views removeFromSuperview];
        }
    }
    
//    NSString *receiveData = startRideCareGiverData;//data[@"data"][@"test_msg"];
//    NSData *datad = [receiveData dataUsingEncoding:NSUTF8StringEncoding];
//    NSMutableDictionary *requestData = [NSJSONSerialization JSONObjectWithData:datad options:0 error:nil];
//    [startRideCareGiverData setObject:[requestData objectForKey:@"source_latitude"] forKey:@"latitude"];
//    [startRideCareGiverData setObject:[requestData objectForKey:@"source_longitude"] forKey:@"longitud"];
    
    NSString *receiveData = startRideCareGiverData[@"data"][@"test_msg"];
    NSData *datad = [receiveData dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *requestData = [NSJSONSerialization JSONObjectWithData:datad options:0 error:nil];
    [startRideCareGiverData setObject:strLat forKey:@"latitude"];
    [startRideCareGiverData setObject:strLng forKey:@"longitud"];
    
    ClientNotificationUIView *requestNotificationUIView = [[[NSBundle mainBundle] loadNibNamed:@"ClientNotificationUIView" owner:self options:nil] objectAtIndex:0];
    
    [requestNotificationUIView setFrame:CGRectMake(0, screenHeight-50 , screenWidth, 50)];
    requestNotificationUIView.startRide = YES;
    requestNotificationUIView.dataNotificationDict = startRideCareGiverData;
    
    NSDictionary *rideDic = @{@"ride":requestData,@"caregiver_detail":startRideCareGiverData};
    [[UIApplication sharedApplication].keyWindow addSubview:requestNotificationUIView];
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"startRide"
     object:rideDic];
}


//Pay mony mahnwndra
-(void)paymentCompletion:(NSNotification *) notification{
    [self.navigationController popToViewController:self animated:YES];
    NSDictionary *notiDict = notification.object;
    if ([[notiDict valueForKey:RESPONSE] allKeys].count > 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Payment Success" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"paymentSuccess" object:[[notiDict valueForKey:RESPONSE] objectForKey:@"result"]];
        }];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
        //  [Utils showMsgWithTitle:RESPONSE message:[NSString stringWithFormat:@"%@",[notiDict valueForKey:RESPONSE]]];
        // [self.navigationController popViewControllerAnimated:YES];
        //        for (UIViewController *controller in self.navigationController.viewControllers)
        //        {
        //            if ([controller isKindOfClass:[HomeViewController class]])
        //            {
        //                [self.navigationController popToViewController:controller animated:YES];
        //                break;
        //            }
        //        }
    }
    else if ([notiDict valueForKey:ERROR]){
        NSError *err = [notiDict valueForKey:ERROR];
        [Utils showMsgWithTitle:ERROR message:[NSString stringWithFormat:@"%@",err.localizedDescription]];
    }
    else{
        [Utils showMsgWithTitle:ERROR message:@"Report this error to Umang"];
    }
}



///////////////



#pragma mark - start notification

- (void) receiveStartRideNotification:(NSNotification *) notification
{
    // [notification name] should always be @"TestNotification"
    // unless you use this method for observation of other notifications
    // as well.
    //CaregiverEndRide
    //CashSuccess
    if ([[notification name] isEqualToString:@"startRide"]){
        NSDictionary *caregiverDetail = [notification.object objectForKey:@"caregiver_detail"];
        CLLocationCoordinate2D destination = CLLocationCoordinate2DMake([[caregiverDetail objectForKey:@"latitude"]doubleValue],[[caregiverDetail objectForKey:@"longitud"]doubleValue]);
        CLLocationCoordinate2D source = CLLocationCoordinate2DMake([[[SYUserDefault sharedManager] getCurrentLat] doubleValue],[[[SYUserDefault sharedManager] getCurrentLng] doubleValue]);
        [self loadMapViewWithDirectionWithSource:source andDistination:destination];
//        GMSMutablePath *path = [GMSMutablePath path];
//        [path addCoordinate:source];
//        [path addCoordinate:destination];
//
//        GMSPolyline *rectangle = [GMSPolyline polylineWithPath:path];
//        rectangle.strokeWidth = 2.f;
//        rectangle.map = googleMapView;
//        NSLog (@"Successfully received the test notification! %@",notification.object);
        
    }else if ([[notification name]isEqualToString:@"CaregiverEndRide"]){
        NSDictionary *endRideDic = notification.object;
        _requestDic = notification.object;
        if ([[[SYUserDefault sharedManager] getUserAuthorityId] intValue] == USER_TYPE) {
            self.ambulanceButton.hidden = NO;
            self.careGiverButton.hidden = NO;
        }
        [self googleMapForCareGiver];
        if (endRideDic.allKeys.count > 0) {
            self.navigationController.navigationBar.hidden = YES;
            finishVIew = [[[NSBundle mainBundle] loadNibNamed:@"FinishProcessUIView" owner:self options:nil] objectAtIndex:0];
            [finishVIew setFrame:CGRectMake(0, 0 , [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
            finishVIew.RececitDict = [endRideDic mutableCopy];
            [self.view addSubview:finishVIew];
        }
    }else if ([[notification name]isEqualToString:@"endRide"]){
        NSDictionary *endRideDic = notification.object;
        _requestDic = notification.object;

        if ([[[SYUserDefault sharedManager] getUserAuthorityId] intValue] == USER_TYPE) {
            self.ambulanceButton.hidden = NO;
            self.careGiverButton.hidden = NO;
        }
        [self googleMapForCareGiver];
        if (endRideDic.allKeys.count > 0) {
            self.navigationController.navigationBar.hidden = YES;
            finishVIew = [[[NSBundle mainBundle] loadNibNamed:@"FinishProcessUIView" owner:self options:nil] objectAtIndex:0];
            [finishVIew setFrame:CGRectMake(0, 0 , [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
            finishVIew.RececitDict = [endRideDic mutableCopy];
            [self.view addSubview:finishVIew];
        }
    }else if ([[notification name]isEqualToString:@"online"]){
        
    
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:UIApplication.sharedApplication.keyWindow animated:YES];
        _requestDic = notification.object;
        self.navigationController.navigationBar.hidden = NO;
        finishVIew.hidden = NO;
        NSDictionary *packageDetail = notification.object;
        
         self.arrPaymentParamValue = [NSMutableArray arrayWithObjects:[self.arrMerchantKey objectAtIndex:envIndex],[self.arrMerchantID objectAtIndex:envIndex],[Utils getTxnID],[NSString stringWithFormat:@"%.2f",[[packageDetail objectForKey:@"payable"]doubleValue]],@"9717410858",@"umangarya336@gmail.com",[packageDetail objectForKey:@"full_name"],@"http://www.google.com",@"http://www.google.com",@"",@"udf1",@"udf2",@"udf3",@"udf4",@"udf5",@"udf6",@"udf7",@"udf8",@"udf9",@"udf10",[self.arrEnvironment objectAtIndex:envIndex], nil];
        [self.defaultActivityIndicator startAnimatingActivityIndicatorWithSelfView:self.view];
        
        [self.view endEditing:YES];
        
        PUMTxnParam *txnParam = [[PUMTxnParam alloc] init];
        txnParam.key = [self.arrPaymentParamValue objectAtIndex:0];
        txnParam.merchantid = [self.arrPaymentParamValue objectAtIndex:1];
        txnParam.txnID = [self.arrPaymentParamValue objectAtIndex:2];
        txnParam.amount = [self.arrPaymentParamValue objectAtIndex:3];
        txnParam.phone = [self.arrPaymentParamValue objectAtIndex:4];
        txnParam.email = [self.arrPaymentParamValue objectAtIndex:5];
        txnParam.firstname = [self.arrPaymentParamValue objectAtIndex:6];
        txnParam.surl = [self.arrPaymentParamValue objectAtIndex:7];
        txnParam.furl = [self.arrPaymentParamValue objectAtIndex:8];
        txnParam.productInfo = [self.arrPaymentParamValue objectAtIndex:9];
        txnParam.udf1 = [self.arrPaymentParamValue objectAtIndex:10];
        txnParam.udf2 = [self.arrPaymentParamValue objectAtIndex:11];
        txnParam.udf3 = [self.arrPaymentParamValue objectAtIndex:12];
        txnParam.udf4 = [self.arrPaymentParamValue objectAtIndex:13];
        txnParam.udf5 = [self.arrPaymentParamValue objectAtIndex:14];
        txnParam.udf6 = [self.arrPaymentParamValue objectAtIndex:15];
        txnParam.udf7 = [self.arrPaymentParamValue objectAtIndex:16];
        txnParam.udf8 = [self.arrPaymentParamValue objectAtIndex:17];
        txnParam.udf9 = [self.arrPaymentParamValue objectAtIndex:18];
        txnParam.udf10 = [self.arrPaymentParamValue objectAtIndex:19];
        txnParam.environment = [[self.arrPaymentParamValue objectAtIndex:20] integerValue];
        txnParam.hashValue = [Utils getHashForTxnParams:txnParam salt:[self.arrMerchantSalt objectAtIndex:envIndex]];
        
        NSError *err;
        
        [PayUMoneyCoreSDK initWithTxnParam:txnParam error:&err];
        if (err) {
            [self.defaultActivityIndicator stopAnimatingActivityIndicator];
            [Utils showMsgWithTitle:@"Error" message:err.localizedDescription];
        }
        else{
            [[PayUMoneyCoreSDK sharedInstance] addPaymentAPIWithCompletionBlock:^(NSDictionary *response, NSError *error, id extraParam) {
                if (error) {
                    [self.defaultActivityIndicator stopAnimatingActivityIndicator];
                    [Utils showMsgWithTitle:@"Error" message:error.localizedDescription];
                }
                else{
                    APIListVC *APIVC = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([APIListVC class])];
                    APIVC.addPaymentAPIResponse = response;
                    if ([PayUMoneyCoreSDK isUserSignedIn]) {
                        [[PayUMoneyCoreSDK sharedInstance] fetchPaymentUserDataAPIWithCompletionBlock:^(NSDictionary *response, NSError *error, id extraParam) {
                            [self.defaultActivityIndicator stopAnimatingActivityIndicator];
                            if (error) {
                                [Utils showMsgWithTitle:@"Error" message:error.localizedDescription];
                            }
                            else{
                                APIVC.fetchPaymentUserDataAPIResponse = response;
                                [hud hideAnimated:YES];

                                [self.navigationController pushViewController:APIVC animated:YES];
                            }
                        }];
                    }
                    else{
                        if ([PUMHelperClass isNitroFlowEnabledForMerchant]) {
                            [[PayUMoneyCoreSDK sharedInstance] fetchUserDataAPIWithCompletionBlock:^(NSDictionary *response, NSError *error, id extraParam) {
                                [self.defaultActivityIndicator stopAnimatingActivityIndicator];
                                if (error) {
                                    [Utils showMsgWithTitle:@"Error" message:error.localizedDescription];
                                }
                                else{
                                    APIVC.fetchUserDataAPIResponse = response;
                                    [hud hideAnimated:YES];

                                    [self.navigationController pushViewController:APIVC animated:YES];
                                }
                            }];
                        }
                        else{
                            [self.defaultActivityIndicator stopAnimatingActivityIndicator];
                            [hud hideAnimated:YES];

                            [self.navigationController pushViewController:APIVC animated:YES];
                        }
                    }
                }
            }];
        }
        

        
    }else if ([[notification name]isEqualToString:@"hire_later"]){
        [self hireLaterCalledAPI:notification.object];
    }else if ([[notification name]isEqualToString:@"openSearchAPI"]){
        startRideDic = [notification.object mutableCopy];
        isStartRide = YES;
        GMSAutocompleteViewController *acController = [[GMSAutocompleteViewController alloc] init];
        acController.delegate = self;
        [self presentViewController:acController animated:YES completion:nil];
    }else if ([[notification name]isEqualToString:@"paymentSuccess"]){
        
        self.navigationController.navigationBar.hidden = NO;
        [finishVIew removeFromSuperview];
        if ([[_requestDic objectForKey:@"type"] isEqualToString:@"caregiver"])
        {
            careGiverBill *requestNotificationUIView = [[[NSBundle mainBundle] loadNibNamed:@"careGiverBill" owner:self options:nil] objectAtIndex:0];
            [requestNotificationUIView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
            requestNotificationUIView.billDictionary = _requestDic;
            [[UIApplication sharedApplication].keyWindow addSubview:requestNotificationUIView];
        }else if ([[_requestDic objectForKey:@"type"] isEqualToString:@"ambulance"]){
            YourBillView *requestNotificationUIView = [[[NSBundle mainBundle] loadNibNamed:@"YourBillView" owner:self options:nil] objectAtIndex:0];
            [requestNotificationUIView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
            requestNotificationUIView.billDictionary = _requestDic;
            [[UIApplication sharedApplication].keyWindow addSubview:requestNotificationUIView];
        }
        if ([notification.object isKindOfClass:[NSDictionary class]]) {
            NSMutableDictionary *paymentDic = [[NSMutableDictionary alloc] init];
            [paymentDic setObject:@"online" forKey:@"payment_mode"];
            [paymentDic setObject:[notification.object objectForKey:@"paymentId"] forKey:@"transaction_id"];
            //  [paymentDic setObject:[notification.object objectForKey:@"paymentId"] forKey:@"transaction_id"];
            [paymentDic setObject:[_requestDic objectForKey:@"caregiver_id"] forKey:@"caregiver_id"];
            [paymentDic setObject:[notification.object objectForKey:@"amount"] forKey:@"amount"];
            [paymentDic setObject:[_requestDic objectForKey:@"type"] forKey:@"type"];
            [paymentDic setObject:[_requestDic objectForKey:@"hire_caregiver_id"] forKey:@"hire_caregiver_id"];
            
            if ([[_requestDic objectForKey:@"type"] isEqualToString:@"ambulance"]) {
                [paymentDic setObject:[_requestDic objectForKey:@"source"] forKey:@"source"];
                [paymentDic setObject:[_requestDic objectForKey:@"destination"] forKey:@"destination"];
                [paymentDic setObject:@"" forKey:@"start_time"];
                [paymentDic setObject:@"" forKey:@"end_time"];
                [paymentDic setObject:@"" forKey:@"total_time"];
                [paymentDic setObject:[_requestDic objectForKey:@"total_kilometer"] forKey:@"total_kilometer"];
            } else {
                [paymentDic setObject:@"" forKey:@"source"];
                [paymentDic setObject:@"" forKey:@"destination"];
                [paymentDic setObject:[_requestDic objectForKey:@"start_time"] forKey:@"start_time"];
                [paymentDic setObject:[_requestDic objectForKey:@"stop_time"] forKey:@"end_time"];
                [paymentDic setObject:[_requestDic objectForKey:@"total_time"] forKey:@"total_time"];
                [paymentDic setObject:@"" forKey:@"total_kilometer"];
            }
            [self addPaymentHistory:paymentDic];
        }else{
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [appDelegate moveTOMainPage];
        }
      
    }else if ([[notification name]isEqualToString:@"CashSuccess"]){
        isCash = YES;
        self.navigationController.navigationBar.hidden = NO;
        [finishVIew removeFromSuperview];
        
        if ([notification.object isKindOfClass:[NSDictionary class]]) {
            _requestDic = notification.object;
            NSMutableDictionary *paymentDic = [[NSMutableDictionary alloc] init];
            [paymentDic setObject:@"cash" forKey:@"payment_mode"];
            [paymentDic setObject:@"" forKey:@"transaction_id"];
            //  [paymentDic setObject:[notification.object objectForKey:@"paymentId"] forKey:@"transaction_id"];
            [paymentDic setObject:[_requestDic objectForKey:@"caregiver_id"] forKey:@"caregiver_id"];
            [paymentDic setObject:[notification.object objectForKey:@"payable"] forKey:@"amount"];
            [paymentDic setObject:[_requestDic objectForKey:@"type"] forKey:@"type"];
            [paymentDic setObject:[_requestDic objectForKey:@"hire_caregiver_id"] forKey:@"hire_caregiver_id"];
            if ([[_requestDic objectForKey:@"type"] isEqualToString:@"ambulance"]) {
               // [paymentDic setObject:[_requestDic objectForKey:@"source"] forKey:@"source"];
               // [paymentDic setObject:[_requestDic objectForKey:@"destination"] forKey:@"destination"];
                [paymentDic setObject:@"" forKey:@"start_time"];
                [paymentDic setObject:@"" forKey:@"end_time"];
                [paymentDic setObject:@"" forKey:@"total_time"];
                [paymentDic setObject:[_requestDic objectForKey:@"total_kilometer"] forKey:@"total_kilometer"];
            } else {
                [paymentDic setObject:@"" forKey:@"source"];
                [paymentDic setObject:@"" forKey:@"destination"];
                [paymentDic setObject:[_requestDic objectForKey:@"start_time"] forKey:@"start_time"];
                [paymentDic setObject:[_requestDic objectForKey:@"stop_time"] forKey:@"end_time"];
                [paymentDic setObject:[_requestDic objectForKey:@"total_time"] forKey:@"total_time"];
                [paymentDic setObject:@"" forKey:@"total_kilometer"];
            }
            [self addPaymentHistory:paymentDic];
        }else{
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [appDelegate moveTOMainPage];
        }
        
    }else if ([[notification name]isEqualToString:@"paymentBack"]){
        self.navigationController.navigationBar.hidden = YES;
        finishVIew.hidden = NO;
    }
}



#pragma mark - Done Textfiled btn

- (void)Adddonebtntitle {
    UIToolbar *ViewForDoneButtonOnKeyboard = [[UIToolbar alloc] init];
    [ViewForDoneButtonOnKeyboard sizeToFit];
    UIBarButtonItem *btnDoneOnKeyboard = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                          style:UIBarButtonItemStyleBordered target:self
                                                                         action:@selector(doneBtnFromKeyboardClicked:)];
    [ViewForDoneButtonOnKeyboard setItems:[NSArray arrayWithObjects:btnDoneOnKeyboard, nil]];
    
    self.Searchtextfiled.inputAccessoryView = ViewForDoneButtonOnKeyboard;
 
    
    
}
#pragma mark - Click Actions
- (IBAction)doneBtnFromKeyboardClicked:(id)sender
{
    NSLog(@"Done Button Clicked.");
    [self.Searchtextfiled resignFirstResponder];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!isForSomeone) {
        isForSomeone = NO;
        _careGiverCollectionView.hidden = YES;
        _confirmHireView.hidden = YES;
        _reConfirmHireView.hidden = YES;
        if ([[[SYUserDefault sharedManager] getUserAuthorityId] intValue] == USER_TYPE) {
            
            _ambulanceButton.hidden = NO;
            _careGiverButton.hidden = NO;
            
            
            if (_plusButtonsViewNavBar.isShowing) {
                
                [self showHideButtonsAction];
            }
            
        } else {
            _ambulanceButton.hidden = YES;
            _careGiverButton.hidden = YES;
        }
        
        [self googleMapForCareGiver];
        
        
        if (_plusButtonsViewNavBar.isShowing) {
            [self showHideButtonsAction];
            
        }

    }
    isForSomeone = NO;
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    [self getCareGiverListForMap];
}

#pragma mark - Google Map
- (void) googleMapForUser :(NSMutableArray *)mapShowArray {
    
    [googleMapView removeFromSuperview];
    googleMapView = [GMSMapView mapWithFrame:self.view.bounds camera:camera];
    googleMapView.myLocationEnabled = YES;
    [_mapView addSubview: googleMapView];
    
    for (NSDictionary *thumbnailDict in mapShowArray) {
        
        // Creates a marker in the center of the map.
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.position = CLLocationCoordinate2DMake([[thumbnailDict valueForKey:@"latitude"] floatValue],[[thumbnailDict valueForKey:@"longitud"] floatValue]);
        marker.title = [thumbnailDict valueForKey:@"full_name"];
        
        if ([[thumbnailDict objectForKey:@"type"] intValue] == 1) {
            marker.icon = [UIImage imageNamed:@"doctor"];
        } else {
             marker.icon = [UIImage imageNamed:@"ambulance"];
        }
        
        marker.map = googleMapView;
    }
    
}

- (void) googleMapForAmbulanceUser :(NSMutableArray *)mapShowArray {
    
    [googleMapView removeFromSuperview];
    googleMapView = [GMSMapView mapWithFrame:self.view.bounds camera:camera];
    googleMapView.myLocationEnabled = YES;
    [_mapView addSubview: googleMapView];
    
    for (NSDictionary *thumbnailDict in mapShowArray) {
        
        // Creates a marker in the center of the map.
       
        
        if ([[thumbnailDict objectForKey:@"type"] intValue] == 1) {
           // marker.icon = [UIImage imageNamed:@"careGiverList"];
        } else {
            GMSMarker *marker = [[GMSMarker alloc] init];
            marker.position = CLLocationCoordinate2DMake([[thumbnailDict valueForKey:@"latitude"] floatValue],[[thumbnailDict valueForKey:@"longitud"] floatValue]);
            marker.title = [thumbnailDict valueForKey:@"full_name"];
            marker.icon = [UIImage imageNamed:@"ambulance"];
            marker.map = googleMapView;
        }
        
    }
    
}

- (void) googleMapForCareGiver {
    // Show Current Location
    [googleMapView removeFromSuperview];
    googleMapView = [GMSMapView mapWithFrame:self.view.bounds camera:camera];
    googleMapView.myLocationEnabled = YES;
    locationManager.delegate = self;
    polyline.map = nil;
    [_mapView addSubview: googleMapView];

    [locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    // If it's a relatively recent event, turn off updates to save power.
    CLLocation* location = [locations lastObject];
    if (isStartRide) {
       // [googleMapView clear];
        MarkerSourceLoc = location.coordinate;
//        sourceMarker = [[GMSMarker alloc] init];
        sourceMarker.position = MarkerSourceLoc;
//        sourceMarker.map = googleMapView;
//
//        destMarker = [[GMSMarker alloc] init];
//        destMarker.position = MarkerDestinationLoc;
//        destMarker.map = googleMapView;
//        googleMapView.delegate = self;

    }else{
    camera = [GMSCameraPosition cameraWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude zoom:15];
   CLGeocoder *ceo= [[CLGeocoder alloc]init];
    [ceo reverseGeocodeLocation:location
              completionHandler:^(NSArray *placemarks, NSError *error) {
                  CLPlacemark *placemark = [placemarks objectAtIndex:0];
                  NSLog(@"placemark %@",placemark);
                  //String to hold address
                  NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
                  NSLog(@"addressDictionary %@", placemark.addressDictionary);
                  
                  NSLog(@"placemark %@",placemark.region);
                  NSLog(@"placemark %@",placemark.country);  // Give Country Name
                  NSLog(@"placemark %@",placemark.locality); // Extract the city name
                  NSLog(@"location %@",placemark.name);
                  NSLog(@"location %@",placemark.ocean);
                  NSLog(@"location %@",placemark.postalCode);
                  NSLog(@"location %@",placemark.subLocality);
                  
                  NSLog(@"location %@",placemark.location);
                  //Print the location to console
                  NSLog(@"I am currently at %@",locatedAt);
                  
                  _Searchtextfiled.text = locatedAt;
                //  _City.text=[placemark.addressDictionary objectForKey:@"City"];
                 // [locationManager stopUpdatingLocation];
              }
     ];
    
    if (currentLatitude != location.coordinate.latitude) {
        currentLatitude = location.coordinate.latitude;
        currentLongitude = location.coordinate.longitude;
        [[SYUserDefault sharedManager]setCurrentLat:[NSString stringWithFormat:@"%.4f",currentLatitude]];
        [[SYUserDefault sharedManager]setCurrentLng:[NSString stringWithFormat:@"%.4f",currentLongitude]];
        if ([[[SYUserDefault sharedManager] getUserAuthorityId] intValue] == USER_TYPE) {
            [self getCareGiverListForMap:nil];
        } else {
            [googleMapView removeFromSuperview];
            googleMapView = [GMSMapView mapWithFrame:self.view.bounds camera:camera];
            googleMapView.myLocationEnabled = YES;
            [_mapView addSubview: googleMapView];
            [self updateLatLongForCareGiver];
        }
    }
    }
    [locationManager stopUpdatingLocation ];
    
}
#pragma mark - KVO updates

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if (!firstLocationUpdate_) {
        // If the first location update has not yet been recieved, then jump to that
        // location.
        firstLocationUpdate_ = YES;
        CLLocation *location = [change objectForKey:NSKeyValueChangeNewKey];
        googleMapView.camera = [GMSCameraPosition cameraWithTarget:location.coordinate
                                                         zoom:14];
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
   

    if ([segue.identifier isEqualToString:@"seniorListSegue"]) {
        
        SeniorListViewController *addSeniorVC = segue.destinationViewController;
        addSeniorVC.delegate = self;
        addSeniorVC.isAddSomeOne = YES;
    } else if ([segue.identifier isEqualToString:@"healthTipsSegue"]) {
        
        HealthTipsListViewController *healthPoint = segue.destinationViewController;
        healthPoint.isReminder = isHealthPooint;
    }else if ([segue.identifier isEqualToString:@"addReminderSegue"]){
        AddReminderViewController *addReminder = segue.destinationViewController;
        addReminder.delegate = self;
    }
}


- (IBAction)manuBarButtonTapped:(id)sender {
    
    [self.menuContainerViewController setMenuState:MFSideMenuStateLeftMenuOpen];

}
- (IBAction)ambulanceButtonTapped:(id)sender {
   
    [_ambulanceButton setBackgroundColor: CAREGIVER_COLOR];
    [_ambulanceButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    [_careGiverButton setTitleColor: CAREGIVER_COLOR forState:UIControlStateNormal];
    [_careGiverButton setBackgroundColor:[UIColor whiteColor] ];

    isCareGiver = NO;
    isSpecialization = NO;
  
    [self getAmbulanceInfo];
    
}

- (void)addPaymentHistory:(NSDictionary*)paymentDic {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.label.text = NSLocalizedString(@"Loading...", @"HUD loading title");
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        
        NSMutableDictionary *parameter = [paymentDic mutableCopy];
        [parameter setObject:[[SYUserDefault sharedManager] getAppToken] forKey:@"token"];
        
        NSMutableDictionary *responceDict = [UserRunningServices addSomeOne:parameter witServiceName:@"addPaymentHistory"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
            
            if ([responceDict[@"status"] intValue] == 200) {
                if (isCash) {
                    [finishVIew removeFromSuperview];
                }else{
                AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                    [appDelegate moveTOMainPage];}
                //  [self googleMapForAmbulanceUser:newAllServicesArray];
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
        [parameter setObject:@"2" forKey:@"type"];

                                                                                                                                                        NSMutableDictionary *responceDict = [UserRunningServices getOtherServices:parameter witServiceName:@"getAmbulanceType"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
            
            if ([responceDict[@"status"] intValue] == 200) {
                
                allServicesArray =  responceDict[@"data"];
                [self preapreData];
                NSMutableDictionary *parameter = [NSMutableDictionary new];
                [parameter setObject:[NSNumber numberWithInteger:2] forKey:@"type"];
                [self getAmbulanceListForMap:parameter];
               //  [self googleMapForAmbulanceUser:newAllServicesArray];
            }
        });
    });
}

- (void)getServicesInfo {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.label.text = NSLocalizedString(@"Loading...", @"HUD loading title");
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        
        NSMutableDictionary *parameter = [NSMutableDictionary new];
        [parameter setObject:[[SYUserDefault sharedManager] getAppToken] forKey:@"token"];
        [parameter setObject:@"1" forKey:@"type"];

        NSMutableDictionary *responceDict = [UserRunningServices getOtherServices:parameter witServiceName:@"getServices"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
            
            if ([responceDict[@"status"] intValue] == 200) {
                careGiverServicesArr = [[NSMutableArray alloc]init];
                careGiverServicesArr =  responceDict[@"data"];
                [self.careGiverCollectionView setHidden:NO];
                [self.careGiverCollectionView reloadData];
            }
        });
    });
}

- (void)getSpecializationInfo:(NSString*)serviceId {
    
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
                
                careGiverSpecializationArr = [[NSMutableArray alloc]init];
                careGiverSpecializationArr =  responceDict[@"data"];
                [self.careGiverCollectionView reloadData];
            }else{
                isServices = YES;
                isCareSpecialization = NO;
                careGiverSpecializationArr = [[NSMutableArray alloc]init];
                
                    if (newCareGiverArray.count > 0) {
                        
                        NSMutableArray *careGiverForSelectedId = [[NSMutableArray alloc]init];
                        
                        
                        for (NSDictionary *caregiver in newCareGiverArray) {
                            if ([[caregiver objectForKey:@"service_id"]isEqual:selectedServiceId]) {
                                [careGiverForSelectedId addObject:caregiver];
                            }
                        }
                        
                        if (careGiverForSelectedId.count > 0) {
                            minMumCharge = 0.0;
                            for (NSDictionary *dictMin in newCareGiverArray) {
                                
                                float tempMin = [dictMin[@"min_charges"] floatValue];
                                if (tempMin > minMumCharge) {
                                    minMumCharge = tempMin;
                                }
                            }
                            
                            confirmArray = [NSMutableDictionary new];
                            confirmArray = [newCareGiverArray firstObject];
                            hireType = @"careGiver";
                            PopupForBookCareGiver *popupForBookCareGiver = [[[NSBundle mainBundle] loadNibNamed:@"PopupForBookCareGiver" owner:self options:nil] objectAtIndex:0];
                            popupForBookCareGiver.addServiceDelegate = self;
                            [popupForBookCareGiver setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
                            
                            [self.view addSubview:popupForBookCareGiver];
                        }else{
                            [self.view makeToast:@"No caregiver avialble." duration:0.2 position: CSToastPositionBottom];
                        }
                        
                    }
                    
                   
                
            }
        });
    });
}



- (IBAction)careGiverButtonTapped:(id)sender {
    
    [_careGiverButton setBackgroundColor: CAREGIVER_COLOR];
    [_careGiverButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_ambulanceButton setTitleColor: CAREGIVER_COLOR forState:UIControlStateNormal];
    [_ambulanceButton setBackgroundColor:[UIColor whiteColor] ];
    isCareGiver = YES;
    isServices = YES;
    isSpecialization = NO;
    
    NSMutableDictionary *parameter = [NSMutableDictionary new];
    [parameter setObject:[NSNumber numberWithInteger:1] forKey:@"type"];
    [self getCareGiverListForMap:parameter];

    [self getServicesInfo];
    
}



#pragma mark - Collection View delegate

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (isCareGiver) {
        if (isServices) {
            return careGiverServicesArr.count;
        }else if (isCareSpecialization){
            return careGiverSpecializationArr.count;
        }
        return newCareGiverArray.count;
    }
    return ambulanceArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CareGiverCell";
    CareGiverListCollectionViewCell *cell = (CareGiverListCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.careView.layer.borderColor = USER_COLOR.CGColor;
    cell.careView.layer.cornerRadius = cell.careView.frame.size.height/2;
    cell.careView.layer.borderWidth = 1;
    
    // return the cell
    
    if (isCareGiver) {
         cell.collectionImageView.contentMode = UIViewContentModeScaleAspectFit;
        if (isServices) {
             NSDictionary *careGiverDict = [careGiverServicesArr objectAtIndex:indexPath.row];
            UIImage *doctorImage;
            if ([[careGiverDict objectForKey:@"service_name"] isEqualToString:@"Doctor"]) {
                doctorImage = [UIImage imageNamed:@"doctor"];

            }else{
                doctorImage = [UIImage imageNamed:@"nurse"];

            }
            //
             cell.nameLabel.text = [careGiverDict objectForKey:@"service_name"]?[careGiverDict objectForKey:@"service_name"]:@"" ;
            cell.collectionImageView.image = doctorImage;
        }else if (isCareSpecialization){
            NSDictionary *careGiverDict = [careGiverSpecializationArr objectAtIndex:indexPath.row];
            UIImage *doctorImage;
            if ([[careGiverDict objectForKey:@"service_name"] isEqualToString:@"Doctor"]) {
                doctorImage = [UIImage imageNamed:@"doctor"];
            }else{
                doctorImage = [UIImage imageNamed:@"nurse"];
            }
            cell.nameLabel.text = [careGiverDict objectForKey:@"specialization"]?[careGiverDict objectForKey:@"specialization"]:@"" ;
            cell.collectionImageView.image = doctorImage;
//service_name
        }else{
            NSDictionary *careGverDict = [newCareGiverArray objectAtIndex:indexPath.row];
            UIImage *doctorImage;
            if ([[careGverDict objectForKey:@"service_name"] isEqualToString:@"Doctor"]) {
                doctorImage = [UIImage imageNamed:@"doctor"];
            }else{
                doctorImage = [UIImage imageNamed:@"nurse"];
            }
            cell.collectionImageView.image = doctorImage;
            cell.nameLabel.text = [careGverDict objectForKey:@"full_name"]?[careGverDict objectForKey:@"full_name"]:@"" ;
        }
//
//        if (isSpecialization) {
//            cell.nameLabel.text = [careGiverDict objectForKey:@"specialization"]?[careGiverDict objectForKey:@"specialization"]:@"" ;
//        } else {
//           /* if (![[careGiverDict objectForKey:@"service_name"] isEqualToString:@"Doctor"]) {
//                cell.collectionImageView.image = [UIImage imageNamed:@"nurse"];
//
//            }*/
//
//
//        }
    } else {
        NSDictionary *careGiverDict = [ambulanceArray objectAtIndex:indexPath.row];

        cell.nameLabel.text = [careGiverDict objectForKey:@"specialization"]?[careGiverDict objectForKey:@"specialization"]:@"" ;
        cell.collectionImageView.image = [UIImage imageNamed:@"ambulance"];
        cell.collectionImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (isCareGiver) {
        
        if (isSpecialization) {
            
            minMumCharge = 0.0;
            for (NSDictionary *dictMin in newCareGiverArray) {
                
                float tempMin = [dictMin[@"min_charges"] floatValue];
                if (tempMin > minMumCharge) {
                    minMumCharge = tempMin;
                }
            }
            
            confirmArray = [NSMutableDictionary new];
            confirmArray = [newCareGiverArray objectAtIndex:indexPath.row];
            hireType = @"careGiver";
            PopupForBookCareGiver *popupForBookCareGiver = [[[NSBundle mainBundle] loadNibNamed:@"PopupForBookCareGiver" owner:self options:nil] objectAtIndex:0];
            popupForBookCareGiver.addServiceDelegate = self;
            [popupForBookCareGiver setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
            
            [self.view addSubview:popupForBookCareGiver];
            
        } else {
            
            if (isServices) {
                  NSDictionary *careGiverDict = [careGiverServicesArr objectAtIndex:indexPath.row];
                selectedServiceId = careGiverDict[@"service_id"];
                isServices = NO;
                isCareSpecialization = YES;
              //  isSpecialization = YES;

                [self getSpecializationInfo:careGiverDict[@"service_id"]];
            }else{
                if (newCareGiverArray.count > 0) {
                    
                    NSMutableArray *careGiverForSelectedId = [[NSMutableArray alloc]init];
                    
                    
                    for (NSDictionary *caregiver in newCareGiverArray) {
                        if ([[caregiver objectForKey:@"service_id"]isEqual:selectedServiceId]) {
                            [careGiverForSelectedId addObject:caregiver];
                        }
                    }
                    
                    if (careGiverForSelectedId.count > 0) {
                        minMumCharge = 0.0;
                        for (NSDictionary *dictMin in careGiverForSelectedId) {
                            
                            float tempMin = [dictMin[@"min_charges"] floatValue];
                            if (tempMin > minMumCharge) {
                                minMumCharge = tempMin;
                            }
                        }
                        
                        confirmArray = [NSMutableDictionary new];
                        confirmArray = [careGiverForSelectedId firstObject];
                        hireType = @"careGiver";
                        PopupForBookCareGiver *popupForBookCareGiver = [[[NSBundle mainBundle] loadNibNamed:@"PopupForBookCareGiver" owner:self options:nil] objectAtIndex:0];
                        popupForBookCareGiver.addServiceDelegate = self;
                        [popupForBookCareGiver setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
                        
                        [self.view addSubview:popupForBookCareGiver];
                    }else{
                           [self.view makeToast:@"No caregiver avialble." duration:0.2 position: CSToastPositionBottom];
                    }
                   
                }
              
               /* NSDictionary *careGiverDict = [careGiverSpecializationArr objectAtIndex:indexPath.row];

                isCareSpecialization = NO;
                isSpecialization = YES;
                NSMutableDictionary *parameter = [NSMutableDictionary new];
                 [parameter setObject:careGiverDict[@"caregiver_specialization_id"] forKey:@"specialization"];
                 [parameter setObject:selectedServiceId forKey:@"service_id"];
                 [parameter setObject:@"1" forKey:@"type"];
                
                [self getCareGiverListForMap:parameter];*/
            }
        
        }
        
    } else {
        
        //minMumCharge = 1000.0;
        if (newAllServicesArray.count > 0) {
            minMumCharge = 0.0;
            for (NSDictionary *dictMin in newAllServicesArray) {
                if ([[dictMin objectForKey:@"type"] isEqual:@"2"]) {
                    float tempMin = [dictMin[@"min_charges"] floatValue];
                    if (tempMin > minMumCharge) {
                        minMumCharge = tempMin;
                    }
                }
            }
            confirmArray = [NSMutableDictionary new];
            confirmArray = [ambulanceArray objectAtIndex:indexPath.row];
            hireType = @"ambulance";
            _minimumChargeLabel.text = [NSString stringWithFormat:@"Minimum Charges: %0.2f",minMumCharge];
            _careGiverCollectionView.hidden= YES;
            _confirmHireView.hidden = NO;
        }
        else {
            [self getAmbulanceInfo];
            //[self.view makeToast:@"No ambulance avialble." duration:0.2 position: CSToastPositionBottom];
        }
    }

}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize cellSize = CGSizeMake(100, 120);
    if (isCareGiver) {
        if (isServices) {
            NSDictionary *careGiverDict = [careGiverServicesArr objectAtIndex:indexPath.row];
            NSString *serviceName = [careGiverDict objectForKey:@"service_name"]?[careGiverDict objectForKey:@"service_name"]:@"" ;
            cellSize.width = [self widthOfString:serviceName withFont:(NSFont*)[UIFont systemFontOfSize:15]]+10;
           
        }else if (isCareSpecialization){
            NSDictionary *careGiverDict = [careGiverSpecializationArr objectAtIndex:indexPath.row];
            NSString *serviceName = [careGiverDict objectForKey:@"specialization"]?[careGiverDict objectForKey:@"specialization"]:@"" ;
            cellSize.width = [self widthOfString:serviceName withFont:(NSFont*)[UIFont systemFontOfSize:15]]+10;

        }else{
            NSDictionary *careGverDict = [newCareGiverArray objectAtIndex:indexPath.row];
            NSString *serviceName = [careGverDict objectForKey:@"full_name"]?[careGverDict objectForKey:@"full_name"]:@"" ;
            cellSize.width = [self widthOfString:serviceName withFont:(NSFont*)[UIFont systemFontOfSize:15]]+10;

        }
    } else {
        NSDictionary *careGiverDict = [ambulanceArray objectAtIndex:indexPath.row];
        NSString *serviceName = [careGiverDict objectForKey:@"specialization"]?[careGiverDict objectForKey:@"specialization"]:@"" ;
        cellSize.width = [self widthOfString:serviceName withFont:(NSFont*)[UIFont systemFontOfSize:15]]+10;
    }
    if (cellSize.width < 75) {
        cellSize.width = 75;
    }
    return cellSize;
}
#pragma mark - APIs Methods



#pragma mark - User Define Mehtods

- (void) navigationButtonsAdded {
    
    _buttonPositionsArr = [[NSMutableArray alloc]init];
    CGFloat x = self.view.frame.size.width - 180;
    CGFloat y = 24;
    for (int i=0; i<3; i++) {
        CGRect rect = CGRectMake(x, y+(i*40), 180, 40);
        [_buttonPositionsArr addObject:[NSValue valueWithCGRect:rect]];
    }
    UIButton *itemBarButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    itemBarButton.frame = CGRectMake(0, 0, 30, 30);
    [itemBarButton setImage:[UIImage imageNamed:@"bellIcon"] forState:UIControlStateNormal];
    [itemBarButton.titleLabel setFont:[UIFont boldSystemFontOfSize:15.f]];
    [itemBarButton addTarget:self action:@selector(showHideButtonsAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:itemBarButton];
    
    _NavigationButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height)];
    
     [_NavigationButtonView setBackgroundColor:[UIColor colorWithWhite:0.f alpha:0.66]];
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showHideButtonsHandler:)];
    singleTap.cancelsTouchesInView = YES;
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    [_NavigationButtonView addGestureRecognizer: singleTap];
    
    
    _plusButtonsViewNavBar = [LGPlusButtonsView plusButtonsViewWithNumberOfButtons:3
                                                           firstButtonIsPlusButton:NO
                                                                     showAfterInit:NO
                                                                     actionHandler:^(LGPlusButtonsView *plusButtonView, NSString *title, NSString *description, NSUInteger index)
                              {
                                  NSLog(@"actionHandler | title: %@, description: %@, index: %lu", title, description, (long unsigned)index);
                                  
                                  if (index == 0) {
                                      
                                      isHealthPooint = NO;
                                      
                                      [self performSegueWithIdentifier:@"healthTipsSegue" sender:self];

                                  } else if (index == 1) {
                                      
                                       isHealthPooint = YES;
                                      
                                      [self performSegueWithIdentifier:@"healthTipsSegue" sender:self];

                                  } else if (index == 2) {
                                      
                                      [self performSegueWithIdentifier:@"addReminderSegue" sender:self];
                                      
                                  }
                                  
                              }];
    
    _plusButtonsViewNavBar.showHideOnScroll = NO;
    _plusButtonsViewNavBar.appearingAnimationType = LGPlusButtonsAppearingAnimationTypeCrossDissolveAndPop;
    _plusButtonsViewNavBar.position = LGPlusButtonsViewPositionTopRight;
   // close.png
  //  reminder.png
  //  todo.png
    [_plusButtonsViewNavBar setDescriptionsTexts:@[@"Health Tips", @"ToDo List", @"Reminders"]];
    [_plusButtonsViewNavBar setButtonsImages:@[@"bell_red",@"todo",@"reminder"] forState:UIControlStateNormal forOrientation: LGPlusButtonsViewOrientationAll];

    [_plusButtonsViewNavBar setButtonsTitleFont:[UIFont boldSystemFontOfSize:32.f] forOrientation:LGPlusButtonsViewOrientationAll];
    [_plusButtonsViewNavBar setButtonsSize:CGSizeMake(40.f, 40.f) forOrientation:LGPlusButtonsViewOrientationAll];
    [_plusButtonsViewNavBar setButtonsLayerCornerRadius:40.f/2.f forOrientation:LGPlusButtonsViewOrientationAll];
    [_plusButtonsViewNavBar setButtonsLayerShadowColor:[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1.f]];
    [_plusButtonsViewNavBar setButtonsLayerShadowOpacity:0.5];
    [_plusButtonsViewNavBar setButtonsLayerShadowRadius:3.f];
    [_plusButtonsViewNavBar setButtonsLayerShadowOffset:CGSizeMake(0.f, 2.f)];
    
    [_plusButtonsViewNavBar setDescriptionsTextColor:[UIColor whiteColor]];
    [_plusButtonsViewNavBar setDescriptionsBackgroundColor:[UIColor colorWithWhite:0.f alpha:0.66]];
    [_plusButtonsViewNavBar setDescriptionsLayerCornerRadius:6.f forOrientation:LGPlusButtonsViewOrientationAll];
    [_plusButtonsViewNavBar setDescriptionsContentEdgeInsets:UIEdgeInsetsMake(4.f, 8.f, 4.f, 8.f) forOrientation:LGPlusButtonsViewOrientationAll];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        [_plusButtonsViewNavBar setButtonsSize:CGSizeMake(44.f, 44.f) forOrientation:LGPlusButtonsViewOrientationLandscape];
        [_plusButtonsViewNavBar setButtonsLayerCornerRadius:44.f/2.f forOrientation:LGPlusButtonsViewOrientationLandscape];
        [_plusButtonsViewNavBar setButtonsTitleFont:[UIFont systemFontOfSize:24.f] forOrientation:LGPlusButtonsViewOrientationLandscape];
    }
    
    [_NavigationButtonView addSubview:_plusButtonsViewNavBar];
}


- (void)showHideButtonsAction {
    if (_plusButtonsViewNavBar.isShowing) {
        // CGPoint touchPoint = [tapRecognizer locationInView: _tileMap]
        [_plusButtonsViewNavBar hideAnimated:YES completionHandler:nil];
        [_NavigationButtonView removeFromSuperview];
    }
    else{
        [self.view addSubview:_NavigationButtonView];
        [_plusButtonsViewNavBar showAnimated:YES completionHandler:nil];
        
    }
}

- (void)showHideButtonsHandler:(UITapGestureRecognizer*)tapRecognizer {
    if (_plusButtonsViewNavBar.isShowing) {
        CGPoint touchPoint = [tapRecognizer locationInView: _plusButtonsViewNavBar];
        for (int i=0; i<_buttonPositionsArr.count; i++) {
            CGRect rect = [[_buttonPositionsArr objectAtIndex:i]CGRectValue];
            BOOL isContainsPoint = CGRectContainsPoint(rect, touchPoint);
            if (isContainsPoint) {
                NSLog(@"contains");
                if (i == 0) {
                    
                    isHealthPooint = NO;
                    
                    [self performSegueWithIdentifier:@"healthTipsSegue" sender:self];
                    
                } else if (i == 1) {
                    
                    isHealthPooint = YES;
                    
                    [self performSegueWithIdentifier:@"healthTipsSegue" sender:self];
                    
                } else if (i == 2) {
                    
                    [self performSegueWithIdentifier:@"addReminderSegue" sender:self];
                    
                }
            }
        }
        [_plusButtonsViewNavBar hideAnimated:YES completionHandler:nil];
        [_NavigationButtonView removeFromSuperview];
    }
    else{
        [self.view addSubview:_NavigationButtonView];
        [_plusButtonsViewNavBar showAnimated:YES completionHandler:nil];
        
    }
}


- (void)getCareGiverListForMap :(NSMutableDictionary *)parameter {
    
    if (parameter == nil) {
        parameter = [NSMutableDictionary new];
        isFirstTime = YES;
    }

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.label.text = NSLocalizedString(@"Please Wait...", @"HUD loading title");
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        
        [parameter setObject:[[SYUserDefault sharedManager] getAppToken] forKey:@"token"];
        [parameter setObject:[NSNumber numberWithDouble:currentLatitude] forKey:@"latitude"];
        [parameter setObject:[NSNumber numberWithDouble:currentLongitude] forKey:@"longitud"];
        
        NSLog(@"Parameter : %@" , parameter);
        NSMutableDictionary *responceDict = [UserRunningServices getAllCareGiver:parameter];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
            
            NSLog(@"%@" , responceDict);
            
            if ([[responceDict objectForKey:@"message"] isEqualToString:@"success"]) {
                
                allServicesArray = [responceDict objectForKey:@"data"];
                if (![parameter objectForKey:@"type"]) {
                    newAllServicesArray = [[NSMutableArray alloc]init];
                    newAllServicesArray = [allServicesArray mutableCopy];
                }
               
                if (parameter.count > 3) {
                    [self preapreData];

                } else {
                    [self preapreDataFirstTime];
                }

                [self googleMapForUser:allServicesArray];
            }else if (([[responceDict objectForKey:@"message"] caseInsensitiveCompare:@"Token DoesN't Matched"] == NSOrderedSame) || ([[responceDict objectForKey:@"message"] caseInsensitiveCompare:@"Invalid Token"] == NSOrderedSame)) {
                UIStoryboard *mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                UINavigationController *mainContorller = [mainSB instantiateViewControllerWithIdentifier:@"loginNavigation"];
                [UIApplication sharedApplication].delegate.window.rootViewController = mainContorller;
            }else{
                if (isCareSpecialization) {
                    isServices = NO;
                    isCareSpecialization = YES;
                    isSpecialization = NO;
                }
                [self googleMapForCareGiver];
            }
            
        });
    });
}

- (void)getAmbulanceListForMap :(NSMutableDictionary *)parameter {
    
    if (parameter == nil) {
        parameter = [NSMutableDictionary new];
        isFirstTime = YES;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.label.text = NSLocalizedString(@"Please Wait...", @"HUD loading title");
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        
        [parameter setObject:[[SYUserDefault sharedManager] getAppToken] forKey:@"token"];
        [parameter setObject:[NSNumber numberWithDouble:currentLatitude] forKey:@"latitude"];
        [parameter setObject:[NSNumber numberWithDouble:currentLongitude] forKey:@"longitud"];
        
        NSLog(@"Parameter : %@" , parameter);
        NSMutableDictionary *responceDict = [UserRunningServices getAllCareGiver:parameter];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
            
            NSLog(@"%@" , responceDict);
            
            if ([[responceDict objectForKey:@"message"] isEqualToString:@"success"]) {
                
                [self googleMapForUser:[responceDict objectForKey:@"data"]];
            }else if (([[responceDict objectForKey:@"message"] caseInsensitiveCompare:@"Token DoesN't Matched"] == NSOrderedSame) || ([[responceDict objectForKey:@"message"] caseInsensitiveCompare:@"Invalid Token"] == NSOrderedSame)) {
                UIStoryboard *mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                UINavigationController *mainContorller = [mainSB instantiateViewControllerWithIdentifier:@"loginNavigation"];
                [UIApplication sharedApplication].delegate.window.rootViewController = mainContorller;
            }else{
               
                [self googleMapForCareGiver];
            }
            
        });
    });
}

- (void) preapreDataFirstTime {
    
    careGiverArray = [NSMutableArray new];
    ambulanceArray = [NSMutableArray new];
    newCareGiverArray = [NSMutableArray new];

    [careGiverArray removeAllObjects];
    [ambulanceArray removeAllObjects];

    for (NSDictionary *dict in allServicesArray) {
        if ([dict[@"type"] intValue] == 1) {
            
            [careGiverArray addObject:dict];
        } else {
            [ambulanceArray addObject:dict];
        }
    }
    for (NSDictionary *hireDic in careGiverArray) {
        NSArray *careArr = [newCareGiverArray valueForKey:@"service_name"];
//        if (careArr.count > 0) {
//            if (![careArr containsObject:[hireDic objectForKey:@"service_name"]]) {
//                [newCareGiverArray addObject:hireDic];
//            }
//        }else{
            [newCareGiverArray addObject:hireDic];
       // }
    }
    [_careGiverCollectionView setHidden:YES];
    
}
- (void) preapreData {
    
    careGiverArray = [NSMutableArray new];
    ambulanceArray = [NSMutableArray new];
    newCareGiverArray = [NSMutableArray new];

    [careGiverArray removeAllObjects];
    [ambulanceArray removeAllObjects];
    for (NSDictionary *dict in allServicesArray) {
        if ([dict[@"type"] intValue] == 1) {
            
            [careGiverArray addObject:dict];
        } else {
            [ambulanceArray addObject:dict];
        }
    }
    
    if (allServicesArray.count > 0) {
        
        for (NSDictionary *hireDic in careGiverArray) {
            NSArray *careArr = [newCareGiverArray valueForKey:@"service_name"];
//            if (careArr.count > 0) {
//                if (![careArr containsObject:[hireDic objectForKey:@"service_name"]]) {
//                    [newCareGiverArray addObject:hireDic];
//                }
//            }else{
                [newCareGiverArray addObject:hireDic];
            //}
        }
        
        [_careGiverCollectionView setHidden:NO];
        [_careGiverCollectionView reloadData];
    } else {
        [_careGiverCollectionView setHidden:YES];
        [self.view makeToast:@"No any caregiver avialble in this location." duration:0.2 position: CSToastPositionBottom];
    }
    
}

- (void) returnAddService:(NSString *)serviceType {
    
    if ([serviceType isEqualToString:@"addSomeOne"]) {
        isForSomeone = YES;
        [self performSegueWithIdentifier:@"seniorListSegue" sender:self];
    } else {
        _minimumChargeLabel.text = [NSString stringWithFormat:@"Minimum Charges: %0.2f",minMumCharge];
        _careGiverCollectionView.hidden= YES;
        _confirmHireView.hidden = NO;
    }
}

- (IBAction)hireNowButtonTapped:(id)sender {
    
    _careGiverCollectionView.hidden= YES;
    _confirmHireView.hidden = YES;
    _reConfirmHireView.hidden = NO;
}

- (IBAction)laterButtonTapped:(id)sender {
    
    _confirmHireView.hidden = YES;
    _careGiverCollectionView.hidden= YES;
    self.datePickerView.hidden = NO;
    self.dtPicker.date = [NSDate date];
    self.dtPicker.minimumDate = [NSDate date];
}


-(void)hireLaterCalledAPI:(NSDictionary*)parameter
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.label.text = NSLocalizedString(@"Sending...", @"HUD loading title");
    NSMutableDictionary *responceDict = [UserRunningServices addSomeOne:parameter witServiceName:@"hiringConfirmationCleint"];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [hud hideAnimated:YES];
        
        NSLog(@"%@" , responceDict);
        
        if ([[responceDict objectForKey:@"status"] isKindOfClass:[NSString class]]) {
            if ([[responceDict objectForKey:@"status"] isEqualToString:@"success"]) {
                _confirmHireView.hidden = YES;
                _careGiverCollectionView.hidden= YES;
                _reConfirmHireView.hidden = YES;
                _requestDic = [responceDict objectForKey:@"data"];
                [self.view makeToast:@"Notification sending..." duration:0.10 position:CSToastPositionBottom];
                requestNotificationUIView = [[[NSBundle mainBundle] loadNibNamed:@"ClientNotificationUIView" owner:self options:nil] objectAtIndex:0];
                [requestNotificationUIView showWaitingView];
                //  requestNotificationUIView.dataNotificationDict = [responceDict objectForKey:@"data"];
                [requestNotificationUIView setFrame:CGRectMake(0, _ambulanceButton.frame.origin.y, self.view.frame.size.width, 50)];
                [[UIApplication sharedApplication].keyWindow addSubview:requestNotificationUIView];
                timer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(autoCancelRequest) userInfo:nil repeats:NO];
                //  [requestNotificationUIView performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.5];
            }
        }else{
            
        }
        
    });

}

- (IBAction)finalConfirmButtonTapped:(id)sender {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.label.text = NSLocalizedString(@"Sending...", @"HUD loading title");
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        
        NSMutableDictionary *parameter = [NSMutableDictionary new];
        
        [parameter setObject:[[SYUserDefault sharedManager] getAppToken] forKey:@"token"];
        [parameter setObject:[NSNumber numberWithDouble:currentLatitude] forKey:@"latitude"];
        [parameter setObject:[NSNumber numberWithDouble:currentLongitude] forKey:@"longitud"];
        [parameter setObject:@"booking" forKey:@"status"];
  
        if (seniorId.length > 0) {
            [parameter setObject:seniorId forKey:@"senior_id"];
        }
        if ([hireType isEqualToString:@"careGiver"]) {
            
            [parameter setObject:confirmArray[@"service_id"] forKey:@"service_id"];
            [parameter setObject:@"1" forKey:@"type"];
        } else {
            [parameter setObject:confirmArray[@"caregiver_specialization_id"] forKey:@"service_id"];
            [parameter setObject:@"2" forKey:@"type"];
        }
        
        NSLog(@"Parameter : %@" , parameter);
        NSMutableDictionary *responceDict = [UserRunningServices addSomeOne:parameter witServiceName:@"hiringConfirmationCleint"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
            
            NSLog(@"%@" , responceDict);
            seniorId = @"";
            if ([[responceDict objectForKey:@"status"] isKindOfClass:[NSString class]]) {
                if ([[responceDict objectForKey:@"status"] isEqualToString:@"success"]) {
                    
                    _confirmHireView.hidden = YES;
                    _careGiverCollectionView.hidden= YES;
                    _reConfirmHireView.hidden = YES;
                    _requestDic = [responceDict objectForKey:@"data"];
                    [self.view makeToast:@"Notification sending..." duration:0.10 position:CSToastPositionBottom];
                    requestNotificationUIView = [[[NSBundle mainBundle] loadNibNamed:@"ClientNotificationUIView" owner:self options:nil] objectAtIndex:0];
                    [requestNotificationUIView showWaitingView];
                    [requestNotificationUIView setFrame:CGRectMake(0, _ambulanceButton.frame.origin.y, self.view.frame.size.width, 50)];
                    [[UIApplication sharedApplication].keyWindow addSubview:requestNotificationUIView];

                    hire_caregiver_id = [_requestDic objectForKey:@"hire_caregiver_id"];
                    
                    timer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(autoCancelRequest) userInfo:nil repeats:NO];
                }
            }else{
                
            }
           
        });
    });

}

-(void) cancelTimer
{
    [timer invalidate];
    timer = nil;
}

-(void)autoCancelRequest{
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        
        NSMutableDictionary *parameter = [NSMutableDictionary new];
        
        [parameter setObject:[[SYUserDefault sharedManager] getAppToken] forKey:@"token"];
        [parameter setObject:hire_caregiver_id forKey:@"hire_caregiver_id"];
//        [parameter setObject:@"client" forKey:@"reciever_type"];
        
        NSMutableDictionary *responceDict = [UserRunningServices addSomeOne:parameter witServiceName:@"updateBookingStatus"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if ([[responceDict objectForKey:@"status"] intValue] ==  200) {
                [requestNotificationUIView removeWaitingView];
                [requestNotificationUIView removeFromSuperview];
            }
            else {
                [requestNotificationUIView removeWaitingView];
                [requestNotificationUIView removeFromSuperview];
                //NSLog(@"responceDict = %@", responceDict);
            }
        });
    });

    //DILIP Comment
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{

        NSMutableDictionary *parameter = [NSMutableDictionary new];

        [parameter setObject:[[SYUserDefault sharedManager] getAppToken] forKey:@"token"];
        [parameter setObject:[_requestDic objectForKey:@"client_id"] forKey:@"reciever_id"];
        [parameter setObject:@"client" forKey:@"reciever_type"];
        [parameter setObject:@"cancel" forKey:@"status"];
        
        NSMutableDictionary *responceDict = [UserRunningServices addSomeOne:parameter witServiceName:@"cancel_request"];

        dispatch_async(dispatch_get_main_queue(), ^{

            if ([[responceDict objectForKey:@"status"] intValue] ==  200) {
                [requestNotificationUIView removeWaitingView];
                [requestNotificationUIView removeFromSuperview];
            }

        });
    });
}
- (IBAction)ActionOnFav:(id)sender {
    [self googleMapForCareGiver];
}

- (void)updateLatLongForCareGiver {
    
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.label.text = NSLocalizedString(@"Please Wait...", @"HUD loading title");
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        
        NSMutableDictionary *parameter = [NSMutableDictionary new];
        [parameter setObject:[[SYUserDefault sharedManager] getAppToken] forKey:@"token"];
        [parameter setObject:[NSNumber numberWithDouble:currentLatitude] forKey:@"latitude"];
        [parameter setObject:[NSNumber numberWithDouble:currentLongitude] forKey:@"longitud"];
        
        NSLog(@"Parameter : %@" , parameter);
        NSMutableDictionary *responceDict = [UserRunningServices addSomeOne:parameter witServiceName:@"updateCaregiverLatLong"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
            
            NSLog(@"%@" , responceDict);
            
            if ([[responceDict objectForKey:@"message"] isEqualToString:@"success"]) {
                
            }
            
        });
    });
}

#pragma mark - UITextField Delegates

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    GMSAutocompleteViewController *acController = [[GMSAutocompleteViewController alloc] init];
    acController.delegate = self;
    [self presentViewController:acController animated:YES completion:nil];
}

// Handle the user's selection.
- (void)viewController:(GMSAutocompleteViewController *)viewController
didAutocompleteWithPlace:(GMSPlace *)place {
    [self dismissViewControllerAnimated:YES completion:nil];
    // Do something with the selected place.
    NSLog(@"Place name %@", place.name);
    NSLog(@"Place address %@", place.formattedAddress);
    NSLog(@"Place attributions %@", place.attributions.string);
    
    camera = [GMSCameraPosition cameraWithLatitude:place.coordinate.latitude longitude:place.coordinate.longitude zoom:15];
    if (isStartRide) {
        destinationLoc = place.coordinate;
        [startRideDic setObject:[NSString stringWithFormat:@"%.4f",destinationLoc.latitude] forKey:@"source_latitude"];
        [startRideDic setObject:[NSString stringWithFormat:@"%.4f",destinationLoc.longitude] forKey:@"source_longitude"];

        [self startRideAPI];
    }else{
        self.Searchtextfiled.text = place.formattedAddress;
        
        if (currentLatitude != place.coordinate.latitude) {
            
            currentLatitude = place.coordinate.latitude;
            currentLongitude = place.coordinate.longitude;
            
            if ([[[SYUserDefault sharedManager] getUserAuthorityId] intValue] == USER_TYPE) {
                
                [self getCareGiverListForMap:nil];
            } else {
                [googleMapView removeFromSuperview];
                googleMapView = [GMSMapView mapWithFrame:self.view.bounds camera:camera];
                googleMapView.myLocationEnabled = YES;
                [_mapView addSubview: googleMapView];
                
                [self updateLatLongForCareGiver];
                
            }
        }
    }
   // NSString *locatedAt = [[place.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
   
}

-(void)startRideAPI{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
  hud.label.text = NSLocalizedString(@"Please Wait...", @"HUD loading title");
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        NSMutableDictionary *responceDict = [UserRunningServices addSomeOne:[startRideDic mutableCopy] witServiceName:@"startStopAmbulanceTime"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [hud hideAnimated:YES];
            
            if ([[responceDict objectForKey:@"status"] intValue] ==  200) {
                for (UIView *views in [[UIApplication sharedApplication].keyWindow subviews]) {
                    
                    if ([views isKindOfClass: [RequestNotificationUIView class]]) {
                        [views removeFromSuperview];
                        break;
                    }
                }
                NSMutableDictionary *Newparameter = [NSMutableDictionary new];
                [Newparameter setObject:[[SYUserDefault sharedManager] getAppToken] forKey:@"token"];
                [Newparameter setObject:[startRideDic objectForKey:@"client_id"] forKey:@"client_id"];
                [Newparameter setObject:@"2" forKey:@"type"];
                [Newparameter setObject:[startRideDic objectForKey:@"hire_caregiver_id"] forKey:@"hire_caregiver_id"];
                [Newparameter setObject:[[SYUserDefault sharedManager]getCurrentLat] forKey:@"source_latitude"];
                [Newparameter setObject:[[SYUserDefault sharedManager]getCurrentLng] forKey:@"source_longitude"];
                [Newparameter setObject:[NSString stringWithFormat:@"%f",destinationLoc.latitude] forKey:@"latitude"];
                [Newparameter setObject:[NSString stringWithFormat:@"%f",destinationLoc.longitude] forKey:@"longitud"];
                
                RequestNotificationUIView *requestNotificationUIView = [[[NSBundle mainBundle] loadNibNamed:@"RequestNotificationUIView" owner:self options:nil] objectAtIndex:0];
                requestNotificationUIView.cancelnoti = @"startRide";
                [requestNotificationUIView setFrame:CGRectMake(0, self.view.frame.size.height - 150, self.view.frame.size.height, 150)];
                
                requestNotificationUIView.requestDataDict = Newparameter;
                
                [[UIApplication sharedApplication].keyWindow addSubview:requestNotificationUIView];
                NSDictionary *rideDic = @{@"ride":startRideDic,@"caregiver_detail":Newparameter};
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:@"startRide"
                 object:rideDic];
                //[self removeFromSuperview];
            }
            
        });
    });
}

- (void)viewController:(GMSAutocompleteViewController *)viewController
didFailAutocompleteWithError:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:nil];
    // TODO: handle the error.
    NSLog(@"Error: %@", [error description]);
}

// User canceled the operation.
- (void)wasCancelled:(GMSAutocompleteViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

// Turn the network activity indicator on and off again.
- (void)didRequestAutocompletePredictions:(GMSAutocompleteViewController *)viewController {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)didUpdateAutocompletePredictions:(GMSAutocompleteViewController *)viewController {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

#pragma mark - Add reminder delegates

-(void)reminderAddedSuccessfully{
    [self performSegueWithIdentifier:@"reminderListSegue" sender:self];
}
-(NSArray*) calculateRoutesFrom:(CLLocationCoordinate2D) f to: (CLLocationCoordinate2D) t {
    NSString* saddr = [NSString stringWithFormat:@"%f,%f", f.latitude, f.longitude];
    NSString* daddr = [NSString stringWithFormat:@"%f,%f", t.latitude, t.longitude];
    
    
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/directions/json?origin=%@&destination=%@&sensor=false&avoid=highways&mode=driving&transit_routing_preference=less_driving",saddr,daddr]];
    
    NSError *error=nil;
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init] ;
    
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    
    NSURLResponse *response = nil;
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error: &error];
    
    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONWritingPrettyPrinted error:nil];
    
    return [self decodePolyLine:[self parseResponse:dic]];
}
- (NSString *)parseResponse:(NSDictionary *)response {
    NSArray *routes = [response objectForKey:@"routes"];
    NSDictionary *route = [routes lastObject];
    if (route) {
        NSString *overviewPolyline = [[route objectForKey:
                                       @"overview_polyline"] objectForKey:@"points"];
        return overviewPolyline;
    }
    return @"";
}
-(NSMutableArray *)decodePolyLine:(NSString *)encodedStr {
    NSMutableString *encoded = [[NSMutableString alloc]
                                initWithCapacity:[encodedStr length]];
    [encoded appendString:encodedStr];
    [encoded replaceOccurrencesOfString:@"\\\\" withString:@"\\"
                                options:NSLiteralSearch
                                  range:NSMakeRange(0,
                                                    [encoded length])];
    NSInteger len = [encoded length];
    NSInteger index = 0;
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSInteger lat=0;
    NSInteger lng=0;
    while (index < len) {
        NSInteger b;
        NSInteger shift = 0;
        NSInteger result = 0;
        do {
            b = [encoded characterAtIndex:index++] - 63;
            result |= (b & 0x1f) << shift;
            shift += 5;
        } while (b >= 0x20);
        NSInteger dlat = ((result & 1) ? ~(result >> 1)
                          : (result >> 1));
        lat += dlat;
        shift = 0;
        result = 0;
        do {
            b = [encoded characterAtIndex:index++] - 63;
            result |= (b & 0x1f) << shift;
            shift += 5;
        } while (b >= 0x20);
        NSInteger dlng = ((result & 1) ? ~(result >> 1)
                          : (result >> 1));
        lng += dlng;
        NSNumber *latitude = [[NSNumber alloc] initWithFloat:lat * 1e-5];
        NSNumber *longitude = [[NSNumber alloc] initWithFloat:lng * 1e-5];
        CLLocation *location = [[CLLocation alloc] initWithLatitude:
                                [latitude floatValue] longitude:[longitude floatValue]];
        [array addObject:location];
    }
    return array;
}
- (void)loadMapViewWithDirectionWithSource:(CLLocationCoordinate2D)source andDistination:(CLLocationCoordinate2D)destination {
    
   
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:source.latitude
                                                            longitude:source.longitude
                                                                 zoom:10];
    
    
    googleMapView = [GMSMapView mapWithFrame:self.view.bounds camera:camera];
    googleMapView.myLocationEnabled = YES;
    
    MarkerSourceLoc = source;
    MarkerDestinationLoc = destination;
    sourceMarker = [[GMSMarker alloc] init];
    sourceMarker.position = MarkerSourceLoc;
    sourceMarker.map = googleMapView;
    
    destMarker = [[GMSMarker alloc] init];
    destMarker.position = MarkerDestinationLoc;
    destMarker.map = googleMapView;
    
    googleMapView.delegate = self;
    
    [self drawDirection:source and:destination];
    
    //[self.view addSubview:googleMapView];
}
- (void) drawDirection:(CLLocationCoordinate2D)source and:(CLLocationCoordinate2D) dest {
    
    
    polyline = [[GMSPolyline alloc] init];
    GMSMutablePath *path = [GMSMutablePath path];
    
    NSArray * points = [self calculateRoutesFrom:source to:dest];
    
    NSInteger numberOfSteps = points.count;
    
    for (NSInteger index = 0; index < numberOfSteps; index++)
    {
        CLLocation *location = [points objectAtIndex:index];
        CLLocationCoordinate2D coordinate = location.coordinate;
        [path addCoordinate:coordinate];
    }
    
    polyline.path = path;
    polyline.strokeColor = [UIColor redColor];
    polyline.strokeWidth = 5.f;
    polyline.map = googleMapView;
    
    // Copy the previous polyline, change its color, and mark it as geodesic.
    polyline = [polyline copy];
    polyline.strokeColor = [UIColor redColor];
    polyline.geodesic = YES;
    polyline.map = googleMapView;
    
    [_mapView addSubview:googleMapView];
}

- (IBAction)ActionOnDone:(id)sender {
    self.datePickerView.hidden = YES;
    
    if (((UIButton*)sender).tag == 1) {
        if ([[[SYUserDefault sharedManager] getUserAuthorityId] intValue] == USER_TYPE) {
            self.ambulanceButton.hidden = NO;
            self.careGiverButton.hidden = NO;
        }
        [self googleMapForCareGiver];
    }else{

    NSDateFormatter *dateFormate = [[NSDateFormatter alloc]init];
    dateFormate.dateFormat = @"yyyy-MM-dd";
    
    NSDateFormatter *timeFormat = [[NSDateFormatter alloc]init];
    timeFormat.dateFormat = @"HH:mm:ss";
        NSMutableDictionary *parameter = [NSMutableDictionary new];
        /*     hashMap.put("time", times);
         hashMap.put("date", dates);*/
        [parameter setObject:[dateFormate stringFromDate:_dtPicker.date] forKey:@"date"];
        [parameter setObject:[timeFormat stringFromDate:_dtPicker.date] forKey:@"time"];
        
        [parameter setObject:[[SYUserDefault sharedManager] getAppToken] forKey:@"token"];
        [parameter setObject:[NSNumber numberWithDouble:currentLatitude] forKey:@"latitude"];
        [parameter setObject:[NSNumber numberWithDouble:currentLongitude] forKey:@"longitud"];
        
        if ([hireType isEqualToString:@"careGiver"]) {
            
            [parameter setObject:confirmArray[@"service_id"] forKey:@"service_id"];
            [parameter setObject:confirmArray[@"caregiver_specialization_id"] forKey:@"caregiver_specialization_id"];
            [parameter setObject:@"1" forKey:@"type"];
        } else {
            [parameter setObject:confirmArray[@"caregiver_specialization_id"] forKey:@"service_id"];
            [parameter setObject:@"2" forKey:@"type"];
        }
        [self setLocalReminder:parameter];
 /*   MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.label.text = NSLocalizedString(@"Sending...", @"HUD loading title");
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        
       
        NSLog(@"Parameter : %@" , parameter);
        NSMutableDictionary *responceDict = [UserRunningServices addSomeOne:parameter witServiceName:@"addScheduleNotification"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
            
            NSLog(@"%@" , responceDict);
            
            if ([[responceDict objectForKey:@"status"] isKindOfClass:[NSString class]]) {
                if ([[responceDict objectForKey:@"status"] isEqualToString:@"success"]) {
                 
                    _requestDic = [responceDict objectForKey:@"data"];
                    [self.view makeToast:@"Notification sending..." duration:0.10 position:CSToastPositionBottom];
                    requestNotificationUIView = [[[NSBundle mainBundle] loadNibNamed:@"ClientNotificationUIView" owner:self options:nil] objectAtIndex:0];
                    [requestNotificationUIView showWaitingView];
                    //  requestNotificationUIView.dataNotificationDict = [responceDict objectForKey:@"data"];
                    [requestNotificationUIView setFrame:CGRectMake(0, _ambulanceButton.frame.origin.y, self.view.frame.size.width, 50)];
                    [[UIApplication sharedApplication].keyWindow addSubview:requestNotificationUIView];
                    timer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(autoCancelRequest) userInfo:nil repeats:NO];
                    //  [requestNotificationUIView performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.5];
                }
            }else{
                
            }
            
        });
    });*/
        
    }
}

-(void)setLocalReminder:(NSDictionary*)parameters{
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    if (notification)
    {
        NSMutableDictionary *newParameter = [[NSMutableDictionary alloc] init];
        [newParameter setObject:parameters forKey:@"hire_later"];
        [newParameter setObject:@"localNotification" forKey:@"action"];
        [newParameter setObject:@"hire_later" forKey:@"type"];
        
        notification.fireDate = _dtPicker.date;
        notification.alertBody = @"Reminder!!!";
        //notification.alertAction = @"localNotification";
        notification.timeZone = [NSTimeZone defaultTimeZone];
        notification.applicationIconBadgeNumber = 1;
        notification.soundName = UILocalNotificationDefaultSoundName;
        //   notification.repeatInterval = NSCalendarUnitDay;
        notification.userInfo = newParameter;
        // this will schedule the notification to fire at the fire date
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
        // this will fire the notification right away, it will still also fire at the date we set
        //   [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
        //  notification.alertBody = _customMessage.text;
        
    }
}

-(void)loadviewWithEvent:(NSNotification*)info{
    NSLog(@"%@",info.userInfo);
    if ([[info.userInfo objectForKey:@"eventType"] intValue] == 3) {
        [self googleMapForCareGiver];
    }
    /*   NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:event]
     forKey:@"eventType"];
     [[NSNotificationCenter defaultCenter] postNotificationName:MFSideMenuStateNotificationEvent
     object:self
     userInfo:userInfo];*/
}

- (CGFloat)widthOfString:(NSString *)string withFont:(NSFont *)font {
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    return [[[NSAttributedString alloc] initWithString:string attributes:attributes] size].width;
}

#pragma mark : Senior list delegates

-(void)didSelectSenior:(NSDictionary *)senior{
    seniorId = [senior objectForKey:@"user_senior_id"];
    _minimumChargeLabel.text = [NSString stringWithFormat:@"Minimum Charges: %0.2f",minMumCharge];
    _careGiverCollectionView.hidden= YES;
    _confirmHireView.hidden = NO;
   // isForSomeone = NO;
}


#pragma mark-

- (void) gettingAcceptedHireCaregiverNotification :(NSMutableDictionary *)responceData {
    
    NSMutableDictionary *parameter = [NSMutableDictionary new];
    [parameter setObject:responceData[@"t_name"] forKey:@"t_name"];
    [parameter setObject:responceData[@"caregiver_id"] forKey:@"caregiver_id"];
    NSMutableDictionary *resultDict = [UserRunningServices getOtherServices:parameter witServiceName:@"get_notification_data"];
    
    if ([resultDict[@"status"] intValue] == 200) {
        // [self comeUserRequestNotifiction:resultDict];
        [self acceptUserRequest:resultDict];
    }
}

- (void) acceptUserRequest:(NSMutableDictionary *)data {
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    for (UIView *views in [appDelegate.window subviews]) {
        
        if ([views isKindOfClass: [RequestNotificationUIView class]] || [views isKindOfClass: [ClientNotificationUIView class]]) {
            [views removeFromSuperview];
        }
    }
    
    ClientNotificationUIView *requestNotificationUIView = [[[NSBundle mainBundle] loadNibNamed:@"ClientNotificationUIView" owner:self options:nil] objectAtIndex:0];
    
    [requestNotificationUIView setFrame:CGRectMake(0, screenHeight-110 , screenWidth, 110)];
//    startRideCareGiverData = [[data objectForKey:@"data"] mutableCopy];
    NSArray *arrData = [data objectForKey:@"data"];
    NSDictionary *dictdata = arrData.firstObject;
    requestNotificationUIView.dataNotificationDict = [[NSMutableDictionary alloc] initWithDictionary:dictdata];
    requestNotificationUIView.isUserView =  YES;
    
    [[UIApplication sharedApplication].keyWindow addSubview:requestNotificationUIView];
}

@end
