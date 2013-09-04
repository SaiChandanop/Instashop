//
//  SearchViewController.m
//  Instashop
//
//  Created by Josh Klobe on 9/3/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchAPIHandler.h"
#import "ISConstants.h"
#import "NavBarTitleView.h"
#import "SearchResultTableCell.h"
#import "AppRootViewController.h"
#import "PurchasingViewController.h"
#import "ProfileViewController.h"
#import "AttributesManager.h"
#import "SearchButtonContainer.h"

@interface SearchViewController ()


@end

@implementation SearchViewController

@synthesize appRootViewController;
@synthesize theSearchBar;
@synthesize containerReferenceView;
@synthesize productContainerView;
@synthesize searchResultsArray;
@synthesize productCategoriesNavigationController;
@synthesize searchCategoriesButton;
@synthesize shopsButton;
@synthesize productsButton;
@synthesize hashtagsButton;

@synthesize selectedCategoriesArray;
@synthesize searchTermsImageView;

@synthesize freeSearchButtonsArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.searchResultsArray = [[NSMutableArray alloc] initWithCapacity:0];
        self.selectedCategoriesArray = [[NSMutableArray alloc] initWithCapacity:0];
        
        self.freeSearchButtonsArray = [[NSMutableArray alloc] initWithCapacity:0];
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setBarTintColor:[ISConstants getISGreenColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.translucent = NO;

    UIView *cancelCustomView = [[UIView alloc] initWithFrame:CGRectMake(0,0, 44, 44)];
    
    UIImageView *cancelImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"closebutton_white.png"]];
    cancelImageView.frame = CGRectMake(0,0,44,44);
    [cancelCustomView addSubview:cancelImageView];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(0,0,cancelCustomView.frame.size.width, cancelCustomView.frame.size.height);
    cancelButton.backgroundColor = [UIColor clearColor];
    [cancelButton addTarget:self action:@selector(backButtonHit) forControlEvents:UIControlEventTouchUpInside];
    [cancelCustomView addSubview:cancelButton];
    
    UIBarButtonItem *cancelBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelCustomView];
    self.navigationItem.leftBarButtonItem = cancelBarButtonItem;
    
    [self.navigationItem setTitleView:[NavBarTitleView getTitleViewWithTitleString:@"SEARCH"]];

    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Menu_BG"]];

    self.highlightView.backgroundColor = [ISConstants getISGreenColor];
    
    
    // Do any additional setup after loading the view from its nib.
    
    self.productContainerView = [[UIView alloc] initWithFrame:self.containerReferenceView.frame];
    self.productContainerView.backgroundColor = [UIColor clearColor];
    
    
    CategoriesTableViewController *productCategoriesTableViewController = [[CategoriesTableViewController alloc] initWithNibName:nil bundle:nil];
    productCategoriesTableViewController.view.backgroundColor = [UIColor clearColor];
    productCategoriesTableViewController.tableView.backgroundColor = [UIColor clearColor];
    productCategoriesTableViewController.positionIndex = 0;
    productCategoriesTableViewController.parentController = self;
    productCategoriesTableViewController.categoriesArray = [[AttributesManager getSharedAttributesManager] getCategoriesWithArray:[NSArray array]];

    
    self.productCategoriesNavigationController = [[UINavigationController alloc] initWithRootViewController:productCategoriesTableViewController];
    [self.productCategoriesNavigationController setNavigationBarHidden:YES];
    [self.productContainerView addSubview:productCategoriesNavigationController.view];
                                                   


    [self.containerReferenceView removeFromSuperview];
}

-(void)backButtonHit
{
    [self.theSearchBar resignFirstResponder];
    [self.appRootViewController searchExitButtonHit:self.navigationController];
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    return [self.searchResultsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    SearchResultTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[SearchResultTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier ] autorelease];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    [cell loadWithSearchResultObject:[self.searchResultsArray objectAtIndex:indexPath.row]];
    
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [self.searchResultsArray objectAtIndex:indexPath.row];
    
    switch ([[dict objectForKey:@"type"] integerValue]) {
        case SEARCH_RESULT_TYPE_PRODUCT:
            NSLog(@"");
            PurchasingViewController *purchasingViewController = [[PurchasingViewController alloc] initWithNibName:@"PurchasingViewController" bundle:nil];
            purchasingViewController.requestingProductID = [dict objectForKey:@"id"];
            purchasingViewController.view.frame = CGRectMake(0, 0, purchasingViewController.view.frame.size.width, purchasingViewController.view.frame.size.height);
            [self.navigationController pushViewController:purchasingViewController animated:YES];

            break;
        case SEARCH_RESULT_TYPE_SELLER:
            NSLog(@"");
            
            ProfileViewController *profileViewController = [[ProfileViewController alloc] initWithNibName:@"ProfileViewController" bundle:nil];
            profileViewController.profileInstagramID = [dict objectForKey:@"id"];
            [self.navigationController pushViewController:profileViewController animated:YES];
            
        default:
            break;
    }
    
    
}

