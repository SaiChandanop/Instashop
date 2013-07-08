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

+(void)makeUserCreateSellerRequestWithDelegate:(id)theDelegate withInstagramUserObject:(InstagramUserObject *)instagramUserObject withSellerAddressDictionary:(NSDictionary *)addressDictionary
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
    
    UserAPIHandler *userAPIHandler = [[UserAPIHandler alloc] init];
    userAPIHandler.delegate = theDelegate;
    userAPIHandler.theWebRequest = [SMWebRequest requestWithURLRequest:URLRequest delegate:userAPIHandler context:NULL];
    [userAPIHandler.theWebRequest addTarget:userAPIHandler action:@selector(userCreateRequestFinished:) forRequestEvents:SMWebRequestEventComplete];
    [userAPIHandler.theWebRequest start];

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


+(void)makeBuyerCreateRequestWithDelegate:(id)theDelegate withInstagramUserObject:(InstagramUserObject *)instagramUserObject
{
    NSString *urlRequestString = [NSString stringWithFormat:@"%@/%@", ROOT_URI, @"create_buyer.php"];
    NSMutableURLRequest *URLRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlRequestString]];
    
    
    NSMutableString *postString = [NSMutableString stringWithCapacity:0];
    [postString appendString:[NSString stringWithFormat:@"userID=%@&", instagramUserObject.userID]];
    [postString appendString:[NSString stringWithFormat:@"username=%@", instagramUserObject.username]];
    
    
    URLRequest.HTTPMethod = @"POST";
    [URLRequest setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"postString: %@", postString);
    
    UserAPIHandler *userAPIHandler = [[UserAPIHandler alloc] init];
    userAPIHandler.delegate = theDelegate;
    userAPIHandler.theWebRequest = [SMWebRequest requestWithURLRequest:URLRequest delegate:userAPIHandler context:NULL];
    [userAPIHandler.theWebRequest addTarget:userAPIHandler action:@selector(buyerCreateRequestFinished:) forRequestEvents:SMWebRequestEventComplete];
    [userAPIHandler.theWebRequest start];
}

-(void)buyerCreateRequestFinished:(id)obj
{
    NSLog(@"buyerCreateRequestFinished!");
}
@end
