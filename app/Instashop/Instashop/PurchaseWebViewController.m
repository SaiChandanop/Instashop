//
//  PurchaseWebViewController.m
//  Instashop
//
//  Created by Josh Klobe on 10/1/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "PurchaseWebViewController.h"

@interface PurchaseWebViewController ()

@end

@implementation PurchaseWebViewController

@synthesize theURLString;
@synthesize theWebView;
@synthesize webSearchBar;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(IBAction)backButtonHit
{
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"loadWithURLString: %@", theURLString);
    
    self.webSearchBar.text = theURLString;
    if ([theURLString rangeOfString:@"http://"].length == 0)
        theURLString = [NSString stringWithFormat:@"http://%@", theURLString];
    
    NSURL *theURL = [NSURL URLWithString:theURLString];
    
    [self.theWebView loadRequest:[NSURLRequest requestWithURL:theURL]];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
