//
//  InstashopWebView.h
//  Instashop
//
//  Created by A50 Admin on 11/13/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InstashopWebView : UIWebView

- (void)loadWithContent:(NSString *)content andFontSize:(int)size;
- (void)loadSpecialWithContent:(NSString *)content andFontSize:(int)size;
- (void)loadWithContent:(NSString *)content withTextColor:(NSString *)tC withLinkColor:(NSString *)lC andFontSize:(int)size;

@end
