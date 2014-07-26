//
//  WebViewController.m
//  Instashop
//  Mostly unused web view container view controller. 
//  Created by A50 Admin on 11/13/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "WebViewController.h"
#import "InstashopWebView.h"
#import "ISConstants.h"
#import "NavBarTitleView.h"
#import "AppRootViewController.h"
@interface WebViewController ()

@end

@implementation WebViewController

@synthesize appRootViewController;
@synthesize titleName;

- (id)initWithWebView:(NSString *) websiteName title:(NSString *) titleName
{
    if (self) {
        // Custom initialization
        
        CGRect screenBound = [[UIScreen mainScreen] bounds];
        CGSize screenSize = screenBound.size;
        CGFloat screenWidth = screenSize.width;
        CGFloat screenHeight = screenSize.height;
        
        NSURL *urlToLoad = [NSURL URLWithString:websiteName];
        
        self.titleName = titleName;
        int topBarHeight = 64.0; // this is the sum of the heights of the status bar and the navigation controller navBar.
        InstashopWebView *webview = [[InstashopWebView alloc] initWithFrame:CGRectMake(0.0, 0.0, screenWidth, screenHeight - topBarHeight)];
        [webview loadRequest:[NSURLRequest requestWithURL:urlToLoad]];
        [self.view addSubview:webview];
    }
    return self;
}

// ran into spring board with error 3 for the first time.


- (void)viewDidLoad
{
    [super viewDidLoad];

    [Utils conformViewControllerToMaxSize:self];
    
    NSLog(@"This is the navigation item: %@", self.navigationController);
    [self.navigationController.navigationBar setBarTintColor:[ISConstants getISGreenColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.translucent = NO;
    
    UIView *homeCustomView = [[UIView alloc] initWithFrame:CGRectMake(0,0, 50, 44)];
    
    UIImageView *homeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"closebutton_white.png"]];
    homeImageView.frame = CGRectMake(0,0,44,44);
    [homeCustomView addSubview:homeImageView];
    
    UIButton *homeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    homeButton.frame = CGRectMake(0,0,homeCustomView.frame.size.width, homeCustomView.frame.size.height);
    homeButton.backgroundColor = [UIColor clearColor];
    [homeButton addTarget:self action:@selector(backButtonHit) forControlEvents:UIControlEventTouchUpInside];
    [homeCustomView addSubview:homeButton];
    
    UIBarButtonItem *homBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:homeCustomView];
    self.navigationItem.leftBarButtonItem = homBarButtonItem;
    [self.navigationItem setTitleView:[NavBarTitleView getTitleViewWithTitleString:self.titleName]];
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.height)];
    bgImageView.image = [UIImage imageNamed:@"Menu_BG"];
    [self.view insertSubview:bgImageView atIndex:0];
}

- (void) backButtonHit {
    NSLog(@"%@ back button hit", self);
    [self.appRootViewController webViewExitButtonHit:self.navigationController];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
