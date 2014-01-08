//
//  ZenCartAuthenticationAPIHandler.m
//  Instashop
//
//  Created by Josh Klobe on 5/27/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "ZenCartAuthenticationAPIHandler.h"

@implementation ZenCartAuthenticationAPIHandler


+(void)makeLoginRequest
{
//    
    NSMutableString *postString = [NSMutableString stringWithCapacity:0];
    [postString appendString:[NSString stringWithFormat:@"admin_name=%@&", @"alchemy50"]];
    [postString appendString:[NSString stringWithFormat:@"admin_pass=%@&", @"2Fpz7qm4"]];
    [postString appendString:[NSString stringWithFormat:@"securityToken=%@&", @"f0d7f02010a83ebd4601a82886e2e5ee"]];
    [postString appendString:[NSString stringWithFormat:@"action=%@", @"dof0d7f02010a83ebd4601a82886e2e5ee"]];

    
    
    NSString *urlRequestString = [NSString stringWithFormat:@"http://www.instashopdev.com.php53-17.ord1-1.websitetestlink.com/zen/zenalchemy50admin/instashop_app_login.php?camefrom=categories.php&zenAdminID=kl8ij3i4bh4mp3pkn6fkpa3qk3"];
    
//    NSString *urlRequestString = [NSString stringWithFormat:@"http://www.instashopdev.com.php53-17.ord1-1.websitetestlink.com/zen/zenalchemy50admin/categories.php"];
    
//.    NSLog(@"urlRequestString: %@", urlRequestString);
    
    NSMutableURLRequest *URLRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlRequestString]];
    URLRequest.HTTPMethod = @"POST";
    [URLRequest setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];

    
    ZenCartAuthenticationAPIHandler *authHandler = [[ZenCartAuthenticationAPIHandler alloc] init];
    authHandler.theWebRequest = [SMWebRequest requestWithURLRequest:URLRequest delegate:authHandler context:NULL];
    [authHandler.theWebRequest addTarget:authHandler action:@selector(loginRequestFinished:) forRequestEvents:SMWebRequestEventComplete];
    [authHandler.theWebRequest start];
    
}


-(void)loginRequestFinished:(id)obj
{

    NSString* newStr = [[NSString alloc] initWithData:self.responseData
                                              encoding:NSUTF8StringEncoding];
    
    NSLog(@"userCreateRequestFinished: %@", newStr);

    
    
}
@end
