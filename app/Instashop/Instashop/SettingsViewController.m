//
//  SettingsViewController.m
//  Instashop
//
//  Created by A50 Admin on 11/15/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "NavBarTitleView.h"
#import "SettingsViewController.h"
#import "AppDelegate.h"
#import "InstagramUserObject.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

@synthesize theScrollView;
@synthesize parentController;
@synthesize logoutView;

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
    
    
    self.theScrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    self.theScrollView.contentSize = CGSizeMake(0, self.logoutView.frame.origin.y + self.logoutView.frame.size.height);
    [self.view addSubview:self.theScrollView];
    
    NSLog(@"Yes this code did run");
    
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
    [self.navigationItem setTitleView:[NavBarTitleView getTitleViewWithTitleString:@"Settings"]];
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.height)];
    bgImageView.image = [UIImage imageNamed:@"Menu_BG"];
    [self.view insertSubview:bgImageView atIndex:0];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) privatePolicyButtonHit {
    [self.parentController webViewButtonHit:@"http://instashop.com/privacy" titleName:@"PRIVACY"];
}

-(IBAction)logOutButtonHit
{
    AppDelegate *del = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [del.instagram logout];
    
    [del userDidLogout];
    
    [InstagramUserObject deleteStoredUserObject];
    
    [self.parentController homeButtonHit];
}

- (IBAction) reportBug {
    
}

- (IBAction) termsOfServiceButtonHit {
    
    [self.parentController webViewButtonHit:@"http://instashop.com/terms" titleName:@"TERMS"];
    NSLog(@"Yes, the terms of Service Button was hit");
}

- (void) backButtonHit {
    [self.parentController webViewExitButtonHit:self.navigationController];
}

@end
