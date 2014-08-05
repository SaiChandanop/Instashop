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
    
/*
    NSMutableString *postString = [NSMutableString stringWithCapacity:0];
    [postString appendString:[NSString stringWithFormat:@"public_token=%@&", TWO_TAP_Public_token]];
    [postString appendString:[NSString stringWithFormat:@"unique_token=%@&", @"2388"]];
    [postString appendString:[NSString stringWithFormat:@"callback_url=%@&", @"https://amber.io/workers/proposed_recipes/test_callback"]];
    [postString appendString:[NSString stringWithFormat:@"custom_css_url=%@&", [Utils getEscapedStringFromUnescapedString:customCSSURLString]]];
    [postString appendString:[NSString stringWithFormat:@"show_tutorial=%@&", @"false"]];
    [postString appendString:[NSString stringWithFormat:@"products=%@&", [NSString stringWithFormat:@"product_1_url=%@", productURLString]]];
*/
//    [urlRequest setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSDictionary *product = [NSDictionary dictionaryWithObjectsAndKeys:productURLString, @"url", nil];
    NSArray *products = [NSArray arrayWithObject:product];
    
    NSDictionary *postDict = [NSDictionary dictionaryWithObjectsAndKeys:TWO_TAP_Public_token, @"public_token", @"2388", @"unique_token", @"https://amber.io/workers/proposed_recipes/test_callback", @"callback_url", customCSSURLString, @"custom_css_url", @"false", @"show_tutorial", products, @"products", nil];
    
    NSError *error;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:postDict options:0 error:&error];
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setHTTPBody:postData];
    NSLog(@"%@", postDict);
    
    return urlRequest;
}
@end