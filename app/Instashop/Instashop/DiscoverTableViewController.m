//
//  DiscoverTableViewController.m
//  Instashop
//  DiscoverViewController's table view controller
//  Created by Josh Klobe on 9/11/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "DiscoverViewController.h"
#import "DiscoverTableViewController.h"
#import "DiscoverTableViewCell.h"
#import "ProductAPIHandler.h"
#import "MediaLikedObject.h"
#import "DiscoverDataManager.h"

float cellHeight = 151;
@interface DiscoverTableViewController ()

@end

@implementation DiscoverTableViewController


@synthesize parentController;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
        
        // Custom initialization
    }
    return self;
}

-(void)doPresentData
{
    [self.tableView reloadData];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.contentArray = [[NSMutableArray alloc] initWithCapacity:0];
    [self.contentArray addObjectsFromArray:[DiscoverDataManager getSharedDiscoverDataManager].contentArray];
    [self.tableView reloadData];
    
  
    
    if ([[DiscoverDataManager getSharedDiscoverDataManager].contentArray count] == 0)
        [DiscoverDataManager getSharedDiscoverDataManager].referenceTableViewController = self;
    
    
    self.navigationItem.backBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@""
                                      style:UIBarButtonItemStyleBordered
                                     target:nil
                                     action:nil];

    if ([[DiscoverDataManager getSharedDiscoverDataManager].contentArray count] == 0)
        self.jkProgressView = [JKProgressView presentProgressViewInView:self.view withText:@"Loading..."];
 
    
    DiscoverDataManager *theManager = [DiscoverDataManager getSharedDiscoverDataManager];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:theManager action:@selector(updateData)
             forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    
}


-(int)getCount
{
    int count = [self.contentArray count] / 2;
    
    if (count > 0)
    {
        [self.jkProgressView hideProgressView];
        
        for (int i = 0; i < [[self.view subviews] count]; i++)
        {
            UIView *theView = [[self.view subviews] objectAtIndex:i];
            if ([theView isKindOfClass:[JKProgressView class]])
                [theView removeFromSuperview];
            
        }
    }
    return count;
    
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
        cell = [[DiscoverTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier withCellHeight:[self tableView:tableView heightForRowAtIndexPath:indexPath]];
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
