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

@synthesize cellSizeQuantityValueDictionary;
@synthesize availableSizesArray;
@synthesize rowShowCount;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
        self.cellSizeQuantityValueDictionary = [[NSMutableDictionary alloc] initWithCapacity:0];
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
    [tableView setSeparatorColor:[UIColor clearColor]];
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"numberOfRowsInSection: %d", self.rowShowCount);
    return self.rowShowCount;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    SizeQuantityTableViewCell *cell = (SizeQuantityTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
    	NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SizeQuantityTableViewCell" owner:self options:nil];
    	cell = (SizeQuantityTableViewCell *)[nib objectAtIndex:0];
    }
    
    
    cell.parentController = self;
    [cell loadWithIndexPath:indexPath withSizeTitle:nil];
    
    
    //    [cell loadWithIndexPath:indexPath withSizeTitle:[self.sizesArray objectAtIndex:indexPath.row]];
  //  if ([[self.sizeSetValuesArray objectAtIndex:indexPath.row] length] > 0)
//        [cell.quantityButton setTitle:[self.sizeSetValuesArray objectAtIndex:indexPath.row] forState:UIControlStateNormal];
    
    
    return cell;
}


-(void)cellSelectedValue:(NSString *)value withIndexPath:(NSIndexPath *)indexPath
{
//    [self.sizeSetValuesArray replaceObjectAtIndex:indexPath.row withObject:value];
}

@end
