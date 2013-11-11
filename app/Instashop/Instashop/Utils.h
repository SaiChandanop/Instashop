//
//  Utils.h
//  Instashop
//
//  Created by Josh Klobe on 5/22/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utils : NSObject

+(NSString *)getEscapedStringFromUnescapedString:(NSString *)unescaped;
+ (NSString *)urlencode:(NSString *)theString;
@end
