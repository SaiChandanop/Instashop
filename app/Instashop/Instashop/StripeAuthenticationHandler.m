//
//  StripeAuthenticationHandler.m
//  Instashop
//
//  Created by Josh Klobe on 6/10/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "StripeAuthenticationHandler.h"
#define STRIPE_PUBLISHABLE_KEY @"pk_test_czwzkTp2tactuLOEOqbMTRzG"

@implementation StripeAuthenticationHandler


static NSString * const apiURLBase = @"api.stripe.com";
static NSString * const apiVersion = @"v1";
static NSString * const tokenEndpoint = @"tokens";


+ (void)createTokenWithCard:(STPCard *)card 
{
    NSString *publishableKey = STRIPE_PUBLISHABLE_KEY;
    
    if (card == nil)
        [NSException raise:@"RequiredParameter" format:@"'card' is required to create a token"];
    
    
    [self validateKey:publishableKey];
    
    NSURL *url = [self apiURLWithPublishableKey:publishableKey];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    
    request.HTTPBody = [self formEncodedDataFromCard:card];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:nil
                           completionHandler:^(NSURLResponse *response, NSData *body, NSError *requestError)
     {
//         [self handleTokenResponse:response body:body error:requestError completion:handler];
     }];
 

}

+ (void)validateKey:(NSString *)publishableKey
{
    if (!publishableKey || [publishableKey isEqualToString:@""])
        [NSException raise:@"InvalidPublishableKey" format:@"You must use a valid publishable key to create a token.  For more info, see https://stripe.com/docs/stripe.js"];
    
    if ([publishableKey hasPrefix:@"sk_"])
        [NSException raise:@"InvalidPublishableKey" format:@"You are using a secret key to create a token, instead of the publishable one. For more info, see https://stripe.com/docs/stripe.js"];
}

+ (NSURL *)apiURLWithPublishableKey:(NSString *)publishableKey
{
    NSURL *url = [[[NSURL URLWithString:
                    [NSString stringWithFormat:@"https://%@:@%@", [self URLEncodedString:publishableKey], apiURLBase]]
                   URLByAppendingPathComponent:apiVersion]
                  URLByAppendingPathComponent:tokenEndpoint];
    return url;
}

+ (NSString *)URLEncodedString:(NSString *)string {
    NSMutableString *output = [NSMutableString string];
    const unsigned char *source = (const unsigned char *)[string UTF8String];
    int sourceLen = strlen((const char *)source);
    for (int i = 0; i < sourceLen; ++i)
    {
        const unsigned char thisChar = source[i];
        if (thisChar == ' ')
            [output appendString:@"+"];
        else if (thisChar == '.' || thisChar == '-' || thisChar == '_' || thisChar == '~' ||
                 (thisChar >= 'a' && thisChar <= 'z') ||
                 (thisChar >= 'A' && thisChar <= 'Z') ||
                 (thisChar >= '0' && thisChar <= '9'))
            [output appendFormat:@"%c", thisChar];
        else
            [output appendFormat:@"%%%02X", thisChar];
    }
    return output;
}

+ (NSData *)formEncodedDataFromCard:(STPCard *)card
{
    NSMutableString *body = [NSMutableString string];
    NSDictionary *attributes = [self requestPropertiesFromCard:card];
    
    for (NSString *key in attributes) {
        NSString *value = [attributes objectForKey:key];
        if ((id)value == [NSNull null]) continue;
        
        if (body.length != 0)
            [body appendString:@"&"];
        
        if ([value isKindOfClass:[NSString class]])
            value = [self URLEncodedString:value];
        
        [body appendFormat:@"card[%@]=%@", [self URLEncodedString:key], value];
    }
}

+ (NSDictionary *)requestPropertiesFromCard:(STPCard *)card
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            card.number         ? card.number : [NSNull null],                                      @"number",
            card.expMonth       ? [NSString stringWithFormat:@"%u", card.expMonth] : [NSNull null], @"exp_month",
            card.expYear        ? [NSString stringWithFormat:@"%u", card.expYear] : [NSNull null],  @"exp_year",
            card.cvc            ? card.cvc : [NSNull null],                                         @"cvc",
            card.name           ? card.name : [NSNull null],                                        @"name",
            card.addressLine1   ? card.addressLine1 : [NSNull null],                                @"address_line1",
            card.addressLine2   ? card.addressLine2 : [NSNull null],                                @"address_line2",
            card.addressCity    ? card.addressCity : [NSNull null],                                 @"address_city",
            card.addressState   ? card.addressState : [NSNull null],                                @"address_state",
            card.addressZip     ? card.addressZip : [NSNull null],                                  @"address_zip",
            card.addressCountry ? card.addressCountry : [NSNull null],                              @"address_country",
            nil];
}

    
    

@end
