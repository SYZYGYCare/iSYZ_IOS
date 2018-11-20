//
//  dinGInfo.h
//  dinG
//
//  Created by iPhones on 7/31/15.
//  Copyright (c) 2015 ps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface dinGInfo : NSObject
@property (nonatomic,assign) float distance,latitude,longitude;
@property (nonatomic,retain) NSString *full_name,*email_id,*facebookLink,*linkdinLink,*googlelink,*introduction,*mobile,*profile_image,*user_id,*user_name,*user_status,*sexuality,*material_status,*date_of_birth,*is_private,*interested_in,*connection_id,*created,*updated,*other_id,*Address,*message_text,*sender_image,*reciver_image,*dingDate,*is_connection,*connection_status;
@property (nonatomic , assign) NSInteger SValue,status,Ding_friend,message_id,sender_id,receiver_id,message_type,is_deleted,unreadMsg;
@property (nonatomic , assign) int event_type_id,message_status,people_id,online_status,is_attend;
@property (nonatomic,assign) BOOL NotificationOn,isImage;

@property (nonatomic,retain) NSString *event_id,*event_name,*long_desc,*short_desc,*event_type,*event_location,*post_code,*date,*start_time,*end_time,*url,*event_image,*is_public,*attendies_id,*invitation,*setting_notification,*setting_radious,*facebook_id,*google_id,*linkdin_id;
@property (nonatomic, retain) NSString *imageUrl,*social_image,*db_event_id;

@property (nonatomic, retain) NSString *end_local,*end_time_zone,*end_utc,*location_name,*start_local,*start_time_zone,*start_utc,*notification_id,*notification_type,*social_email;

@property (nonatomic,retain) UIImage *DefaultImage;
@property (nonatomic,assign)CGSize imageSize;
@end
