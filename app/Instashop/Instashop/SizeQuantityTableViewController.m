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

@synthesize sizeSetValuesArray;
@synthesize sizesArray;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.sizeSetValuesArray = [[NSMutableArray alloc] initWithCapacity:0];
}



#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    [self.sizeSetValuesArray removeAllObjects];
    [tableView setSeparatorColor:[UIColor clearColor]];
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.sizesArray == nil)
    {
        [self.sizeSetValuesArray addObject:@""];
        return 1;
    }
    else
    {
        for (int i = 0; i < [self.sizesArray count]; i++)
            [self.sizeSetValuesArray addObject:@""];
        
        return [self.sizesArray count];
        
    }

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    SizeQuantityTableViewCell *cell = [[SizeQuantityTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];

    cell.parentController = self;
    if (self.sizesArray == nil)
        [cell loadWithIndexPath:indexPath withSizeTitle:nil];
    else
        [cell loadWithIndexPath:indexPath withSizeTitle:[self.sizesArray objectAtIndex:indexPath.row]];
        
    if ([[self.sizeSetValuesArray objectAtIndex:indexPath.row] length] > 0)
        [cell.quantityButton setTitle:[self.sizeSetValuesArray objectAtIndex:indexPath.row] forState:UIControlStateNormal];
        
    
    return cell;
}


-(void)cellSelectedValue:(NSString *)value withIndexPath:(NSIndexPath *)indexPath
{
    [self.sizeSetValuesArray replaceObjectAtIndex:indexPath.row withObject:value];
    
    NSLog(@"cellSelectedValue self.sizeSetValuesArray: %@", self.sizeSetValuesArray);
}

@end
