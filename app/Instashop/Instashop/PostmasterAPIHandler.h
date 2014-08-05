//
//  PostmasterAPIHandler.h
//  Instashop
//
//  Created by Josh Klobe on 7/8/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "RootAPIHandler.h"

@interface PostmasterAPIHandler : RootAPIHandler

+(void)makePostmasterRatesCallWithDelegate:(id)theDelegate withFromZip:(NSString *)fromZip withToZip:(NSString *)toZip withWeight:(NSString *)weight withCarrier:(NSString *)carrier;

+(void)makePostmasterShipRequestCallWithDelegate:(id)theDelegate withFromDictionary:(NSDictionary *)fromDictionary withToDictionary:(NSDictionary *)toDictionary shippingDictionary:(NSDictionary *)shippingOption withPackageDictionary:(NSDictionary *)packageDictionary;
@end
