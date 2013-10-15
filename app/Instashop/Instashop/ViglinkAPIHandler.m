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
    [urlRequestString appendString:[NSString stringWithFormat:@"key=%@", @"603bf197cf154d2916539b465ba2895e"]];
    [urlRequestString appendString:[NSString stringWithFormat:@"&loc=%@", @"http://shopsy.com/"]];
    [urlRequestString appendString:[NSString stringWithFormat:@"&out=%@", [theURLString stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]]];
    [urlRequestString appendString:[NSString stringWithFormat:@"&format=%@", @"txt"]];
    
    //http://api.viglink.com/api/click?key=<your API key>&out=<URL>&loc=<URL>[&cuid=<str>][&format=go|jsonp|txt][&jsonp=<str>][&reaf=1][&ref=<URL>][&title=<str>][&txt=<str>]

//    API Key: 603bf197cf154d2916539b465ba2895e
//    Secret Key: e7cd33e835c68f317ebbedc59ee679e170f12912
    
    
    NSMutableURLRequest *URLRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlRequestString]];
    NSLog(@"urlRequestString: %@", urlRequestString);

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
    [self.delegate viglinkCallReturned:responseString];
}
@end
