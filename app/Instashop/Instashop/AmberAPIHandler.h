//
//  AmberAPIHandler.h
//  Instashop
//
//  Created by Josh Klobe on 10/31/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "RootAPIHandler.h"
#import "BitlyResponseHandler.h"

#define TWO_TAP_Public_token @"286b2ac01d5d6139579eb903306333"
#define TWO_TAP_Private token @"9f2d84e9b935fbc013485b1ae57f3691467cc7a98a5dd674e3"
#define TWO_TAP_OAuth_key @"dd90b192a2982f38adbd3fb993d877141bae031f17382f7868664a3677d37b20"
#define TWO_TAP_OAuth_secret @"42445516617bb72f3c869890e39dfe7f81e296051fff6cb9654cef8518f30c33"

@interface AmberAPIHandler : RootAPIHandler <BitlyResponseHandler>
{
    NSMutableArray *supportedSitesArray;
}
//+(void)makeAmberCall;
+(NSString *)getTwoTapURLStringWithReferenceURLString:(NSString *)referenceURLString;
+(void)makeAmberSupportedSiteCallWithReference:(NSString *)referenceURLString withResponseDelegate:(id)delegate;

@property (nonatomic, strong) NSMutableArray *supportedSitesArray;
@end
