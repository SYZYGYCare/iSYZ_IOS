//
//  UserLoginServices.m
//  Syzygy
//
//  Created by kamal gupta on 12/2/17.
//  Copyright © 2017 kamal gupta. All rights reserved.
//

#import "UserLoginServices.h"
#import "BaseServices.h"
#import "Constant.h"
#import "SYUserDefault.h"

@implementation UserLoginServices


+ (NSMutableDictionary *) generateOTPByUser :(NSMutableDictionary *) parameter {
    
    BaseServices *baseService =  [BaseServices new];
    baseService.parameters = parameter;
    
    NSString *endPointUrl = [NSString stringWithFormat:@"%@getOtp", kBaseUrl];
    
    NSMutableDictionary *responceData = [baseService callToServerByGETMethods:endPointUrl];
    
    return responceData;
}


+ (NSMutableDictionary *) matchOTP :(NSMutableDictionary *) parameter {
    
    BaseServices *baseService =  [BaseServices new];
    baseService.parameters = parameter;
    
    NSString *endPointUrl = [NSString stringWithFormat:@"%@matchOtp", kBaseUrl];
    
    NSMutableDictionary *responceData = [baseService callToServerByGETMethods:endPointUrl];
    
    return responceData;
}

+ (NSMutableDictionary *) userRegistartion :(NSMutableDictionary *) parameter {
    
    BaseServices *baseService =  [BaseServices new];
    baseService.parameters = parameter;
    
    NSString *endPointUrl = [NSString stringWithFormat:@"%@registration", kBaseUrl];
    
    NSMutableDictionary *responceData = [baseService callToServerByGETMethods:endPointUrl];
    
    return responceData;
}

+ (NSMutableDictionary *) userLogin :(NSMutableDictionary *) parameter {
    
    BaseServices *baseService =  [BaseServices new];
    baseService.parameters = parameter;
    
    NSString *endPointUrl = [NSString stringWithFormat:@"%@login", kBaseUrl];
    
    NSMutableDictionary *responceData = [baseService callToServerByGETMethods:endPointUrl];
    
    return responceData;
}

+ (NSMutableDictionary *) userDetail :(NSMutableDictionary *) parameter {
    
    BaseServices *baseService =  [BaseServices new];
    baseService.parameters = parameter;
    
    NSString *endPointUrl = [NSString stringWithFormat:@"%@getProfileDetail", kBaseUrl];
    
    NSMutableDictionary *responceData = [baseService callToServerByGETMethods:endPointUrl];
    
    return responceData;
}


+ (NSMutableDictionary *) TrustBadges :(NSMutableDictionary *) parameter {
    
    BaseServices *baseService =  [BaseServices new];
    baseService.parameters = parameter;
    
    NSString *endPointUrl = [NSString stringWithFormat:@"%@getTrustBadges", kBaseUrl];
    
    NSMutableDictionary *responceData = [baseService callToServerByGETMethods:endPointUrl];
    
    return responceData;
}
+ (NSMutableDictionary *) getUserProperties :(NSMutableDictionary *) parameter withEndPoint:(NSString *)endPoint {
    
    BaseServices *baseService =  [BaseServices new];
    baseService.parameters = parameter;
    
    NSString *endPointUrl = [NSString stringWithFormat:@"%@%@", kBaseUrl, endPoint];
    
    NSMutableDictionary *responceData = [baseService callToServerByGETMethods:endPointUrl];
    
    return responceData;
}

+ (NSMutableDictionary *) changePassword :(NSMutableDictionary *)parameter {
    
    BaseServices *baseService =  [BaseServices new];
    baseService.parameters = parameter;
    
    NSString *endPointUrl = [NSString stringWithFormat:@"%@%@", kBaseUrl, @"change_password_at_login"];
    
    NSMutableDictionary *responceData = [baseService callToServerByPostMethods:endPointUrl];
    
    return responceData;
}

