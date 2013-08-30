//
//  SellerDetailResponseProtocol.h
//  Instashop
//
//  Created by Josh Klobe on 8/30/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SellerDetailResponseProtocol <NSObject>


-(void)sellerDetailsResopnseDidOccurWithDictionary:(NSDictionary *)responseDictionary;
@end
