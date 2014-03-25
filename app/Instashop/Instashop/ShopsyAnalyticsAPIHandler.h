//
//  ShopsyAnalyticsAPIHandler.h
//  Instashop
//
//  Created by Josh Klobe on 3/24/14.
//  Copyright (c) 2014 Josh Klobe. All rights reserved.
//

#import "RootAPIHandler.h"

@interface ShopsyAnalyticsAPIHandler : RootAPIHandler

+(void)makeViewedAnalyticsCallWithOwnerInstagramID:(NSString *)ownerInstagramID withProductInstagramID:(NSString *)productInstagramID withProductID:(NSString *)theProductID;
+(void)makeSavedAnalyticsCallWithOwnerInstagramID:(NSString *)ownerInstagramID withProductInstagramID:(NSString *)productInstagramID withProductID:(NSString *)theProductID;
+(void)makeBoughtAnalyticsCallWithOwnerInstagramID:(NSString *)ownerInstagramID withProductInstagramID:(NSString *)productInstagramID withProductID:(NSString *)theProductID;
+(void)makeLikedAnalyticsCallWithOwnerInstagramID:(NSString *)ownerInstagramID withProductInstagramID:(NSString *)productInstagramID withProductID:(NSString *)theProductID;
+(void)makeAnalyticsReportCallWithProductID:(NSString *)theProductID withDelegate:(id)theDelegate;
@end
