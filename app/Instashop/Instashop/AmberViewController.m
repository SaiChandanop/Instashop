//
//  AmberViewController.m
//  Squashed iOS
//
//  Created by Radu Spineanu on 4/25/13.
//  Copyright (c) 2013 Radu Spineanu. All rights reserved.
//

#import "TwoTapAPIHandler.h"
#import "AmberAPIHandler.h"
#import "AmberViewController.h"
#import "Utils.h"
#import "SocialManager.h"
#import <Social/Social.h>
#import "AppDelegate.h"
@interface AmberViewController ()

@end

@implementation AmberViewController

@synthesize amberWebView;
@synthesize loadingView;
@synthesize referenceURLString;
@synthesize referenceImage;
@synthesize viglinkString;
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.backBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@""
                                      style:UIBarButtonItemStyleBordered
                                     target:nil
                                     action:nil];
    
}

-(void)run
{
/*
    NSLog(@"referenceURLString: %@", self.referenceURLString);
    NSLog(@"[self.referenceURLString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]: %@", [self.referenceURLString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
    NSLog(@"[Utils getEscapedStringFromUnescapedString:self.referenceURLString];: %@", [Utils getEscapedStringFromUnescapedString:self.referenceURLString]);
    NSLog(@"[Utils urlencode:self.referenceURLString]: %@", [Utils urlencode:self.referenceURLString]);
    
    UIImageView *theImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"toolbarShopsyLogo.png"]];
    self.navigationItem.titleView = theImageView;

    
    self.referenceURLString = [self.referenceURLString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *customCSSURLString = @"http://instashop.com/test_custom.css";
    
    NSString *amberPath = [AmberAPIHandler getTwoTapURLStringWithReferenceURLString:self.referenceURLString];

    NSString *amberPath = [NSString stringWithFormat:@"https://checkout.twotap.com/?public_token=286b2ac01d5d6139579eb903306333&unique_token=2388&custom_css_url=%@&callback_url=https://amber.io/workers/proposed_recipes/test_callback&show_tutorial=false&products=%@", [Utils getEscapedStringFromUnescapedString:customCSSURLString], [Utils getEscapedStringFromUnescapedString:self.referenceURLString]];


    
    NSLog(@"amberPath: %@", amberPath);
    
    NSURL *amberURL = [NSURL URLWithString:amberPath];
    //NSURLRequest *amberRequestObj = [NSURLRequest requestWithURL:amberURL];
    NSMutableURLRequest *amberRequestObj = [NSMutableURLRequest requestWithURL:amberURL];
    amberRequestObj.HTTPMethod = @"POST";
    [self.amberWebView loadRequest:amberRequestObj];
*/
    [self.amberWebView loadRequest:[TwoTapAPIHandler getTwoTapURLRequestWithProductURLString:self.referenceURLString]];
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

-(void)addCloseButton{
    UIButton *closeAmberViewButton = [[UIButton alloc] initWithFrame:CGRectMake(280, 33, 30, 30)];
    [closeAmberViewButton setTitle:@"✕" forState:UIControlStateNormal];
    closeAmberViewButton.titleLabel.font = [UIFont systemFontOfSize:20.0f];
    [closeAmberViewButton addTarget:self action:@selector(closeAmberView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeAmberViewButton];
}

-(void)closeAmberView{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)openActionSheet
{
    UIActionSheet *shareActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Facebook", @"Twitter", nil];
    shareActionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [shareActionSheet showFromRect:CGRectMake(0,self.view.frame.size.height, self.view.frame.size.width,self.view.frame.size.width) inView:self.view animated:YES];
    
}

- (void) actionSheet:(UIActionSheet *)theActionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSString *buttonTitle = [theActionSheet buttonTitleAtIndex:buttonIndex];
    
    if ([buttonTitle compare:@"Facebook"] == NSOrderedSame)
    {
        [SocialManager requestInitialFacebookAccess];
        
        SLComposeViewController *facebookController = [SLComposeViewController
                                                       composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        SLComposeViewControllerCompletionHandler __block completionHandler=^(SLComposeViewControllerResult result){
                        
            [facebookController dismissViewControllerAnimated:YES completion:nil];
            
            switch(result){
                case SLComposeViewControllerResultCancelled:
                    NSLog(@"SLComposeViewControllerResultCancelled");
                default:
                    break;
                case SLComposeViewControllerResultDone:
                    NSLog(@"SLComposeViewControllerResultDone");
                    break;
            }};
        
        //NSString *postText = [NSString stringWithFormat:@"Checkout @shopsy, the place to shop for products discovered on Instagram"];
        //[facebookController setInitialText:postText];
        [facebookController setInitialText:@"Find this product from Instagram via @ShopsyApp"];
        [facebookController addImage:referenceImage];
        //[facebookController addURL:[NSURL URLWithString:self.viglinkString]];
        [facebookController addURL:[NSURL URLWithString:@"http://shopsy.com/download"]];
        [facebookController setCompletionHandler:completionHandler];
        
        
        [[AppRootViewController sharedRootViewController] presentViewController:facebookController animated:YES completion:nil];
        
        
        
    }
    
    else if ([buttonTitle compare:@"Twitter"] == NSOrderedSame)
    {
        SLComposeViewController *tweetController = [SLComposeViewController
                                                    composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        SLComposeViewControllerCompletionHandler __block completionHandler=^(SLComposeViewControllerResult result){
            
            [tweetController dismissViewControllerAnimated:YES completion:nil];
            
            switch(result){
                case SLComposeViewControllerResultCancelled:
                    NSLog(@"SLComposeViewControllerResultCancelled");
                default:
                    break;
                case SLComposeViewControllerResultDone:
                    NSLog(@"SLComposeViewControllerResultDone");
                    break;
            }};
        
        //NSString *postText = [NSString stringWithFormat:@"Checkout @shopsy, the place to shop for products discovered on Instagram"];
        //[tweetController setInitialText:postText];
        [tweetController setInitialText:@"Find this product from Instagram via @ShopsyApp"];
        [tweetController addImage:referenceImage];
        //[tweetController addURL:[NSURL URLWithString:self.viglinkString]];
        [tweetController addURL:[NSURL URLWithString:@"http://shopsy.com/download"]];
        [tweetController setCompletionHandler:completionHandler];
        
        
        [[AppRootViewController sharedRootViewController] presentViewController:tweetController animated:YES completion:nil];
        
    }
    
    else if ([buttonTitle compare:@"Instagram"] == NSOrderedSame)
    {
        AppDelegate *del = (AppDelegate *)[UIApplication sharedApplication].delegate;
        
        NSURL *instagramURL = [NSURL URLWithString:@"instagram://"];
        if ([[UIApplication sharedApplication] canOpenURL:instagramURL])
        {
            CGRect rect = CGRectMake(0,0,0,0);
            CGRect cropRect=CGRectMake(0,0,612,612);
            NSString *jpgPath=[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/test.ig"];
            CGImageRef imageRef = CGImageCreateWithImageInRect([referenceImage CGImage], cropRect);
            UIImage *img = [UIImage imageNamed:@"AppIcon76x76.png"];//[[UIImage alloc] initWithCGImage:imageRef];
            CGImageRelease(imageRef);
            
            BOOL writeSuccess = [UIImageJPEGRepresentation(img, 1.0) writeToFile:jpgPath atomically:YES];
            
            
            NSURL *igImageHookFile = [[NSURL alloc] initWithString:[[NSString alloc] initWithFormat:@"file://%@",jpgPath]];
            UIDocumentInteractionController *dicot = [UIDocumentInteractionController interactionControllerWithURL:igImageHookFile];
            dicot.delegate = del;
            dicot.UTI = @"com.instagram.photo";
            dicot.annotation = [NSDictionary dictionaryWithObject:PROMOTE_TEXT forKey:@"InstagramCaption"];
            [dicot presentOpenInMenuFromRect: rect  inView: [AppRootViewController sharedRootViewController].view animated: YES ];
            
            
//            [del loadShareCoverViewWithImage:img];
        }
    }
    
}



@end
