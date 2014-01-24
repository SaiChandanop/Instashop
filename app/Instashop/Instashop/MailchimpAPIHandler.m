//
//  MailchimpAPIHandler.m
//  Instashop
//
//  Created by Josh Klobe on 1/24/14.
//  Copyright (c) 2014 Josh Klobe. All rights reserved.
//

#import "MailchimpAPIHandler.h"

@implementation MailchimpAPIHandler


+(void)makeMailchimpCallWithEmail:(NSString *)theEmail
{
    NSString *urlRequestString = [NSString stringWithFormat:@"%@/%@", ROOT_URI, @"shopsy_mailchimp_receiver.php"];
    NSMutableURLRequest *URLRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlRequestString]];
    URLRequest.HTTPMethod = @"POST";
    
    
    NSMutableString *postString = [NSMutableString stringWithCapacity:0];
    [postString appendString:[NSString stringWithFormat:@"action=%@", @"submit_email"]];
    [postString appendString:[NSString stringWithFormat:@"&email=%@&", theEmail]];

    
    [URLRequest setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSLog(@"search, urlRequestString: %@", urlRequestString);
    NSLog(@"post string: %@", postString);
    
    MailchimpAPIHandler *apiHandler = [[MailchimpAPIHandler alloc] init];
    apiHandler.theWebRequest = [SMWebRequest requestWithURLRequest:URLRequest delegate:apiHandler context:NULL];
    [apiHandler.theWebRequest addTarget:apiHandler action:@selector(makeMailchimpCallWithEmailDone:) forRequestEvents:SMWebRequestEventComplete];
    [apiHandler.theWebRequest start];

}

-(void)makeMailchimpCallWithEmailDone:(id)obj
{
    NSLog(@"makeMailchimpCallWithEmailDone: %@", obj);
}
@end
