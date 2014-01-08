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
    [urlRequestString appendString:[NSString stringWithFormat:@"http://api.viglink.com/api/click?"]];
    [urlRequestString appendString:[NSString stringWithFormat:@"key=%@", @"d5f8c8f691f4d1f3bb2d2911a327c41a"]];
    [urlRequestString appendString:[NSString stringWithFormat:@"&loc=%@", @"http://shopsy.com/"]];
    [urlRequestString appendString:[NSString stringWithFormat:@"&out=%@", [theURLString stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]]];
    [urlRequestString appendString:[NSString stringWithFormat:@"&format=%@", @"txt"]];
    
    //http://api.viglink.com/api/click?key=<your API key>&out=<URL>&loc=<URL>[&cuid=<str>][&format=go|jsonp|txt][&jsonp=<str>][&reaf=1][&ref=<URL>][&title=<str>][&txt=<str>]

//    API Key: 8d1fb10debee711bdaf5209ce4a7f72d
//    Secret Key: e7cd33e835c68f317ebbedc59ee679e170f12912
    
    
    NSMutableURLRequest *URLRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlRequestString]];
//    NSLog(@"urlRequestString: %@", urlRequestString);

    URLRequest.HTTPMethod = @"GET";

                                  
    ViglinkAPIHandler *apiHandler = [[ViglinkAPIHandler alloc] init];
    apiHandler.delegate = theDelegate;
    apiHandler.theWebRequest = [SMWebRequest requestWithURLRequest:URLRequest delegate:apiHandler context:NULL];
    [apiHandler.theWebRequest addTarget:apiHandler action:@selector(viglinkCallReturned:) forRequestEvents:SMWebRequestEventComplete];
    [apiHandler.theWebRequest start];
    
}

-(void)viglinkCallReturned:(id)object
{
    NSString* responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    

    [self.delegate viglinkCallReturned:responseString];
}
@end
