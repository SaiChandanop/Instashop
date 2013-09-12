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
}


-(void)refreshContent
{
    NSString *categoryString = nil;
    if ([self.searchRequestObject.searchCategoriesArray count] > 0)
        categoryString = [self.searchRequestObject.searchCategoriesArray objectAtIndex:0];
    
    if (categoryString != nil)
        [SearchAPIHandler makeSellerCategoryRequestWithDelegate:self withCategoryString:categoryString withFreeformTextArray:self.searchRequestObject.searchFreeTextArray];
    

    
    
 //   [self.tableView reloadData];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"numberOfRowsInSection: %d", [self.contentArray count]);
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
    
    [cell loadWithDictionary:[self.contentArray objectAtIndex:indexPath.row]];
    // Configure the cell...
    
    return cell;
}


-(void)searchReturnedWithArray:(NSArray *)searchResultsArray
{
    NSLog(@"searchReturnedWithArray: %@", searchResultsArray);
    [self.contentArray removeAllObjects];
    [self.contentArray addObjectsFromArray:searchResultsArray];
    [self.tableView reloadData];
//    [self feedRequestFinishedWithArrray:searchResultsArray];
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
