//
//  ShopsAPIHandler.h
//  Instashop
//
//  Created by Josh Klobe on 9/1/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RootAPIHandler.h"


@interface ShopsAPIHandler : RootAPIHandler


+(void)getSuggestedShopsWithDelegate:(id)theDelegate;

@end
