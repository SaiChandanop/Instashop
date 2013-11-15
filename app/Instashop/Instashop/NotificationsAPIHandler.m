//
//  NotificationsAPIHandler.m
//  Instashop
//
//  Created by Josh Klobe on 11/14/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "NotificationsAPIHandler.h"

@implementation NotificationsAPIHandler


+(void)createUserLikedNotificationWithProductID:(NSString *)productID withInstagramID:(NSString *)instagramID
{
    
    NSMutableString *postString = [NSMutableString stringWithCapacity:0];
    [postString appendString:@"type=user_liked_product"];
    [postString appendString:[NSString stringWithFormat:@"&product_id=%@", productID]];
    [postString appendString:[NSString stringWithFormat:@"&instagram_id=%@", instagramID]];
    
    NSString *urlRequestString = [NSString stringWithFormat:@"%@/push_notifications/push_receiver.php", ROOT_URI];
    NSMutableURLRequest *URLRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlRequestString]];
    URLRequest.HTTPMethod = @"POST";
    [URLRequest setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NotificationsAPIHandler *apiHandler = [[NotificationsAPIHandler alloc] init];
    apiHandler.theWebRequest = [SMWebRequest requestWithURLRequest:URLRequest delegate:apiHandler context:NULL];
    [apiHandler.theWebRequest addTarget:apiHandler action:@selector(createUserLikedNotificationWithProductIDFinished:) forRequestEvents:SMWebRequestEventComplete];
    [apiHandler.theWebRequest start];
    
}

-(void)createUserLikedNotificationWithProductIDFinished:(id)obj
{
    NSString* responseString = [[[NSString alloc] initWithData:self.responseData  encoding:NSUTF8StringEncoding] autorelease];
    NSLog(@"createUserLikedNotificationWithProductIDFinished: %@", responseString);
    
}

@end
