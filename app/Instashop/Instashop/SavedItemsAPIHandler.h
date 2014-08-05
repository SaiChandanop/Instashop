//
//  SavedItemsAPIHandler.h
//  Instashop
//
//  Created by Josh Klobe on 11/18/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "RootAPIHandler.h"

@interface SavedItemsAPIHandler : RootAPIHandler

+(void)makeSavedItemRequestWithDelegate:(id)theDelegate withInstagramID:(NSString *)instagramID withProductID:(NSString *)productID;

@end
