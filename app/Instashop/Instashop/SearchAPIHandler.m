//
//  SearchAPIHandler.m
//  Instashop
//
//  Created by Josh Klobe on 9/3/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "SearchAPIHandler.h"
#import "SearchReturnedReceiverProtocol.h"
@implementation SearchAPIHandler


+(void)makeSearchRequestWithDelegate:(id)delegate withRequestString:(NSString *)requestString
{
    NSString *urlRequestString = [NSString stringWithFormat:@"%@/%@", ROOT_URI, @"search/search.php"];
    NSMutableURLRequest *URLRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlRequestString]];
    URLRequest.HTTPMethod = @"POST";
    
    
    NSMutableString *postString = [NSMutableString stringWithCapacity:0];
    [postString appendString:[NSString stringWithFormat:@"search_string=%@&", requestString]];
    [URLRequest setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    SearchAPIHandler *apiHandler = [[SearchAPIHandler alloc] init];
    apiHandler.delegate = delegate;
    apiHandler.theWebRequest = [SMWebRequest requestWithURLRequest:URLRequest delegate:apiHandler context:NULL];
    [apiHandler.theWebRequest addTarget:apiHandler action:@selector(searchRequestComplete:) forRequestEvents:SMWebRequestEventComplete];
    [apiHandler.theWebRequest start];
    
}

-(void)searchRequestComplete:(id)obj
{
    
    NSString* newStr = [[[NSString alloc] initWithData:responseData
                                              encoding:NSUTF8StringEncoding] autorelease];
    
    NSLog(@"searchRequestComplete: %@", newStr);
    
    NSArray *responseArray = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
    
    
    if ([self.delegate conformsToProtocol:@protocol(SearchReturnedReceiverProtocol)])
        [(id<SearchReturnedReceiverProtocol>)self.delegate searchReturnedWithArray:responseArray];
    
}
@end
