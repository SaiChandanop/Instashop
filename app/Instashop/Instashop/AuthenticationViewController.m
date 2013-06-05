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
@interface AuthenticationViewController ()

@end

@implementation AuthenticationViewController

@synthesize loginWebView;


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

-(void)makeLoginRequestWithURL:(NSURL *)theURL
{
    self.loginWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, self.view.frame.size.height - 100)];
    [self.view addSubview:self.loginWebView];
    [self.loginWebView loadRequest:[NSURLRequest requestWithURL:theURL]];
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
    [UserAPIHandler makeUserCreateSellerRequestWithDelegate:self withInstagramUserObject:[InstagramUserObject getStoredUserObject]];   
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
//        NSLog(@"userDict: %@", userDict);
        
        InstagramUserObject *instagramUserObject = [[InstagramUserObject alloc] initWithDictionary:userDict];
        [instagramUserObject setAsStoredUser];
        
        
//        NSLog(@"instagramUserObject: %@", instagramUserObject);
        
//        [UserAPIHandler makeUserCreateRequestWithDelegate:self withInstagramUserObject:instagramUserObject];
        
        AppDelegate *del = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [del userDidLogin];
    }
}







@end
