//
//  Utils.m
//  Instashop
//  Workbench class for random necessary usage
//  Created by Josh Klobe on 5/22/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "Utils.h"

@implementation Utils


+(NSString *)getEscapedStringFromUnescapedString:(NSString *)unescaped
{
    NSString *escapedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                  NULL,
                                                                                  (CFStringRef)unescaped,
                                                                                  NULL,
                                                                                  CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                                  kCFStringEncodingUTF8));
    
    
    return escapedString;
}


+(NSString *)getRootURI
{
 
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL staging = [defaults boolForKey:@"staging_preference"];
    
    NSString *retval = @"http://www.shopsy.com/server_source";
    if (staging)
        retval = @"http://www.shopsy.com/staging_source";
    
    NSLog(@"retval!!: %@", retval);
    return retval;
    
}


+ (NSString *)urlencode:(NSString *)theString {
    
    NSMutableString *output = [NSMutableString string];
//    const unsigned char *source = (const unsigned char *)theString;
    const char *source = [theString cStringUsingEncoding:NSASCIIStringEncoding];
    int sourceLen = strlen((const char *)source);
    for (int i = 0; i < sourceLen; ++i) {
        const unsigned char thisChar = source[i];
        if (thisChar == ' '){
            [output appendString:@"+"];
        } else if (thisChar == '.' || thisChar == '-' || thisChar == '_' || thisChar == '~' ||
                   (thisChar >= 'a' && thisChar <= 'z') ||
                   (thisChar >= 'A' && thisChar <= 'Z') ||
                   (thisChar >= '0' && thisChar <= '9')) {
            [output appendFormat:@"%c", thisChar];
        } else {
            [output appendFormat:@"%%%02X", thisChar];
        }
    }
    return output;
}

+(void)destroyObject:(id)theObject
{
 NSLog(@"destroyObject: %@", theObject);
    
}


+(void)conformViewControllerToMaxSize:(UIViewController *)theViewController
{
    if (theViewController.view.frame.size.height > [UIScreen mainScreen].bounds.size.height)
        theViewController.view.frame = CGRectMake(theViewController.view.frame.origin.x, theViewController.view.frame.origin.y, theViewController.view.frame.size.width,[UIScreen mainScreen].bounds.size.height);
    
}


@end
