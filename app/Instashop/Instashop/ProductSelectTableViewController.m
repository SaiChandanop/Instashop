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
#import "TableCellAddClass.h"
#import "InstagramUserObject.h"
#import "SearchAPIHandler.h"
#import "PaginationAPIHandler.h"
#import "MBProgressHUD.h"
#import "CacheManager.h"

@interface ProductSelectTableViewController ()

@end

@implementation ProductSelectTableViewController


@synthesize checkCountup;
@synthesize cacheArray;
@synthesize loaded;
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
    
    self.cacheArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    self.navigationItem.backBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@""
                                      style:UIBarButtonItemStyleBordered
                                     target:nil
                                     action:nil];
    
}

- (void)request:(IGRequest *)request didLoad:(id)result {
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    NSDictionary *metaDictionary = [result objectForKey:@"meta"];
    int responseCode = [[metaDictionary objectForKey:@"code"] intValue];
    
    if (responseCode == 200)
    {
        NSArray *dataArray = [result objectForKey:@"data"];
        
        NSMutableArray *mutableDataArray = [NSMutableArray arrayWithCapacity:0];
        for (int i = 0; i < [dataArray count]; i++)
        {
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[dataArray objectAtIndex:i]];
            [mutableDataArray addObject:dict];
            NSData *theData = [NSKeyedArchiver archivedDataWithRootObject:dict];
            
            [self.cacheArray addObject:theData];
        }
        
        
        if (!self.loaded)
            [self.contentArray removeAllObjects];
        
        self.loaded = YES;
        
        
        [self.contentArray addObjectsFromArray:mutableDataArray];
        
        NSString *nextURLString = nil;
        NSDictionary *paginationDictionary = [result objectForKey:@"pagination"];
        if (paginationDictionary != nil)
            if ([paginationDictionary objectForKey:@"next_url"] != nil)
                nextURLString = [paginationDictionary objectForKey:@"next_url"];
        
        
        if (nextURLString != nil)
        {
//            NSLog(@"paginationDictionary: %@", paginationDictionary);
            [PaginationAPIHandler makePaginationRequestWithDelegate:self withRequestURLString:nextURLString];
            
        }
        else
        {
//            NSLog(@"paginationComplete");
//            NSLog(@"self.contentArray: %@", self.contentArray);
            
            [[NSUserDefaults standardUserDefaults] setObject:self.cacheArray forKey:@"user_photo_data"];
            
            
//            NSLog(@"[[NSUserDefaults standardUserDefaults.user_photo_data: %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"user_photo_data"]);
            
            for (int i = 0; i < [self.contentArray count]; i++)
            {
                NSMutableDictionary *theSelectionObject = [self.contentArray objectAtIndex:i];
                [ProductAPIHandler makeCheckForExistingProductURLWithDelegate:self withProductURL:[[[theSelectionObject objectForKey:@"images"] objectForKey:@"standard_resolution"] objectForKey:@"url"] withDictionary:theSelectionObject];
            }
        }
    }
    
    
}

-(void)checkFinishedWithBoolValue:(BOOL)exists withDictionary:(NSMutableDictionary *)referenceDictionary
{
    if (exists)
    {
        int theIndex = [self.contentArray indexOfObject:referenceDictionary];
        NSMutableDictionary *dict = [self.contentArray objectAtIndex:theIndex];
        [dict setObject:@"1" forKey:@"exists"];
        [self.contentArray replaceObjectAtIndex:theIndex withObject:dict];
    }
    
    
    
    self.checkCountup++;
    if (self.checkCountup == [self.contentArray count])
    {
        if (self.referenceTableView != nil)
            [self.referenceTableView reloadData];
        else
            [self.tableView reloadData];
        
        [self.refreshControl endRefreshing];
    }
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    [tableView setSeparatorColor:[UIColor clearColor]];
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (([self.contentArray count] % 3) == 0)
        return [self.contentArray count] / 3;
    else
        return [self.contentArray count] / 3 + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    ImagesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[ImagesTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier withCellHeight:[self tableView:tableView heightForRowAtIndexPath:indexPath]];
    }
    
    
    [cell loadWithIndexPath:indexPath withFeedItemsArray:self.contentArray withDelegate:self.cellDelegate];
    
    if (self.productRequestorType == PRODUCT_REQUESTOR_TYPE_FEED_PRODUCTS)
    {
        [[CacheManager getSharedCacheManager] precacheWithDataSet:self.contentArray withIndexPath:indexPath];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  self.view.frame.size.width/3;
}



