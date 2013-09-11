//
//  SearchSiloViewController.m
//  Instashop
//
//  Created by Josh Klobe on 9/11/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "SearchSiloViewController.h"
#import "CategoriesTableViewController.h"
#import "SearchButtonContainer.h"
#import "AttributesManager.h"
@interface SearchSiloViewController ()

@end

@implementation SearchSiloViewController


@synthesize theSearchBar;
@synthesize contentContainerView;
@synthesize categoriesNavigationController;
@synthesize searchCategoriesButton;
@synthesize selectedCategoriesArray;
@synthesize searchTermsImageView;
@synthesize freeSearchButtonsArray;
@synthesize searchPromptLabel;
@synthesize separatorImageView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.selectedCategoriesArray = [[NSMutableArray alloc] initWithCapacity:0];
        self.freeSearchButtonsArray = [[NSMutableArray alloc] initWithCapacity:0];
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Menu_BG"]];
    
    self.contentContainerView = [[UIView alloc] initWithFrame:CGRectMake(0,self.separatorImageView.frame.origin.y + self.separatorImageView.frame.size.height,320, self.view.frame.size.height - (self.separatorImageView.frame.origin.x + self.separatorImageView.frame.size.height))];
                                 
    self.contentContainerView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.contentContainerView];
    
    CategoriesTableViewController *productCategoriesTableViewController = [[CategoriesTableViewController alloc] initWithNibName:nil bundle:nil];
    productCategoriesTableViewController.view.backgroundColor = [UIColor clearColor];
    productCategoriesTableViewController.tableView.backgroundColor = [UIColor clearColor];
    productCategoriesTableViewController.positionIndex = 0;
    productCategoriesTableViewController.parentController = self;
    productCategoriesTableViewController.categoriesArray = [[AttributesManager getSharedAttributesManager] getCategoriesWithArray:[NSArray array]];
    
    
    self.categoriesNavigationController = [[UINavigationController alloc] initWithRootViewController:productCategoriesTableViewController];
    [self.categoriesNavigationController setNavigationBarHidden:YES];
    [self.contentContainerView addSubview:categoriesNavigationController.view];
    
    
    self.productSelectTableViewController = [[ProductSelectTableViewController alloc] initWithNibName:@"ProductSelectTableViewController" bundle:nil];
    self.productSelectTableViewController.productRequestorType = PRODUCT_REQUESTOR_TYPE_SEARCH;
    self.productSelectTableViewController.view.frame = CGRectMake(0, 0, self.contentContainerView.frame.size.width, self.contentContainerView.frame.size.height);
    self.productSelectTableViewController.tableView.frame = CGRectMake(0, 0, self.contentContainerView.frame.size.width, self.contentContainerView.frame.size.height);
    self.productSelectTableViewController.tableView.backgroundColor = [UIColor whiteColor];
    
    
}

-(void)runSearch
{
    [self.contentContainerView addSubview:self.productSelectTableViewController.tableView];
    
    NSMutableArray *freeTextArray = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < [self.freeSearchButtonsArray count]; i++)
        [freeTextArray addObject:((SearchButtonContainer *)[self.freeSearchButtonsArray objectAtIndex:i]).searchTerm];
    
    self.productSelectTableViewController.searchRequestObject = [[SearchRequestObject alloc] initWithCategoriesArray:self.selectedCategoriesArray withFreeTextArray:freeTextArray];
    [self.productSelectTableViewController refreshContent];
    NSLog(@"run search");
}

-(void)searchCategoriesButtonHit
{
    NSLog(@"searchCategoriesButtonHit");
    self.searchCategoriesButton.frame = CGRectMake(0,0,0,0);
    [self.selectedCategoriesArray removeAllObjects];
    [self.searchCategoriesButton removeFromSuperview];
    [self.searchCategoriesButton release];
    [self.categoriesNavigationController popToRootViewControllerAnimated:YES];
    [self layoutSearchBarContainers];
}

