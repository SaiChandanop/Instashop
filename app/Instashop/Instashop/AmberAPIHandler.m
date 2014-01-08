//
//  AmberAPIHandler.m
//  Instashop
//
//  Created by Josh Klobe on 10/31/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "AmberAPIHandler.h"
#import "BitlyAPIHandler.h"
#import "PurchasingViewController.h"
@implementation AmberAPIHandler


@synthesize supportedSitesArray;


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
    NSString* newStr = [[NSString alloc] initWithData:self.responseData
                                              encoding:NSUTF8StringEncoding];
    
    //   NSLog(@"amber call finished: %@", newStr);
    
}

+(void)makeAmberSupportedSiteCallWithReference:(NSString *)referenceURLString withResponseDelegate:(id)delegate
{
    
    NSString *urlRequestString = @"http://api.amber.io/v1.0/supported_sites";
    NSMutableURLRequest *URLRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlRequestString]];
    AmberAPIHandler *apiHandler = [[AmberAPIHandler alloc] init];
    apiHandler.theWebRequest = [SMWebRequest requestWithURLRequest:URLRequest delegate:apiHandler context:NULL];
    apiHandler.delegate = delegate;
    apiHandler.contextObject = referenceURLString;
    [apiHandler.theWebRequest addTarget:apiHandler action:@selector(supportedSiteHandlerFinished:) forRequestEvents:SMWebRequestEventComplete];
    [apiHandler.theWebRequest start];
    
}

-(void)supportedSiteHandlerFinished:(id)obj
{
    if (self.supportedSitesArray == nil)
    {
/*        NSString* newStr = [[[NSString alloc] initWithData:self.responseData
                                                  encoding:NSUTF8StringEncoding] autorelease];
  */
        self.supportedSitesArray = [NSMutableArray arrayWithCapacity:0];
        NSArray *responseArray = [NSJSONSerialization JSONObjectWithData:self.responseData options:0 error:nil];
        
        for (int i = 0; i < [responseArray count]; i++)
        {
            NSDictionary *dict = [responseArray objectAtIndex:i];
            [self.supportedSitesArray addObject:[dict objectForKey:@"url"]];
        }
    }
    
    if ([self.contextObject rangeOfString:@"bit.ly"].length > 0)
    {
        [BitlyAPIHandler makeExpandBitlyRequestWithDelegate:self withReferenceURL:self.contextObject];
        return;
    }
    
    NSString *domainString = self.contextObject;
    domainString = [domainString stringByReplacingOccurrencesOfString:@"http://" withString:@""];
    domainString = [domainString stringByReplacingOccurrencesOfString:@"https://" withString:@""];
    NSArray *componentsArray = [domainString componentsSeparatedByString:@"/"];
    domainString = [componentsArray objectAtIndex:0];
    
    NSLog(@"1domainString: %@", domainString);
    
    componentsArray = [domainString componentsSeparatedByString:@"."];
    NSLog(@"componentsArray: %@", componentsArray);
    if ([componentsArray count] > 0)
    {
        if ([componentsArray count] > 1)
        {
            NSString *theDomainString = [componentsArray objectAtIndex:[componentsArray count] -2];
            NSString *extensionString = [componentsArray objectAtIndex:[componentsArray count] -1];
            domainString = [NSString stringWithFormat:@"%@.%@", theDomainString, extensionString];
        }
    }
    
    NSLog(@"domainString: %@", domainString);
    if ([self.delegate isKindOfClass:[PurchasingViewController class]])
         [((PurchasingViewController *)self.delegate) amberSupportedSiteCallFinishedWithIsSupported:[supportedSitesArray containsObject:domainString] withExpandedURLString:self.contextObject];
    
}

-(void)bitlyExpandCallDidRespondWithURLString:(NSString *)urlString
{
    NSLog(@"%@ bitlyExpandCallDidRespondWithURLString: %@", self, urlString);
    self.contextObject = urlString;
    [self supportedSiteHandlerFinished:nil];
}

@end
