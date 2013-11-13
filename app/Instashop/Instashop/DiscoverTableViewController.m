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
#import "MediaLikedObject.h"

float cellHeight = 151;
@interface DiscoverTableViewController ()

@end

@implementation DiscoverTableViewController

@synthesize sellersObjectsArray;
@synthesize parentController;
@synthesize contentArray;
@synthesize unsortedDictionary;
@synthesize likedArray;

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
    self.likedArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.unsortedDictionary = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    for (int i = 0; i < [theArray count]; i++)
    {
        NSDictionary *dict = [theArray objectAtIndex:i];
        [self.unsortedDictionary setObject:dict forKey:[dict objectForKey:@"products_instagram_id"]];
    }
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSLog(@"theArray: %@", theArray);
  
    for (int i = 0; i < [theArray count]; i++)
    {
        NSDictionary *dict = [theArray objectAtIndex:i];
        NSMutableDictionary  *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"media/%@", [dict objectForKey:@"products_instagram_id"]], @"method", nil];
        [appDelegate.instagram requestWithParams:params delegate:self];
    }
}


- (void)request:(IGRequest *)request didLoad:(id)result
{
    NSDictionary *dataDict = [result objectForKey:@"data"];
    
    MediaLikedObject *likedObject = [[MediaLikedObject alloc] init];
    likedObject.mediaID = [dataDict objectForKey:@"id"];
    
    NSDictionary *likesDict = [dataDict objectForKey:@"likes"];
    likedObject.likedCount = [[likesDict objectForKey:@"count"] integerValue];
    
    [self.likedArray addObject:likedObject];
    
    if ([self.likedArray count] == [[self.unsortedDictionary allKeys] count] - 1)
        [self sortAndPresent];
    //    NSLog(@"likedObject.mediaID: %@", likedObject.mediaID);
    //    NSLog(@"likedCount: %d", likedObject.likedCount);
    //    NSLog(@"result: %@", result);
}



-(void)sortAndPresent
{
    self.contentArray = [[NSMutableArray alloc] initWithCapacity:0];
    NSLog(@"sortAndPresent");
    
    [self.likedArray sortUsingComparator:
     ^NSComparisonResult(id obj1, id obj2){
         
         MediaLikedObject *p1 = (MediaLikedObject*)obj1;
         MediaLikedObject *p2 = (MediaLikedObject*)obj2;
         if (p1.likedCount < p2.likedCount) {
             return (NSComparisonResult)NSOrderedDescending;
         }
         
         else if (p1.likedCount > p2.likedCount) {
             return (NSComparisonResult)NSOrderedAscending;
         }
         else return (NSComparisonResult)NSOrderedSame;
     }
     ];
    
    for (int i = 0; i < [likedArray count]; i++)
    {
        MediaLikedObject *obj = [likedArray objectAtIndex:i];
        [self.contentArray addObject:[self.unsortedDictionary objectForKey:obj.mediaID]];
    }
    
    self.tableView.contentSize = CGSizeMake(0, cellHeight * [self getCount]);
    [self.tableView reloadData];
    
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
