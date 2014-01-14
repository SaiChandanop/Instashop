//
//  CategoriesNavigationViewController.m
//  Instashop
//
//  Created by Josh Klobe on 8/7/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "CategoriesViewController.h"
#import "CategoriesTableViewController.h"
#import "AttributesManager.h"
#import "ProductDetailsViewController.h"
#import "EnterEmailViewController.h"

@interface CategoriesViewController ()

@end

@implementation CategoriesViewController

@synthesize parentController;
@synthesize categoriesType;
@synthesize potentialCategoriesArray;
@synthesize selectedCategoriesArray;
@synthesize initialTableReference;
@synthesize initialCategoriesTableViewController;
@synthesize categoriesTableViewController;
@synthesize subtableContainerViewsArray;

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
    
    self.subtableContainerViewsArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Menu_BG"]];
    
    self.selectedCategoriesArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    self.initialCategoriesTableViewController = [[CategoriesTableViewController alloc] initWithNibName:nil bundle:nil];
    self.initialCategoriesTableViewController.categoriesType = self.categoriesType;
    self.initialCategoriesTableViewController.view.backgroundColor = [UIColor clearColor];
    self.initialCategoriesTableViewController.tableView.backgroundColor = [UIColor clearColor];
    self.initialCategoriesTableViewController.positionIndex = 0;
    self.initialCategoriesTableViewController.parentController = self;
    self.initialCategoriesTableViewController.categoriesArray = [NSArray arrayWithArray:self.potentialCategoriesArray];
    [self.view addSubview:self.initialCategoriesTableViewController.tableView];
    
    self.initialCategoriesTableViewController.navigationController.navigationBar.topItem.title = @"Categories";
    
    self.initialTableReference = self.initialCategoriesTableViewController.tableView;
    
    if (self.initialCategoriesTableViewController.navigationController.navigationBar.topItem.title == nil)
    {
        [self setTheTitleWithString:@"Categories" withVC:self];
    }
    
    self.navigationItem.backBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@""
                                      style:UIBarButtonItemStyleBordered
                                     target:nil
                                     action:nil];
   
    

}

-(void)setTheTitleWithString:(NSString *)theString withVC:(UIViewController *)theVC
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:20.0];
    label.textAlignment = NSTextAlignmentCenter;
    // ^-Use UITextAlignmentCenter for older SDKs.
    label.textColor = [UIColor whiteColor]; // change this color
    theVC.navigationItem.titleView = label;
    label.text = theString;
    [label sizeToFit];
    

    self.navigationItem.backBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@""
                                      style:UIBarButtonItemStyleBordered
                                     target:nil
                                     action:nil];
    
}


-(void)categorySelected:(NSString *)theCategory withCallingController:(CategoriesTableViewController *)callingController
{
 
    
    
    if ([self.selectedCategoriesArray count] > callingController.positionIndex)
        [self.selectedCategoriesArray removeObjectsInRange:NSMakeRange(callingController.positionIndex, [self.selectedCategoriesArray count] - callingController.positionIndex)];
    
    [self.selectedCategoriesArray addObject:theCategory];
    
    
    if ([self.parentController isKindOfClass:[EnterEmailViewController class]])
         {
             [self.parentController categorySelectionCompleteWithArray:self.selectedCategoriesArray];
         }
    
    
    if ([[AttributesManager getSharedAttributesManager] getCategoriesWithArray:self.selectedCategoriesArray] == nil || self.categoriesType == CATEGORIES_TYPE_SELLER)
    {
        [self.parentController categorySelectionCompleteWithArray:self.selectedCategoriesArray];
        [self.navigationController popToViewController:parentController animated:YES];
    }
    else
    {
        NSMutableString *titleString = [NSMutableString stringWithCapacity:0];
        for (int i = 0; i < [self.selectedCategoriesArray count]; i++)
        {
            [titleString appendString:[NSString stringWithFormat:@" %@", [self.selectedCategoriesArray objectAtIndex:i]]];
            if (i != [self.selectedCategoriesArray count] -1)
                [titleString appendString:@" >"];
            
        }
        
        self.categoriesTableViewController = [[CategoriesTableViewController alloc] initWithNibName:nil bundle:nil];
        self.categoriesTableViewController.categoriesType = self.categoriesType;
        self.categoriesTableViewController.view.backgroundColor = [UIColor clearColor];
        self.categoriesTableViewController.tableView.backgroundColor = [UIColor clearColor];
        self.categoriesTableViewController.basePriorCategoriesArray = [[NSArray alloc] initWithArray:self.selectedCategoriesArray];
        self.categoriesTableViewController.positionIndex = callingController.positionIndex + 1;
        self.categoriesTableViewController.parentController = self;
        self.categoriesTableViewController.categoriesArray = [[AttributesManager getSharedAttributesManager] getCategoriesWithArray:self.selectedCategoriesArray];
        self.categoriesTableViewController.titleString = titleString;
        [self.subtableContainerViewsArray addObject:self.categoriesTableViewController];
        
        self.categoriesTableViewController.navigationItem.backBarButtonItem =
        [[UIBarButtonItem alloc] initWithTitle:@""
                                         style:UIBarButtonItemStyleBordered
                                        target:nil
                                        action:nil];
        
        
        UIViewController *containerViewController = [[UIViewController alloc] initWithNibName:nil bundle:nil];
        containerViewController.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Menu_BG"]];
        [containerViewController.view addSubview:self.categoriesTableViewController.tableView];
        self.categoriesTableViewController.tableView.frame = CGRectMake(0,2, categoriesTableViewController.tableView.frame.size.width, categoriesTableViewController.tableView.frame.size.height);
        [self.navigationController pushViewController:containerViewController animated:YES];
        
        [self setTheTitleWithString:titleString withVC:containerViewController];
        

        containerViewController.navigationItem.backBarButtonItem =
        [[UIBarButtonItem alloc] initWithTitle:@""
                                          style:UIBarButtonItemStyleBordered
                                         target:nil
                                         action:nil];
        
        self.navigationController.navigationItem.backBarButtonItem =
        [[UIBarButtonItem alloc] initWithTitle:@""
                                          style:UIBarButtonItemStyleBordered
                                         target:nil
                                        action:nil];

        
        
        
        
        
//        categoriesTableViewController.navigationController.navigationBar.topItem.title = titleString;
    }
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
