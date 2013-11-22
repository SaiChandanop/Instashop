//
//  SellersAPIHandler.h
//  Instashop
//
//  Created by Josh Klobe on 7/8/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "RootAPIHandler.h"
#import "InstagramUserObject.h"

@interface SellersAPIHandler : RootAPIHandler

+(void)makeCreateSellerRequestWithDelegate:(id)theDelegate withInstagramUserObject:(InstagramUserObject *)instagramUserObject withSellerAddressDictionary:(NSDictionary *)addressDictionary;

+(void)makeCheckIfSellerExistsCallWithDelegate:(id)delegate;
+(void)makeGetSellersRequestWithDelegate:(id)theDelegate withSellerInstagramID:(NSString *)sellerInstagramID;
+(void)makeGetAllSellersRequestWithDelegate:(id)theDelegate;
+(void)updateSellerPushIDWithPushID:(NSString *)pushID withInstagramID:(NSString *)instagramID;
+(void)uploadProfileImage:(UIImage *)image withDelegate:(id)theDelegate;

+(void)getSellerDetailsWithInstagramID:(NSString *)instagramID withDelegate:(id)theDelegate;

+(void)updateSellerDescriptionWithDelegate:(id)theDelegate InstagramID:(NSString *)instagramID withDescription:(NSString *)theDescription;

@end
