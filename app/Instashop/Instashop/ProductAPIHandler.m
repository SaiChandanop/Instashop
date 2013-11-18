//
//  ProductAPIHandler.m
//  Instashop
//
//  Created by Josh Klobe on 5/28/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "ProductAPIHandler.h"
#import "InstagramUserObject.h"
#import "FeedRequestFinishedProtocol.h"
#import "ProductPurchaseCompleteProtocol.h"
#import "EditProductCompleteProtocol.h"

@implementation ProductAPIHandler

+(void)getLikedProductsByInstagramIDs:(NSArray *)instagramIDs withDelegate:(id)delegate
{
    NSMutableString *likedIDsString = [NSMutableString stringWithCapacity:0];
    
    for (int i = 0; i < [instagramIDs count]; i++)
    {
        [likedIDsString appendString:[instagramIDs objectAtIndex:i]];
        if (i != [instagramIDs count] -1)
            [likedIDsString appendString:@"___"];
        
    }
    likedIDsString = [likedIDsString stringByReplacingOccurrencesOfString:@"null" withString:@""];
    NSString *urlRequestString = [NSString stringWithFormat:@"%@/%@%@", ROOT_URI, @"get_products.php?liked_ids=", likedIDsString];
    
    NSLog(@"urlRequestString: %@", urlRequestString);
    
    
    NSMutableURLRequest *URLRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlRequestString]];
    URLRequest.HTTPMethod = @"GET";
    
    
    ProductAPIHandler *productAPIHandler = [[ProductAPIHandler alloc] init];
    productAPIHandler.delegate = delegate;
    productAPIHandler.theWebRequest = [SMWebRequest requestWithURLRequest:URLRequest delegate:productAPIHandler context:NULL];
    [productAPIHandler.theWebRequest addTarget:productAPIHandler action:@selector(getProductsRequestFinished:) forRequestEvents:SMWebRequestEventComplete];
    [productAPIHandler.theWebRequest start];

    
}

+(void)getSavedProductsWithInstagramID:(NSString *)instagramID withDelegate:(id)delegate
{
    NSString *urlRequestString = [NSString stringWithFormat:@"%@/%@%@", ROOT_URI, @"get_products.php?saved_user_id=", instagramID];
    
    NSLog(@"urlRequestString: %@", urlRequestString);
    
    
    NSMutableURLRequest *URLRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlRequestString]];
    URLRequest.HTTPMethod = @"GET";
    
    
    ProductAPIHandler *productAPIHandler = [[ProductAPIHandler alloc] init];
    productAPIHandler.delegate = delegate;
    productAPIHandler.theWebRequest = [SMWebRequest requestWithURLRequest:URLRequest delegate:productAPIHandler context:NULL];
    [productAPIHandler.theWebRequest addTarget:productAPIHandler action:@selector(getProductsRequestFinished:) forRequestEvents:SMWebRequestEventComplete];
    [productAPIHandler.theWebRequest start];

}

+(void)getProductsWithInstagramID:(NSString *)instagramID withDelegate:(id)delegate
{
    NSString *urlRequestString = [NSString stringWithFormat:@"%@/%@%@", ROOT_URI, @"get_products.php?requesting_seller_id=", instagramID];
    
//    NSLog(@"urlRequestString: %@", urlRequestString);
    
    
    NSMutableURLRequest *URLRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlRequestString]];
    URLRequest.HTTPMethod = @"GET";
    
    
    ProductAPIHandler *productAPIHandler = [[ProductAPIHandler alloc] init];
    productAPIHandler.delegate = delegate;
    productAPIHandler.theWebRequest = [SMWebRequest requestWithURLRequest:URLRequest delegate:productAPIHandler context:NULL];
    [productAPIHandler.theWebRequest addTarget:productAPIHandler action:@selector(getProductsRequestFinished:) forRequestEvents:SMWebRequestEventComplete];
    [productAPIHandler.theWebRequest start];

    
}

