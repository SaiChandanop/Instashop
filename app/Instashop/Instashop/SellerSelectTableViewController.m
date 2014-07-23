//
//  SellerSelectTableViewController.m
//  Instashop
//  Presentation controller container for searching of bloggers/sellers
//  Created by Josh Klobe on 9/12/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "SellerSelectTableViewController.h"
#import "SellersTableViewCell.h"
#import "SearchViewController.h"
#import "AppDelegate.h"

@interface SellerSelectTableViewController ()

@end

@implementation SellerSelectTableViewController

@synthesize searchResultsArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.searchResultsArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Menu_BG"]];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Menu_BG"]];
    
    self.navigationItem.backBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@""
                                      style:UIBarButtonItemStyleBordered
                                     target:nil
                                     action:nil];
}


-(void)refreshContent
{
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Menu_BG"]];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Menu_BG"]];
    
    NSString *categoryString = @"";
    if ([self.searchRequestObject.searchCategoriesArray count] > 0)
        categoryString = [self.searchRequestObject.searchCategoriesArray objectAtIndex:0];
    
    if (categoryString != nil)
        [SearchAPIHandler makeSellerCategoryRequestWithDelegate:self withCategoryString:categoryString withFreeformTextArray:self.searchRequestObject.searchFreeTextArray];    
}


-(void)searchReturnedWithArray:(NSArray *)theSearchResultsArray
{
    [self.searchResultsArray removeAllObjects];
    [self.contentArray removeAllObjects];
    [self.tableView reloadData];

    
    for (int i = 0; i < [theSearchResultsArray count]; i++)
    {
        NSDictionary *dict = [theSearchResultsArray objectAtIndex:i];
        [self.searchResultsArray addObject:[dict objectForKey:@"instagram_id"]];
        
    }
    
    NSLog(@"self.searchResultsArray: %@", self.searchResultsArray);
    
    
    if ([self.searchResultsArray count] > 0)
    {
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"users/%@", [self.searchResultsArray objectAtIndex:0]], @"method", nil];
        [appDelegate.instagram requestWithParams:params delegate:self];
    }
    else
        [self searchNext];

    
    
}

-(void)searchNext
{
    if ([self.searchResultsArray count] > 0)
        [self.searchResultsArray removeObjectAtIndex:0];
    
    if ([self.searchResultsArray count] > 0)
    {
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"users/%@", [self.searchResultsArray objectAtIndex:0]], @"method", nil];
        [appDelegate.instagram requestWithParams:params delegate:self];
    }
    else
    {
        [self.tableView reloadData];
        [self.refreshControl endRefreshing];
    }
}

- (void)request:(IGRequest *)request didLoad:(id)result {
    [self.contentArray addObject:result];
    [self searchNext];
}


- (void)request:(IGRequest *)request didFailWithError:(NSError *)error
{
    [self searchNext];
}





- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.contentArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    SellersTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[SellersTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (indexPath.row % 2 == 0)
        cell.backgroundColor = [UIColor colorWithRed:208.0f/255.0f green:208.0f/255.0f blue:208.0f/255.0f alpha:1];
    else
        cell.backgroundColor = [UIColor colorWithRed:233.0f/255.0f green:233.0f/255.0f blue:233.0f/255.0f alpha:1];
    
    
    
    [cell loadWithDictionary:[self.contentArray objectAtIndex:indexPath.row]];
    // Configure the cell...
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.rowSelectedDelegate isKindOfClass:[SearchViewController class]])
        [((SearchViewController *)self.rowSelectedDelegate) rowSelectionOccured:[self.contentArray objectAtIndex:indexPath.row]];
}








- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
