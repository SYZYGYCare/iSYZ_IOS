//
//  Constant.h
//  Syzygy
//
//  Created by kamal gupta on 12/2/17.
//  Copyright © 2017 kamal gupta. All rights reserved.
//

#ifndef Constant_h
#define Constant_h

#import "UIImageView+WebCache.h"

//http://syzygycare.com //new
//http://syzygycare.com //old
static NSString * const kBaseUrl = @"https://syzygycare.com/careApp/";


#define CAREGIVER_COLOR [UIColor colorWithRed:0/255.0 green:128/255.0 blue:64/255.0 alpha:1.0]
#define USER_COLOR [UIColor colorWithRed:128/255.0 green:0/255.0 blue:0/255.0 alpha:1.0]
#define USER_TYPE 1
#define CAREGIVER_TYPE 2

#define ISUSER ([[[SYUserDefault sharedManager] getUserAuthorityId] intValue] == USER_TYPE)
#define ISCAREGIVER ([[[SYUserDefault sharedManager] getUserAuthorityId] intValue] == CAREGIVER_TYPE)

static NSString * const kProfileBaseUrl = @"https://syzygycare.com/careApp/uploads/profile/";
static NSString * const kHealthBaseUrl = @"https://syzygycare.com/careApp/uploads/healthTips/";
static NSString * const kDocumentBaseUrl = @"https://syzygycare.com/careApp/uploads/document/ambulance/";



#define SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)


#endif /* Constant_h */
