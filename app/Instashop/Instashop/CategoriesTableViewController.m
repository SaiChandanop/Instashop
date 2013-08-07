//
//  CategoriesTableViewController.m
//  Instashop
//
//  Created by Josh Klobe on 8/7/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "CategoriesTableViewController.h"
#import "CategoriesNavigationViewController.h"
#import "AttributesManager.h"
#import "CategorySelectCell.h"
@interface CategoriesTableViewController ()

@end

@implementation CategoriesTableViewController

@synthesize parentController;
@synthesize categoriesArray;
@synthesize positionIndex;
@synthesize basePriorCategoriesArray;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];


    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    tableView.backgroundColor = [UIColor blackColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    return [self.categoriesArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    CategorySelectCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[CategorySelectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier ] autorelease];
        cell.backgroundColor = [UIColor clearColor];
    }
    
    NSMutableArray *searchCategoriesArray = [NSMutableArray arrayWithCapacity:0];    
    if (self.basePriorCategoriesArray != nil)
        [searchCategoriesArray addObjectsFromArray:self.basePriorCategoriesArray];
    
    [searchCategoriesArray addObject:[self.categoriesArray objectAtIndex:indexPath.row]];
    

    
    if ([[AttributesManager getSharedAttributesManager] getCategoriesWithArray:searchCategoriesArray] != nil)
        cell.disclosureImageView.alpha = 1;
    else
        cell.disclosureImageView.alpha = 0;
    
    cell.theLabel.text = [self.categoriesArray objectAtIndex:indexPath.row];
    
    
    return cell;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.parentController categorySelected:[self.categoriesArray objectAtIndex:indexPath.row] withCallingController:self];
    NSLog(@"didSelectRowAtIndexPath");
}

@end
