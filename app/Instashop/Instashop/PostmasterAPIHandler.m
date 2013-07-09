//
//  PostmasterAPIHandler.m
//  Instashop
//
//  Created by Josh Klobe on 7/8/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "PostmasterAPIHandler.h"
#import "SBJson.h"

@implementation PostmasterAPIHandler

+(void)makePostmasterRatesCallWithDelegate:(id)theDelegate withFromZip:(NSString *)fromZip withToZip:(NSString *)toZip withWeight:(NSString *)weight withCarrier:(NSString *)carrier
{
    NSString *urlRequestString = [NSString stringWithFormat:@"%@/postmaster/instashop/getShippingRates.php?from_zip=%@&to_zip=%@&weight=%@&carrier=%@", ROOT_URI, fromZip, toZip, weight, carrier];
    NSMutableURLRequest *URLRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlRequestString]];
    
    
    PostmasterAPIHandler *apiHandler = [[PostmasterAPIHandler alloc] init];
    apiHandler.delegate = theDelegate;
    apiHandler.theWebRequest = [SMWebRequest requestWithURLRequest:URLRequest delegate:apiHandler context:NULL];
    [apiHandler.theWebRequest addTarget:apiHandler action:@selector(ratesCallDidFinish:) forRequestEvents:SMWebRequestEventComplete];
    [apiHandler.theWebRequest start];
    
}


-(void)ratesCallDidFinish:(id)obj
{
    NSString* responseString = [[[NSString alloc] initWithData:responseData
                                                      encoding:NSUTF8StringEncoding] autorelease];
 
    NSLog(@"responseString: %@", responseString);
    id aobj = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
    NSLog(@"aobj: %@", aobj);
    [self.delegate ratesCallReturnedWithDictionary:aobj];
}


+(void)makePostmasterShipRequestCallWithDelegate:(id)theDelegate withFromDictionary:(NSDictionary *)fromDictionary withToDictionary:(NSDictionary *)toDictionary shippingDictionary:(NSDictionary *)shippingDictionary withPackageDictionary:(NSDictionary *)packageDictionary
{
    NSString *urlRequestString = [NSString stringWithFormat:@"%@/postmaster/instashop/makeShippingRequest.php", ROOT_URI];
    
    
    NSMutableDictionary *postDictionary = [NSMutableDictionary dictionaryWithCapacity:0];
    [postDictionary addEntriesFromDictionary:fromDictionary];
    [postDictionary addEntriesFromDictionary:toDictionary];
    [postDictionary addEntriesFromDictionary:shippingDictionary];
    [postDictionary addEntriesFromDictionary:packageDictionary];
    
    
    
    NSError *error;
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    NSData *myRequestData = [NSJSONSerialization dataWithJSONObject:postDictionary
                                                            options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                              error:&error];
    
    [jsonWriter release];
    
    NSMutableURLRequest *request = [ [ NSMutableURLRequest alloc ] initWithURL: [ NSURL URLWithString:urlRequestString] ];
    [ request setHTTPMethod: @"POST" ];
    [ request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    [ request setHTTPBody: myRequestData ];
        

        
    PostmasterAPIHandler *apiHandler = [[PostmasterAPIHandler alloc] init];
    apiHandler.delegate = theDelegate;
    apiHandler.theWebRequest = [SMWebRequest requestWithURLRequest:request delegate:apiHandler context:NULL];
    [apiHandler.theWebRequest addTarget:apiHandler action:@selector(postmasterShipCallReturned:) forRequestEvents:SMWebRequestEventComplete];
    [apiHandler.theWebRequest start];

    
}

-(void)postmasterShipCallReturned:(id)obj
{
    NSString* responseString = [[[NSString alloc] initWithData:responseData
                                                      encoding:NSUTF8StringEncoding] autorelease];
    
    NSLog(@"responseString: %@", responseString);
}

@end
