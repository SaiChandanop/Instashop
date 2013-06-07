//
//  DiscoverViewController.m
//  Instashop
//
//  Created by Josh Klobe on 5/31/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "DiscoverViewController.h"
#import "CategoriesAttributesHandler.h"
@interface DiscoverViewController ()

@end

@implementation DiscoverViewController

@synthesize theScrollView;

@synthesize currentTopCategorySelection;


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

    self.theScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,44, self.view.frame.size.width, self.view.frame.size.height - 44)];
    [self.view addSubview:self.theScrollView];
    
    
    self.discoverTopCategoryTableViewController = [[DiscoverTopCategoryTableViewController alloc] initWithStyle:UITableViewStylePlain];
    self.discoverTopCategoryTableViewController.parentController = self;
    self.discoverTopCategoryTableViewController.view.frame = CGRectMake(0,0,self.theScrollView.frame.size.width, self.theScrollView.frame.size.height);
    [self.theScrollView addSubview:self.discoverTopCategoryTableViewController.view];
    
    
    self.theScrollView.contentSize = CGSizeMake(self.theScrollView.frame.size.width * 2, 0);
}

-(void)topCategorySelectedWithString:(NSString *)theString
{
    NSLog(@"topCategorySelectedWithString: %@", theString);
    self.currentTopCategorySelection = theString;
  
    [self.theScrollView setContentOffset:CGPointMake(self.view.frame.size.width * 2, 0) animated:YES];
//    [self.theScrollView scrollRectToVisible:CGRectMake(self.theScrollView.frame.size.width, 0,self.theScrollView.frame.size.width, self.theScrollView.frame.size.height) animated:YES];
    
}





@end