+(void)getProductWithID:(NSString *)productID withDelegate:(id)delegate withInstagramID:(NSString *)instagramID
{
    
    NSString *urlRequestString = [NSString stringWithFormat:@"%@/%@", ROOT_URI, [NSString stringWithFormat:@"get_products.php?requesting_product_id=%@&instagram_id=%@", productID, instagramID]];
    
    NSLog(@"urlRequestString: %@", urlRequestString);
    NSMutableURLRequest *URLRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlRequestString]];
    URLRequest.HTTPMethod = @"GET";
    
    
    ProductAPIHandler *productAPIHandler = [[ProductAPIHandler alloc] init];
    productAPIHandler.delegate = delegate;
    productAPIHandler.theWebRequest = [SMWebRequest requestWithURLRequest:URLRequest delegate:productAPIHandler context:NULL];
    [productAPIHandler.theWebRequest addTarget:productAPIHandler action:@selector(getProductsRequestFinished:) forRequestEvents:SMWebRequestEventComplete];
    [productAPIHandler.theWebRequest start];

}
+(void)getAllProductsWithDelegate:(id)delegate
{
    NSString *urlRequestString = [NSString stringWithFormat:@"%@/%@", ROOT_URI, @"get_products.php?requesting_seller_id=ALL"];
    NSLog(@"urlRequestStringurlRequestString: %@", urlRequestString);
    NSMutableURLRequest *URLRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlRequestString]];
    URLRequest.HTTPMethod = @"GET";
        
    
    ProductAPIHandler *productAPIHandler = [[ProductAPIHandler alloc] init];
    productAPIHandler.delegate = delegate;
    productAPIHandler.theWebRequest = [SMWebRequest requestWithURLRequest:URLRequest delegate:productAPIHandler context:NULL];
    [productAPIHandler.theWebRequest addTarget:productAPIHandler action:@selector(getProductsRequestFinished:) forRequestEvents:SMWebRequestEventComplete];
    [productAPIHandler.theWebRequest start];
    

}


-(void)getProductsRequestFinished:(id)obj
{
    
    NSString* newStr = [[[NSString alloc] initWithData:responseData
                                              encoding:NSUTF8StringEncoding] autorelease];
    
    
    NSArray *responseArray = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
//    NSLog(@"responseArray: %@", responseArray);

    if (responseArray == nil)
    {
  /*
        NSString* newStr = [[[NSString alloc] initWithData:responseData
                                                  encoding:NSUTF8StringEncoding] autorelease];
     
        NSLog(@"responseString: %@", newStr);
*/        
    }
    else if ([self.delegate conformsToProtocol:@protocol(FeedRequestFinishedProtocol)])
        [(id<FeedRequestFinishedProtocol>)self.delegate feedRequestFinishedWithArrray:responseArray];

        

 
    
 
}


+(void)productPurchasedWithDelegate:(id)delegate withStripeDictionary:(NSDictionary *)stripeDictionary withProductObject:(NSDictionary *)productObject withProductCategoryObjectID:(NSString *)productCategoryObjectID withPostmasterDictionary:(NSDictionary *)postmasterDictionary
{
    NSString *urlRequestString = [NSString stringWithFormat:@"%@/%@", ROOT_URI, @"buy_product.php"];
    NSMutableURLRequest *URLRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlRequestString]];
    URLRequest.HTTPMethod = @"POST";

    InstagramUserObject *userInstagramObject = [InstagramUserObject getStoredUserObject];
    
    
    NSMutableString *postString = [NSMutableString stringWithCapacity:0];
    
    [postString appendString:[NSString stringWithFormat:@"product_category_id=%@&", productCategoryObjectID]];
    [postString appendString:[NSString stringWithFormat:@"products_id=%@&", [productObject objectForKey:@"products_id"]]];
    [postString appendString:[NSString stringWithFormat:@"products_name=%@&", [productObject objectForKey:@"products_name"]]];
    [postString appendString:[NSString stringWithFormat:@"products_price=%@&", [productObject objectForKey:@"products_price"]]];
    [postString appendString:[NSString stringWithFormat:@"products_quantity=%@&", @"1"]];
    [postString appendString:[NSString stringWithFormat:@"purchaser_id=%@&", userInstagramObject.userID]];
    [postString appendString:[NSString stringWithFormat:@"purchaser_username=%@&", userInstagramObject.username]];

    for (id key in postmasterDictionary)
        [postString appendString:[NSString stringWithFormat:@"&%@=%@", key, [postmasterDictionary objectForKey:key]]];
    
    [URLRequest setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    ProductAPIHandler *productAPIHandler = [[ProductAPIHandler alloc] init];
    productAPIHandler.delegate = delegate;
    productAPIHandler.theWebRequest = [SMWebRequest requestWithURLRequest:URLRequest delegate:productAPIHandler context:NULL];
    [productAPIHandler.theWebRequest addTarget:productAPIHandler action:@selector(productPurchasedComplete:) forRequestEvents:SMWebRequestEventComplete];
    [productAPIHandler.theWebRequest start];

    
}

-(void)productPurchasedComplete:(id)obj
{
    NSString* newStr = [[[NSString alloc] initWithData:responseData
                                              encoding:NSUTF8StringEncoding] autorelease];
        
    
    if ([self.delegate conformsToProtocol:@protocol(ProductPurchaseCompleteProtocol)])
        [(id<ProductPurchaseCompleteProtocol>)self.delegate productPurchaceSuccessful];
    

    NSLog(@"productPurchasedComplete: %@", newStr);
}


