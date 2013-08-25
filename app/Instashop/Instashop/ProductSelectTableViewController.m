//
//  ProductSelectTableViewController.m
//  Instashop
//
//  Created by Josh Klobe on 6/4/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "ProductSelectTableViewController.h"
#import "AppDelegate.h"
#import "ImagesTableViewCell.h"
#import "ImageAPIHandler.h"
#import "ProductCreateViewController.h"
#import "ProductAPIHandler.h"

@interface ProductSelectTableViewController ()

@end

@implementation ProductSelectTableViewController


@synthesize parentController;
@synthesize cellDelegate;
@synthesize contentArray;
@synthesize contentRequestParameters;
@synthesize referenceTableView;
@synthesize productRequestorType;
@synthesize productRequestorReferenceObject;

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

    self.contentArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshContent)
             forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;

}

- (void)request:(IGRequest *)request didLoad:(id)result {
    
    NSDictionary *metaDictionary = [result objectForKey:@"meta"];
    int responseCode = [[metaDictionary objectForKey:@"code"] intValue];

    
    if (responseCode == 200)
    {
        NSArray *dataArray = [result objectForKey:@"data"];
        [self.contentArray removeAllObjects];
        [self.contentArray addObjectsFromArray:dataArray];
        if (self.referenceTableView != nil)
            [self.referenceTableView reloadData];
        else
            [self.tableView reloadData];
    }
}

- (void)request:(IGRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"%@ request did fail with error: %@", self, error);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    [tableView setSeparatorColor:[UIColor clearColor]];   
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.contentArray count] / 3 + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    ImagesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[ImagesTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier withCellHeight:[self tableView:tableView heightForRowAtIndexPath:indexPath]] autorelease];
    }
    
    cell.delegate = self.cellDelegate;
    [cell loadWithIndexPath:indexPath withFeedItemsArray:self.contentArray];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}


/*
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  104;
}
*/


-(void) cellSelectionOccured:(NSDictionary *)theSelectionObject
{
    [self.parentController tableViewProductSelectedWithDataDictionary:theSelectionObject];
}


-(void)refreshContent;
{
    if (self.contentRequestParameters != nil)
    {
        AppDelegate *theAppDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [theAppDelegate.instagram requestWithParams:contentRequestParameters delegate:self];
    }
    else if (self.productRequestorType > 0)
    {
        switch (self.productRequestorType) {
            case PRODUCT_REQUESTOR_TYPE_FEED_PRODUCTS:
                [ProductAPIHandler getAllProductsWithDelegate:self];
                break;
            case PRODUCT_REQUESTOR_TYPE_FEED_INSTAGRAM_USER:
                [ProductAPIHandler getProductsWithInstagramID:self.productRequestorReferenceObject withDelegate:self];
                
            default:
                break;
        }
    }
        
    
}


-(void)feedRequestFinishedWithArrray:(NSArray *)theArray
{
    [self.contentArray removeAllObjects];
    
    NSArray *sorted = [theArray sortedArrayUsingFunction:dateSort context:nil];
    [self.contentArray addObjectsFromArray:sorted];
    [self.refreshControl endRefreshing];
    [self.tableView reloadData];
}

NSComparisonResult dateSort(NSDictionary *s1, NSDictionary *s2, void *context) {
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *string1 = [s1 objectForKey:@"products_date_added"];
    NSDate *date1 = [dateFormatter dateFromString:string1];
    
    NSString *string2 = [s2 objectForKey:@"products_date_added"];
    NSDate *date2 = [dateFormatter dateFromString:string2];
    
    int ret = [date2 compare:date1];
    
    [dateFormatter release];
    
    return ret;
    
}






@end
