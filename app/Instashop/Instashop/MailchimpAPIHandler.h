//
//  MailchimpAPIHandler.h
//  Instashop
//
//  Created by Josh Klobe on 1/24/14.
//  Copyright (c) 2014 Josh Klobe. All rights reserved.
//

#import "RootAPIHandler.h"

@interface MailchimpAPIHandler : RootAPIHandler

+(void)makeMailchimpCallWithEmail:(NSString *)theEmail withCategory:(NSString *)category withName:(NSString *)theName;

@end
