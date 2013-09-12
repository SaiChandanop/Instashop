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


+(void)makeProductSearchRequestWithDelegate:(id)delegate withSearchCategoriesArray:(NSArray *)searchCategoriesArray withFreeformTextArray:(NSArray *)freeformTextArray
{
    NSString *urlRequestString = [NSString stringWithFormat:@"%@/%@", ROOT_URI, @"search/search.php"];
    NSMutableURLRequest *URLRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlRequestString]];
    URLRequest.HTTPMethod = @"POST";
    
    
    NSMutableString *categoriesPostString = [NSMutableString stringWithCapacity:0];
    for (int i = 0; i < [searchCategoriesArray count]; i++)
    {
        [categoriesPostString appendString:[searchCategoriesArray objectAtIndex:i]];
        if (i != [searchCategoriesArray count] -1)
            [categoriesPostString appendString:@"___"];
    }
    
    NSMutableString *freeTextPostString = [NSMutableString stringWithCapacity:0];
    for (int i = 0; i < [freeformTextArray count]; i++)
    {
        [freeTextPostString appendString:[freeformTextArray objectAtIndex:i]];
        if (i != [freeformTextArray count] -1)
            [freeTextPostString appendString:@"___"];
    }
    
    
    NSMutableString *postString = [NSMutableString stringWithCapacity:0];
    [postString appendString:[NSString stringWithFormat:@"search_type=%@", @"products"]];
    [postString appendString:[NSString stringWithFormat:@"&categories_string=%@&", categoriesPostString]];
    [postString appendString:[NSString stringWithFormat:@"&freetext_string=%@&", freeTextPostString]];
    
    [URLRequest setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    SearchAPIHandler *apiHandler = [[SearchAPIHandler alloc] init];
    apiHandler.delegate = delegate;
    apiHandler.theWebRequest = [SMWebRequest requestWithURLRequest:URLRequest delegate:apiHandler context:NULL];
    [apiHandler.theWebRequest addTarget:apiHandler action:@selector(searchRequestComplete:) forRequestEvents:SMWebRequestEventComplete];
    [apiHandler.theWebRequest start];
    
}

+(void)makeSellerCategoryRequestWithDelegate:(id)delegate withCategoryString:(NSString *)categoryString withFreeformTextArray:(NSArray *)freeformTextArray
{
    NSString *urlRequestString = [NSString stringWithFormat:@"%@/%@", ROOT_URI, @"sellerfunctions/get_sellers.php"];
    NSMutableURLRequest *URLRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlRequestString]];
    URLRequest.HTTPMethod = @"POST";
    
    
    NSMutableString *postString = [NSMutableString stringWithCapacity:0];
    [postString appendString:[NSString stringWithFormat:@"category=%@", categoryString]];
    [postString appendString:[NSString stringWithFormat:@"&freeform_text_array=%@&", freeformTextArray]];

    [URLRequest setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    SearchAPIHandler *apiHandler = [[SearchAPIHandler alloc] init];
    apiHandler.delegate = delegate;
    apiHandler.theWebRequest = [SMWebRequest requestWithURLRequest:URLRequest delegate:apiHandler context:NULL];
    [apiHandler.theWebRequest addTarget:apiHandler action:@selector(searchRequestComplete:) forRequestEvents:SMWebRequestEventComplete];
    [apiHandler.theWebRequest start];
}



-(void)searchRequestComplete:(id)obj
{
    NSString* newStr = [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease];
    NSArray *responseArray = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
    
    if ([self.delegate conformsToProtocol:@protocol(SearchReturnedReceiverProtocol)])
        [(id<SearchReturnedReceiverProtocol>)self.delegate searchReturnedWithArray:responseArray];
    
}


@end
