//
//  SizeQuantityTableViewController.m
//  Instashop
//
//  Created by Josh Klobe on 7/16/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "SizeQuantityTableViewController.h"
#import "SizeQuantityTableViewCell.h"
@interface SizeQuantityTableViewController ()

@end

@implementation SizeQuantityTableViewController

@synthesize sizeQuantityTableViewCells;
@synthesize sizesArray;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
        self.sizeQuantityTableViewCells = [[NSMutableArray alloc] initWithCapacity:0];
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
        self.sizeQuantityTableViewCells = [[NSMutableArray alloc] initWithCapacity:0];
}



#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    [self.sizeQuantityTableViewCells removeAllObjects];
    [tableView setSeparatorColor:[UIColor clearColor]];
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.sizesArray == nil)
        return 1;
    else
        return [self.sizesArray count];

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    SizeQuantityTableViewCell *cell = [[SizeQuantityTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];

    if (self.sizesArray == nil)
        [cell loadWithIndexPath:indexPath withSizeTitle:nil];
    else
        [cell loadWithIndexPath:indexPath withSizeTitle:[self.sizesArray objectAtIndex:indexPath.row]];
    
    if (![self.sizeQuantityTableViewCells containsObject:cell])
        [self.sizeQuantityTableViewCells addObject:cell];
    
    
    
    return cell;
}


@end
