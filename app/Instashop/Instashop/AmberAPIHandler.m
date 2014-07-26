//
//  AmberAPIHandler.m
//  Instashop
//  Used to determine if amber supports a selected product site.
//  Created by Josh Klobe on 10/31/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "AmberAPIHandler.h"
#import "BitlyAPIHandler.h"
#import "PurchasingViewController.h"
@implementation AmberAPIHandler


@synthesize supportedSitesArray;


+(NSString *)getTwoTapURLStringWithReferenceURLString:(NSString *)referenceURLString
{
    /*
#  unique_token=an_unique_token&
#  callback_url=your_callback_url&
#  products=product_1_url,product_2_url&
#  affiliate_links=product_1_affiliate_url,product_2_affiliate_url
*/
    
    NSString *urlRequestString = [NSString stringWithFormat:@"https://checkout.twotap.com/?public_token=%@&unique_token=2388&callback_url=https://amber.io/workers/proposed_recipes/test_callback&show_tutorial=false&products=%@", TWO_TAP_Public_token, referenceURLString];
    
    return urlRequestString;
}



-(void)apiHandlerFinished:(id)obj
{
    NSString* newStr = [[NSString alloc] initWithData:self.responseData
                                              encoding:NSUTF8StringEncoding];
    
    //   NSLog(@"amber call finished: %@", newStr);
    
}

+(void)makeAmberSupportedSiteCallWithReference:(NSString *)referenceURLString withResponseDelegate:(id)delegate
{
    NSLog(@"makeAmberSupportedSiteCallWithReference!!!!");
    NSString *urlRequestString = @"https://api.twotap.com/v1.0/supported_sites";
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
