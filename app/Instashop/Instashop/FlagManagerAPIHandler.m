//
//  FlagManagerAPIHandler.m
//  Instashop
//
//  Created by Susan Yee on 10/18/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "FlagManagerAPIHandler.h"

@implementation FlagManagerAPIHandler

+ (void) makeFlagDeclarationRequestComplaint:(NSString *)complaintString andProductID:(NSString*) product_ID userID: (NSString *) user_ID {

    // Should I take into account the Instashop User? - YES
    // Flag the User, time, reason and product.
    
    NSString *urlRequestString = [NSString stringWithFormat:@"%@/%@", ROOT_URI, @"flag_manager.php"];
    NSLog(@"urlRequestString: %@", urlRequestString);
    NSMutableURLRequest *URLRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlRequestString]];
    URLRequest.HTTPMethod = @"POST";
    
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterFullStyle];
    [dateFormatter setTimeStyle:NSDateFormatterFullStyle];
    NSString *timeString = [dateFormatter stringFromDate:now];

    NSMutableString *postString = [NSMutableString stringWithCapacity:0];
    [postString appendString:[NSString stringWithFormat:@"Product_ID=%@&", product_ID]];
    [postString appendString:[NSString stringWithFormat:@"complaint_string=%@&", complaintString]];
    [postString appendString:[NSString stringWithFormat:@"Date=%@&", timeString]];
    [postString appendString:[NSString stringWithFormat:@"User_ID=%@&", user_ID]];

    [URLRequest setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    FlagManagerAPIHandler *flagManagerAPIHandler = [[FlagManagerAPIHandler alloc] init];
    // I don't need a Delegate ID since this complaint is being sent from one place right now.
    flagManagerAPIHandler.theWebRequest = [SMWebRequest requestWithURLRequest:URLRequest delegate:flagManagerAPIHandler context:NULL];
    [flagManagerAPIHandler.theWebRequest addTarget:flagManagerAPIHandler action:@selector(getComplaintsRequestFinished:) forRequestEvents:SMWebRequestEventComplete];
    [flagManagerAPIHandler.theWebRequest start];
    
    // 1. Get Client server relationship done.    
}

- (void) getComplaintsRequestFinished:(id)obj {
    
    // if else statement needs to go here checking whether php file returned saying that the user already sent complaint about this product or if user had not.
    
    NSString* requestDoneStr = [[[NSString alloc] initWithData:responseData
                                              encoding:NSUTF8StringEncoding] autorelease];
    
    NSLog(@"YES, COMPLAINT WAS RECEIVED: %@", requestDoneStr);
}


@end
