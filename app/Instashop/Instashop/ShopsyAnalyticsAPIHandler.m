//
//  ShopsyAnalyticsAPIHandler.m
//  Instashop
//  API Interface to register relevant actions that Shopsy wants to track, such as product viewed, product saved, bought etc.
//  Created by Josh Klobe on 3/24/14.
//  Copyright (c) 2014 Josh Klobe. All rights reserved.
//

#import "ShopsyAnalyticsAPIHandler.h"
#import "AnalyticsReportCompleteProtocol.h"
#import "InstagramUserObject.h"
@implementation ShopsyAnalyticsAPIHandler


+(void)makeViewedAnalyticsCallWithOwnerInstagramID:(NSString *)ownerInstagramID withProductInstagramID:(NSString *)productInstagramID withProductID:(NSString *)theProductID
{
//    NSLog(@"makeViewedAnalyticsCallWithOwnerInstagramID");
    NSString *urlRequestString = [NSString stringWithFormat:@"%@/%@", [Utils getRootURI], @"analytics/analytics.php"];
    NSMutableURLRequest *URLRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlRequestString]];
    URLRequest.HTTPMethod = @"POST";
    
    NSMutableString *postString = [NSMutableString stringWithCapacity:0];
    [postString appendString:[NSString stringWithFormat:@"action=%@", @"viewed"]];
    [postString appendString:[NSString stringWithFormat:@"&owner_instagram_id=%@", ownerInstagramID]];
    [postString appendString:[NSString stringWithFormat:@"&product_instagram_id=%@", productInstagramID]];
    [postString appendString:[NSString stringWithFormat:@"&shopsy_product_id=%@", theProductID]];
    [postString appendString:[NSString stringWithFormat:@"&sender_instagram_id=%@", [InstagramUserObject getStoredUserObject].userID]];
    [URLRequest setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    ShopsyAnalyticsAPIHandler *apiHandler = [[ShopsyAnalyticsAPIHandler alloc] init];
    apiHandler.theWebRequest = [SMWebRequest requestWithURLRequest:URLRequest delegate:apiHandler context:NULL];
    [apiHandler.theWebRequest addTarget:apiHandler action:@selector(makeViewedAnalyticsCallWithInstagramIDComplete:) forRequestEvents:SMWebRequestEventComplete];
    [apiHandler.theWebRequest start];
    
}

-(void)makeViewedAnalyticsCallWithInstagramIDComplete:(id)obj
{
    NSString* newStr = [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding];
//    NSLog(@"makeViewedAnalyticsCallWithInstagramIDComplete: %@", newStr);
}



+(void)makeSavedAnalyticsCallWithOwnerInstagramID:(NSString *)ownerInstagramID withProductInstagramID:(NSString *)productInstagramID withProductID:(NSString *)theProductID
{
    NSString *urlRequestString = [NSString stringWithFormat:@"%@/%@", [Utils getRootURI], @"analytics/analytics.php"];
    NSMutableURLRequest *URLRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlRequestString]];
    URLRequest.HTTPMethod = @"POST";
    
    NSMutableString *postString = [NSMutableString stringWithCapacity:0];
    [postString appendString:[NSString stringWithFormat:@"action=%@", @"saved"]];
    [postString appendString:[NSString stringWithFormat:@"&owner_instagram_id=%@", ownerInstagramID]];
    [postString appendString:[NSString stringWithFormat:@"&product_instagram_id=%@", productInstagramID]];
    [postString appendString:[NSString stringWithFormat:@"&shopsy_product_id=%@", theProductID]];
    [postString appendString:[NSString stringWithFormat:@"&sender_instagram_id=%@", [InstagramUserObject getStoredUserObject].userID]];
    [URLRequest setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    ShopsyAnalyticsAPIHandler *apiHandler = [[ShopsyAnalyticsAPIHandler alloc] init];
    apiHandler.theWebRequest = [SMWebRequest requestWithURLRequest:URLRequest delegate:apiHandler context:NULL];
    [apiHandler.theWebRequest addTarget:apiHandler action:@selector(makeSavedAnalyticsCallWithOwnerInstagramIDComplete:) forRequestEvents:SMWebRequestEventComplete];
    [apiHandler.theWebRequest start];
    
}


-(void)makeSavedAnalyticsCallWithOwnerInstagramIDComplete:(id)obj
{
    NSString* newStr = [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding];
//    NSLog(@"makeSavedAnalyticsCallWithOwnerInstagramIDComplete: %@", newStr);
}


