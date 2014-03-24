//
//  ShopsyAnalyticsAPIHandler.m
//  Instashop
//
//  Created by Josh Klobe on 3/24/14.
//  Copyright (c) 2014 Josh Klobe. All rights reserved.
//

#import "ShopsyAnalyticsAPIHandler.h"

@implementation ShopsyAnalyticsAPIHandler


+(void)makeViewedAnalyticsCallWithOwnerInstagramID:(NSString *)ownerInstagramID withProductInstagramID:(NSString *)productInstagramID withProductID:(NSString *)theProductID
{
    NSString *urlRequestString = [NSString stringWithFormat:@"%@/%@", ROOT_URI, @"analytics/analytics.php"];
    NSMutableURLRequest *URLRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlRequestString]];
    URLRequest.HTTPMethod = @"POST";
    
    NSMutableString *postString = [NSMutableString stringWithCapacity:0];
    [postString appendString:[NSString stringWithFormat:@"action=%@", @"viewed"]];
    [postString appendString:[NSString stringWithFormat:@"&owner_instagram_id=%@", ownerInstagramID]];
    [postString appendString:[NSString stringWithFormat:@"&product_instagram_id=%@", productInstagramID]];
    [postString appendString:[NSString stringWithFormat:@"&shopsy_product_id=%@", theProductID]];
    [URLRequest setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    ShopsyAnalyticsAPIHandler *apiHandler = [[ShopsyAnalyticsAPIHandler alloc] init];
    apiHandler.theWebRequest = [SMWebRequest requestWithURLRequest:URLRequest delegate:apiHandler context:NULL];
    [apiHandler.theWebRequest addTarget:apiHandler action:@selector(makeViewedAnalyticsCallWithInstagramIDComplete:) forRequestEvents:SMWebRequestEventComplete];
    [apiHandler.theWebRequest start];
    
}

-(void)makeViewedAnalyticsCallWithInstagramIDComplete:(id)obj
{
    NSString* newStr = [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding];
    NSLog(@"makeViewedAnalyticsCallWithInstagramIDComplete: %@", newStr);
}



+(void)makeSavedAnalyticsCallWithOwnerInstagramID:(NSString *)ownerInstagramID withProductInstagramID:(NSString *)productInstagramID withProductID:(NSString *)theProductID
{
    NSString *urlRequestString = [NSString stringWithFormat:@"%@/%@", ROOT_URI, @"analytics/analytics.php"];
    NSMutableURLRequest *URLRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlRequestString]];
    URLRequest.HTTPMethod = @"POST";
    
    NSMutableString *postString = [NSMutableString stringWithCapacity:0];
    [postString appendString:[NSString stringWithFormat:@"action=%@", @"saved"]];
    [postString appendString:[NSString stringWithFormat:@"&owner_instagram_id=%@", ownerInstagramID]];
    [postString appendString:[NSString stringWithFormat:@"&product_instagram_id=%@", productInstagramID]];
    [postString appendString:[NSString stringWithFormat:@"&shopsy_product_id=%@", theProductID]];
    [URLRequest setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    ShopsyAnalyticsAPIHandler *apiHandler = [[ShopsyAnalyticsAPIHandler alloc] init];
    apiHandler.theWebRequest = [SMWebRequest requestWithURLRequest:URLRequest delegate:apiHandler context:NULL];
    [apiHandler.theWebRequest addTarget:apiHandler action:@selector(makeSavedAnalyticsCallWithOwnerInstagramIDComplete:) forRequestEvents:SMWebRequestEventComplete];
    [apiHandler.theWebRequest start];
    
}


-(void)makeSavedAnalyticsCallWithOwnerInstagramIDComplete:(id)obj
{
    NSString* newStr = [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding];
    NSLog(@"makeSavedAnalyticsCallWithOwnerInstagramIDComplete: %@", newStr);
}


+(void)makeBoughtAnalyticsCallWithOwnerInstagramID:(NSString *)ownerInstagramID withProductInstagramID:(NSString *)productInstagramID withProductID:(NSString *)theProductID
{
    NSString *urlRequestString = [NSString stringWithFormat:@"%@/%@", ROOT_URI, @"analytics/analytics.php"];
    NSMutableURLRequest *URLRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlRequestString]];
    URLRequest.HTTPMethod = @"POST";
    
    NSMutableString *postString = [NSMutableString stringWithCapacity:0];
    [postString appendString:[NSString stringWithFormat:@"action=%@", @"bought"]];
    [postString appendString:[NSString stringWithFormat:@"&owner_instagram_id=%@", ownerInstagramID]];
    [postString appendString:[NSString stringWithFormat:@"&product_instagram_id=%@", productInstagramID]];
    [postString appendString:[NSString stringWithFormat:@"&shopsy_product_id=%@", theProductID]];
    [URLRequest setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    ShopsyAnalyticsAPIHandler *apiHandler = [[ShopsyAnalyticsAPIHandler alloc] init];
    apiHandler.theWebRequest = [SMWebRequest requestWithURLRequest:URLRequest delegate:apiHandler context:NULL];
    [apiHandler.theWebRequest addTarget:apiHandler action:@selector(makeBoughtAnalyticsCallWithOwnerInstagramIDComplete:) forRequestEvents:SMWebRequestEventComplete];
    [apiHandler.theWebRequest start];
    
}



-(void)makeBoughtAnalyticsCallWithOwnerInstagramIDComplete:(id)obj
{
    NSString* newStr = [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding];
    NSLog(@"makeBoughtAnalyticsCallWithOwnerInstagramIDComplete: %@", newStr);
}






+(void)makeLikedAnalyticsCallWithOwnerInstagramID:(NSString *)ownerInstagramID withProductInstagramID:(NSString *)productInstagramID withProductID:(NSString *)theProductID
{
    NSString *urlRequestString = [NSString stringWithFormat:@"%@/%@", ROOT_URI, @"analytics/analytics.php"];
    NSMutableURLRequest *URLRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlRequestString]];
    URLRequest.HTTPMethod = @"POST";
    
    NSMutableString *postString = [NSMutableString stringWithCapacity:0];
    [postString appendString:[NSString stringWithFormat:@"action=%@", @"liked"]];
    [postString appendString:[NSString stringWithFormat:@"&owner_instagram_id=%@", ownerInstagramID]];
    [postString appendString:[NSString stringWithFormat:@"&product_instagram_id=%@", productInstagramID]];
    [postString appendString:[NSString stringWithFormat:@"&shopsy_product_id=%@", theProductID]];
    [URLRequest setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    ShopsyAnalyticsAPIHandler *apiHandler = [[ShopsyAnalyticsAPIHandler alloc] init];
    apiHandler.theWebRequest = [SMWebRequest requestWithURLRequest:URLRequest delegate:apiHandler context:NULL];
    [apiHandler.theWebRequest addTarget:apiHandler action:@selector(makeLikedAnalyticsCallWithOwnerInstagramIDComplete:) forRequestEvents:SMWebRequestEventComplete];
    [apiHandler.theWebRequest start];
    
}

-(void)makeLikedAnalyticsCallWithOwnerInstagramIDComplete:(id)obj
{
    NSString* newStr = [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding];
    NSLog(@"makeLikedAnalyticsCallWithOwnerInstagramIDComplete: %@", newStr);
}




@end