-(void)moveHighlightToButton:(UIButton *)theButton
{
    float transitionTime = .15;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:transitionTime];
    [UIView setAnimationDelegate:self];
    self.highlightView.frame = CGRectMake(theButton.frame.origin.x, self.highlightView.frame.origin.y, theButton.frame.size.width, self.highlightView.frame.size.height);
    [UIView commitAnimations];

    
    
    self.shopsButton.selected = NO;
    self.productsButton.selected = NO;
    self.hashtagsButton.selected = NO;
    
    theButton.selected = YES;
}

-(IBAction)shopsButtonHit:(UIButton *)theButton
{
    [self moveHighlightToButton:theButton];
    
    
    [self.productContainerView removeFromSuperview];
    
}

-(IBAction)productsButtonHit:(UIButton *)theButton
{
    [self moveHighlightToButton:theButton];
    
    if ([self.productContainerView superview] == nil)
        [self.view addSubview:self.productContainerView];
         
}

-(IBAction)hashtagButtonHit:(UIButton *)theButton
{
    [self moveHighlightToButton:theButton];    
}


-(void)searchCategoriesButtonHit
{
    NSLog(@"searchCategoriesButtonHit");
    self.searchCategoriesButton.frame = CGRectMake(0,0,0,0);
    [self.selectedCategoriesArray removeAllObjects];
    [self.searchCategoriesButton removeFromSuperview];
    [self.searchCategoriesButton release];
    [self.productCategoriesNavigationController popToRootViewControllerAnimated:YES];
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
//        [self.parentController categorySelectionCompleteWithArray:self.selectedCategoriesArray];
//        [self.navigationController popToViewController:parentController animated:YES];
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
        
        
        [self.productCategoriesNavigationController pushViewController:containerViewController animated:YES];
    }
    
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.searchResultsArray removeAllObjects];
    //    [self.searchResultsTableView reloadData];
    
    [self.theSearchBar resignFirstResponder];
    //    [SearchAPIHandler makeSearchRequestWithDelegate:self withRequestString:searchBar.text];
    
    
    SearchButtonContainer *searchButtonContainer = [[SearchButtonContainer buttonWithType:UIButtonTypeRoundedRect] retain];
    searchButtonContainer.searchTerm = searchBar.text;
    searchButtonContainer.backgroundColor = [UIColor colorWithRed:223.0f/255.0f green:223.0f/255.0f blue:223.0f/255.0f alpha:1];
    [searchButtonContainer addTarget:self action:@selector(searchButtonContainerHit:) forControlEvents:UIControlEventTouchUpInside];
    [searchButtonContainer setTitle:[NSString stringWithFormat:@"%@ X ", searchBar.text] forState:UIControlStateNormal];
    searchButtonContainer.titleLabel.textColor = [UIColor colorWithRed:89.0f/255.0f green:89.0f/255.0f blue:89.0f/255.0f alpha:1];
    [self.freeSearchButtonsArray addObject:searchButtonContainer];
    
    [self layoutSearchBarContainers];
    searchBar.text = @"";
    
}

-(void)searchReturnedWithArray:(NSArray *)theSearchResultsArray
{
    NSLog(@"searchReturnedWithArray: %@", theSearchResultsArray);
    
    [self.searchResultsArray removeAllObjects];
    [self.searchResultsArray addObjectsFromArray:theSearchResultsArray];
    
    //    [self.searchResultsTableView reloadData];
    
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
    
}


-(void)searchButtonContainerHit:(SearchButtonContainer *)theButton
{
    [theButton removeFromSuperview];
    [self.freeSearchButtonsArray removeObject:theButton];
    [self layoutSearchBarContainers];
    
    
}



@end
