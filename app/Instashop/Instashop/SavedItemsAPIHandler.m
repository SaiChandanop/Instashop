//
//  SavedItemsAPIHandler.m
//  Instashop
//
//  Created by Josh Klobe on 11/18/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "SavedItemsAPIHandler.h"
#import "PurchasingViewController.h"


@implementation SavedItemsAPIHandler

+(void)makeSavedItemRequestWithDelegate:(id)theDelegate withInstagramID:(NSString *)instagramID withProductID:(NSString *)productID
{
    NSString *urlRequestString = [NSString stringWithFormat:@"%@/%@", ROOT_URI, @"savedItems.php"];
    NSMutableURLRequest *URLRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlRequestString]];
    URLRequest.HTTPMethod = @"POST";

    
    
    NSMutableString *postString = [NSMutableString stringWithCapacity:0];
    [postString appendString:[NSString stringWithFormat:@"request_type=%@", @"saved"]];
    [postString appendString:[NSString stringWithFormat:@"&instagram_id=%@&", instagramID]];
    [postString appendString:[NSString stringWithFormat:@"&product_id=%@&", productID]];
    
    [URLRequest setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSLog(@"search, urlRequestString: %@", urlRequestString);
    NSLog(@"post string: %@", postString);
    
    SavedItemsAPIHandler *apiHandler = [[SavedItemsAPIHandler alloc] init];
    apiHandler.delegate = theDelegate;
    apiHandler.theWebRequest = [SMWebRequest requestWithURLRequest:URLRequest delegate:apiHandler context:NULL];
    [apiHandler.theWebRequest addTarget:apiHandler action:@selector(makeSavedItemRequestWithInstagramIDDone:) forRequestEvents:SMWebRequestEventComplete];
    [apiHandler.theWebRequest start];

}

-(void)makeSavedItemRequestWithInstagramIDDone:(id)object
{
    NSString* newStr = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];    
    NSLog(@"makeSavedItemRequestWithInstagramIDDone: %@", newStr);
    
    if ([self.delegate isKindOfClass:[PurchasingViewController class]])
        [((PurchasingViewController *)self.delegate) savedItemsCompleted];
}

@end
