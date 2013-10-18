//
//  FlagManagerAPIHandler.m
//  Instashop
//
//  Created by Susan Yee on 10/18/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "FlagManagerAPIHandler.h"

@implementation FlagManagerAPIHandler

+ (void) makeFlagDeclarationRequestComplaint:(NSString *)complaintString andProductID:(NSString*) product_ID {

    // Should I take into account the Instashop User?
    
    NSString *urlRequestString = [NSString stringWithFormat:@"%@/%@", ROOT_URI, @"create_product.php"];
    NSMutableURLRequest *URLRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlRequestString]];
    URLRequest.HTTPMethod = @"POST";

    NSMutableString *postString = [NSMutableString stringWithCapacity:0];
    [postString appendString:[NSString stringWithFormat:@"Product_ID=%@&", product_ID]];
    [postString appendString:[NSString stringWithFormat:@"complaint_string=%@&", complaintString]];
    
    [URLRequest setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    FlagManagerAPIHandler *flagManagerAPIHandler = [[FlagManagerAPIHandler alloc] init];
//    productAPIHandler.delegate = delegate;
    flagManagerAPIHandler.theWebRequest = [SMWebRequest requestWithURLRequest:URLRequest delegate:flagManagerAPIHandler context:NULL];
    [flagManagerAPIHandler.theWebRequest start];

    
}

@end
