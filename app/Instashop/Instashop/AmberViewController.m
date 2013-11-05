//
//  AmberViewController.m
//  Squashed iOS
//
//  Created by Radu Spineanu on 4/25/13.
//  Copyright (c) 2013 Radu Spineanu. All rights reserved.
//

#import "AmberViewController.h"

@interface AmberViewController ()

@end

@implementation AmberViewController

@synthesize amberWebView;
@synthesize loadingView;
@synthesize referenceURLString;

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)run
{
    NSString *amberPath = [NSString stringWithFormat:@"https://mobile.amber.io/?public_token=6ad2af4e0e1e2fb08de9&unique_token=2388&test_mode=fake_confirm&callback_url=https://amber.io/workers/proposed_recipes/test_callback&show_tutorial=false&products=%@", [self.referenceURLString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    //http%3A%2F%2Fwww.footlocker.com%2Fproduct%2Fmodel%3A199142%2Fsku%3A99565600%2Fnike-air-max-stutter-step-mens%2Fred%2Fwhite
    
    NSLog(@"amberPath: %@", amberPath);
    
    NSURL *amberURL = [NSURL URLWithString:amberPath];
    NSURLRequest *amberRequestObj = [NSURLRequest requestWithURL:amberURL];
    [self.amberWebView loadRequest:amberRequestObj];
   
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [UIView animateWithDuration:1.0 animations:^ {
//        self.loadingView.alpha = 0;
    }];
}


- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    if ([[request.URL absoluteString] rangeOfString:@"/done"].location != NSNotFound) {
        
        // Nice pop.
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.75];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.navigationController.view cache:NO];
        [UIView commitAnimations];
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelay:0.375];
        [self.navigationController popViewControllerAnimated:NO];
        [UIView commitAnimations];
        
        return NO;
    }
    
    return YES;
}


@end
