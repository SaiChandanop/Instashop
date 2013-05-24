//
//  RootAPIHandler.m
//  HomeTalk
//
//  Created by Josh Klobe on 9/25/12.
//  Copyright (c) 2012 Josh Klobe. All rights reserved.
//

#import "RootAPIHandler.h"

@implementation RootAPIHandler

@synthesize theWebRequest, delegate, responseData, response, contextObject;


- (id)webRequest:(SMWebRequest *)webRequest resultObjectForData:(NSData *)data context:(id)context
{
    self.responseData = data;

    NSString* newStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //NSLog(@"response String: %@", newStr);
    return newStr;
}
// both of these are called on the main thread, BEFORE the target/action listeners are called
- (void)webRequest:(SMWebRequest *)webRequest didCompleteWithResult:(id)result context:(id)context
{    
    self.response = [webRequest.response retain];
//    NSLog(@"statusCode: %d", [webRequest.response statusCode]);
                              
//     NSURLResponse
}

- (void)webRequest:(SMWebRequest *)webRequest didFailWithError:(NSError *)error context:(id)context
{
    NSLog(@"Request Did Fail With Error: %@", error);
}

@end
