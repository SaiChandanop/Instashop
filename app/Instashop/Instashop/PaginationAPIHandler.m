//
//  PaginationAPIHandler.m
//  Instashop
//
//  Created by Josh Klobe on 12/17/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "PaginationAPIHandler.h"
#import "ProductSelectTableViewController.h"
#import "PullAccountHandler.h"


@implementation PaginationAPIHandler



+(void)makePaginationRequestWithDelegate:(id)theDelegate withRequestURLString:(NSString *)requestURLString
{

    NSMutableURLRequest *URLRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestURLString]];

    
    PaginationAPIHandler *apiHandler = [[PaginationAPIHandler alloc] init];
    apiHandler.delegate = theDelegate;
    apiHandler.theWebRequest = [SMWebRequest requestWithURLRequest:URLRequest delegate:apiHandler context:NULL];
    [apiHandler.theWebRequest addTarget:apiHandler action:@selector(makePaginationRequestWithDelegateFinished:) forRequestEvents:SMWebRequestEventComplete];
    [apiHandler.theWebRequest start];
}

-(void)makePaginationRequestWithDelegateFinished:(id)obj
{
//    NSString* newStr = [[[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding] autorelease];
    NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingAllowFragments error:nil];
    
    NSLog(@"makePaginationRequestWithDelegateFinished");
    
    if ([self.delegate isKindOfClass:[ProductSelectTableViewController class]])
        [((ProductSelectTableViewController *)self.delegate)  request:nil didLoad:responseDictionary];
    else if ([self.delegate isKindOfClass:[PullAccountHandler class]])
        [((PullAccountHandler *)self.delegate)  request:nil didLoad:responseDictionary];
}

@end
