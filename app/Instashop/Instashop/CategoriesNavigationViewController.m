//
//  CategoriesNavigationViewController.m
//  Instashop
//
//  Created by Josh Klobe on 8/7/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "CategoriesNavigationViewController.h"
#import "CategoriesTableViewController.h"
@interface CategoriesNavigationViewController ()

@end

@implementation CategoriesNavigationViewController

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
    
    NSLog(@"%@ viewDidLoad", self);
    CategoriesTableViewController *categoriesTableViewController = [[CategoriesTableViewController alloc] initWithNibName:nil bundle:nil];
    
    [self.view addSubview:categoriesTableViewController.tableView];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
