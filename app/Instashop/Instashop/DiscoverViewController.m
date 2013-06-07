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
    
//    CategoriesAttributesHandler *handler = [CategoriesAttributesHandler sharedCategoryAttributesHandler];
    
    self.discoverTopCategoryTableViewController = [[DiscoverTopCategoryTableViewController alloc] initWithStyle:UITableViewStylePlain];
    self.discoverTopCategoryTableViewController.view.frame = CGRectMake(0,44, self.view.frame.size.width, self.view.frame.size.height - 44);
    [self.view addSubview:self.discoverTopCategoryTableViewController.view];
}







@end
