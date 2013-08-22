//
//  StripeAuthenticationHandler.h
//  Instashop
//
//  Created by Josh Klobe on 6/10/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "RootAPIHandler.h"
#import "STPCard.h"

#define TEST_SECRET_KEY  @"sk_test_uMQ75pJIdtsnlmdWbbWgWcE2"
#define TEST_PUBLISHABLE_KEY @"pk_test_In7Ru0V1t1cRtTEm4Pna3YqQ"


@interface StripeAuthenticationHandler : RootAPIHandler

+ (void)createTokenWithCard:(STPCard *)card withDelegate:(id)delegate;
+(void)buyItemWithToken:(NSString *)theToken withPurchaseAmount:(NSString *)amount withDescription:(NSString *)description withDelegate:(id)delegate;

@end
