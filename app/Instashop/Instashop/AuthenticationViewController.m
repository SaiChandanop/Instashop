//
//  AuthenticationViewController.m
//  Instashop
//
//  Created by Josh Klobe on 5/22/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "AuthenticationViewController.h"
#import "AppDelegate.h"
#import "InstagramUserObject.h"
#import "UserAPIHandler.h"
#import "GroupDiskManager.h"
#import "SellersAPIHandler.h"
@interface AuthenticationViewController ()

@end

@implementation AuthenticationViewController

@synthesize loginWebView;

@synthesize instagramLoginWebViewController, backLabel, backButton;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(IBAction) loginButtonHit
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    
    appDelegate.instagram.sessionDelegate = self;
    
    if ([appDelegate.instagram isSessionValid]) {
        NSLog(@"isValid!");
        [self igDidLogin];
    }
    else
      [appDelegate.instagram authorize:[NSArray arrayWithObjects:@"comments", @"likes", nil]];
    
}

-(IBAction) downloadButtonHit
{
    NSURL *webURL = [NSURL URLWithString:@"https://itunes.apple.com/us/app/instagram/id389801252"];
    [[UIApplication sharedApplication] openURL: webURL];
    
}


- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,44,44)];
    backImageView.image = [UIImage imageNamed:@"closebutton.png"];
    [self.loginWebView addSubview:backImageView];
    
    self.backLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    self.backLabel.backgroundColor = [UIColor clearColor];
    self.backLabel.text = @"x";
    self.backLabel.textColor = [UIColor whiteColor];
    self.backLabel.textAlignment = NSTextAlignmentCenter;
    self.backLabel.font = [UIFont systemFontOfSize:14];
    //    [self.loginWebView addSubview:self.backLabel];
    
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backButton.frame = self.backLabel.frame;
    [self.backButton addTarget:self action:@selector(loginBackButtonHit) forControlEvents:UIControlEventTouchUpInside];
    [self.loginWebView addSubview:self.backButton];

}
-(void)makeLoginRequestWithURL:(NSURL *)theURL
{
    
    self.loginWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.loginWebView.delegate = self;
    [self.loginWebView loadRequest:[NSURLRequest requestWithURL:theURL]];

    
    self.instagramLoginWebViewController = [[UIViewController alloc] initWithNibName:nil bundle:nil];
    self.instagramLoginWebViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.instagramLoginWebViewController.view addSubview:self.loginWebView];
    [self presentViewController:self.instagramLoginWebViewController animated:YES completion:nil];
    
}

-(void)loginBackButtonHit
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)igDidLogin
{
    [self.loginWebView removeFromSuperview];
    NSLog(@"Instagram did login");
    // here i can store accessToken
    AppDelegate* appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [[NSUserDefaults standardUserDefaults] setObject:appDelegate.instagram.accessToken forKey:@"accessToken"];
	[[NSUserDefaults standardUserDefaults] synchronize];
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"users/self", @"method", nil];
    [appDelegate.instagram requestWithParams:params
                                    delegate:self];
    
    [appDelegate userDidLogin];
    
    [self.loginWebView removeFromSuperview];
 
    UIButton *buyerButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    buyerButton.frame = CGRectMake(self.view.frame.size.width / 2 - 50, self.view.frame.size.height / 2 - 40, 100, 40);
    [buyerButton setTitle:@"buyer" forState:UIControlStateNormal];
    [buyerButton addTarget:self action:@selector(buyerButtonHit) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buyerButton];
    
    UIButton *sellerButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    sellerButton.frame = CGRectMake(buyerButton.frame.origin.x, buyerButton.frame.origin.y + buyerButton.frame.size.height + 10, buyerButton.frame.size.width, buyerButton.frame.size.height);
    [sellerButton setTitle:@"seller" forState:UIControlStateNormal];
    [sellerButton addTarget:self action:@selector(sellerButtonHit) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sellerButton];
}

-(void)buyerButtonHit
{
    
}

-(void)sellerButtonHit
{
//    [SellersAPIHandler makeCreateSellerRequestWithDelegate:self withInstagramUserObject:[InstagramUserObject getStoredUserObject] ];
}
-(void)igDidNotLogin:(BOOL)cancelled
{
    
}

-(void)igDidLogout
{
    
}

-(void)igSessionInvalidated
{
    
}

- (void)request:(IGRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"Instagram did fail: %@", error);
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:[error localizedDescription]
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
    [alertView show];
}

- (void)request:(IGRequest *)request didLoad:(id)result {
    
    NSLog(@"Instagram did load: %@", result);
    
    NSDictionary *metaDictionary = [result objectForKey:@"meta"];
    if ([[metaDictionary objectForKey:@"code"] intValue] == 200)
    {
        NSDictionary *userDict = [result objectForKey:@"data"];

        InstagramUserObject *instagramUserObject = [[InstagramUserObject alloc] initWithDictionary:userDict];
        [instagramUserObject setAsStoredUser:instagramUserObject];
        
        [UserAPIHandler makeBuyerCreateRequestWithDelegate:self withInstagramUserObject:instagramUserObject];
        
        AppDelegate *del = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [del userDidLogin];
        
        [SellersAPIHandler makeCheckIfSellerExistsCallWithDelegate:self];
    }
}





-(void)sellerExistsCallReturned
{
    AppDelegate* appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate.appRootViewController.homeViewController loadStates];
}








@end
