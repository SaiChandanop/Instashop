//
//  AmberAPIHandler.m
//  Instashop
//
//  Created by Josh Klobe on 10/31/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "AmberAPIHandler.h"

@implementation AmberAPIHandler


+(void)makeAmberCall
{
    NSString *originURL = @"http://www.nastygal.com/clothes-tops/soft-curve-knit-black";
    originURL = [originURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *urlRequestString = [NSString stringWithFormat:@"https://mobile.amber.io/?public_token=6ad2af4e0e1e2fb08de9&unique_token=2388&test_mode=fake_confirm&callback_url=https://amber.io/workers/proposed_recipes/test_callback&show_tutorial=false&products=%@", originURL];
    NSMutableURLRequest *URLRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlRequestString]];
    
    AmberAPIHandler *apiHandler = [[AmberAPIHandler alloc] init];
    apiHandler.theWebRequest = [SMWebRequest requestWithURLRequest:URLRequest delegate:apiHandler context:NULL];
    [apiHandler.theWebRequest addTarget:apiHandler action:@selector(apiHandlerFinished:) forRequestEvents:SMWebRequestEventComplete];
    [apiHandler.theWebRequest start];
    
}

-(void)apiHandlerFinished:(id)obj
{
    NSString* newStr = [[[NSString alloc] initWithData:self.responseData
                                              encoding:NSUTF8StringEncoding] autorelease];
    
    NSLog(@"amber call finished: %@", newStr);
    
}
@end
