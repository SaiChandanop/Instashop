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


+(void)createNewProductWithDelegate:(id)delegate withInstagramDataObject:(NSDictionary *)productDict withTitle:(NSString *) title withQuantity:(NSString *)quantity withModel:(NSString *)model withPrice:(NSString *)price withWeight:(NSString *)weight withDescription:(NSString *)description withProductImageURL:(NSString *)productImageURLString
{
 
    NSString *urlRequestString = [NSString stringWithFormat:@"%@/%@", ROOT_URI, @"product_admin.php"];
    NSMutableURLRequest *URLRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlRequestString]];
    URLRequest.HTTPMethod = @"POST";

    InstagramUserObject *userInstagramObject = [InstagramUserObject getStoredUserObject];
    
    
    NSLog(@"!!createNewProductWithDelegate.title: %@", title);
          
    NSMutableString *postString = [NSMutableString stringWithCapacity:0];
    [postString appendString:[NSString stringWithFormat:@"instagramUserId=%@&", userInstagramObject.userID]];
    [postString appendString:[NSString stringWithFormat:@"instagramProductId=%@&", [productDict objectForKey:@"id"]]];
    [postString appendString:[NSString stringWithFormat:@"object_title=%@&", title]];
    [postString appendString:[NSString stringWithFormat:@"object_quantity=%@&", quantity]];
    [postString appendString:[NSString stringWithFormat:@"object_model=%@&", model]];
    [postString appendString:[NSString stringWithFormat:@"object_price=%@&", price]];
    [postString appendString:[NSString stringWithFormat:@"object_weight=%@&", weight]];
    [postString appendString:[NSString stringWithFormat:@"object_image_urlstring=%@&", productImageURLString]];
    [postString appendString:[NSString stringWithFormat:@"object_description=%@", description]];             
    [URLRequest setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"postString: %@", postString);
    
    ProductAPIHandler *productAPIHandler = [[ProductAPIHandler alloc] init];
    productAPIHandler.delegate = delegate;
    productAPIHandler.theWebRequest = [SMWebRequest requestWithURLRequest:URLRequest delegate:productAPIHandler context:NULL];
    [productAPIHandler.theWebRequest addTarget:productAPIHandler action:@selector(productCreateRequestFinished:) forRequestEvents:SMWebRequestEventComplete];
    [productAPIHandler.theWebRequest start];
    

}


-(void)productCreateRequestFinished:(id)obj
{
    NSString* newStr = [[[NSString alloc] initWithData:responseData
                                              encoding:NSUTF8StringEncoding] autorelease];    
    NSLog(@"newStr: %@", newStr);
}


+(void)getAllProductsWithDelegate:(id)delegate
{
    NSString *urlRequestString = [NSString stringWithFormat:@"%@/%@", ROOT_URI, @"get_products.php"];
    NSMutableURLRequest *URLRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlRequestString]];
    URLRequest.HTTPMethod = @"POST";
    
    
    InstagramUserObject *userInstagramObject = [InstagramUserObject getStoredUserObject];
    
    
    NSMutableString *postString = [NSMutableString stringWithCapacity:0];
    [URLRequest setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"postString: %@", postString);
    
    ProductAPIHandler *productAPIHandler = [[ProductAPIHandler alloc] init];
    productAPIHandler.delegate = delegate;
    productAPIHandler.theWebRequest = [SMWebRequest requestWithURLRequest:URLRequest delegate:productAPIHandler context:NULL];
    [productAPIHandler.theWebRequest addTarget:productAPIHandler action:@selector(getProductsRequestFinished:) forRequestEvents:SMWebRequestEventComplete];
    [productAPIHandler.theWebRequest start];
    

}


-(void)getProductsRequestFinished:(id)obj
{
    NSArray *responseArray = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];

    [self.delegate feedRequestFinishedWithArrray:responseArray];
    
}



@end
