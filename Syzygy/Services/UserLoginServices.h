//
//  UserLoginServices.h
//  Syzygy
//
//  Created by kamal gupta on 12/2/17.
//  Copyright © 2017 kamal gupta. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserLoginServices : NSObject


+ (NSMutableDictionary *) generateOTPByUser :(NSMutableDictionary *) parameter;
+ (NSMutableDictionary *) matchOTP :(NSMutableDictionary *) parameter ;
+ (NSMutableDictionary *) userRegistartion :(NSMutableDictionary *) parameter ;
+ (NSMutableDictionary *) userLogin :(NSMutableDictionary *) parameter;
+ (NSMutableDictionary *) userDetail :(NSMutableDictionary *) parameter;
+ (NSMutableDictionary *) TrustBadges :(NSMutableDictionary *) parameter;

// Hire
+ (NSMutableDictionary *) getUserProperties :(NSMutableDictionary *) parameter withEndPoint:(NSString *)endPoint;

+ (NSMutableDictionary *) changePassword :(NSMutableDictionary *)parameter;
+ (NSMutableDictionary *) hireCareGiverList :(NSMutableDictionary *)parameter;
+ (NSMutableDictionary *) GetReferCode :(NSMutableDictionary *) parameter ;
+ (NSMutableDictionary *) GetCheckList :(NSMutableDictionary *)parameter;
+ (NSMutableDictionary *) UpdateUserProfile :(NSMutableDictionary *) parameter andImageData:(NSData*)imageData;
+ (NSMutableDictionary *) UpdateCaregiverProfile :(NSMutableDictionary *) parameter andImageData:(NSData*)imageData;
+ (NSMutableDictionary *) UpdateAmbulanceProfile :(NSMutableDictionary *) parameter andImageData:(NSData*)imageData andLincenceImageData:(NSData*)licenceImageData;
+ (NSMutableDictionary *) UpdateCaregiverProfile :(NSMutableDictionary *) parameter andImageArr:(NSArray*)imageArr;
+ (NSMutableDictionary *) UpdateAmbulanceProfile :(NSMutableDictionary *) parameter andImageData:(NSData*)imageData andLincenceImageData:(NSData*)licenceImageData andImage1Data:(NSData*)imageData1 andImage2Data:(NSData*)ImageData2;
+ (NSMutableDictionary *)ForgotPassword :(NSMutableDictionary *)parameter ;
+ (NSMutableDictionary *)ForgotPasswordOTP :(NSMutableDictionary *)parameter;
@end