-(void) cellSelectionOccured:(NSDictionary *)theSelectionObject
{
    [self.parentController tableViewProductSelectedWithDataDictionary:theSelectionObject];
}


-(void)refreshContent
{
    if ([self.contentArray count] == 0)
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES].detailsLabelText = @"Loading...";
        UIView *theView = [MBProgressHUD HUDForView:self.view];
        theView.frame = CGRectMake(0, 0, theView.frame.size.width, self.view.frame.size.height * .8);

        
        
    }
    
    self.checkCountup = 0;
    [self.contentArray removeAllObjects];

    if (self.contentRequestParameters != nil)
    {
        NSLog(@"requestWithParams: %@", self.contentRequestParameters);
        AppDelegate *theAppDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [theAppDelegate.instagram requestWithParams:[NSMutableDictionary dictionaryWithDictionary:self.contentRequestParameters] delegate:self];
        
        
        NSArray *cachedDataArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_photo_data"];
        
        if (cachedDataArray != nil)
        {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
            for (int i = 0; i < [cachedDataArray count]; i++)
            {
                NSData *myData = [cachedDataArray objectAtIndex:i];
                NSDictionary *myDictionary = (NSDictionary*) [NSKeyedUnarchiver unarchiveObjectWithData:myData];
                [self.contentArray addObject:myDictionary];
                
                [ProductAPIHandler makeCheckForExistingProductURLWithDelegate:self withProductURL:[[[myDictionary objectForKey:@"images"] objectForKey:@"standard_resolution"] objectForKey:@"url"] withDictionary:myDictionary];
             
                [self.tableView reloadData];
//                [self.contentArray removeAllObjects];
                
            }
        }
        
        
    }
    else if (self.productRequestorType > 0)
    {
        switch (self.productRequestorType) {
            case PRODUCT_REQUESTOR_TYPE_FEED_PRODUCTS:
                [ProductAPIHandler getAllProductsWithDelegate:self];
                break;
            case PRODUCT_REQUESTOR_TYPE_FEED_INSTAGRAM_SELLER:
                [ProductAPIHandler getProductsWithInstagramID:self.productRequestorReferenceObject withDelegate:self];
                break;
            case PRODUCT_REQUESTOR_TYPE_SEARCH:
                
                [SearchAPIHandler makeProductSearchRequestWithDelegate:self withSearchCategoriesArray:self.searchRequestObject.searchCategoriesArray withFreeformTextArray:self.searchRequestObject.searchFreeTextArray];
                break;
                
            case PRODUCT_REQUESTOR_TYPE_FEED_INSTAGRAM_BUYER:
                [ProductAPIHandler getSavedProductsWithInstagramID:self.productRequestorReferenceObject withDelegate:self];
            default:
                break;
        }
    }
    
    
}

-(void)searchReturnedWithArray:(NSArray *)searchResultsArray
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [self feedRequestFinishedWithArrray:searchResultsArray];
}

-(void)feedRequestFinishedWithArrray:(NSArray *)theArray
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [self.contentArray removeAllObjects];
    
    
    
    if (self.productRequestorType == PRODUCT_REQUESTOR_TYPE_FEED_INSTAGRAM_SELLER)
    {
        if ([self.productRequestorReferenceObject compare:[InstagramUserObject getStoredUserObject].userID] == NSOrderedSame)
        {
            TableCellAddClass *addClass = [[TableCellAddClass alloc] init];
            [self.contentArray addObject:addClass];
        }
    }
    
    
    NSArray *sorted = [theArray sortedArrayUsingFunction:dateSort context:nil];
    
    [self.contentArray addObjectsFromArray:sorted];
    
//    NSLog(@"contentArray: %@", contentArray);
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
    
    
    return ret;
    
}






@end
