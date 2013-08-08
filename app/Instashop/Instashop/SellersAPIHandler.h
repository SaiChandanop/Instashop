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

@end
