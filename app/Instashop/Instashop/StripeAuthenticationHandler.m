//
//  StripeAuthenticationHandler.m
//  Instashop
//
//  Created by Josh Klobe on 6/10/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "StripeAuthenticationHandler.h"
#import "STPCard.h"


@implementation StripeAuthenticationHandler


static NSString * const apiURLBase = @"api.stripe.com";
static NSString * const apiVersion = @"v1";
static NSString * const tokenEndpoint = @"tokens";
static NSString * const chargeEndpoint = @"charges";

+ (void)createTokenWithCard:(STPCard *)card withDelegate:(id)delegate
{
    NSString *publishableKey = TEST_PUBLISHABLE_KEY;
    
    [self validateKey:publishableKey];
    
    NSURL *url = [self apiURLWithPublishableKey:publishableKey withEndpoint:tokenEndpoint];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    request.HTTPBody = [self formEncodedDataWithAttributes:[self requestPropertiesFromCard:card]];

    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *body, NSError *requestError)
     {
         NSError* error;
         NSDictionary* json = [NSJSONSerialization JSONObjectWithData:body options:kNilOptions error:&error];
        
         
         
         [delegate tokenCreatedWithDictionary:json];
     }];


}




+(void)buyItemWithToken:(NSString *)theToken withPurchaseAmount:(NSString *)amount withDescription:(NSString *)description withDelegate:(id)delegate
{
    NSMutableDictionary *requestPropertiesDictionary = [NSMutableDictionary dictionaryWithCapacity:0];
    [requestPropertiesDictionary setObject:amount forKey:@"amount"];
    [requestPropertiesDictionary setObject:@"usd" forKey:@"currency"];
    [requestPropertiesDictionary setObject:theToken forKey:@"card"];
    [requestPropertiesDictionary setObject:description forKey:@"description"];
    
    
    
    NSString *publishableKey = TEST_PUBLISHABLE_KEY;
    
    [self validateKey:publishableKey];
    
    NSURL *url = [self apiURLWithPublishableKey:publishableKey withEndpoint:chargeEndpoint];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    request.HTTPMethod = @"POST";
    request.HTTPBody = [self dictionaryToHTTPBodyConverter:requestPropertiesDictionary];
    [request setValue:[NSString stringWithFormat:@"Bearer %@", TEST_SECRET_KEY] forHTTPHeaderField:@"Authorization"];
    

    
    
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *body, NSError *requestError)
     {
         NSError* error;
         NSDictionary* json = [NSJSONSerialization JSONObjectWithData:body options:kNilOptions error:&error];
         
         
         [delegate buySuccessfulWithDictionary:json];
//         NSLog(@"json[id]: %@", [json objectForKey:@"id"]);
         
//         [[NSUserDefaults standardUserDefaults] setObject:[json objectForKey:@"id"] forKey:@"StripeToken"];
//         [[NSUserDefaults standardUserDefaults] synchronize];
         
     }];
    

    
    /*
    
    curl https://api.stripe.com/v1/charges \
    -u sk_test_uMQ75pJIdtsnlmdWbbWgWcE2: \
    -d amount=400 \
    -d currency=usd \
    -d card=tok_1kveomSIbeEjS3 \
    -d "description=Charge for test@example.com"
    */
    
}

+ (void)validateKey:(NSString *)publishableKey
{
    if (!publishableKey || [publishableKey isEqualToString:@""])
        [NSException raise:@"InvalidPublishableKey" format:@"You must use a valid publishable key to create a token.  For more info, see https://stripe.com/docs/stripe.js"];
    
    if ([publishableKey hasPrefix:@"sk_"])
        [NSException raise:@"InvalidPublishableKey" format:@"You are using a secret key to create a token, instead of the publishable one. For more info, see https://stripe.com/docs/stripe.js"];
}

+ (NSURL *)apiURLWithPublishableKey:(NSString *)publishableKey withEndpoint:(NSString *)endpoint
{
    NSURL *url = [[[NSURL URLWithString:
                    [NSString stringWithFormat:@"https://%@:@%@", [self URLEncodedString:publishableKey], apiURLBase]]
                   URLByAppendingPathComponent:apiVersion]
                  URLByAppendingPathComponent:endpoint];
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


+ (NSData *)dictionaryToHTTPBodyConverter:(NSDictionary *)attributes
{
    NSMutableString *body = [NSMutableString string];
    //    NSDictionary *attributes = [self requestPropertiesFromCard:card];
    
    for (NSString *key in attributes) {
        NSString *value = [attributes objectForKey:key];
        if ((id)value == [NSNull null]) continue;
        
        if (body.length != 0)
            [body appendString:@"&"];
        
        if ([value isKindOfClass:[NSString class]])
            value = [self URLEncodedString:value];
        
        [body appendFormat:@"%@=%@", [self URLEncodedString:key], value];
    }
    
    return [body dataUsingEncoding:NSUTF8StringEncoding];
}



+ (NSData *)formEncodedDataWithAttributes:(NSDictionary *)attributes
{
    NSMutableString *body = [NSMutableString string];
//    NSDictionary *attributes = [self requestPropertiesFromCard:card];
    
    for (NSString *key in attributes) {
        NSString *value = [attributes objectForKey:key];
        if ((id)value == [NSNull null]) continue;
        
        if (body.length != 0)
            [body appendString:@"&"];
        
        if ([value isKindOfClass:[NSString class]])
            value = [self URLEncodedString:value];
        
        [body appendFormat:@"card[%@]=%@", [self URLEncodedString:key], value];
    }
    
    return [body dataUsingEncoding:NSUTF8StringEncoding];
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
