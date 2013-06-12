//
//  StripeAuthenticationHandler.h
//  Instashop
//
//  Created by Josh Klobe on 6/10/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "RootAPIHandler.h"
#import "STPCard.h"
@interface StripeAuthenticationHandler : RootAPIHandler

+ (void)createTokenWithCard:(STPCard *)card withDelegate:(id)delegate;
+ (void)buyItemWithToken:(NSString *)theToken withPurchaseAmount:(NSString *)amount withDescription:(NSString *)description;

@end
