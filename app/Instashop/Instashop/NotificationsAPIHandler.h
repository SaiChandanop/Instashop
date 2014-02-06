//
//  NotificationsAPIHandler.h
//  Instashop
//
//  Created by Josh Klobe on 11/14/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "RootAPIHandler.h"

@interface NotificationsAPIHandler : RootAPIHandler

+(void)getAllNotificationsCountInstagramID:(NSString *)instagramID withDelegate:(id)theDelegate;
+(void)getAllNotificationsWithInstagramID:(NSString *)instagramID withDelegate:(id)theDelegate;
+(void)createUserSocialNotificationWithProductID:(NSString *)productID withInstagramID:(NSString *)instagramID withSocialType:(NSString *)socialType;
+(void)createUserLikedNotificationWithProductID:(NSString *)productID withInstagramID:(NSString *)instagramID;
+(void)createUserSavedNotificationWithProductID:(NSString *)productID withInstagramID:(NSString *)instagramID;
+(void)makeSocialPostNotificationWithProductID:(NSString *)productID withInstagramID:(NSString *)instagramID withSocialType:(NSString *)socialType;
+(void)makeUserJoinedNotificationWithNotificationArray:(NSArray *)theNotificationArray;
@end
