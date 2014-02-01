//
//  FlagManagerAPIHandler.m
//  Instashop
//
//  Created by Susan Yee on 10/18/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "FlagManagerAPIHandler.h"

@implementation FlagManagerAPIHandler

+ (void) makeFlagDeclarationRequestComplaint:(NSString*) buttonTitle andProductID:(NSString*) product_ID userID: (NSString *) user_ID delegate:(id) delegate {
    
    NSString *urlRequestString = [NSString stringWithFormat:@"%@/%@", ROOT_URI, @"flag_manager.php"];
//    NSLog(@"urlRequestString: %@", urlRequestString);
    NSMutableURLRequest *URLRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlRequestString]];
    URLRequest.HTTPMethod = @"POST";
    
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    NSString *timeString = [dateFormatter stringFromDate:now];
    
    NSMutableString *postString = [NSMutableString stringWithCapacity:0];
    [postString appendString:[NSString stringWithFormat:@"Product_ID=%@&", product_ID]];
    
    if ([buttonTitle isEqualToString:@"Inappropriate"]) {
        [postString appendString:[NSString stringWithFormat:@"complaint_type=%i&", 1]];
    }
    else if ([buttonTitle isEqualToString:@"Incorrect Link"]) {
        [postString appendString:[NSString stringWithFormat:@"complaint_type=%i&", 2]];
    }
    else if ([buttonTitle isEqualToString:@"Other"]) {
        [postString appendString:[NSString stringWithFormat:@"complaint_type=%i&", 0]];
    }

    // Wasn't sure if you wanted an int or a string stored in the database but saving an int would seem to save more space.
    
    [postString appendString:[NSString stringWithFormat:@"Date=%@&", timeString]];
    [postString appendString:[NSString stringWithFormat:@"User_ID=%@&", user_ID]];
    NSLog(@"This is the postString: %@", postString);

    [URLRequest setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    FlagManagerAPIHandler *flagManagerAPIHandler = [[FlagManagerAPIHandler alloc] init];
    // I don't need a Delegate ID since this complaint is being sent from one place right now.
    flagManagerAPIHandler.delegate = delegate;
    flagManagerAPIHandler.theWebRequest = [SMWebRequest requestWithURLRequest:URLRequest delegate:flagManagerAPIHandler context:NULL];
    [flagManagerAPIHandler.theWebRequest addTarget:flagManagerAPIHandler action:@selector(getComplaintsRequestFinished:) forRequestEvents:SMWebRequestEventComplete];
    [flagManagerAPIHandler.theWebRequest start];
    
    // 1. Get Client server relationship done.    
}

- (void) getComplaintsRequestFinished:(id)obj {
    
    // if else statement needs to go here checking whether php file returned saying that the user already sent complaint about this product or if user had not.
    
    
    NSString* requestDoneStr = [[NSString alloc] initWithData:responseData
                                              encoding:NSUTF8StringEncoding];
    
    [self.delegate showComplaintReceivedAlert:requestDoneStr];
}


@end
