//
//  FlagManagerAPIHandler.h
//  Instashop
//
//  Created by Susan Yee on 10/18/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "RootAPIHandler.h"

@protocol FlagManagerProtocol <NSObject>

- (void) showComplaintReceivedAlert:(NSString *) message;

@end

@interface FlagManagerAPIHandler : RootAPIHandler

+ (void) makeFlagDeclarationRequestComplaint:(int)compaintType andProductID:(NSString*) product_ID userID: (NSString *) user_ID delegate:(id) delegate;

@end
