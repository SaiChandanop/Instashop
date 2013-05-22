//
//  FirstViewController.m
//  Instashop
//
//  Created by Josh Klobe on 5/22/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "FirstViewController.h"
#import "AppDelegate.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"First", @"First");
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    appDelegate.instagram.accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"];
    appDelegate.instagram.sessionDelegate = self;
    if ([appDelegate.instagram isSessionValid]) {
        NSLog(@"isValid!");
    }
    else
        [appDelegate.instagram authorize:[NSArray arrayWithObjects:@"comments", @"likes", nil]];
    
    
    
	// Do any additional setup after loading the view, typically from a nib.
}

//https://instagram.com/oauth/authorize?response_type=token&redirect_uri=igd63f114e63814512b820b717a73e3ada%3A%2F%2Fauthorize&scope=comments+likes&client_id=d63f114e63814512b820b717a73e3ada

//https://instagram.com/oauth/authorize?response_type=token&redirect_uri=igfd725621c5e44198a5b8ad3f7a0ffa09%3A%2F%2Fauthorize&scope=comments+likes&client_id=fd725621c5e44198a5b8ad3f7a0ffa09


-(void)igDidLogin
{

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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
