//
//  ProductAPIHandler.h
//  Instashop
//
//  Created by Josh Klobe on 5/28/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "RootAPIHandler.h"

@interface ProductAPIHandler : RootAPIHandler






+(void)getProductWithID:(NSString *)productID withDelegate:(id)delegate;
+(void)getAllProductsWithDelegate:(id)delegate;

+(void)productPurchasedWithDelegate:(id)delegate withStripeDictionary:(NSDictionary *)stripeDictionary withProductObject:(NSDictionary *)productObject withPostmasterDictionary:(NSDictionary *)postmasterDictionary;

@end