-(void)categorySelected:(NSString *)theCategory withCallingController:(CategoriesTableViewController *)callingController
{
    if ([self.selectedCategoriesArray count] > callingController.positionIndex)
        [self.selectedCategoriesArray removeObjectsInRange:NSMakeRange(callingController.positionIndex, [self.selectedCategoriesArray count] - callingController.positionIndex)];
    
    [self.selectedCategoriesArray addObject:theCategory];
    
    if ([self.searchCategoriesButton superview] == nil)
    {
        self.searchCategoriesButton = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
        self.searchCategoriesButton.frame = CGRectMake(15, self.searchTermsImageView.frame.origin.y + self.searchTermsImageView.frame.size.height / 8, 0, self.searchTermsImageView.frame.size.height - self.searchTermsImageView.frame.size.height / 16);
        self.searchCategoriesButton.backgroundColor = [UIColor colorWithRed:223.0f/255.0f green:223.0f/255.0f blue:223.0f/255.0f alpha:1];
        self.searchCategoriesButton.titleLabel.textColor = [UIColor colorWithRed:89.0f/255.0f green:89.0f/255.0f blue:89.0f/255.0f alpha:1];
        [self.searchCategoriesButton addTarget:self action:@selector(searchCategoriesButtonHit) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.searchCategoriesButton];
        
    }
    
    NSMutableString *titleString = [NSMutableString stringWithCapacity:0];
    for (int i = 0; i < [self.selectedCategoriesArray count]; i++)
    {
        [titleString appendString:[NSString stringWithFormat:@" %@", [self.selectedCategoriesArray objectAtIndex:i]]];
        if (i != [self.selectedCategoriesArray count] -1)
            [titleString appendString:@" >"];
        
    }
    
    [titleString appendString:@" X "];
    
    CGSize buttonTextSize = [titleString sizeWithFont:self.searchCategoriesButton.titleLabel.font];
    [self.searchCategoriesButton setTitle:titleString forState:UIControlStateNormal];
    self.searchCategoriesButton.frame = CGRectMake(self.searchCategoriesButton.frame.origin.x, self.searchCategoriesButton.frame.origin.y, buttonTextSize.width + 5, self.searchCategoriesButton.frame.size.height);
    
    [self layoutSearchBarContainers];
    
    
    if ([[AttributesManager getSharedAttributesManager] getCategoriesWithArray:self.selectedCategoriesArray] == nil)
    {
        [self runSearch];
    }
    else
    {
        CategoriesTableViewController *categoriesTableViewController = [[CategoriesTableViewController alloc] initWithNibName:nil bundle:nil];
        categoriesTableViewController.view.backgroundColor = [UIColor clearColor];
        categoriesTableViewController.tableView.backgroundColor = [UIColor clearColor];
        categoriesTableViewController.basePriorCategoriesArray = [[NSArray alloc] initWithArray:self.selectedCategoriesArray];
        categoriesTableViewController.positionIndex = callingController.positionIndex + 1;
        categoriesTableViewController.parentController = self;
        categoriesTableViewController.categoriesArray = [[AttributesManager getSharedAttributesManager] getCategoriesWithArray:self.selectedCategoriesArray];
        
        
        UIViewController *containerViewController = [[UIViewController alloc] initWithNibName:nil bundle:nil];
        containerViewController.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Menu_BG"]];
        [containerViewController.view addSubview:categoriesTableViewController.tableView];
        
        categoriesTableViewController.tableView.frame = CGRectMake(0,2, categoriesTableViewController.tableView.frame.size.width, categoriesTableViewController.tableView.frame.size.height);
        
        
        [self.categoriesNavigationController pushViewController:containerViewController animated:YES];
    }
    
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.theSearchBar resignFirstResponder];
    
    
    SearchButtonContainer *searchButtonContainer = [[SearchButtonContainer buttonWithType:UIButtonTypeRoundedRect] retain];
    searchButtonContainer.searchTerm = searchBar.text;
    searchButtonContainer.backgroundColor = [UIColor colorWithRed:223.0f/255.0f green:223.0f/255.0f blue:223.0f/255.0f alpha:1];
    [searchButtonContainer addTarget:self action:@selector(searchButtonContainerHit:) forControlEvents:UIControlEventTouchUpInside];
    [searchButtonContainer setTitle:[NSString stringWithFormat:@"%@ X ", searchBar.text] forState:UIControlStateNormal];
    searchButtonContainer.titleLabel.textColor = [UIColor colorWithRed:89.0f/255.0f green:89.0f/255.0f blue:89.0f/255.0f alpha:1];
    [self.freeSearchButtonsArray addObject:searchButtonContainer];
    
    [self layoutSearchBarContainers];
    searchBar.text = @"";
    
    [self runSearch];
    
}


-(void)layoutSearchBarContainers
{
    
    float indentPoint = self.searchCategoriesButton.frame.origin.x + self.searchCategoriesButton.frame.size.width + 15;
    
    for (int i = 0; i < [self.freeSearchButtonsArray count]; i++)
    {
        UIView *aView = [self.freeSearchButtonsArray objectAtIndex:i];
        [aView removeFromSuperview];
    }
    
    int yPoint = self.searchCategoriesButton.frame.origin.y;
    if (self.searchCategoriesButton == nil)
        yPoint = self.searchTermsImageView.frame.origin.y + self.searchTermsImageView.frame.size.height / 8;
    
    
    for (int i = 0; i < [self.freeSearchButtonsArray count]; i++)
    {
        SearchButtonContainer *buttonContainer = [self.freeSearchButtonsArray objectAtIndex:i];
        
        buttonContainer.frame = CGRectMake(indentPoint, self.searchTermsImageView.frame.origin.y + self.searchTermsImageView.frame.size.height / 8, [buttonContainer.titleLabel.text sizeWithFont:buttonContainer.titleLabel.font].width, self.searchTermsImageView.frame.size.height - self.searchTermsImageView.frame.size.height / 16);
        buttonContainer.titleLabel.text = buttonContainer.searchTerm;
        [self.view addSubview:buttonContainer];
        
        indentPoint = buttonContainer.frame.origin.x + buttonContainer.frame.size.width + 15;
        
    }
    
    if ([self.selectedCategoriesArray count] == 0 && [self.freeSearchButtonsArray count] == 0)
        [self.productSelectTableViewController.tableView removeFromSuperview];
}


-(void)searchButtonContainerHit:(SearchButtonContainer *)theButton
{
    [theButton removeFromSuperview];
    [self.freeSearchButtonsArray removeObject:theButton];
    [self layoutSearchBarContainers];
    
    [self runSearch];
}



@end
