//
//  FlagManagerAPIHandler.h
//  Instashop
//
//  Created by Susan Yee on 10/18/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "RootAPIHandler.h"

@interface FlagManagerAPIHandler : RootAPIHandler

+ (void) makeFlagDeclarationRequestComplaint:(NSString *)complaintString andProductID:(NSString*) product_ID userID: (NSString *) user_ID;

@end