+(void)makeBoughtAnalyticsCallWithOwnerInstagramID:(NSString *)ownerInstagramID withProductInstagramID:(NSString *)productInstagramID withProductID:(NSString *)theProductID
{
    NSString *urlRequestString = [NSString stringWithFormat:@"%@/%@", [Utils getRootURI], @"analytics/analytics.php"];
    NSMutableURLRequest *URLRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlRequestString]];
    URLRequest.HTTPMethod = @"POST";
    
    NSMutableString *postString = [NSMutableString stringWithCapacity:0];
    [postString appendString:[NSString stringWithFormat:@"action=%@", @"bought"]];
    [postString appendString:[NSString stringWithFormat:@"&owner_instagram_id=%@", ownerInstagramID]];
    [postString appendString:[NSString stringWithFormat:@"&product_instagram_id=%@", productInstagramID]];
    [postString appendString:[NSString stringWithFormat:@"&shopsy_product_id=%@", theProductID]];
    [postString appendString:[NSString stringWithFormat:@"&sender_instagram_id=%@", [InstagramUserObject getStoredUserObject].userID]];
    [URLRequest setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    ShopsyAnalyticsAPIHandler *apiHandler = [[ShopsyAnalyticsAPIHandler alloc] init];
    apiHandler.theWebRequest = [SMWebRequest requestWithURLRequest:URLRequest delegate:apiHandler context:NULL];
    [apiHandler.theWebRequest addTarget:apiHandler action:@selector(makeBoughtAnalyticsCallWithOwnerInstagramIDComplete:) forRequestEvents:SMWebRequestEventComplete];
    [apiHandler.theWebRequest start];
    
}

-(void)makeBoughtAnalyticsCallWithOwnerInstagramIDComplete:(id)obj
{
    NSString* newStr = [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding];
 //   NSLog(@"makeBoughtAnalyticsCallWithOwnerInstagramIDComplete: %@", newStr);
}



+(void)makeLikedAnalyticsCallWithOwnerInstagramID:(NSString *)ownerInstagramID withProductInstagramID:(NSString *)productInstagramID withProductID:(NSString *)theProductID withLiked:(BOOL)liked
{
    NSString *urlRequestString = [NSString stringWithFormat:@"%@/%@", [Utils getRootURI], @"analytics/analytics.php"];
    NSMutableURLRequest *URLRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlRequestString]];
    URLRequest.HTTPMethod = @"POST";
    
    
//    NSLog(@"withLiked withLiked withLiked: %d", liked);
    
    
    NSMutableString *postString = [NSMutableString stringWithCapacity:0];
    [postString appendString:[NSString stringWithFormat:@"action=%@", @"liked"]];
    [postString appendString:[NSString stringWithFormat:@"&owner_instagram_id=%@", ownerInstagramID]];
    [postString appendString:[NSString stringWithFormat:@"&product_instagram_id=%@", productInstagramID]];
    [postString appendString:[NSString stringWithFormat:@"&shopsy_product_id=%@", theProductID]];
    [postString appendString:[NSString stringWithFormat:@"&sender_instagram_id=%@", [InstagramUserObject getStoredUserObject].userID]];
    [postString appendString:[NSString stringWithFormat:@"&liked=%@", [NSString stringWithFormat:@"%d", liked]]];
    [URLRequest setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    ShopsyAnalyticsAPIHandler *apiHandler = [[ShopsyAnalyticsAPIHandler alloc] init];
    apiHandler.theWebRequest = [SMWebRequest requestWithURLRequest:URLRequest delegate:apiHandler context:NULL];
    [apiHandler.theWebRequest addTarget:apiHandler action:@selector(makeLikedAnalyticsCallWithOwnerInstagramIDComplete:) forRequestEvents:SMWebRequestEventComplete];
    [apiHandler.theWebRequest start];
    
}

-(void)makeLikedAnalyticsCallWithOwnerInstagramIDComplete:(id)obj
{
    NSString* newStr = [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding];
//    NSLog(@"makeLikedAnalyticsCallWithOwnerInstagramIDComplete: %@", newStr);
}





+(void)makeAnalyticsReportCallWithProductID:(NSString *)theProductID withDelegate:(id)theDelegate
{
    NSString *urlRequestString = [NSString stringWithFormat:@"%@/%@", [Utils getRootURI], @"analytics/analytics.php"];
    NSMutableURLRequest *URLRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlRequestString]];
    URLRequest.HTTPMethod = @"POST";
    
    NSMutableString *postString = [NSMutableString stringWithCapacity:0];
    [postString appendString:[NSString stringWithFormat:@"action=%@", @"report"]];
    [postString appendString:[NSString stringWithFormat:@"&shopsy_product_id=%@", theProductID]];
    [URLRequest setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    ShopsyAnalyticsAPIHandler *apiHandler = [[ShopsyAnalyticsAPIHandler alloc] init];
    apiHandler.delegate = theDelegate;
    apiHandler.theWebRequest = [SMWebRequest requestWithURLRequest:URLRequest delegate:apiHandler context:NULL];
    [apiHandler.theWebRequest addTarget:apiHandler action:@selector(makeAnalyticsReportCallWithProductIDComplete:) forRequestEvents:SMWebRequestEventComplete];
    [apiHandler.theWebRequest start];
    
}

-(void)makeAnalyticsReportCallWithProductIDComplete:(id)obj
{
    NSString* newStr = [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding];
//    NSLog(@"makeAnalyticsReportCallWithProductIDComplete: %@", newStr);
    
    NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
//    NSLog(@"makeAnalyticsReportCallWithProductIDComplete, dict: %@", responseDictionary);
    
    if ([self.delegate conformsToProtocol:@protocol(AnalyticsReportCompleteProtocol)])
        [(id<AnalyticsReportCompleteProtocol>)self.delegate reportDidCompleteWithDictionary:responseDictionary];
    
    
}



@end