+(void)deleteProductWithProductID:(NSString *)productID
{
    NSString *urlRequestString = [NSString stringWithFormat:@"%@/%@", ROOT_URI, @"product_functions/productManager.php"];
    NSMutableURLRequest *URLRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlRequestString]];
    URLRequest.HTTPMethod = @"POST";

    
    NSMutableString *postString = [NSMutableString stringWithCapacity:0];
    [postString appendString:[NSString stringWithFormat:@"action=%@&", @"delete"]];
    [postString appendString:[NSString stringWithFormat:@"&product_id=%@&", productID]];
    
    
    [URLRequest setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    ProductAPIHandler *productAPIHandler = [[ProductAPIHandler alloc] init];
    productAPIHandler.theWebRequest = [SMWebRequest requestWithURLRequest:URLRequest delegate:productAPIHandler context:NULL];
    [productAPIHandler.theWebRequest addTarget:productAPIHandler action:@selector(productDeleteComplete:) forRequestEvents:SMWebRequestEventComplete];
    [productAPIHandler.theWebRequest start];
    
}


-(void)productDeleteComplete:(id)obj
{
    NSString* newStr = [[[NSString alloc] initWithData:self.responseData
                                              encoding:NSUTF8StringEncoding] autorelease];
 
    NSLog(@"productDeleteComplete: %@", newStr);
    
}


+(void)editProductCreateObject:(id)delegate withProductCreateObject:(ProductCreateContainerObject *)productCreateContainerObject
{
    ProductCreateObject *theProductCreateObject = productCreateContainerObject.mainObject;
    
    NSString *urlRequestString = [NSString stringWithFormat:@"%@/%@", ROOT_URI, @"product_functions/productManager.php"];
    NSMutableURLRequest *URLRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlRequestString]];
    URLRequest.HTTPMethod = @"POST";
    
    InstagramUserObject *userInstagramObject = [InstagramUserObject getStoredUserObject];
    
    
    NSMutableString *postString = [NSMutableString stringWithCapacity:0];
    [postString appendString:@"action=edit&"];
    [postString appendString:[NSString stringWithFormat:@"instagramUserId=%@&", userInstagramObject.userID]];
    [postString appendString:[NSString stringWithFormat:@"object_instagram_id=%@&", [theProductCreateObject.instragramMediaInfoDictionary objectForKey:@"id"]]];
    [postString appendString:[NSString stringWithFormat:@"object_title=%@&", theProductCreateObject.title]];
    [postString appendString:[NSString stringWithFormat:@"object_description=%@&", theProductCreateObject.description]];
    [postString appendString:[NSString stringWithFormat:@"object_quantity=%@&", theProductCreateObject.quantity]];
    [postString appendString:[NSString stringWithFormat:@"object_price=%@&", [theProductCreateObject.retailPrice stringByReplacingOccurrencesOfString:@"$" withString:@""]]];
    [postString appendString:[NSString stringWithFormat:@"object_list_price=%@&", [theProductCreateObject.listPrice stringByReplacingOccurrencesOfString:@"$" withString:@""]]];
    [postString appendString:[NSString stringWithFormat:@"object_weight=%@&", theProductCreateObject.shippingWeight]];
    [postString appendString:[NSString stringWithFormat:@"object_image_urlstring=%@&", theProductCreateObject.instagramPictureURLString]];
    [postString appendString:[NSString stringWithFormat:@"edit_product_id=%@&", theProductCreateObject.editingReferenceID]];
    
    
    
    
    [URLRequest setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    ProductAPIHandler *productAPIHandler = [[ProductAPIHandler alloc] init];
    productAPIHandler.contextObject = productCreateContainerObject;
    productAPIHandler.delegate = delegate;
    productAPIHandler.theWebRequest = [SMWebRequest requestWithURLRequest:URLRequest delegate:productAPIHandler context:NULL];
    [productAPIHandler.theWebRequest addTarget:productAPIHandler action:@selector(editContainerFinished:) forRequestEvents:SMWebRequestEventComplete];
    [productAPIHandler.theWebRequest start];
    
}



-(void)editContainerFinished:(id)someObject
{
    NSString* newStr = [[[NSString alloc] initWithData:responseData
                                              encoding:NSUTF8StringEncoding] autorelease];
    
    NSLog(@"productContainerCreateFinished: %@", newStr);
    
    ProductCreateContainerObject *productCreateContainerObject = self.contextObject;
    
    NSMutableArray *ar = [NSMutableArray arrayWithArray:productCreateContainerObject.objectSizePermutationsArray];
    
    for (int i = 0; i < [ar count]; i++)
    {
        
        NSLog(@"-------------------------------------------------------!: %d", i);
        ProductCreateObject *obj = [ar objectAtIndex:i];
        [ProductAPIHandler editProductSizeQuantityWithDelegate:self.delegate withProductObject:obj withProductID:productCreateContainerObject.mainObject.editingReferenceID];
    }
    
    if ([self.delegate conformsToProtocol:@protocol(EditProductCompleteProtocol)])
        [(id<EditProductCompleteProtocol>)self.delegate editProductComplete];

    
}



