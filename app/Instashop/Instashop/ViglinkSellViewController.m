//
//  ViglinkSellViewController.m
//  Instashop
//
//  Created by Josh Klobe on 9/23/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "ViglinkSellViewController.h"
#import "ViglinkAPIHandler.h"

@interface ViglinkSellViewController ()

@end

@implementation ViglinkSellViewController

@synthesize webContainerView, theWebView, webSearchBar;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *searchString = searchBar.text;
    if ([searchString rangeOfString:@"http://"].length == 0)
        searchString = [NSString stringWithFormat:@"http://%@", searchString];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:searchString]];
    [self.theWebView loadRequest:request];
    [searchBar resignFirstResponder];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view addSubview:self.webContainerView];
    
    // Do any additional setup after loading the view from its nib.
}

-(IBAction)selectPageLinkButtonHit
{
    NSString *linkString = [self.theWebView.request.URL absoluteString];

    [ViglinkAPIHandler makeViglinkRestCallWithDelegate:self withReferenceURLString:linkString];
    NSLog(@"linkString: %@", linkString);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
