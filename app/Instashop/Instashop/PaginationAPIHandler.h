//
//  PaginationAPIHandler.h
//  Instashop
//
//  Created by Josh Klobe on 12/17/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "RootAPIHandler.h"

@interface PaginationAPIHandler : RootAPIHandler

+(void)makePaginationRequestWithDelegate:(id)theDelegate withRequestURLString:(NSString *)requestURLString;
@end
