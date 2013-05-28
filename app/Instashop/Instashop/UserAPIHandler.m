//
//  UserAPIHandler.m
//  Instashop
//
//  Created by Josh Klobe on 5/22/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "UserAPIHandler.h"

@implementation UserAPIHandler

+(void)makeUserCreateSellerRequestWithDelegate:(id)theDelegate withInstagramUserObject:(InstagramUserObject *)instagramUserObject
{
    NSString *urlRequestString = [NSString stringWithFormat:@"%@/%@", ROOT_URI, @"user_admin/seller_admin.php"];
    NSMutableURLRequest *URLRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlRequestString]];
    URLRequest.HTTPMethod = @"POST";
    NSString *postString = [instagramUserObject userObjectAsPostString];
    [URLRequest setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"postString: %@", postString);
    
    UserAPIHandler *userAPIHandler = [[UserAPIHandler alloc] init];
    userAPIHandler.delegate = theDelegate;
    userAPIHandler.theWebRequest = [SMWebRequest requestWithURLRequest:URLRequest delegate:userAPIHandler context:NULL];
    [userAPIHandler.theWebRequest addTarget:userAPIHandler action:@selector(userCreateRequestFinished:) forRequestEvents:SMWebRequestEventComplete];
    [userAPIHandler.theWebRequest start];

}


-(void)userCreateRequestFinished:(id)obj
{
    NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
    NSLog(@"responseDictionary: %@", responseDictionary);
    
    
    NSString* newStr = [[[NSString alloc] initWithData:responseData
                                              encoding:NSUTF8StringEncoding] autorelease];
    
    NSLog(@"newStr: %@", newStr);
    
    
    
}


@end
