//
//  AmberViewController.m
//  Squashed iOS
//
//  Created by Radu Spineanu on 4/25/13.
//  Copyright (c) 2013 Radu Spineanu. All rights reserved.
//

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
    NSLog(@"referenceURLString: %@", self.referenceURLString);
    NSLog(@"[self.referenceURLString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]: %@", [self.referenceURLString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
    NSLog(@"[Utils getEscapedStringFromUnescapedString:self.referenceURLString];: %@", [Utils getEscapedStringFromUnescapedString:self.referenceURLString]);
    NSLog(@"[Utils urlencode:self.referenceURLString]: %@", [Utils urlencode:self.referenceURLString]);
    
    UIImageView *theImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"toolbarShopsyLogo.png"]];
    self.navigationItem.titleView = theImageView;

    
    self.referenceURLString = [self.referenceURLString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *customCSSURLString = @"http://instashop.com/test_custom.css";
    
    NSString *amberPath = [NSString stringWithFormat:@"https://mobile.amber.io/?public_token=6ad2af4e0e1e2fb08de9&unique_token=2388&test_mode=fake_confirm&custom_css_url=%@&callback_url=https://amber.io/workers/proposed_recipes/test_callback&show_tutorial=false&products=%@", [Utils getEscapedStringFromUnescapedString:customCSSURLString], [Utils getEscapedStringFromUnescapedString:self.referenceURLString]];
        
    //http%3A%2F%2Fwww.footlocker.com%2Fproduct%2Fmodel%3A199142%2Fsku%3A99565600%2Fnike-air-max-stutter-step-mens%2Fred%2Fwhite
    
    NSLog(@"amberPath: %@", amberPath);
    
    NSURL *amberURL = [NSURL URLWithString:amberPath];
    NSURLRequest *amberRequestObj = [NSURLRequest requestWithURL:amberURL];
    [self.amberWebView loadRequest:amberRequestObj];
    
/*    UIImage *shareButtonImage = [UIImage imageNamed:@"more_button.png"];
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithImage:shareButtonImage style:UIBarButtonItemStylePlain target:self action:@selector(openActionSheet)];
    self.navigationItem.rightBarButtonItem = shareButton;
    
  */
   
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
        
        NSString *postText = [NSString stringWithFormat:@"promo!"];
        [facebookController setInitialText:postText];
        [facebookController addImage:referenceImage];
        [facebookController addURL:[NSURL URLWithString:self.viglinkString]];
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
        
        NSString *postText = [NSString stringWithFormat:@"promo!"];
        [tweetController setInitialText:postText];
        [tweetController addImage:referenceImage];
        [tweetController addURL:[NSURL URLWithString:self.viglinkString]];
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
