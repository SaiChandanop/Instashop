//
//  Utils.h
//  Instashop
//
//  Created by Josh Klobe on 5/22/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <Foundation/Foundation.h>

#define PROMOTE_TEXT @"Download Shopsy now"

@interface Utils : NSObject

+(NSString *)getEscapedStringFromUnescapedString:(NSString *)unescaped;
+ (NSString *)urlencode:(NSString *)theString;
+(void)conformViewControllerToMaxSize:(UIViewController *)theViewController;
@end
