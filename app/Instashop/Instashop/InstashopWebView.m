//
//  InstashopWebView.m
//  Instashop
//
//  Created by A50 Admin on 11/13/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "InstashopWebView.h"

@interface InstashopWebView()

@property (nonatomic, assign) BOOL initialCall;

@property (nonatomic, strong) NSString *textColor;
@property (nonatomic, strong) NSString *linkColor;

@end

@implementation InstashopWebView

@synthesize initialCall;

@synthesize textColor, linkColor;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (NSString *)washHrefsWithString:(NSString *)content
{
    NSString *beginTag = @"<a href";
    while ([content rangeOfString:beginTag].length > 0)
    {
        NSString *beginHTMLTag = @"<a href=\"";
        NSString *endATag =      @"</a>";
        
        NSRange startRange = [content rangeOfString:beginHTMLTag];
        NSRange endRange = [content rangeOfString:endATag];
        NSString *hrefString = [content substringWithRange:NSMakeRange(startRange.location, endRange.location + endRange.length - startRange.location)];
        
        NSRange beginURLRange = [hrefString rangeOfString:beginHTMLTag];
        NSRange endURLRange = [hrefString rangeOfString:@"\" rel"];
        NSString *urlString = [hrefString substringWithRange:NSMakeRange(beginURLRange.location + beginURLRange.length, endURLRange.location - beginURLRange.location - beginURLRange.length)];
        
        content = [content stringByReplacingOccurrencesOfString:hrefString withString:urlString];
    }
    return content;
}



- (void)loadWithContent:(NSString *)content andFontSize:(int)size
{
    // Initialization code
    
    //NSLog(@"%s - %@", __func__, content);
    
    self.delegate = self;
    self.initialCall = YES;
    self.dataDetectorTypes = UIDataDetectorTypeAll;
    self.scrollView.scrollEnabled = NO;
    self.scrollView.bounces = NO;
    [self setOpaque:FALSE];
    [self setBackgroundColor:[UIColor clearColor]];
    
    content = [self washHrefsWithString:content];
    
    NSString *head = [NSString stringWithFormat:@"<html id=\"foo\"><head></head><body text=\"#61717d\" link=\"#61717d\" style=\"background-color: transparent; font-family: Helvetica; font-size:%dpx\"><p> ", size];
    NSString *tail = @" </p></body></html>";
    content = [content stringByReplacingOccurrencesOfString:@"\n" withString:@"<br/>"];
    content = [content stringByReplacingOccurrencesOfString:@"\b" withString:@"<br/>"];
    
    NSString *body = [NSString stringWithFormat:@"%@ %@ %@", head, content, tail];
    
    //NSLog(@"%s - %@", __func__, body);
    
    [self loadHTMLString:body baseURL:nil];
}

- (void)loadSpecialWithContent:(NSString *)content andFontSize:(int)size
{
    // Initialization code
    
    //NSLog(@"%s - %@", __func__, content);
    
    self.delegate = self;
    self.initialCall = YES;
    self.dataDetectorTypes = UIDataDetectorTypeAll;
    self.scrollView.scrollEnabled = NO;
    self.scrollView.bounces = NO;
    [self setOpaque:FALSE];
    [self setBackgroundColor:[UIColor clearColor]];
    
    NSString *head = [NSString stringWithFormat:@"<html id=\"foo\"><head></head><body text=\"#61717d\" link=\"#61717d\" style=\"background-color: transparent; font-family: Helvetica; font-size:%dpx\"><p> ", size];
    NSString *tail = @" </p></body></html>";
    content = [content stringByReplacingOccurrencesOfString:@"\n" withString:@"<br/>"];
    content = [content stringByReplacingOccurrencesOfString:@"\b" withString:@"<br/>"];
    
    NSString *body = [NSString stringWithFormat:@"%@ %@ %@", head, content, tail];
    
    //NSLog(@"%s - %@", __func__, body);
    
    [self loadHTMLString:body baseURL:nil];
}

- (void)loadWithContent:(NSString *)content withTextColor:(NSString *)tC withLinkColor:(NSString *)lC andFontSize:(int)size
{
    // Initialization code
    
    //\"#61717d\"
    //\"#000000\"
    
    //NSLog(@"%s - %@", __func__, content);
    
    self.delegate = self;
    self.initialCall = YES;
    self.dataDetectorTypes = UIDataDetectorTypeAll;
    self.scrollView.scrollEnabled = NO;
    self.scrollView.bounces = NO;
    [self setOpaque:FALSE];
    [self setBackgroundColor:[UIColor clearColor]];
    
    content = [self washHrefsWithString:content];
    
    
    NSString *head = [NSString stringWithFormat:@"<html id=\"foo\"><head></head><body text=%@ link=%@ style=\"background-color: transparent; font-family: Helvetica; font-size:%dpx\"><p> ", tC, lC, size];
    NSString *tail = @" </p></body></html>";
    content = [content stringByReplacingOccurrencesOfString:@"\n" withString:@"<br/>"];
    content = [content stringByReplacingOccurrencesOfString:@"\b" withString:@"<br/>"];
    
    NSString *body = [NSString stringWithFormat:@"%@ %@ %@", head, content, tail];
    
    //NSLog(@"%s - %@", __func__, body);
    
    [self loadHTMLString:content baseURL:nil];
}


#pragma mark - web view delegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    //NSLog(@"%s", __func__);
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //NSLog(@"%s", __func__);
    //NSString *output = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementById(\"foo\").offsetHeight;"];
    //NSLog(@"%s height: %@", __func__, output);
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"%s - %@", __func__, error.userInfo);
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (self.initialCall)
    {
        self.initialCall = NO;
        return YES;
    }
    else                                                                                // check for mailto
    {
        NSLog(@"REQ: %s - %@", __func__, request);
        
        NSString *rS = [request.URL absoluteString];
        NSRange range = [rS rangeOfString:@"http://"];
        
        if (range.location != NSNotFound && range.location > 0)
        {
            rS = [rS substringWithRange:NSMakeRange(range.location, [rS length] - range.location)];
            //[[RootViewController sharedController] loadLinkInBrowser:[NSURL URLWithString:rS]];
        }
        else if (range.location != NSNotFound) {
            
        }
        //[[RootViewController sharedController] loadLinkInBrowser:[NSURL URLWithString:rS]];
        else
            return YES;
        
        
        return NO;
    }
}

-(void) dealloc
{
    
    /*
     switch (DEALLOC_LOG_LEVEL) {
     case DEALLOC_LOG_LEVEL_ALL:
     NSLog(@"deallocing: %@", [self class]);
     break;
     
     case DEALLOC_LOG_LEVEL_EXCLUDE:
     NSLog(@"");
     BOOL proceed = YES;
     if ([[[self class] description] rangeOfString:@"APIHandler"].length > 0)
     proceed = NO;
     if(proceed)
     NSLog(@"deallocing: %@", [self class]);
     break;
     
     default:
     break;
     }*/
    
    self.textColor;
    self.linkColor;
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
