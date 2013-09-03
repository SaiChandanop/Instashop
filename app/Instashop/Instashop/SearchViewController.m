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
@interface SearchViewController ()


@end

@implementation SearchViewController

@synthesize appRootViewController;
@synthesize theSearchBar;
@synthesize searchResultsTableView;
@synthesize searchResultsArray;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.searchResultsArray = [[NSMutableArray alloc] initWithCapacity:0];
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
    
    [self.navigationItem setTitleView:[NavBarTitleView getTitleViewWithTitleString:@"SELECT A PHOTO"]];

    
    
    
    // Do any additional setup after loading the view from its nib.
}

-(void)backButtonHit
{
    [self.theSearchBar resignFirstResponder];
    [self.appRootViewController searchExitButtonHit:self.navigationController];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.searchResultsArray removeAllObjects];
    [self.searchResultsTableView reloadData];
    
    [self.theSearchBar resignFirstResponder];
    [SearchAPIHandler makeSearchRequestWithDelegate:self withRequestString:searchBar.text];
    
}

-(void)searchReturnedWithArray:(NSArray *)theSearchResultsArray
{
    NSLog(@"searchReturnedWithArray: %@", theSearchResultsArray);
    
    [self.searchResultsArray removeAllObjects];
    [self.searchResultsArray addObjectsFromArray:theSearchResultsArray];
    
    [self.searchResultsTableView reloadData];
    
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
            
        default:
            break;
    }
    
    
}







@end
