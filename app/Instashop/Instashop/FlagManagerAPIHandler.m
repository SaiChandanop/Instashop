//
//  FlagManagerAPIHandler.m
//  Instashop
//
//  Created by Susan Yee on 10/18/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "FlagManagerAPIHandler.h"

@implementation FlagManagerAPIHandler

+ (void) makeFlagDeclarationRequestComplaint:(int)compaintType andProductID:(NSString*) product_ID userID: (NSString *) user_ID delegate:(id) delegate {
    
    NSLog(@"makeFlagDeclarationRequestComplaint");
    NSString *urlRequestString = [NSString stringWithFormat:@"%@/%@", ROOT_URI, @"flag_manager.php"];
    NSMutableURLRequest *URLRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlRequestString]];
    URLRequest.HTTPMethod = @"POST";
    
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    NSString *timeString = [dateFormatter stringFromDate:now];
    
    NSMutableString *postString = [NSMutableString stringWithCapacity:0];
    [postString appendString:[NSString stringWithFormat:@"Product_ID=%@&", product_ID]];
    [postString appendString:[NSString stringWithFormat:@"complaint_type=%i&", compaintType]];
    [postString appendString:[NSString stringWithFormat:@"Date=%@&", timeString]];
    [postString appendString:[NSString stringWithFormat:@"User_ID=%@&", user_ID]];
    NSLog(@"This is the postString: %@", postString);

    [URLRequest setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    FlagManagerAPIHandler *flagManagerAPIHandler = [[FlagManagerAPIHandler alloc] init];
    flagManagerAPIHandler.delegate = delegate;
    flagManagerAPIHandler.theWebRequest = [SMWebRequest requestWithURLRequest:URLRequest delegate:flagManagerAPIHandler context:NULL];
    [flagManagerAPIHandler.theWebRequest addTarget:flagManagerAPIHandler action:@selector(getComplaintsRequestFinished:) forRequestEvents:SMWebRequestEventComplete];
    [flagManagerAPIHandler.theWebRequest start];
    
}

- (void) getComplaintsRequestFinished:(id)obj {
    
    
    NSString* requestDoneStr = [[NSString alloc] initWithData:responseData
                                              encoding:NSUTF8StringEncoding];
    
    [self.delegate showComplaintReceivedAlert:requestDoneStr];
}


@end
