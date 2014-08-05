//
//  PostmasterShipResponseProtocol.h
//  Instashop
//
//  Created by Josh Klobe on 8/20/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PostmasterShipResponseProtocol <NSObject>

-(void)postmasterShipRequestRespondedWithDictionary:(NSDictionary *)theDict;

@end
