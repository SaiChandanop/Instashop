//
//  ShopsAPIHandler.m
//  Instashop
//
//  Created by Josh Klobe on 9/1/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "ShopsAPIHandler.h"
#import "SuggestedShopReturnProtocol.h"

@implementation ShopsAPIHandler



+(void)getSuggestedShopsWithDelegate:(id)theDelegate withCategory:(NSString *)categoryString
{
    
    NSString *urlRequestString = [NSString stringWithFormat:@"%@/%@", ROOT_URI, @"shopFunctions.php"];
    NSLog(@"Make get suggested shops call with request: %@", urlRequestString);
    NSMutableURLRequest *URLRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlRequestString]];
    URLRequest.HTTPMethod = @"POST";
    
    NSMutableString *postString = [NSMutableString stringWithCapacity:0];
    [postString appendString:[NSString stringWithFormat:@"action=%@", @"get_suggested_shops"]];
    [postString appendString:[NSString stringWithFormat:@"&category=%@", categoryString]];
    [URLRequest setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    ShopsAPIHandler *apiHandler = [[ShopsAPIHandler alloc] init];
    apiHandler.delegate = theDelegate;
    apiHandler.contextObject = categoryString;
    apiHandler.theWebRequest = [SMWebRequest requestWithURLRequest:URLRequest delegate:apiHandler context:NULL];
    [apiHandler.theWebRequest addTarget:apiHandler action:@selector(suggestedShopsComplete:) forRequestEvents:SMWebRequestEventComplete];
    [apiHandler.theWebRequest start];
    
}

-(void)suggestedShopsComplete:(id)theObj
{
    NSString* newStr = [[NSString alloc] initWithData:responseData
                                              encoding:NSUTF8StringEncoding];
    
    NSLog(@"suggestedShopsComplete: %@", newStr);
   NSArray *responseArray = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
    
    if ([self.delegate conformsToProtocol:@protocol(SuggestedShopReturnProtocol)])
        [(id<SuggestedShopReturnProtocol>)self.delegate suggestedShopsDidReturn:responseArray withCategory:self.contextObject];

}


@end
