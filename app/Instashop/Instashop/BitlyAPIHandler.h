//
//  BitlyAPIHandler.h
//  Instashop
//
//  Created by Josh Klobe on 11/22/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "RootAPIHandler.h"

@interface BitlyAPIHandler : RootAPIHandler

+(void)makeBitlyRequestWithDelegate:(id)theDelegate withReferenceURL:(NSString *)referenceURL;
+(void)makeExpandBitlyRequestWithDelegate:(id)theDelegate withReferenceURL:(NSString *)referenceURL;
@end
