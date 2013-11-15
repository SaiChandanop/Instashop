//
//  NotificationsAPIHandler.m
//  Instashop
//
//  Created by Josh Klobe on 11/14/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "NotificationsAPIHandler.h"
#import "NotificationsObject.h"
#import "NotificationsFinishedProtocol.h"
@implementation NotificationsAPIHandler

+(void)getAllNotificationsWithInstagramID:(NSString *)instagramID withDelegate:(id)theDelegate
{
 
    NSMutableString *postString = [NSMutableString stringWithCapacity:0];
    [postString appendString:[NSString stringWithFormat:@"&request_type=%@", @"all"]];
    [postString appendString:[NSString stringWithFormat:@"&instagram_id=%@", instagramID]];
    
    NSString *urlRequestString = [NSString stringWithFormat:@"%@/push_notifications/get_notifications.php", ROOT_URI];
    NSMutableURLRequest *URLRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlRequestString]];
    URLRequest.HTTPMethod = @"POST";
    [URLRequest setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NotificationsAPIHandler *apiHandler = [[NotificationsAPIHandler alloc] init];
    apiHandler.theWebRequest = [SMWebRequest requestWithURLRequest:URLRequest delegate:apiHandler context:NULL];
    apiHandler.delegate = theDelegate;
    [apiHandler.theWebRequest addTarget:apiHandler action:@selector(getAllNotificationsWithInstagramIDFinished:) forRequestEvents:SMWebRequestEventComplete];
    [apiHandler.theWebRequest start];
    
}

-(void)getAllNotificationsWithInstagramIDFinished:(id)obj
{
    NSString* responseString = [[[NSString alloc] initWithData:self.responseData  encoding:NSUTF8StringEncoding] autorelease];
//    NSLog(@"getAllNotificationsWithInstagramIDFinished: %@", responseString);
    
    NSArray *responseArray = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
    
    NSLog(@"responseArray: %@", responseArray);
    
    NSMutableArray *ar = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < [responseArray count]; i++)
    {
        NSDictionary *dict = [responseArray objectAtIndex:i];
        
        NotificationsObject *notificationsObject = [[NotificationsObject alloc] init];
        notificationsObject.message = [dict objectForKey:@"message"];
        notificationsObject.dataDictionary = [[NSDictionary alloc] initWithDictionary:[dict objectForKey:@"data"]];
        
        [ar addObject:notificationsObject];
    }
    
    
    
    if ([self.delegate conformsToProtocol:@protocol(NotificationsFinishedProtocol)])
        [(id<NotificationsFinishedProtocol>)self.delegate notificationsDidFinishWithArray:ar];    
    
}



+(void)createUserLikedNotificationWithProductID:(NSString *)productID withInstagramID:(NSString *)instagramID
{
    NSLog(@"createUserLikedNotificationWithProductID");
    
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
