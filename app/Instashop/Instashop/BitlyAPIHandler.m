//
//  BitlyAPIHandler.m
//  Instashop
//  API Handler to craete shortened bitly strings where necessary
//  Created by Josh Klobe on 11/22/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "BitlyAPIHandler.h"
#import "BitlyResponseHandler.h"
@implementation BitlyAPIHandler


#define ACCESS_TOKEN @"649673326269e4e2daf3e3b590a0aacb86c274ea"

+(void)makeBitlyRequestWithDelegate:(id)theDelegate withReferenceURL:(NSString *)referenceURL
{

//    NSLog(@"referenceURL: %@", referenceURL);
    referenceURL = [Utils getEscapedStringFromUnescapedString:referenceURL];
    
//    referenceURL = @"http%3A%2F%2Fclick.linksynergy.com%2Fdeeplink%3Fid%3Dje6NUbpObpQ%26mid%3D38660%26u1%3Dogbu7s2ykc5f%26murl%3Dhttp%253A%252F%252Fm.nike.com%252Fus%252Fen_us%252Fpd%252Fdri-fit-wool-crew-running-shirt%252Fpid-773938%252Fpgid-1058609";
    NSString *requestString = [NSString stringWithFormat:@"https://api-ssl.bitly.com/v3/shorten?access_token=%@&longUrl=%@",ACCESS_TOKEN, referenceURL];
    NSMutableURLRequest *URLRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestString]];
    
//    NSLog(@"makeBitlyRequestWithDelegate: %@", requestString);
    
    BitlyAPIHandler *apiHandler = [[BitlyAPIHandler alloc] init];
    apiHandler.delegate = theDelegate;
    apiHandler.theWebRequest = [SMWebRequest requestWithURLRequest:URLRequest delegate:apiHandler context:NULL];
    [apiHandler.theWebRequest addTarget:apiHandler action:@selector(bitlyRequestFinished:) forRequestEvents:SMWebRequestEventComplete];
    [apiHandler.theWebRequest start];
    
}

-(void)bitlyRequestFinished:(id)obj
{
    NSString* responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
    
//    NSLog(@"bitlyRequestFinished: %@", responseDictionary);
    
    NSString *returnString = nil;
    
    NSDictionary *dataDictionary = [responseDictionary objectForKey:@"data"];
    if ([dataDictionary isKindOfClass:[NSDictionary class]])
        if (dataDictionary != nil)
            returnString = [dataDictionary objectForKey:@"url"];

        if ([self.delegate conformsToProtocol:@protocol(BitlyResponseHandler)])
            [(id<BitlyResponseHandler>)self.delegate bitlyCallDidRespondWIthShortURLString:returnString];
    
}

+(void)makeExpandBitlyRequestWithDelegate:(id)theDelegate withReferenceURL:(NSString *)referenceURL
{
 
    
    NSString *requestString = [NSString stringWithFormat:@"https://api-ssl.bitly.com/v3/expand?access_token=%@&shortURL=%@",ACCESS_TOKEN, [Utils getEscapedStringFromUnescapedString:referenceURL]];
    NSMutableURLRequest *URLRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestString]];

   
    BitlyAPIHandler *apiHandler = [[BitlyAPIHandler alloc] init];
    apiHandler.delegate = theDelegate;
    apiHandler.contextObject = referenceURL;
    apiHandler.theWebRequest = [SMWebRequest requestWithURLRequest:URLRequest delegate:apiHandler context:NULL];
    [apiHandler.theWebRequest addTarget:apiHandler action:@selector(bitlyExpandRequestFinished:) forRequestEvents:SMWebRequestEventComplete];
    [apiHandler.theWebRequest start];
    
}

-(void)bitlyExpandRequestFinished:(id)obj
{
 
    NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
    
    NSLog(@"bitlyExpandRequestFinished: %@", responseDictionary);
    NSLog(@"bitlyExpandRequestFinished.class: %@", [responseDictionary class]);
    
    if ([self.delegate conformsToProtocol:@protocol(BitlyResponseHandler)])
    {
        NSString *returnString = self.contextObject;
        if ([[responseDictionary objectForKey:@"status_code"] integerValue] == 200)
        {
            NSDictionary *dataDictionary = [responseDictionary objectForKey:@"data"];
            NSArray *expandArray = [dataDictionary objectForKey:@"expand"];
            if ([expandArray count] > 0)
            {
                NSDictionary *expandDictionary = [expandArray objectAtIndex:0];
                returnString = [expandDictionary objectForKey:@"long_url"];
            }
        }
        NSLog(@"bitlyExpandRequestFinished, returnString: %@", returnString);
        
        [(id<BitlyResponseHandler>)self.delegate bitlyExpandCallDidRespondWithURLString:returnString];
        
    }
    //-(void)bitlyExpandCallDidRespondWithURLString:(NSString *)urlString;
}
@end
