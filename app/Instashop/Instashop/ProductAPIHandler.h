//
//  ProductAPIHandler.h
//  Instashop
//
//  Created by Josh Klobe on 5/28/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "RootAPIHandler.h"
#import "ProductCreateContainerObject.h"
@interface ProductAPIHandler : RootAPIHandler





+(void)getProductsWithInstagramID:(NSString *)instagramID withDelegate:(id)delegate;
+(void)getProductWithID:(NSString *)productID withDelegate:(id)delegate withInstagramID:(NSString *)instagramID;
+(void)getAllProductsWithDelegate:(id)delegate;

+(void)productPurchasedWithDelegate:(id)delegate withStripeDictionary:(NSDictionary *)stripeDictionary withProductObject:(NSDictionary *)productObject withProductCategoryObjectID:(NSString *)productCategoryObjectID withPostmasterDictionary:(NSDictionary *)postmasterDictionary;
+(void)getLikedProductsByInstagramIDs:(NSArray *)instagramIDs withDelegate:(id)delegate;
+(void)getSavedProductsWithInstagramID:(NSString *)instagramID withDelegate:(id)delegate;

+(void)deleteProductWithProductID:(NSString *)productID;
+(void)editProductCreateObject:(id)delegate withProductCreateObject:(ProductCreateContainerObject *)productCreateContainerObject;
+(void)editProductSizeQuantityWithDelegate:(id)delegate withProductObject:(ProductCreateObject *)theProductCreateObject withProductID:(NSString *)productID;
+(void)makeCheckForExistingProductURLWithDelegate:(id)delegate withProductURL:(NSString *)productURL withDictionary:(NSDictionary *)referenceDictionary;
@end
