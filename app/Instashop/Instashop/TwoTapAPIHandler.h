//
//  TwoTapAPIHandler.h
//  Instashop
//
//  Created by Josh Klobe on 7/28/14.
//  Copyright (c) 2014 Josh Klobe. All rights reserved.
//

#import "RootAPIHandler.h"

@interface TwoTapAPIHandler : RootAPIHandler


+(NSMutableURLRequest *)getTwoTapURLRequestWithProductURLString:(NSString *)productURLString;
@end