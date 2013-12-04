//
//  AmberAPIHandler.h
//  Instashop
//
//  Created by Josh Klobe on 10/31/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "RootAPIHandler.h"
#import "BitlyResponseHandler.h"

@interface AmberAPIHandler : RootAPIHandler <BitlyResponseHandler>
{
    NSMutableArray *supportedSitesArray;
}
+(void)makeAmberCall;
+(void)makeAmberSupportedSiteCallWithReference:(NSString *)referenceURLString withResponseDelegate:(id)delegate;

@property (nonatomic, retain) NSMutableArray *supportedSitesArray;
@end
