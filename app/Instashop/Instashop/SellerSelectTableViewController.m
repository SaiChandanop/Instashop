//
//  SellerSelectTableViewController.m
//  Instashop
//
//  Created by Josh Klobe on 9/12/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "SellerSelectTableViewController.h"
#import "SellersTableViewCell.h"

@interface SellerSelectTableViewController ()

@end

@implementation SellerSelectTableViewController

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
    
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Menu_BG"]];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Menu_BG"]];
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
    [self.rowSelectedDelegate rowSelectionOccured:[self.contentArray objectAtIndex:indexPath.row]];
}




-(void)searchReturnedWithArray:(NSArray *)searchResultsArray
{
    [self.contentArray removeAllObjects];
    [self.contentArray addObjectsFromArray:searchResultsArray];
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
//    [self feedRequestFinishedWithArrray:searchResultsArray];
    
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
