//
//  CategoriesTableViewController.m
//  Instashop
//
//  Created by Josh Klobe on 8/7/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "CategoriesTableViewController.h"
#import "CategoriesViewController.h"
#import "AttributesManager.h"
#import "CategorySelectCell.h"
#import "EnterEmailViewController.h"
@interface CategoriesTableViewController ()

@end

@implementation CategoriesTableViewController

@synthesize parentController;
@synthesize categoriesType;
@synthesize categoriesArray;
@synthesize positionIndex;
@synthesize basePriorCategoriesArray;
@synthesize titleString;

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
    
    self.navigationItem.backBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@""
                                      style:UIBarButtonItemStyleBordered
                                     target:nil
                                     action:nil];
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    return [self.categoriesArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    CategorySelectCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[CategorySelectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier ];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    
    NSMutableArray *searchCategoriesArray = [NSMutableArray arrayWithCapacity:0];
    if (self.basePriorCategoriesArray != nil)
        [searchCategoriesArray addObjectsFromArray:self.basePriorCategoriesArray];
    
    [searchCategoriesArray addObject:[self.categoriesArray objectAtIndex:indexPath.row]];
    

    
    if ([[AttributesManager getSharedAttributesManager] getCategoriesWithArray:searchCategoriesArray] != nil && self.categoriesType == CATEGORIES_TYPE_PRODUCT)
        cell.disclosureImageView.alpha = 1;
    else
        cell.disclosureImageView.alpha = 0;
    
    cell.theLabel.text = [self.categoriesArray objectAtIndex:indexPath.row];
    
    if (indexPath.row %2 == 0)
        cell.bgView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"menuDarkBG.png"]];
    else
        cell.bgView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"menuLightBG.png"]];

    
    if (self.parentController.parentController != nil)
    {
        if ([self.parentController.parentController isKindOfClass:[EnterEmailViewController class]])
            cell.disclosureImageView.alpha = 0;
    }

    
    return cell;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.parentController categorySelected:[self.categoriesArray objectAtIndex:indexPath.row] withCallingController:self];
}

@end
