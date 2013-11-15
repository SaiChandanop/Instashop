//
//  NotificationsAPIHandler.h
//  Instashop
//
//  Created by Josh Klobe on 11/14/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "RootAPIHandler.h"

@interface NotificationsAPIHandler : RootAPIHandler


+(void)createUserLikedNotificationWithProductID:(NSString *)productID withInstagramID:(NSString *)instagramID;

@end
