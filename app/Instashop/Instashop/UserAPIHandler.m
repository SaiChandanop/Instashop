//
//  UserAPIHandler.m
//  Instashop
//  APIHandler for creation of shopsy buyers and registration of their push IDS for later use
//  Created by Josh Klobe on 5/22/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "UserAPIHandler.h"
#import "AppDelegate.h"

@implementation UserAPIHandler



+(void)makeBuyerCreateRequestWithDelegate:(id)theDelegate withInstagramUserObject:(InstagramUserObject *)instagramUserObject
{
    NSString *urlRequestString = [NSString stringWithFormat:@"%@/%@", [Utils getRootURI], @"buyer_management.php"];
    NSMutableURLRequest *URLRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlRequestString]];
    
    
    NSMutableString *postString = [NSMutableString stringWithCapacity:0];
    [postString appendString:[NSString stringWithFormat:@"function=%@&", @"create"]];
    [postString appendString:[NSString stringWithFormat:@"&instagram_id=%@", instagramUserObject.userID]];
    [postString appendString:[NSString stringWithFormat:@"&username=%@", instagramUserObject.username]];
    
    
    URLRequest.HTTPMethod = @"POST";
    [URLRequest setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    UserAPIHandler *userAPIHandler = [[UserAPIHandler alloc] init];
    userAPIHandler.delegate = theDelegate;
    userAPIHandler.theWebRequest = [SMWebRequest requestWithURLRequest:URLRequest delegate:userAPIHandler context:NULL];
    [userAPIHandler.theWebRequest addTarget:userAPIHandler action:@selector(buyerCreateRequestFinished:) forRequestEvents:SMWebRequestEventComplete];
    [userAPIHandler.theWebRequest start];
}

-(void)buyerCreateRequestFinished:(id)obj
{
    
}


+(void)updateUserPushIdentityWithPushID:(NSString *)pushID withInstagramID:(NSString *)instagramID
{
    NSString *urlRequestString = [NSString stringWithFormat:@"%@/%@", [Utils getRootURI], @"buyer_management.php"];
    NSMutableURLRequest *URLRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlRequestString]];
    
    
    NSMutableString *postString = [NSMutableString stringWithCapacity:0];
    [postString appendString:[NSString stringWithFormat:@"function=%@&", @"update_push_id"]];
    [postString appendString:[NSString stringWithFormat:@"&instagram_id=%@", instagramID]];
    [postString appendString:[NSString stringWithFormat:@"&push_id=%@", pushID]];
    
    
    URLRequest.HTTPMethod = @"POST";
    [URLRequest setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    UserAPIHandler *userAPIHandler = [[UserAPIHandler alloc] init];
    userAPIHandler.theWebRequest = [SMWebRequest requestWithURLRequest:URLRequest delegate:userAPIHandler context:NULL];
    [userAPIHandler.theWebRequest addTarget:userAPIHandler action:@selector(updateRequestFinished:) forRequestEvents:SMWebRequestEventComplete];
    [userAPIHandler.theWebRequest start];
    
}

-(void)updateRequestFinished:(id)object
{
    
}

@end
