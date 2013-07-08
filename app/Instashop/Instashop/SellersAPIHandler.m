//
//  SellersAPIHandler.m
//  Instashop
//
//  Created by Josh Klobe on 7/8/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "SellersAPIHandler.h"
#import "AppDelegate.h"
#import "InstagramUserObject.h"

@implementation SellersAPIHandler

+(void)makeCreateSellerRequestWithDelegate:(id)theDelegate withInstagramUserObject:(InstagramUserObject *)instagramUserObject withSellerAddressDictionary:(NSDictionary *)addressDictionary
{
    NSString *urlRequestString = [NSString stringWithFormat:@"%@/%@", ROOT_URI, @"create_seller.php"];
    NSMutableURLRequest *URLRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlRequestString]];
    
    
    URLRequest.HTTPMethod = @"POST";
    NSMutableString *thePostString  = [NSMutableString stringWithCapacity:0];
    
    
    [thePostString appendString:[instagramUserObject userObjectAsPostString]];
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (appDelegate.pushDeviceTokenString != nil)
        [thePostString appendString:[NSString stringWithFormat:@"&push_id=%@", appDelegate.pushDeviceTokenString]];
    
    for (id key in addressDictionary)
        [thePostString appendString:[NSString stringWithFormat:@"&%@=%@", key, [addressDictionary objectForKey:key]]];
    
    
    [URLRequest setHTTPBody:[thePostString dataUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"postString: %@", thePostString);
    
    SellersAPIHandler *apiHandler = [[SellersAPIHandler alloc] init];
    apiHandler.delegate = theDelegate;
    apiHandler.theWebRequest = [SMWebRequest requestWithURLRequest:URLRequest delegate:apiHandler context:NULL];
    [apiHandler.theWebRequest addTarget:apiHandler action:@selector(userCreateRequestFinished:) forRequestEvents:SMWebRequestEventComplete];
    [apiHandler.theWebRequest start];
    
}


-(void)userCreateRequestFinished:(id)obj
{
    
    NSString* responseString = [[[NSString alloc] initWithData:responseData
                                                      encoding:NSUTF8StringEncoding] autorelease];
    
    NSLog(@"responseString: %@", responseString);
    
    
    NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
    NSLog(@"responseDictionary: %@", responseDictionary);
    
    [self.delegate userDidCreateSellerWithResponseDictionary:responseDictionary];
    
    
}


+(void)makeGetSellersRequestWithDelegate:(id)theDelegate withSellerInstagramID:(NSString *)sellerInstagramID
{
    NSString *urlRequestString = [NSString stringWithFormat:@"%@/%@%@", ROOT_URI, @"get_sellers.php?seller_instagram_id=", sellerInstagramID];
    NSMutableURLRequest *URLRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlRequestString]];
    
    
    SellersAPIHandler *apiHandler = [[SellersAPIHandler alloc] init];
    apiHandler.delegate = theDelegate;
    apiHandler.theWebRequest = [SMWebRequest requestWithURLRequest:URLRequest delegate:apiHandler context:NULL];
    [apiHandler.theWebRequest addTarget:apiHandler action:@selector(getSellersRequestFinished:) forRequestEvents:SMWebRequestEventComplete];
    [apiHandler.theWebRequest start];
  
}


-(void)getSellersRequestFinished:(id)obj
{
    NSString* responseString = [[[NSString alloc] initWithData:responseData
                                                  encoding:NSUTF8StringEncoding] autorelease];
    
    [self.delegate sellersRequestFinishedWithResponseObject:[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil]];
}
@end
