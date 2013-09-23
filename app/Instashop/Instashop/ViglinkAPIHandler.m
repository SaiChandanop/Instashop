//
//  ViglinkAPIHandler.m
//  Instashop
//
//  Created by Josh Klobe on 9/23/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "ViglinkAPIHandler.h"

@implementation ViglinkAPIHandler

+(void)makeViglinkRestCallWithDelegate:(id)theDelegate withReferenceURLString:(NSString *)theURLString
{
 
    NSMutableString *urlRequestString = [NSMutableString stringWithCapacity:0];
//    [urlRequestString appendString:[NSString stringWithFormat:@"http://redirect.viglink.com/api/click?"]];
    [urlRequestString appendString:[NSString stringWithFormat:@"http://redirect.viglink.com?"]];
    [urlRequestString appendString:[NSString stringWithFormat:@"key=%@", @"603bf197cf154d2916539b465ba2895e"]];
    [urlRequestString appendString:[NSString stringWithFormat:@"&loc=%@", theURLString]];
    [urlRequestString appendString:[NSString stringWithFormat:@"&out=%@", theURLString]];
    [urlRequestString appendString:[NSString stringWithFormat:@"&format=%@", @"jsonp"]];
    
                                  
    NSMutableURLRequest *URLRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlRequestString]];
    

    URLRequest.HTTPMethod = @"GET";

                                  
    ViglinkAPIHandler *apiHandler = [[ViglinkAPIHandler alloc] init];
    apiHandler.delegate = theDelegate;
    apiHandler.theWebRequest = [SMWebRequest requestWithURLRequest:URLRequest delegate:apiHandler context:NULL];
    [apiHandler.theWebRequest addTarget:apiHandler action:@selector(viglinkCallReturned:) forRequestEvents:SMWebRequestEventComplete];
    [apiHandler.theWebRequest start];
    
}

-(void)viglinkCallReturned:(id)object
{
    NSString* responseString = [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease];
    
    NSLog(@"viglinkCallReturned: %@", responseString);
}
@end