+ (NSMutableDictionary *)ForgotPassword :(NSMutableDictionary *)parameter {
    
    BaseServices *baseService =  [BaseServices new];
    baseService.parameters = parameter;
    
    NSString *endPointUrl = [NSString stringWithFormat:@"%@%@", kBaseUrl, @"change_password"];
    
    NSMutableDictionary *responceData = [baseService callToServerByPostMethods:endPointUrl];
    
    return responceData;
}

+ (NSMutableDictionary *)ForgotPasswordOTP :(NSMutableDictionary *)parameter {
    
    BaseServices *baseService =  [BaseServices new];
    baseService.parameters = parameter;
    
    NSString *endPointUrl = [NSString stringWithFormat:@"%@%@", kBaseUrl, @"forgot_password"];
    
    NSMutableDictionary *responceData = [baseService callToServerByPostMethods:endPointUrl];
    
    return responceData;
}
+ (NSMutableDictionary *) GetCheckList :(NSMutableDictionary *)parameter {
    
    BaseServices *baseService =  [BaseServices new];
    baseService.parameters = parameter;
    
    NSString *endPointUrl = [NSString stringWithFormat:@"%@%@", kBaseUrl, @"getAllHealthPoints"];
    
    //getCheckList
    NSMutableDictionary *responceData = [baseService callToServerByPostMethods:endPointUrl];
    
    return responceData;
}

// chaange File


+ (NSMutableDictionary *) hireCareGiverList :(NSMutableDictionary *)parameter {
    
    BaseServices *baseService =  [BaseServices new];
    baseService.parameters = parameter;
    //http://syzygycare.com/careApp/getCargiverHistory
    NSString *endPointUrl = [NSString stringWithFormat:@"%@%@", kBaseUrl, @"getCustomerHistory"];

    if ([[[SYUserDefault sharedManager] getUserAuthorityId] intValue] != USER_TYPE) {
        endPointUrl = [NSString stringWithFormat:@"%@%@", kBaseUrl, @"getCargiverHistory"];
    }
    NSMutableDictionary *responceData = [baseService callToServerByPostMethods:endPointUrl];
    
    return responceData;
}

+ (NSMutableDictionary *) GetReferCode :(NSMutableDictionary *) parameter {
    
    BaseServices *baseService =  [BaseServices new];
    baseService.parameters = parameter;
    
    NSString *endPointUrl = [NSString stringWithFormat:@"%@get_refer_code", kBaseUrl];
    
    NSMutableDictionary *responceData = [baseService callToServerByGETMethods:endPointUrl];
    
    return responceData;
}

