//
//  DiscoverTableViewController.m
//  Instashop
//
//  Created by Josh Klobe on 9/11/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "DiscoverTableViewController.h"
#import "DiscoverTableViewCell.h"
#import "ProductAPIHandler.h"

float cellHeight = 151;
@interface DiscoverTableViewController ()

@end

@implementation DiscoverTableViewController

@synthesize sellersObjectsArray;
@synthesize parentController;
@synthesize contentArray;


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
    
    [ProductAPIHandler getAllProductsWithDelegate:self];
    
    
}

-(void)feedRequestFinishedWithArrray:(NSArray *)theArray
{

    self.contentArray = [[NSArray alloc] initWithArray:theArray];
    [self.tableView reloadData];
    
    NSLog(@"cellHeight: %f", cellHeight);
    self.tableView.contentSize = CGSizeMake(0, cellHeight * [self getCount]);

    NSLog(@"self.tableView: %@", self.tableView);
}

                                      
-(int)getCount
{
    return [self.contentArray count] / 2;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    self.tableView.separatorColor = [UIColor clearColor];
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self getCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    DiscoverTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[DiscoverTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier withCellHeight:[self tableView:tableView heightForRowAtIndexPath:indexPath]] autorelease];
    }
    
    
    [cell loadWithIndexPath:indexPath withFeedItemsArray:self.contentArray withDelegate:self.parentController];
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  cellHeight;
}



@end
