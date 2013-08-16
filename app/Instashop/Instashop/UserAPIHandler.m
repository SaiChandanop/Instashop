//
//  UserAPIHandler.m
//  Instashop
//
//  Created by Josh Klobe on 5/22/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "UserAPIHandler.h"
#import "AppDelegate.h"

@implementation UserAPIHandler



+(void)makeBuyerCreateRequestWithDelegate:(id)theDelegate withInstagramUserObject:(InstagramUserObject *)instagramUserObject
{
    NSString *urlRequestString = [NSString stringWithFormat:@"%@/%@", ROOT_URI, @"create_buyer.php"];
    NSMutableURLRequest *URLRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlRequestString]];
    
    
    NSMutableString *postString = [NSMutableString stringWithCapacity:0];
    [postString appendString:[NSString stringWithFormat:@"userID=%@&", instagramUserObject.userID]];
    [postString appendString:[NSString stringWithFormat:@"username=%@", instagramUserObject.username]];
    
    
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
@end