+ (NSMutableDictionary *) UpdateUserProfile :(NSMutableDictionary *) parameter andImageData:(NSData*)imageData{
    BaseServices *baseService =  [BaseServices new];
    baseService.parameters = parameter;
    
    NSString *endPointUrl = [NSString stringWithFormat:@"%@updateProfile", kBaseUrl];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:endPointUrl]];
    [request setHTTPMethod:@"POST"];
   
    NSMutableData *body = [NSMutableData data];
    NSString *boundary = [NSString stringWithString:@"---------------------------14737809831466499882746641449"];
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    
  
    // file
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:@"Content-Disposition: attachment; name=\"profile_pic\"; filename=\".png\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:imageData]];
    [body appendData:[[NSString stringWithString:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // text parameter Email iD
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"email_id\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[parameter objectForKey:@"email_id"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // another text parameter Name
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"full_name\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[parameter objectForKey:@"full_name"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    // another text parameter mobile
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"phone\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[parameter objectForKey:@"phone"]dataUsingEncoding:NSUTF8StringEncoding] ];
    [body appendData:[[NSString stringWithString:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // another text parameter address
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"address\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[parameter objectForKey:@"address"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    /*
     email_id
     phone
     address
     aadharNumber
     gender
     */
    
    // another text parameter gender
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"gender\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[parameter objectForKey:@"gender"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // another text parameter gender
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"aadharNumber\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[parameter objectForKey:@"aadharNumber"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"token\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[parameter objectForKey:@"token"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // close form
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // set request body
    [request setHTTPBody:body];
    NSMutableDictionary *responceData = [baseService callToServerByPostMethodsWithRequest:request];
    
    return responceData;
}

+ (NSMutableDictionary *) UpdateCaregiverProfile :(NSMutableDictionary *) parameter andImageData:(NSData*)imageData{
    BaseServices *baseService =  [BaseServices new];
    baseService.parameters = parameter;
    
    NSString *endPointUrl = [NSString stringWithFormat:@"%@addDetailsCaregiver", kBaseUrl];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:endPointUrl]];
    [request setHTTPMethod:@"POST"];
    
    NSMutableData *body = [NSMutableData data];
    NSString *boundary = [NSString stringWithString:@"---------------------------14737809831466499882746641449"];
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    
    // file
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:@"Content-Disposition: attachment; name=\"document\"; filename=\".png\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:imageData]];
    [body appendData:[[NSString stringWithString:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // text parameter Email iD
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"service_id\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[parameter objectForKey:@"service_id"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // another text parameter Name
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"type\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[parameter objectForKey:@"type"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    // another text parameter mobile
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"specialization_id\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[parameter objectForKey:@"specialization_id"]dataUsingEncoding:NSUTF8StringEncoding] ];
    [body appendData:[[NSString stringWithString:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // another text parameter address
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"qualificatin\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[parameter objectForKey:@"qualificatin"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // another text parameter gender
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"registration_no\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[parameter objectForKey:@"registration_no"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // another text parameter gender
   
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"token\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[parameter objectForKey:@"token"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // close form
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // set request body
    [request setHTTPBody:body];
    NSMutableDictionary *responceData = [baseService callToServerByPostMethodsWithRequest:request];
    
    return responceData;
}

+ (NSMutableDictionary *) UpdateCaregiverProfile :(NSMutableDictionary *) parameter andImageArr:(NSArray*)imageArr{
    BaseServices *baseService =  [BaseServices new];
    baseService.parameters = parameter;
    
    NSString *endPointUrl = [NSString stringWithFormat:@"%@addDetailsCaregiver", kBaseUrl];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:endPointUrl]];
    [request setHTTPMethod:@"POST"];
    
    NSMutableData *body = [NSMutableData data];
    NSString *boundary = [NSString stringWithString:@"---------------------------14737809831466499882746641449"];
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    
    // file
    int number = 0;
    for (UIImage *image in imageArr) {
        NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
        NSString *imageName = [NSString stringWithFormat:@"document%d",number];
        if (number == 0) {
            imageName = [NSString stringWithFormat:@"document"];
        }else if (number < 3){
            imageName = [NSString stringWithFormat:@"image%d",number];
        }
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: attachment; name=\"%@\"; filename=\".png\"\r\n",imageName] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[NSData dataWithData:imageData]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        number++;
    }
   
    
    // text parameter Email iD
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"service_id\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[parameter objectForKey:@"service_id"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // another text parameter Name
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"type\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[parameter objectForKey:@"type"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    // another text parameter mobile
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"specialization_id\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[parameter objectForKey:@"specialization_id"]dataUsingEncoding:NSUTF8StringEncoding] ];
    [body appendData:[[NSString stringWithString:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // another text parameter address
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"qualificatin\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[parameter objectForKey:@"qualificatin"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // another text parameter gender
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"registration_no\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[parameter objectForKey:@"registration_no"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // another text parameter gender
    
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"token\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[parameter objectForKey:@"token"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // close form
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // set request body
    [request setHTTPBody:body];
    NSMutableDictionary *responceData = [baseService callToServerByPostMethodsWithRequest:request];
    
    return responceData;
}

+ (NSMutableDictionary *) UpdateAmbulanceProfile :(NSMutableDictionary *) parameter andImageData:(NSData*)imageData andLincenceImageData:(NSData*)licenceImageData{
    BaseServices *baseService =  [BaseServices new];
    baseService.parameters = parameter;
    
    NSString *endPointUrl = [NSString stringWithFormat:@"%@addAmbulance", kBaseUrl];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:endPointUrl]];
    [request setHTTPMethod:@"POST"];
    
    NSMutableData *body = [NSMutableData data];
    NSString *boundary = [NSString stringWithString:@"---------------------------14737809831466499882746641449"];
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    
   
    // file
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:@"Content-Disposition: attachment; name=\"lincens\"; filename=\".png\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:licenceImageData]];
    [body appendData:[[NSString stringWithString:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:@"Content-Disposition: attachment; name=\"registration_card\"; filename=\".png\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:imageData]];
    [body appendData:[[NSString stringWithString:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // text parameter Email iD
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"ambulance_type\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[parameter objectForKey:@"ambulance_type"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // another text parameter Name
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"type\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[parameter objectForKey:@"type"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    // another text parameter mobile
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"vehical_registration_no\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[parameter objectForKey:@"vehical_registration_no"]dataUsingEncoding:NSUTF8StringEncoding] ];
    [body appendData:[[NSString stringWithString:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // another text parameter address
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"vehical_model_no\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[parameter objectForKey:@"vehical_model_no"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // another text parameter gender
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"path\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[parameter objectForKey:@"path"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // another text parameter gender
    
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"token\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[parameter objectForKey:@"token"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // close form
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // set request body
    [request setHTTPBody:body];
    NSMutableDictionary *responceData = [baseService callToServerByPostMethodsWithRequest:request];
    
    return responceData;
}

+ (NSMutableDictionary *) UpdateAmbulanceProfile :(NSMutableDictionary *) parameter andImageData:(NSData*)imageData andLincenceImageData:(NSData*)licenceImageData andImage1Data:(NSData*)imageData1 andImage2Data:(NSData*)ImageData2{
    BaseServices *baseService =  [BaseServices new];
    baseService.parameters = parameter;
    
    NSString *endPointUrl = [NSString stringWithFormat:@"%@addAmbulance", kBaseUrl];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:endPointUrl]];
    [request setHTTPMethod:@"POST"];
    
    NSMutableData *body = [NSMutableData data];
    NSString *boundary = [NSString stringWithString:@"---------------------------14737809831466499882746641449"];
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:@"Content-Disposition: attachment; name=\"image1\"; filename=\".png\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:imageData1]];
    [body appendData:[[NSString stringWithString:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:@"Content-Disposition: attachment; name=\"image2\"; filename=\".png\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:ImageData2]];
    [body appendData:[[NSString stringWithString:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    // file
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:@"Content-Disposition: attachment; name=\"lincens\"; filename=\".png\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:licenceImageData]];
    [body appendData:[[NSString stringWithString:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:@"Content-Disposition: attachment; name=\"registration_card\"; filename=\".png\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:imageData]];
    [body appendData:[[NSString stringWithString:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    // text parameter Email iD
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"ambulance_type\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[parameter objectForKey:@"ambulance_type"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // another text parameter Name
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"type\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[parameter objectForKey:@"type"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    // another text parameter mobile
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"vehical_registration_no\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[parameter objectForKey:@"vehical_registration_no"]dataUsingEncoding:NSUTF8StringEncoding] ];
    [body appendData:[[NSString stringWithString:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // another text parameter address
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"vehical_model_no\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[parameter objectForKey:@"vehical_model_no"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // another text parameter gender
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"path\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[parameter objectForKey:@"path"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // another text parameter gender
    
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"token\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[parameter objectForKey:@"token"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // close form
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // set request body
    [request setHTTPBody:body];
    NSMutableDictionary *responceData = [baseService callToServerByPostMethodsWithRequest:request];
    
    return responceData;
}

@end
