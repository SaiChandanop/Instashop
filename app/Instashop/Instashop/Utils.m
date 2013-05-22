//
//  Utils.m
//  Instashop
//
//  Created by Josh Klobe on 5/22/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "Utils.h"

@implementation Utils


+(NSString *)getEscapedStringFromUnescapedString:(NSString *)unescaped
{
    NSString *escapedString = (NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                                                  NULL,
                                                                                  (CFStringRef)unescaped,
                                                                                  NULL,
                                                                                  CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                                  kCFStringEncodingUTF8);
    
    
    return escapedString;
}
@end
