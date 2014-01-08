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
    
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Menu_BG"]];
    
    self.selectedCategoriesArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    CategoriesTableViewController *categoriesTableViewController = [[CategoriesTableViewController alloc] initWithNibName:nil bundle:nil];
    categoriesTableViewController.categoriesType = self.categoriesType;
    categoriesTableViewController.view.backgroundColor = [UIColor clearColor];
    categoriesTableViewController.tableView.backgroundColor = [UIColor clearColor];
    categoriesTableViewController.positionIndex = 0;
    categoriesTableViewController.parentController = self;
    categoriesTableViewController.categoriesArray = [NSArray arrayWithArray:self.potentialCategoriesArray];
    [self.view addSubview:categoriesTableViewController.tableView];
    
    categoriesTableViewController.navigationController.navigationBar.topItem.title = @"Categories";
    
    self.initialTableReference = categoriesTableViewController.tableView;
    
    if (categoriesTableViewController.navigationController.navigationBar.topItem.title == nil)
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
        
        CategoriesTableViewController *categoriesTableViewController = [[CategoriesTableViewController alloc] initWithNibName:nil bundle:nil];
        categoriesTableViewController.categoriesType = self.categoriesType;
        categoriesTableViewController.view.backgroundColor = [UIColor clearColor];
        categoriesTableViewController.tableView.backgroundColor = [UIColor clearColor];
        categoriesTableViewController.basePriorCategoriesArray = [[NSArray alloc] initWithArray:self.selectedCategoriesArray];
        categoriesTableViewController.positionIndex = callingController.positionIndex + 1;
        categoriesTableViewController.parentController = self;
        categoriesTableViewController.categoriesArray = [[AttributesManager getSharedAttributesManager] getCategoriesWithArray:self.selectedCategoriesArray];
        categoriesTableViewController.titleString = titleString;
        
        UIViewController *containerViewController = [[UIViewController alloc] initWithNibName:nil bundle:nil];
        containerViewController.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Menu_BG"]];
        [containerViewController.view addSubview:categoriesTableViewController.tableView];
        categoriesTableViewController.tableView.frame = CGRectMake(0,2, categoriesTableViewController.tableView.frame.size.width, categoriesTableViewController.tableView.frame.size.height);
        [self.navigationController pushViewController:containerViewController animated:YES];
        
        [self setTheTitleWithString:titleString withVC:containerViewController];
        
        /*
        containerViewController.navigationItem.backBarButtonItem =
        [[[UIBarButtonItem alloc] initWithTitle:@""
                                          style:UIBarButtonItemStyleBordered
                                         target:nil
                                         action:nil] autorelease];
        
        self.navigationController.navigationItem.backBarButtonItem =
        [[[UIBarButtonItem alloc] initWithTitle:@""
                                          style:UIBarButtonItemStyleBordered
                                         target:nil
                                         action:nil] autorelease];

        
        self.navigationController.backBarButtonItem =
        [[[UIBarButtonItem alloc] initWithTitle:@""
                                          style:UIBarButtonItemStyleBordered
                                         target:nil
                                         action:nil] autorelease];

        
        categoriesTableViewController.navigationItem.backBarButtonItem =
        [[[UIBarButtonItem alloc] initWithTitle:@""
                                          style:UIBarButtonItemStyleBordered
                                         target:nil
                                         action:nil] autorelease];
        
        categoriesTableViewController.navigationController.navigationItem.backBarButtonItem =
        [[[UIBarButtonItem alloc] initWithTitle:@""
                                          style:UIBarButtonItemStyleBordered
                                         target:nil
                                         action:nil] autorelease];
        
        
        */
        
        
        
        
//        categoriesTableViewController.navigationController.navigationBar.topItem.title = titleString;
    }
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