+(void)editProductSizeQuantityWithDelegate:(id)delegate withProductObject:(ProductCreateObject *)theProductCreateObject withProductID:(NSString *)productID
{
    NSString *urlRequestString = [NSString stringWithFormat:@"%@/%@", ROOT_URI, @"product_functions/productManager.php"];
    NSMutableURLRequest *URLRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlRequestString]];
    URLRequest.HTTPMethod = @"POST";
    
    InstagramUserObject *userInstagramObject = [InstagramUserObject getStoredUserObject];
    
    
    NSMutableString *categoriesString = [NSMutableString stringWithCapacity:0];
    
    for (int i = 0; i < [theProductCreateObject.categoriesArray count]; i++)
    {
        [categoriesString appendString:[theProductCreateObject.categoriesArray objectAtIndex:i]];
        if (i != [theProductCreateObject.categoriesArray count] - 1)
            [categoriesString appendString:@"|"];
    }
    
    NSMutableString *postString = [NSMutableString stringWithCapacity:0];
    [postString appendString:@"action=edit_size_quantity_object&"];
    [postString appendString:[NSString stringWithFormat:@"zencart_product_id=%@&", productID]];
    [postString appendString:[NSString stringWithFormat:@"instagramUserId=%@&", userInstagramObject.userID]];
    [postString appendString:[NSString stringWithFormat:@"instagramProductId=%@&", [theProductCreateObject.instragramMediaInfoDictionary objectForKey:@"id"]]];
    [postString appendString:[NSString stringWithFormat:@"object_quantity=%@&", theProductCreateObject.quantity]];
    [postString appendString:[NSString stringWithFormat:@"object_size=%@&", theProductCreateObject.size]];
    [postString appendString:[NSString stringWithFormat:@"categories=%@&", categoriesString]];
    
    /*    [postString appendString:[NSString stringWithFormat:@"&object_attribute_one=%@", [attributesArray objectAtIndex:0]]];
     [postString appendString:[NSString stringWithFormat:@"&object_attribute_two=%@", [attributesArray objectAtIndex:1]]];
     [postString appendString:[NSString stringWithFormat:@"&object_attribute_three=%@", [attributesArray objectAtIndex:2]]];
     */
    
    [URLRequest setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"createProductSizeQuantityObjects postString: %@", postString);
    
    ProductAPIHandler *productAPIHandler = [[ProductAPIHandler alloc] init];
    productAPIHandler.delegate = delegate;
    productAPIHandler.theWebRequest = [SMWebRequest requestWithURLRequest:URLRequest delegate:productAPIHandler context:NULL];
    [productAPIHandler.theWebRequest addTarget:productAPIHandler action:@selector(editSizeQuantityFinished:) forRequestEvents:SMWebRequestEventComplete];
    [productAPIHandler.theWebRequest start];
}


-(void)editSizeQuantityFinished:(id)object
{
//    NSString* newStr = [[[NSString alloc] initWithData:responseData
  //                                            encoding:NSUTF8StringEncoding] autorelease];
    NSLog(@"editSizeQuantityFinished: %@", self.delegate);
    
    
    
}


+(void)makeCheckForExistingProductURLWithDelegate:(id)delegate withProductURL:(NSString *)productURL
{
    NSString *urlRequestString = [NSString stringWithFormat:@"%@/%@%@", ROOT_URI, @"get_products.php?check_for_existing_product_url=", [productURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSLog(@"urlRequestString: %@", urlRequestString);
    
    
    NSMutableURLRequest *URLRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlRequestString]];
    URLRequest.HTTPMethod = @"GET";
    
    
    ProductAPIHandler *productAPIHandler = [[ProductAPIHandler alloc] init];
    productAPIHandler.delegate = delegate;
    productAPIHandler.theWebRequest = [SMWebRequest requestWithURLRequest:URLRequest delegate:productAPIHandler context:NULL];
    [productAPIHandler.theWebRequest addTarget:productAPIHandler action:@selector(makeCheckForExistingProductURLFinished:) forRequestEvents:SMWebRequestEventComplete];
    [productAPIHandler.theWebRequest start];
}

-(void)makeCheckForExistingProductURLFinished:(id)object
{
    NSString* newStr = [[[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding] autorelease];
    
    NSLog(@"makeCheckForExistingProductURLFinished: %@", newStr);
    
    [self.delegate checkFinishedWithBoolValue:[newStr boolValue]];
    
}



@end
