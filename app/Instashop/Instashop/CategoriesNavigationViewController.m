//
//  CategoriesNavigationViewController.m
//  Instashop
//
//  Created by Josh Klobe on 8/7/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "CategoriesNavigationViewController.h"
#import "CategoriesTableViewController.h"
#import "AttributesManager.h"
#import "ProductDetailsViewController.h"

@interface CategoriesNavigationViewController ()

@end

@implementation CategoriesNavigationViewController

@synthesize parentController;
@synthesize selectedCategoriesArray;

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
    
    
    self.selectedCategoriesArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    CategoriesTableViewController *categoriesTableViewController = [[CategoriesTableViewController alloc] initWithNibName:nil bundle:nil];
    categoriesTableViewController.positionIndex = 0;
    categoriesTableViewController.parentController = self;
    categoriesTableViewController.categoriesArray = [[AttributesManager getSharedAttributesManager] getCategoriesWithArray:[NSArray array]];
    [self.view addSubview:categoriesTableViewController.tableView];
    
    categoriesTableViewController.navigationController.navigationBar.topItem.title = @"Categories";
}


-(void)categorySelected:(NSString *)theCategory withCallingController:(CategoriesTableViewController *)callingController
{
    if ([self.selectedCategoriesArray count] > callingController.positionIndex)
        [self.selectedCategoriesArray removeObjectsInRange:NSMakeRange(callingController.positionIndex, [self.selectedCategoriesArray count] - callingController.positionIndex)];
    
    [self.selectedCategoriesArray addObject:theCategory];
    
    
    if ([[AttributesManager getSharedAttributesManager] getCategoriesWithArray:self.selectedCategoriesArray] == nil)
    {
        [self.parentController categorySelectionCompleteWithArray:self.selectedCategoriesArray];
        [self.navigationController popToViewController:parentController animated:YES];
    }
    else
    {
        CategoriesTableViewController *categoriesTableViewController = [[CategoriesTableViewController alloc] initWithNibName:nil bundle:nil];
        categoriesTableViewController.basePriorCategoriesArray = [[NSArray alloc] initWithArray:self.selectedCategoriesArray];
        categoriesTableViewController.positionIndex = callingController.positionIndex + 1;
        categoriesTableViewController.parentController = self;
        categoriesTableViewController.categoriesArray = [[AttributesManager getSharedAttributesManager] getCategoriesWithArray:self.selectedCategoriesArray];
        [self.navigationController pushViewController:categoriesTableViewController animated:YES];
        
        NSMutableString *titleString = [NSMutableString stringWithCapacity:0];
        for (int i = 0; i < [self.selectedCategoriesArray count]; i++)
        {
            [titleString appendString:[NSString stringWithFormat:@" %@", [self.selectedCategoriesArray objectAtIndex:i]]];
            if (i != [self.selectedCategoriesArray count] -1)
                [titleString appendString:@" >"];
            
        }
        
        categoriesTableViewController.navigationController.navigationBar.topItem.title = titleString;
    }
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end