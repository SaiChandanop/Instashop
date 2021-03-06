//
//  TwoTapAPIHandler.m
//  Instashop
//
//  Created by Josh Klobe on 7/28/14.
//  Copyright (c) 2014 Josh Klobe. All rights reserved.
//

#import "TwoTapAPIHandler.h"
#import "AmberAPIHandler.h"


@implementation TwoTapAPIHandler



+(NSMutableURLRequest *)getTwoTapURLRequestWithProductURLString:(NSString *)productURLString
{
    NSString *customCSSURLString = @"http://instashop.com/test_custom.css";
    NSString *amberURLString = @"https://checkout.twotap.com";
    NSURL *amberURL = [NSURL URLWithString:amberURLString];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:amberURL];
    urlRequest.HTTPMethod = @"POST";

    NSError *error = nil;
    
    NSDictionary *productDictionary = [NSDictionary dictionaryWithObject:productURLString forKey:@"url"];
    NSMutableArray *productsArray = [NSMutableArray arrayWithObject:productDictionary];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:productsArray options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSLog(@"jsonString: %@", jsonString);

    
    NSMutableString *postString = [NSMutableString stringWithCapacity:0];
    [postString appendString:[NSString stringWithFormat:@"public_token=%@&", TWO_TAP_Public_token]];
    [postString appendString:[NSString stringWithFormat:@"unique_token=%@&", @"2388"]];
    [postString appendString:[NSString stringWithFormat:@"callback_url=%@&", @"https://amber.io/workers/proposed_recipes/test_callback"]];
    [postString appendString:[NSString stringWithFormat:@"custom_css_url=%@&", [Utils getEscapedStringFromUnescapedString:customCSSURLString]]];
    [postString appendString:[NSString stringWithFormat:@"show_tutorial=%@&", @"false"]];
    [postString appendString:[NSString stringWithFormat:@"products=%@&", jsonString]];
    [urlRequest setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    return urlRequest;
}
@end
