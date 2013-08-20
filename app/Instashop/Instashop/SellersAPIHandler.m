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
#import "SellerExistsResponderProtocol.h"
#import "CreateSellerOccuredProtocol.h"
#import "SellersRequestFinishedProtocol.h"


@implementation SellersAPIHandler

+(void)makeCheckIfSellerExistsCallWithDelegate:(id)delegate
{
    NSString *urlRequestString = [NSString stringWithFormat:@"%@/%@", ROOT_URI, @"sellerfunctions/create_seller.php?action=checkSeller"];
    NSMutableURLRequest *URLRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlRequestString]];
    
    
    URLRequest.HTTPMethod = @"POST";
    NSMutableString *thePostString  = [NSMutableString stringWithCapacity:0];    
    [thePostString appendString:[NSString stringWithFormat:@"userID=%@", [InstagramUserObject getStoredUserObject].userID]];
    [thePostString appendString:[NSString stringWithFormat:@"&action=%@", @"checkSeller"]];
    [URLRequest setHTTPBody:[thePostString dataUsingEncoding:NSUTF8StringEncoding]];
    
    SellersAPIHandler *apiHandler = [[SellersAPIHandler alloc] init];
    apiHandler.delegate = delegate;
    apiHandler.theWebRequest = [SMWebRequest requestWithURLRequest:URLRequest delegate:apiHandler context:NULL];
    [apiHandler.theWebRequest addTarget:apiHandler action:@selector(checkSellerExistsCallFinished:) forRequestEvents:SMWebRequestEventComplete];
    [apiHandler.theWebRequest start];
    
}

-(void)checkSellerExistsCallFinished:(id)obj
{
    NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];

    if ([responseDictionary objectForKey:@"zencart_id"] != nil)
    {
        InstagramUserObject *theUserObject =[InstagramUserObject getStoredUserObject];
        theUserObject.zencartID = [responseDictionary objectForKey:@"zencart_id"];
    
        [[InstagramUserObject getStoredUserObject] setAsStoredUser:theUserObject];
    }
    
    
    if ([self.delegate conformsToProtocol:@protocol(SellerExistsResponderProtocol)])
        [(id<SellerExistsResponderProtocol>)self.delegate sellerExistsCallReturned];

    
}


+(void)makeCreateSellerRequestWithDelegate:(id)theDelegate withInstagramUserObject:(InstagramUserObject *)instagramUserObject withSellerAddressDictionary:(NSDictionary *)addressDictionary
{
    NSString *urlRequestString = [NSString stringWithFormat:@"%@/%@", ROOT_URI, @"sellerfunctions/create_seller.php"];
    NSMutableURLRequest *URLRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlRequestString]];
    
    
    URLRequest.HTTPMethod = @"POST";
    NSMutableString *thePostString  = [NSMutableString stringWithCapacity:0];
    
    
    [thePostString appendString:[instagramUserObject userObjectAsPostString]];
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (appDelegate.pushDeviceTokenString != nil)
        [thePostString appendString:[NSString stringWithFormat:@"&push_id=%@", appDelegate.pushDeviceTokenString]];
    
    for (id key in addressDictionary)
        [thePostString appendString:[NSString stringWithFormat:@"&%@=%@", key, [addressDictionary objectForKey:key]]];
    
    [thePostString appendString:[NSString stringWithFormat:@"&%@=%@", @"instagram_username", instagramUserObject.username]];
    
    
    [URLRequest setHTTPBody:[thePostString dataUsingEncoding:NSUTF8StringEncoding]];
    
    SellersAPIHandler *apiHandler = [[SellersAPIHandler alloc] init];
    apiHandler.delegate = theDelegate;
    apiHandler.theWebRequest = [SMWebRequest requestWithURLRequest:URLRequest delegate:apiHandler context:NULL];
    [apiHandler.theWebRequest addTarget:apiHandler action:@selector(userCreateRequestFinished:) forRequestEvents:SMWebRequestEventComplete];
    [apiHandler.theWebRequest start];
    
}


-(void)userCreateRequestFinished:(id)obj
{
    
//    NSString* responseString = [[[NSString alloc] initWithData:responseData
  //                                                    encoding:NSUTF8StringEncoding] autorelease];

//    NSLog(@"userCreateRequestFinished: %@", responseString);
    
    NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
    
    if ([self.delegate conformsToProtocol:@protocol(CreateSellerOccuredProtocol)])
        [(id<CreateSellerOccuredProtocol>)self.delegate userDidCreateSellerWithResponseDictionary:responseDictionary];

}


+(void)makeGetSellersRequestWithDelegate:(id)theDelegate withSellerInstagramID:(NSString *)sellerInstagramID
{
    NSString *urlRequestString = [NSString stringWithFormat:@"%@/%@%@", ROOT_URI, @"sellerfunctions/get_sellers.php?seller_instagram_id=", sellerInstagramID];
    NSMutableURLRequest *URLRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlRequestString]];
    
    
    SellersAPIHandler *apiHandler = [[SellersAPIHandler alloc] init];
    apiHandler.delegate = theDelegate;
    apiHandler.theWebRequest = [SMWebRequest requestWithURLRequest:URLRequest delegate:apiHandler context:NULL];
    [apiHandler.theWebRequest addTarget:apiHandler action:@selector(getSellersRequestFinished:) forRequestEvents:SMWebRequestEventComplete];
    [apiHandler.theWebRequest start];
  
}


-(void)getSellersRequestFinished:(id)obj
{
//    NSString* responseString = [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease];
    
    if ([self.delegate conformsToProtocol:@protocol(SellersRequestFinishedProtocol)])
        [(id<SellersRequestFinishedProtocol>)self.delegate sellersRequestFinishedWithResponseObject:[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil]];
    
}
@end
