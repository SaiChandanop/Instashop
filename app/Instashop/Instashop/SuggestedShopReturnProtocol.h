//
//  SuggestedShopReturnProtocol.h
//  Instashop
//
//  Created by Josh Klobe on 9/1/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SuggestedShopReturnProtocol <NSObject>


-(void)suggestedShopsDidReturn:(NSArray *)suggestedShopArray withCategory:(NSString *)theCategory;

@end
