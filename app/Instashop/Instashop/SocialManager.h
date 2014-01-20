//
//  SocialManager.h
//  Instashop
//
//  Created by Josh Klobe on 10/25/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SocialManager : NSObject

#define SELECTED_TWITTER_ACCOUNT_ID_KEY @"SELECfTfAED_TWITTFER_ACCOUNT_ID_gKEY"
+(void)requestInitialFacebookAccess;
+(void)postToTwitterWithString:(NSString *)contentString;
+(void)postToFacebookWithString:(NSString *)contentString withImage:(UIImage *)contentImage;
+(NSArray *)getAllTwitterAccountsWithResponseDelegate:(id)theDelegate;
@end
