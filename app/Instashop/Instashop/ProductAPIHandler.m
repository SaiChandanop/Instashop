//
//  ProductAPIHandler.m
//  Instashop
//
//  Created by Josh Klobe on 5/28/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "ProductAPIHandler.h"
#import "InstagramUserObject.h"

@implementation ProductAPIHandler


+(void)getProductWithID:(NSString *)productID withDelegate:(id)delegate
{
    
    NSString *urlRequestString = [NSString stringWithFormat:@"%@/%@%@", ROOT_URI, @"get_products.php?requesting_product_id=", productID];
    
    NSLog(@"urlRequestString urlRequestString: %@", urlRequestString);
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
    NSString *urlRequestString = [NSString stringWithFormat:@"%@/%@", ROOT_URI, @"get_products.php"];
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
    
    NSLog(@"getProductsRequestFinished: %@", newStr);
    NSArray *responseArray = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
    NSLog(@"responseArray: %@", responseArray);

    if (responseArray == nil)
    {
  /*
        NSString* newStr = [[[NSString alloc] initWithData:responseData
                                                  encoding:NSUTF8StringEncoding] autorelease];
     
        NSLog(@"responseString: %@", newStr);
*/        
    }
    else
        [self.delegate feedRequestFinishedWithArrray:responseArray];
 
 
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
    NSLog(@"postString: %@", postString);
    
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
    
    [self.delegate productPurchaceSuccessful];
    NSLog(@"productPurchasedComplete: %@", newStr);
}


@end
