//
//  UserAPIHandler.h
//  Instashop
//
//  Created by Josh Klobe on 5/22/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "RootAPIHandler.h"
#import "InstagramUserObject.h"

@interface UserAPIHandler : RootAPIHandler



+(void)makeBuyerCreateRequestWithDelegate:(id)theDelegate withInstagramUserObject:(InstagramUserObject *)instagramUserObject;


+(void)updateUserPushIdentityWithPushID:(NSString *)pushID withInstagramID:(NSString *)instagramID;

@end
