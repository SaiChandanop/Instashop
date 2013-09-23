//
//  ViglinkAPIHandler.h
//  Instashop
//
//  Created by Josh Klobe on 9/23/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "RootAPIHandler.h"

@interface ViglinkAPIHandler : RootAPIHandler


+(void)makeViglinkRestCallWithDelegate:(id)theDelegate withReferenceURLString:(NSString *)theURLString;

@end
