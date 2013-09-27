//
//  HTWebView.h
//  HomeTalk
//
//  Created by jay canty on 3/8/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <UIKit/UIKit.h>

// WebView Example is just used in HomeViewController class.  

@interface HTWebView : UIWebView <UIWebViewDelegate>

- (void)loadWithContent:(NSString *)content andFontSize:(int)size;
- (void)loadSpecialWithContent:(NSString *)content andFontSize:(int)size;
- (void)loadWithContent:(NSString *)content withTextColor:(NSString *)tC withLinkColor:(NSString *)lC andFontSize:(int)size;

@end
