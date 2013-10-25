//
//  SocialManager.h
//  Instashop
//
//  Created by Josh Klobe on 10/25/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SocialManager : NSObject

+(void)requestInitialFacebookAccess;
+(void)postToTwitterWithString:(NSString *)contentString;
+(void)postToFacebookWithString:(NSString *)contentString;

@end
